// Heading settings.
// In a thesis we want
// - Level 1 headings to be called Chapters [heading1-as-chapter]
// - PDF bookmark to contain heading numberings 1.1.2 etc
// - Chapters to start on a new page [break-before-headings]

// They must be created in the precise order above, so the PDF link points to directly
// ABOVE the cosmetics and BELOW the breaks.

#let headings_custom(it) = {
  // ------------------- Settings for Chapter headings -------------------
  show heading.where(
    level: 1,
  ): it => {
    if it.numbering != none {
      block(
        width: 90%,
        stroke: (bottom: 1pt, right: 0pt),
        inset: (bottom: 2em, top: 5em),
        below: 10%,
      )[
        #set text(2em, weight: "regular")
        #text(1.5em, counter(heading).display("1" + it.numbering))
        #h(0.5em)
        #smallcaps(it.body)
      ]
    } else {
      block(width: 100%)[
        #v(3cm)
        #set text(2em, weight: "regular")
        #smallcaps(it.body)
        #v(1em)
      ]
    }
  }
  show heading.where(
    level: 2,
  ): it => {
    block(width: 100%)[
      #v(1em)
      #set text(1.5em, weight: "regular")
      #smallcaps(it)
      #v(1em)
    ]
  }
  show heading.where(
    level: 3,
  ): it => {
    block(width: 100%)[
      #v(1em)
      #set text(1.3em, weight: "regular")
      #smallcaps(it)
      #v(0.5em)
    ]
  }
  show heading.where(
    level: 4,
  ): it => {
    block(width: 100%)[
      #v(0.5em)
      #set text(1.1em, weight: "regular")
      #smallcaps(it.body)
      #v(0.5em)
    ]
  }
  it + [wow]
}

#let thesis-heading(it) = {
  show: it => headings_custom(it)
  show: break-before-headings
  it
}
