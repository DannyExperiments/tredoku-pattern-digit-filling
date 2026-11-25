"""Independent geometric check of the tredoku labelling (corroborating, not load-bearing).

Triangular lattice in integer basis; directions D0=(1,0), D1=(0,1), D2=(-1,1); coordinates
scaled by 3. Random non-overlapping lozenge patterns are generated (overlap tested on the
18 small triangles of each tile); runs are components of shared-edge adjacency per
direction; lines are built geometrically by crossing shared sub-edges (no index
convention is assumed in the next tile); the labelling L_d = i_d + o(T,d) with forms
x, y, x+y is applied, and every tile and every line along runs of length 2 or 3 is checked.
`--negative-control` flips the index on one tile type and must be detected.
"""
import random, itertools
D=[(1,0),(0,1),(-1,1)]
def add(*v): return tuple(sum(c) for c in zip(*v))
def mul(k,v): return (k*v[0],k*v[1])
# work in coordinates scaled by 3 (sub-cell lattice)
class Tile:
    def __init__(s,p,i,j): s.p=p; s.i=i; s.j=j
    def pt(s,a,b): # scaled-by-3 point p*3 + a*D_i + b*D_j
        return add(mul(3,s.p),mul(a,D[s.i]),mul(b,D[s.j]))
    def cells(s):
        for a in range(3):
            for b in range(3):
                c=[s.pt(a,b),s.pt(a+1,b),s.pt(a+1,b+1),s.pt(a,b+1)]
                edges=[frozenset((c[k],c[(k+1)%4])) for k in range(4)]
                yield (a,b),edges
    def unit_edges(s):
        P=[mul(3,s.p),add(mul(3,s.p),mul(3,D[s.i])),add(mul(3,s.p),mul(3,D[s.i]),mul(3,D[s.j])),add(mul(3,s.p),mul(3,D[s.j]))]
        return [(frozenset((P[0],P[1])),s.i),(frozenset((P[3],P[2])),s.i),(frozenset((P[0],P[3])),s.j),(frozenset((P[1],P[2])),s.j)]
    def interior_pts(s): # centroids*3 of the 18 small equilateral triangles
        out=set(); Di,Dj=D[s.i],D[s.j]
        for a in range(3):
            for b in range(3):
                P=s.pt(a,b)
                if (s.i,s.j)==(0,2): T=[(P,add(P,Di),add(P,Di,Dj)),(P,add(P,Dj),add(P,Di,Dj))]
                else: T=[(P,add(P,Di),add(P,Dj)),(add(P,Di),add(P,Dj),add(P,Di,Dj))]
                for tr in T: out.add(add(*tr))
        return out
NEG=False
def label(t,a,b,off):
    # L_0=x, L_1=y, L_2=x+y ; solve L_i=a+o_i, L_j=b+o_j mod 3
    if NEG and (t.i,t.j)==(0,2): a=2-a  # deliberately wrong per-tile convention
    vi=(a+off[(id(t),t.i)])%3; vj=(b+off[(id(t),t.j)])%3
    for x in range(3):
        for y in range(3):
            L=[x,y,(x+y)%3]
            if L[t.i]==vi and L[t.j]==vj: return (x,y)
def trial(rng,ntiles,R):
    tiles=[];occ=set()
    tries=0
    while len(tiles)<ntiles and tries<5000:
        tries+=1
        i,j=rng.choice([(0,1),(0,2),(1,2)])
        t=Tile((rng.randint(-R,R),rng.randint(-R,R)),i,j)
        P=t.interior_pts()
        if P&occ: continue
        occ|=P; tiles.append(t)
    # adjacency by shared unit edge
    emap={}
    for t in tiles:
        for e,d in t.unit_edges(): emap.setdefault(e,[]).append((t,d))
    nbr={}
    for e,L in emap.items():
        if len(L)==2:
            (t,d),(u,_)=L
            nbr.setdefault((id(t),d),[]).append(u); nbr.setdefault((id(u),d),[]).append(t)
    # runs
    off={};runs=[];seen=set()
    for t in tiles:
        for d in (t.i,t.j):
            off[(id(t),d)]=0
    for t in tiles:
        for d in (t.i,t.j):
            if (id(t),d) in seen: continue
            comp=[t];seen.add((id(t),d));st=[t]
            while st:
                x=st.pop()
                for y in nbr.get((id(x),d),[]):
                    if (id(y),d) not in seen: seen.add((id(y),d));comp.append(y);st.append(y)
            runs.append((d,comp))
    checked=0
    for d,comp in runs:
        if not (2<=len(comp)<=3): continue
        offs=list(range(3)); rng.shuffle(offs)
        for k,x in enumerate(comp): off[(id(x),d)]=offs[k]
    # cell edge map for geometric crossing
    cedge={}
    for t in tiles:
        for (a,b),edges in t.cells():
            for e in edges: cedge.setdefault(e,[]).append((t,a,b))
    for t in tiles:
        labs={label(t,a,b,off) for a in range(3) for b in range(3)}
        assert len(labs)==9
    for d,comp in runs:
        if not (2<=len(comp)<=3): continue
        # build strands geometrically: start at each tile, flood through strips (local) and cross shared sub-edges (geometric)
        for t0 in comp:
            for k in range(3):
                # strip in t0: if d==t0.i, strip fixed a=k
                start=[(t0,k,b) if d==t0.i else (t0,b,k) for b in range(3)]
                cells=set(); st=[(id(c[0]),c[1],c[2],c[0]) for c in start]
                tileof={}
                while st:
                    tid,a,b,t=st.pop()
                    if (tid,a,b) in cells: continue
                    cells.add((tid,a,b)); tileof[(tid,a,b)]=t
                    # strip partners
                    for bb in range(3):
                        c=(tid,a,bb) if d==t.i else (tid,bb,b)
                        if c not in cells: st.append((c[0],c[1],c[2],t))
                    # cross edges parallel to d
                    for (aa,bbb),edges in t.cells():
                        if (aa,bbb)!=(a,b): continue
                        for e in edges:
                            for (u,ua,ub) in cedge[e]:
                                if u is not t and u in comp:
                                    st.append((id(u),ua,ub,u))
                labs=[label(tileof[c],c[1],c[2],off) for c in cells]
                assert len(cells)==3*len(comp),(len(cells),len(comp))
                assert len(set(labs))==len(labs),"repeat"
                checked+=1
    return checked, sum(1 for d,c in runs if len(c)==3), len({(id(t)) for d,c in runs if len(c)>=2 for t in c if t.i!=c[0].i or t.j!=c[0].j})
if __name__=="__main__":
    import sys
    NEG = "--negative-control" in sys.argv
    rng=random.Random(1)
    tot=0;r3=0
    try:
        for _ in range(3000):
            c,n3,_b=trial(rng,rng.randint(5,40),rng.randint(2,6)); tot+=c; r3+=n3
    except AssertionError as e:
        print("FAILURE DETECTED:", e or "repeat"); sys.exit(1 if not NEG else 0)
    if NEG: print("negative control NOT detected"); sys.exit(1)
    print("lines checked",tot,"length-3 runs",r3,"all OK")
