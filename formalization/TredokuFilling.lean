/-
  Tredoku digit filling — logical core (Lean 4 core, no Mathlib).

  Model. Triangular lattice in the integer basis e₁=(1,0), e₂=(0,1) with the three
  positively oriented unit directions D 0 = (1,0), D 1 = (0,1), D 2 = (-1,1).
  Every lozenge tile is p + [0,1]·D i + [0,1]·D j for a lattice point p and a pair i<j;
  `ty` encodes the pair: 0 ↦ {0,1}, 1 ↦ {0,2}, 2 ↦ {1,2}.  Points are scaled by 3 so
  that the 3×3 subdivision has integer corners.  A cell (a,b) of a tile is the
  sub-lozenge with corner `pt a b`; `a` is its index along `di`, `b` along `dj`.

  A nine-cell line along a run of direction d consists, in each of the three tiles,
  of the strip of three cells with a fixed index along d, and consecutive strips are
  joined geometrically: a boundary cell of one strip and a boundary cell of the next
  have the same boundary sub-segment (as an unordered pair of scaled lattice points).
  Nothing about indices in the second tile is assumed: the crossing lemma
  `along_eq_of_link` derives that the index is preserved.
-/

def D : Fin 3 → Int × Int
  | 0 => (1, 0)
  | 1 => (0, 1)
  | 2 => (-1, 1)

structure Tile where
  px : Int
  py : Int
  ty : Fin 3
deriving DecidableEq, Repr

def Tile.di (t : Tile) : Fin 3 := if t.ty = 2 then 1 else 0
def Tile.dj (t : Tile) : Fin 3 := if t.ty = 0 then 1 else 2

/-- scaled point `3p + a·D di + b·D dj` -/
def Tile.pt (t : Tile) (a b : Int) : Int × Int :=
  (3 * t.px + a * (D t.di).1 + b * (D t.dj).1,
   3 * t.py + a * (D t.di).2 + b * (D t.dj).2)

def Tile.HasDir (t : Tile) (d : Fin 3) : Prop := d = t.di ∨ d = t.dj

structure Cell where
  t : Tile
  a : Fin 3
  b : Fin 3
deriving DecidableEq, Repr

/-- index of a cell along direction `d` (meaningful when `d` is a direction of its tile) -/
def Cell.along (c : Cell) (d : Fin 3) : Fin 3 := if d = c.t.di then c.a else c.b
/-- index of a cell across direction `d` -/
def Cell.across (c : Cell) (d : Fin 3) : Fin 3 := if d = c.t.di then c.b else c.a

/-- the sub-segment of the tile's boundary edge parallel to `d` at transverse level `B`
    (B = 0 or 3) that the cell's strip meets -/
def Cell.seg (c : Cell) (d : Fin 3) (B : Int) : (Int × Int) × (Int × Int) :=
  if d = c.t.di then (c.t.pt (c.a.val : Int) B, c.t.pt ((c.a.val : Int) + 1) B)
  else (c.t.pt B (c.b.val : Int), c.t.pt B ((c.b.val : Int) + 1))

def Cell.OnBoundary (c : Cell) (d : Fin 3) (B : Int) : Prop :=
  (B = 0 ∧ c.across d = 0) ∨ (B = 3 ∧ c.across d = 2)

/-- Geometric crossing: `c` and `c'` sit on boundary edges parallel to `d` of their tiles
    and share that boundary sub-segment (orientation of the pair is irrelevant). -/
def Link (d : Fin 3) (c c' : Cell) : Prop :=
  ∃ B B' : Int, c.OnBoundary d B ∧ c'.OnBoundary d B' ∧
    (c.seg d B = c'.seg d B' ∨ c.seg d B = ((c'.seg d B').2, (c'.seg d B').1))

/-! ### Crossing lemma: the strand index is preserved across a shared edge -/

theorem along_eq_of_link (d : Fin 3) (c c' : Cell)
    (h : c.t.HasDir d) (h' : c'.t.HasDir d) (hl : Link d c c') :
    c.along d = c'.along d := by
  obtain ⟨⟨px, py, ⟨ty, hty⟩⟩, ⟨a, ha⟩, ⟨b, hb⟩⟩ := c
  obtain ⟨⟨qx, qy, ⟨ty', hty'⟩⟩, ⟨a', ha'⟩, ⟨b', hb'⟩⟩ := c'
  obtain ⟨d, hd⟩ := d
  obtain ⟨B, B', hB, hB', hs⟩ := hl
  have e1 : d = 0 ∨ d = 1 ∨ d = 2 := by omega
  have e2 : ty = 0 ∨ ty = 1 ∨ ty = 2 := by omega
  have e3 : ty' = 0 ∨ ty' = 1 ∨ ty' = 2 := by omega
  rcases e1 with rfl | rfl | rfl <;> rcases e2 with rfl | rfl | rfl <;>
    rcases e3 with rfl | rfl | rfl <;>
    simp [Cell.along, Cell.across, Cell.OnBoundary, Cell.seg, Tile.pt, Tile.HasDir,
      Tile.di, Tile.dj, D, Fin.ext_iff, Prod.ext_iff] at h h' hB hB' hs ⊢ <;>
    omega

/-! ### The labelling -/

/-- the three linear forms `x`, `y`, `x+y` on (ℤ/3)² -/
def form : Fin 3 → Fin 3 × Fin 3 → Fin 3
  | 0, p => p.1
  | 1, p => p.2
  | 2, p => p.1 + p.2

/-- the unique pair with `form i = u` and `form j = v`, for the three ordered pairs i<j used -/
def solve : Fin 3 → Fin 3 → Fin 3 → Fin 3 × Fin 3
  | 0, u, v => (u, v)        -- forms x, y
  | 1, u, v => (u, v - u)    -- forms x, x+y
  | 2, u, v => (v - u, u)    -- forms y, x+y

theorem solve_spec : ∀ (ty u v : Fin 3),
    form (if ty = 2 then 1 else 0) (solve ty u v) = u ∧
    form (if ty = 0 then 1 else 2) (solve ty u v) = v := by decide

theorem solve_inj : ∀ (ty u v u' v' : Fin 3), solve ty u v = solve ty u' v' → u = u' ∧ v = v' := by
  decide

/-- offsets: `off T d` is the offset of tile `T` for direction `d` -/
abbrev Offsets := Tile → Fin 3 → Fin 3

def label (off : Offsets) (c : Cell) : Fin 3 × Fin 3 :=
  solve c.t.ty (c.a + off c.t c.t.di) (c.b + off c.t c.t.dj)

/-- digits 1..9 -/
def digit (p : Fin 3 × Fin 3) : Nat := 1 + 3 * p.1.val + p.2.val

theorem digit_inj (p q : Fin 3 × Fin 3) (h : digit p = digit q) : p = q := by
  obtain ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ := p
  obtain ⟨⟨x', hx'⟩, ⟨y', hy'⟩⟩ := q
  simp only [digit] at h
  have : x = x' := by omega
  have : y = y' := by omega
  subst_vars; rfl

theorem digit_range (p : Fin 3 × Fin 3) : 1 ≤ digit p ∧ digit p ≤ 9 := by
  obtain ⟨⟨x, hx⟩, ⟨y, hy⟩⟩ := p
  simp only [digit]; omega

def di' (ty : Fin 3) : Fin 3 := if ty = 2 then 1 else 0
def dj' (ty : Fin 3) : Fin 3 := if ty = 0 then 1 else 2

theorem fin3_add_right_cancel : ∀ x y z : Fin 3, x + z = y + z → x = y := by decide

theorem form_solve_along : ∀ (ty d a b o1 o2 : Fin 3), (d = di' ty ∨ d = dj' ty) →
    form d (solve ty (a + o1) (b + o2)) =
      (if d = di' ty then a else b) + (if d = di' ty then o1 else o2) := by decide

theorem form_solve_across : ∀ (ty d a b o1 o2 : Fin 3), (d = di' ty ∨ d = dj' ty) →
    form (if d = di' ty then dj' ty else di' ty) (solve ty (a + o1) (b + o2)) =
      (if d = di' ty then b else a) + (if d = di' ty then o2 else o1) := by decide

theorem form_label_along (off : Offsets) (c : Cell) (d : Fin 3) (h : c.t.HasDir d) :
    form d (label off c) = c.along d + off c.t d := by
  have k := form_solve_along c.t.ty d c.a c.b (off c.t c.t.di) (off c.t c.t.dj) h
  have hdi : c.t.di = di' c.t.ty := rfl
  have hdj : c.t.dj = dj' c.t.ty := rfl
  simp only [label, Cell.along]
  rw [k]
  rcases h with e | e
  · rw [← hdi] at *; simp [e]
  · by_cases e' : d = c.t.di
    · rw [← hdi] at *; simp [e']
    · rw [← hdi] at *; simp only [e', if_false]; rw [e]

theorem form_label_across (off : Offsets) (c : Cell) (d : Fin 3) (h : c.t.HasDir d) :
    form (if d = c.t.di then c.t.dj else c.t.di) (label off c) =
      c.across d + off c.t (if d = c.t.di then c.t.dj else c.t.di) := by
  have k := form_solve_across c.t.ty d c.a c.b (off c.t c.t.di) (off c.t c.t.dj) h
  simp only [label, Cell.across]
  by_cases e : d = c.t.di
  · have e2 : d = di' c.t.ty := e
    simp only [e2, if_true] at k
    simp only [e, if_true]; exact k
  · have e2 : ¬ d = di' c.t.ty := e
    simp only [e2, if_false] at k
    simp only [e, if_false]; exact k

/-! ### Each tile receives all nine labels -/

theorem tile_injective (off : Offsets) (T : Tile) (a b a' b' : Fin 3)
    (h : label off ⟨T, a, b⟩ = label off ⟨T, a', b'⟩) : a = a' ∧ b = b' := by
  simp only [label] at h
  obtain ⟨h1, h2⟩ := solve_inj _ _ _ _ _ h
  exact ⟨fin3_add_right_cancel _ _ _ h1, fin3_add_right_cancel _ _ _ h2⟩

/-! ### Each nine-cell line along a run receives all nine labels -/

/-- the three tiles of a run of direction `d`, each having `d` as a direction -/
structure Run where
  d : Fin 3
  t1 : Tile
  t2 : Tile
  t3 : Tile
deriving DecidableEq

def Run.tiles (r : Run) : List Tile := [r.t1, r.t2, r.t3]

/-- A line along `r`: indices `s₁,s₂,s₃` of the strips in the three tiles, joined
    geometrically by `Link`. The line's cells are the cells of the three tiles with the
    given index along `d`. -/
structure Line (r : Run) where
  s1 : Fin 3
  s2 : Fin 3
  s3 : Fin 3
  link12 : ∃ c c' : Cell, c.t = r.t1 ∧ c'.t = r.t2 ∧ c.along r.d = s1 ∧ c'.along r.d = s2 ∧ Link r.d c c'
  link23 : ∃ c c' : Cell, c.t = r.t2 ∧ c'.t = r.t3 ∧ c.along r.d = s2 ∧ c'.along r.d = s3 ∧ Link r.d c c'

def Line.Mem {r : Run} (L : Line r) (c : Cell) : Prop :=
  (c.t = r.t1 ∧ c.along r.d = L.s1) ∨ (c.t = r.t2 ∧ c.along r.d = L.s2) ∨
  (c.t = r.t3 ∧ c.along r.d = L.s3)

theorem Line.s_eq {r : Run} (L : Line r) (hd : ∀ t ∈ r.tiles, t.HasDir r.d) :
    L.s1 = L.s2 ∧ L.s2 = L.s3 := by
  obtain ⟨c, c', hc, hc', h1, h2, hl⟩ := L.link12
  obtain ⟨e, e', he, he', h3, h4, hl'⟩ := L.link23
  have k1 := along_eq_of_link r.d c c' (hc ▸ hd _ (by simp [Run.tiles])) (hc' ▸ hd _ (by simp [Run.tiles])) hl
  have k2 := along_eq_of_link r.d e e' (he ▸ hd _ (by simp [Run.tiles])) (he' ▸ hd _ (by simp [Run.tiles])) hl'
  exact ⟨h1 ▸ h2 ▸ k1, h3 ▸ h4 ▸ k2⟩

/-- cells in a strip of one tile are determined by their index across `d` -/
theorem cell_eq_of_along_across (c c' : Cell) (d : Fin 3) (ht : c.t = c'.t)
    (h1 : c.along d = c'.along d) (h2 : c.across d = c'.across d) : c = c' := by
  obtain ⟨t, a, b⟩ := c
  obtain ⟨t', a', b'⟩ := c'
  simp only at ht; subst ht
  simp only [Cell.along, Cell.across] at h1 h2
  by_cases e : d = t.di
  · simp only [e, if_true] at h1 h2; subst h1; subst h2; rfl
  · simp only [e, if_false] at h1 h2; subst h1; subst h2; rfl

theorem line_injective (off : Offsets) (r : Run) (L : Line r)
    (hd : ∀ t ∈ r.tiles, t.HasDir r.d)
    (hoff : off r.t1 r.d ≠ off r.t2 r.d ∧ off r.t1 r.d ≠ off r.t3 r.d ∧ off r.t2 r.d ≠ off r.t3 r.d)
    (c c' : Cell) (hc : L.Mem c) (hc' : L.Mem c') (h : label off c = label off c') : c = c' := by
  obtain ⟨e12, e23⟩ := L.s_eq hd
  -- both cells have index s along d, and offsets distinguish tiles
  have hdirc : c.t.HasDir r.d := by
    rcases hc with ⟨h, _⟩ | ⟨h, _⟩ | ⟨h, _⟩ <;> rw [h] <;> exact hd _ (by simp [Run.tiles])
  have hdirc' : c'.t.HasDir r.d := by
    rcases hc' with ⟨h, _⟩ | ⟨h, _⟩ | ⟨h, _⟩ <;> rw [h] <;> exact hd _ (by simp [Run.tiles])
  have fa := form_label_along off c r.d hdirc
  have fa' := form_label_along off c' r.d hdirc'
  rw [h] at fa
  have halong : c.along r.d = c'.along r.d := by
    rcases hc with ⟨_, h1⟩ | ⟨_, h1⟩ | ⟨_, h1⟩ <;> rcases hc' with ⟨_, h2⟩ | ⟨_, h2⟩ | ⟨_, h2⟩ <;>
      rw [h1, h2] <;> simp_all
  have hoffeq : off c.t r.d = off c'.t r.d := by
    have : c.along r.d + off c.t r.d = c'.along r.d + off c'.t r.d := fa ▸ fa'
    rw [halong] at this
    have k : ∀ x y z : Fin 3, z + x = z + y → x = y := by decide
    exact k _ _ _ this
  have htile : c.t = c'.t := by
    rcases hc with ⟨h1, _⟩ | ⟨h1, _⟩ | ⟨h1, _⟩ <;> rcases hc' with ⟨h2, _⟩ | ⟨h2, _⟩ | ⟨h2, _⟩ <;>
      rw [h1, h2] at hoffeq ⊢ <;> first | rfl | (exfalso; simp_all)
  have fx := form_label_across off c r.d hdirc
  have fx' := form_label_across off c' r.d hdirc'
  rw [h] at fx
  rw [htile] at fx
  have hacross : c.across r.d = c'.across r.d :=
    fin3_add_right_cancel _ _ _ (fx.symm.trans fx')
  exact cell_eq_of_along_across c c' r.d htile halong hacross

/-! ### Existence of a filling from a family of pairwise disjoint runs per direction -/

def runOff (runs : List Run) : Offsets := fun T d =>
  match runs.find? (fun r => r.d == d && (r.t1 == T || r.t2 == T || r.t3 == T)) with
  | some r => if r.t1 = T then 0 else if r.t2 = T then 1 else 2
  | none => 0

theorem runOff_spec (runs : List Run)
    (hdisj : ∀ r ∈ runs, ∀ r' ∈ runs, r.d = r'.d → (∃ t, t ∈ r.tiles ∧ t ∈ r'.tiles) → r = r')
    (hdist : ∀ r ∈ runs, r.t1 ≠ r.t2 ∧ r.t1 ≠ r.t3 ∧ r.t2 ≠ r.t3)
    (r : Run) (hr : r ∈ runs) :
    runOff runs r.t1 r.d = 0 ∧ runOff runs r.t2 r.d = 1 ∧ runOff runs r.t3 r.d = 2 := by
  have key : ∀ T ∈ r.tiles, runs.find? (fun r' => r'.d == r.d && (r'.t1 == T || r'.t2 == T || r'.t3 == T)) = some r := by
    intro T hT
    cases hf : runs.find? (fun r' => r'.d == r.d && (r'.t1 == T || r'.t2 == T || r'.t3 == T)) with
    | none =>
      exfalso
      have := List.find?_eq_none.mp hf r hr
      simp [Run.tiles] at hT
      rcases hT with h | h | h <;> subst h <;> simp_all
    | some r' =>
      have hm := List.mem_of_find?_eq_some hf
      have hp := List.find?_some hf
      simp only [Bool.and_eq_true, beq_iff_eq, Bool.or_eq_true] at hp
      obtain ⟨hd, ht⟩ := hp
      have : r' = r := by
        apply hdisj r' hm r hr hd
        refine ⟨T, ?_, hT⟩
        simp only [Run.tiles, List.mem_cons, List.not_mem_nil, or_false]
        rcases ht with (h | h) | h <;> simp [h]
      rw [this]
  obtain ⟨d12, d13, d23⟩ := hdist r hr
  refine ⟨?_, ?_, ?_⟩
  · simp only [runOff, key r.t1 (by simp [Run.tiles])]; simp
  · simp only [runOff, key r.t2 (by simp [Run.tiles])]; simp [d12]
  · simp only [runOff, key r.t3 (by simp [Run.tiles])]; simp [d13, d23]

/-- **Main theorem (logical core).** For any family of three-tile runs that are pairwise
    disjoint within each direction (as runs of a tredoku pattern are), the explicit labelling
    gives every tile all nine labels and every geometric nine-cell line along every run all
    nine labels. -/
theorem exists_filling (runs : List Run)
    (hdir : ∀ r ∈ runs, ∀ t ∈ r.tiles, t.HasDir r.d)
    (hdist : ∀ r ∈ runs, r.t1 ≠ r.t2 ∧ r.t1 ≠ r.t3 ∧ r.t2 ≠ r.t3)
    (hdisj : ∀ r ∈ runs, ∀ r' ∈ runs, r.d = r'.d → (∃ t, t ∈ r.tiles ∧ t ∈ r'.tiles) → r = r') :
    ∃ lab : Cell → Nat,
      (∀ c, 1 ≤ lab c ∧ lab c ≤ 9) ∧
      (∀ (T : Tile) (a b a' b' : Fin 3), lab ⟨T, a, b⟩ = lab ⟨T, a', b'⟩ → a = a' ∧ b = b') ∧
      (∀ r ∈ runs, ∀ L : Line r, ∀ c c', L.Mem c → L.Mem c' → lab c = lab c' → c = c') := by
  refine ⟨fun c => digit (label (runOff runs) c), fun c => digit_range _, ?_, ?_⟩
  · intro T a b a' b' h
    exact tile_injective _ T a b a' b' (digit_inj _ _ h)
  · intro r hr L c c' hc hc' h
    obtain ⟨o1, o2, o3⟩ := runOff_spec runs hdisj hdist r hr
    apply line_injective (runOff runs) r L (hdir r hr) ?_ c c' hc hc' (digit_inj _ _ h)
    rw [o1, o2, o3]; decide

/-! ### Non-vacuity: a concrete run that bends, with a geometric line through it

T1 has directions {0,1}; T2 (above it) has directions {0,2}; T3 has directions {0,1}.
All three share edges parallel to direction 0, and the other direction changes at each step. -/

def bendRun : Run := ⟨0, ⟨0, 0, 0⟩, ⟨0, 1, 1⟩, ⟨-1, 2, 0⟩⟩

def bendLine : Line bendRun where
  s1 := 1
  s2 := 1
  s3 := 1
  link12 := ⟨⟨⟨0, 0, 0⟩, 1, 2⟩, ⟨⟨0, 1, 1⟩, 1, 0⟩, rfl, rfl, rfl, rfl,
    3, 0, Or.inr ⟨rfl, rfl⟩, Or.inl ⟨rfl, rfl⟩, Or.inl (by decide)⟩
  link23 := ⟨⟨⟨0, 1, 1⟩, 1, 2⟩, ⟨⟨-1, 2, 0⟩, 1, 0⟩, rfl, rfl, rfl, rfl,
    3, 0, Or.inr ⟨rfl, rfl⟩, Or.inl ⟨rfl, rfl⟩, Or.inl (by decide)⟩

/-- the index along the run is genuinely the same in all three tiles of the bending run -/
example : bendLine.s1 = bendLine.s2 ∧ bendLine.s2 = bendLine.s3 :=
  bendLine.s_eq (by
    intro t ht
    simp only [bendRun, Run.tiles, List.mem_cons, List.not_mem_nil, or_false] at ht
    rcases ht with rfl | rfl | rfl <;> simp [bendRun, Tile.HasDir, Tile.di, Tile.dj])

