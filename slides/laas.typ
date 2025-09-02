#import "@preview/polylux:0.4.0": *

// Define text sizes
#let footer_size = 10pt
#let text_size = 15pt
#let header_sizes = (30pt, 20pt, 15pt, 10pt)

#let content_slide(
  title: none,
  subtitle: none,
  body,
) = {
  slide[
    #if title != none {
      [
        #place(
          dx: -10%,
          dy: -16%,
          block(
            height: 20%,
            width: 95%,
            inset: (left: 5%, right: 0%),
            fill: rgb("#001f3f"),
            text(
              fill: white,
              align(horizon + left)[
                = #title
              ],
            ),
          ),
        )
        #place(
          dx: 25%,
          dy: 2%,
          block(
            fill: red,
            height: 4%,
            width: 60%,
          ),
        )
      ]
      place(
        dx: 0%,
        dy: 10%,
        block(
          width: 100%,
          height: 92%,
          inset: (top: 0%, bottom: 0%),
          body,
        ),
      )
    } else {
      place(
        dx: 0%,
        dy: -10%,
        block(
          width: 100%,
          height: 110%,
          body,
        ),
      )
    }

    // Place the logos
    // LAAS
    #place(
      top + right,
      dx: 8%,
      dy: -15%,
      image(width: 20%, "LogoLAAS.png"),
    )
  ]
}

#let title_slide(
  title: none,
  subtitle: none,
) = {
  set page(footer: none)
  slide[
    #place(
      dx: 0%,
      dy: 25%,
      block(
        height: 50%,
        width: 100%,
        inset: (left: 8%, right: 8%),
        fill: rgb("#001f3f"),
        text(
          fill: white,
          align(horizon + center)[
            = #title
            #line(stroke: white, length: 40%)
            == #subtitle
          ],
        ),
      ),
    )
    #place(
      dx: 40%,
      dy: 73%,
      block(
        fill: red,
        height: 4%,
        width: 60%,
      ),
    )
    // Place the logos
    // LAAS
    #place(
      top + right,
      dx: 8%,
      dy: -15%,
      image(width: 20%, "LogoLAAS.png"),
    )
  ]
}


#let slides(
  title: none,
  subtitle: none,
  authors: none,
  footer: none,
  bib: none,
  body,
) = {
  set page(
    paper: "presentation-16-9",
    numbering: "- 1 -",
    footer: context {
      if counter(page).get().at(0) != 1 {
        // Handle the case when page.numbering is not set by
        // falling back to the default "1" numbering pattern.
        let page-numbering = page.numbering
        if page-numbering == none { page-numbering = "1" }
        let both = (
          type(page-numbering) == function
            or {
              (
                page-numbering
                  .clusters()
                  .filter(c => (
                    c
                      in (
                        // Counting symbols: https://typst.app/docs/reference/model/numbering
                        "1",
                        "a",
                        "A",
                        "i",
                        "I",
                        "α",
                        "Α",
                        "*",
                      )
                  ))
                  .len()
                  >= 2
              )
            }
        )
        text(
          size: footer_size,
          footer,
        )
        align(center)[
          #numbering(
            page-numbering,
            ..counter(page).get(),
            ..if both { counter(page).at(<numbering-main-end>) },
          )
        ]
      }
    },
  )
  set text(size: text_size, font: "New Computer Modern")
  show heading: head => text(
    size: header_sizes.at(head.level - 1),
    head,
  )
  // Title slide
  slide[
    #place(
      dx: -8%,
      dy: 15%,
      block(
        height: 30%,
        width: 116%,
        inset: (left: 8%, right: 8%),
        fill: rgb("#001f3f"),
        text(
          fill: white,
          align(horizon + center)[
            = #title
          ],
        ),
      ),
    )
    #place(
      dx: 50%,
      dy: 43%,
      block(
        fill: red,
        height: 4%,
        width: 60%,
      ),
    )
    #v(40%)
    #align(horizon + center)[
      == #subtitle
    ]
    #v(5%)
    // Authors and affiliations
    #block(
      inset: (left: 10%, right: 10%),
      grid(
        columns: (1fr,) * authors.len(),
        align: center,
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
      ),
    )

    // Place the logos
    // LAAS
    #place(
      top + left,
      dx: -5%,
      dy: -12%,
      image(width: 20%, "LogoLAAS.png"),
    )
    // CNRS
    #place(
      bottom + left,
      dx: 0%,
      dy: 5%,
      image(width: 8%, "LogoCNRS.png"),
    )
    // UT
    #place(
      bottom + right,
      dx: 0%,
      dy: 10%,
      image(width: 20%, "LogoUT.png"),
    )
  ]

  body
}

