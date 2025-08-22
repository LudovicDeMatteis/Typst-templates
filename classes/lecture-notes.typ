#let notes(
  title: none,
  authors: (),
  school: "",
  bib: none,
  body,
) = {
  set document(
    title: title,
    author: authors.keys().at(0),
    date: auto,
  )
  set page(
    paper: "a4",
    header: align(left)[#title]
      + if school != "" {
        align(right)[#school]
      } else {
        none
      },
    numbering: "1",
    number-align: center,
  )
  set par(justify: true)
  set text(
    font: "Times New Roman",
    size: 11pt,
    spacing: 100%,
  )
  set heading(numbering: "1.a")
  set math.equation(numbering: "(1)")
  set figure(
    numbering: "A",
    gap: 10pt,
  )

  show heading: head => block(width: 100%, head + v(1%))
  show heading.where(level: 1): head => align(center)[
    #text(
      size: 14pt,
      weight: "bold",
      smallcaps(head),
    )
  ]
  show figure.caption: capt => block(width: 75%, capt)

  // Title
  align(
    center,
    title,
  )

  body
}
