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
    header: context {
      if (counter(page).get().at(0) != 1) {
        title
        h(1fr)
        if (school != "") {
          school
        } else {
          none
        }
      } else { [] }
    },
    footer: align(left)[
      #for (i, name) in authors.keys().enumerate() {
        if i > 0 {
          " | "
        }
        name
      }
    ],
    numbering: "1",
    number-align: center,
  )
  set par(justify: true)
  set text(
    size: 11pt,
    font: "New Computer Modern",
    spacing: 100%,
  )
  set heading(numbering: "I.A.")
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
    text(
      size: 18pt,
      weight: "bold",
      smallcaps(title),
    ),
  )
  // Authors and affiliations
  grid(
    columns: 1fr * authors.len(),
    align: center,
    for name in authors.keys() {
      name
      if "affiliation" in authors.at(name).keys() {
        linebreak()
        authors.at(name).affiliation
      }
      if "email" in authors.at(name).keys() {
        linebreak()
        link("mailto:" + authors.at(name).email)
      }
    }
  )

  set outline(depth: 2, indent: 5%)
  show outline.entry.where(level: 1): it => {
    v(1%)
    it
  }

  body
}
