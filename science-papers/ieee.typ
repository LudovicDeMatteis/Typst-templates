#let conf(
  title: none,
  // Dictionnary of authors
  // Example:
  // (
  //   "Auther Name": (
  //     "affiliation": "affil-1",
  //     "email": "author.name@example.com", // Optional
  //     "address": "Mail address",  // Optional
  //   )
  // )
  authors: (),
  affiliations: (),
  acknowledgement: "",
  abstract: [],
  // The path to a bib file
  bib: none,
  body,
) = {
  let indent = 0.5cm

  set page(
    columns: 2,
    paper: "us-letter",
    numbering: "1",
    number-align: bottom + center,
    margin: 1.9cm,
  )

  let clean_numbering(..schemes) = {
    (..nums) => {
      let (section, ..subsections) = nums.pos()
      let (section_scheme, ..subschemes) = schemes.pos()

      if subsections.len() == 0 {
        numbering(section_scheme, section)
      } else if subschemes.len() == 0 {
        numbering(section_scheme, ..nums.pos())
      } else {
        clean_numbering(..subschemes)(..subsections)
      }
    }
  }
  set heading(numbering: clean_numbering("I.", "A.", "1.a."))
  show heading: head => text(
    weight: "regular",
    size: 11pt,
    if head.level == 1 {
      align(center)[
        #smallcaps(head)
      ]
    } else {
      emph(head)
    }
      + v(0.1cm),
  )

  set par(
    justify: true,
    // leading: 1pt,
    first-line-indent: indent,
  )
  show "¬": h(indent)

  set text(
    size: 10pt,
    font: "Times New Roman",
  )

  // Title
  place(
    auto,
    scope: "parent",
    float: true,
    v(2.54cm - 1.9cm) + text(size: 16pt, weight: "bold", title) + v(0.1cm),
  )

  // Authors
  let aff_keys = affiliations.keys()
  let corresp_aut = ()
  let authors_font_size = 11pt
  place(
    auto,
    scope: "parent",
    float: true,
    for (ai, aut_name) in authors.keys().enumerate() {
      let aut_data = authors.at(aut_name)
      // Put a comma before the authors name (expect for the first one)
      if ai != 0 {
        text(size: authors_font_size, [, ])
      }
      // Write author name
      text(size: authors_font_size, [#aut_name])
      // Associate the authors with their affiliations
      let aut_aff_key = aut_data.affiliation
      let aut_primary_aff = ""
      if type(aut_aff_key) == array {
        aut_primary_aff = affiliations.at(aut_aff_key.first())
        let aut_aff_index = aut_aff_key.map(id => aff_keys.position(key => key == id) + 1)
        // Output the affiliation
        super([#(aut_aff_index.map(id => [#id]).join([,]))])
      } else if type(aut_aff_key) == str {
        let aut_aff_index = aut_aff_key.position(aut_aff_key) + 1
        super([#aut_aff_index])
      }
      if aut_data.keys().contains("email") {
        super([, \*])
        corresp_aut.push(aut_name)
      }
    }
      + v(0.2cm),
  )

  // Aknowlegdment and affiliations
  place(
    bottom,
    scope: "column",
    float: true,
    par(
      justify: false,
      text(
        size: 8pt,
        if acknowledgement != "" {
          [¬#acknowledgement #linebreak()]
        }
          + for (ai, aff_name) in affiliations.keys().enumerate() {
            [¬#(ai + 1) - #affiliations.at(aff_name).description]
            if ai < affiliations.len() - 1 {
              linebreak()
            }
          }
          + if corresp_aut != () {
            linebreak()
            if corresp_aut.len() == 1 {
              text([¬\* Corresponding author: ])
            } else {
              text([¬\* Corresponding authors: ])
            }
            for (i, aut_name) in corresp_aut.enumerate() {
              [#authors.at(aut_name).email]
              if i < corresp_aut.len() - 1 {
                text([; ])
              }
            }
          },
      ),
    ),
  )

  if abstract != [] {
    text(
      weight: "bold",
      [_Abstract_- #abstract],
    )
  }

  body

  if bib != none {
    show bibliography: set text(1em)
    show bibliography: set par(first-line-indent: 0em)
    bibliography(bib, title: [References], style: "ieee")
  }
}
