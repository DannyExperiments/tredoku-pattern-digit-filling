# Build

`latexmk -pdf -interaction=nonstopmode -halt-on-error manuscript.tex` (pdfTeX, `amsart`, TeX Live). The manuscript uses an inline bibliography; `references.bib` lists the same references for reuse. The PDF workflow rebuilds the manuscript and rejects unresolved references and overfull or underfull boxes. Every page of the committed PDF was rendered and inspected.
