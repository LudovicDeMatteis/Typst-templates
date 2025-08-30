#import "@preview/polylux:0.4.0": *

// Define text sizes
#let footer_size = 10pt
#let header_sizes = (40pt, 25pt, 15pt, 10pt)

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
              height: 95%,
              inset: (top: 0%, bottom: 0%),
              body,
            ),
          )
        } else {
          place(
            dx: 0%,
            dy: 0%,
            block(
              width: 100%,
              height: 120%,
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
  author: (),
  bib: none,
  body,
) = {
  set page(
    paper: "presentation-16-9",
    footer: text(
      size: footer_size,
      [#author.name #author.surname],
    ),
    numbering: "1",
    number-align: bottom + right,
    background: image("background.jpeg", width: 100%, height: 100%),
  )
  set text(size: 25pt, font: "New Computer Modern")
  show heading: head => text(
    size: header_sizes.at(head.level),
    smallcaps(head),
  )

  body
}
