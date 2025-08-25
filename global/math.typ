#let proof(body) = {
  block(
    fill: luma(230),
    inset: 8pt,
    radius: 4pt,
    text(size: 10pt, weight: "bold", [_Proof_ - \ ]) + body,
  )
}

#let nonum(eq) = math.equation(numbering: none, block: true)[#eq]
