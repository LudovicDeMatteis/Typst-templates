#let notes(
  title: none,
  authors: (),
  school: "",
  bib: none,
  body,
) = {
  set document(
    title: title,
    author: authors.at(0).name,
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
      #for (i, author) in authors.enumerate() {
        if i > 0 {
          " | "
        }
        author.name
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
    #text(size: 14pt, weight: "bold", smallcaps(head))
  ]
  show figure.caption: capt => block(width: 75%, capt)

  // Title
  align(center, text(size: 18pt, weight: "bold", smallcaps(title)))
  // Authors and affiliations
  grid(
    columns: (1fr,) * authors.len(),
    align: center,
    row-gutter: 24pt,
    ..authors.map(author => [
      #author.name \
      #if "affiliation" in author.keys() {
        author.affiliation
        linebreak()
      }
      #if "email" in author.keys() {
        link("mailto:" + author.email)
      }
    ])
  )

  set outline(depth: 2, indent: 5%)
  show outline.entry.where(level: 1): it => {
    v(1%)
    it
  }

  body
}

