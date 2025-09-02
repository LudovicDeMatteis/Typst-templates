#import "@preview/polylux:0.4.0": *

// Define text sizes
#let text_size = 15pt
#let footer_size = 10pt
#let header_sizes = (25pt, 17pt, 15pt, 10pt)

#let title_slide(
  title: none,
  subtitle: none,
) = {
  set page(
    background: image("title_background.jpeg", width: 100%, height: 100%),
    footer: none,
  )
  slide[
    #place(
      dx: 37%,
      block(
        height: 100%,
        width: 50%,
        align(horizon)[
          = #title
          #line(length: 45%)
          == #subtitle
        ],
      ),
    )
  ]
}

#let content_slide(
  title: none,
  subtitle: none,
  body,
) = {
  set page(background: image("background.jpeg", width: 100%, height: 100%))
  slide[
    #place(
      dx: 0%,
      dy: -10%,
      [
        #if title != none {
          [
            = #title
            #line(length: 60%)
            #v(-3%)
            #if subtitle != none {
              [== #subtitle]
            }
          ]
          place(
            dx: 0%,
            dy: 30%,
            block(
              width: 100%,
              height: 92%,
              inset: (top: 2%, bottom: 0%),
              body,
            ),
          )
        } else {
          place(
            dx: 0%,
            dy: 0%,
            block(
              width: 100%,
              height: 110%,
              inset: (top: 0%, bottom: 0%),
              body,
            ),
          )
        }
      ],
    )
  ]
}

#let slides(
  title: none,
  subtitle: none,
  authors: (),
  footer: none,
  bib: none,
  body,
) = {
  set page(
    background: image("title_background.jpeg", width: 100%, height: 100%),
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
    smallcaps(head),
  )
  slide[
    #place(
      dx: 37%,
      block(
        height: 100%,
        width: 50%,
        align(horizon)[
          = #title
          #line(length: 45%)
          == #subtitle

          #align(horizon + left)[
            #for (ai, name) in (..authors.map(a => a.name),).enumerate() {
              linebreak()
              name
            }
          ]
        ],
      ),
    )
  ]

  body
}
