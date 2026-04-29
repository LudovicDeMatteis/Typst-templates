// global
#import "@preview/great-theorems:0.1.2": great-theorems-init
#import "@preview/hydra:0.6.1": hydra
#import "@preview/equate:0.3.2": equate
#import "@preview/i-figured:0.2.4": reset-counters, show-equation

#import "headings.typ": thesis-heading

#let in-outline = state("in-outline", false)

#let flex-caption(long, short) = context if in-outline.get() { short } else { long }

#let template(
  author: "",
  title: "",
  supervisor: "",
  deadline: "",
  // file paths for logos etc.
  uni-logo: none,
  lab-logo: none,
  // formatting settings
  body-font: "Libertinus Serif",
  cover-font: "Libertinus Serif",
  // Heading settings
  heading-numbering: "1.1",
  // Colors
  cover-color: rgb("#800080"),
  heading-color: rgb("#0000ff"),
  link-color: rgb("#000000"),
  // Equation settings
  equate-settings: none,
  equation-numbering-pattern: "(1.1)",
  // Special content
  frontmatter: none,
  quote-text: none,
  quote-author: none,
  abstract: none,
  resume: none,
  acknowledgments: none,
  list_acronyms: none,
  list_figures: none,
  list_tables: none,
  list_symbols: none,
  //
  text-base-size: 12pt,
  // Body content
  body,
) = {
  // Main settings
  set document(
    author: author,
    title: title,
  )
  set heading(
    numbering: heading-numbering,
  )
  set enum(
    numbering: "(i)",
  )
  show link: set text(fill: link-color)
  show ref: set text(fill: link-color)
  set page(
    paper: "a4",
    numbering: "i'",
  )
  set text(
    size: text-base-size,
  )
  // ------------------  Math settings  ---------------------
  // either use equate if equate-settings is provided
  // or use i-figured settings otherwise
  show math.equation: it => {
    if equate-settings == none {
      show-equation(prefix: "eq:", only-labeled: true, numbering: equation-numbering-pattern, it)
    } else {
      it
    }
  }
  set math.equation(supplement: none) if equate-settings == none

  // equate settings
  show: it => {
    if equate-settings != none {
      equate(..equate-settings, it)
    } else {
      it
    }
  }
  set math.equation(numbering: equation-numbering-pattern) if equate-settings != none

  // Reference equations with parentheses (for equate)
  // cf. https://forum.typst.app/t/how-can-i-set-numbering-for-sub-equations/1603/4
  show ref: it => {
    let eq = math.equation
    let el = it.element

    let is-normal-equation = el != none and el.func() == eq
    let with-subnumbers = (
      equate-settings != none and equate-settings.keys().contains("sub-numbering") and equate-settings.sub-numbering
    )
    let is-sub-equation = el != none and el.func() == figure and el.kind == eq
    if equate-settings != none and is-normal-equation {
      link(el.location(), numbering(el.numbering, ..counter(eq).at(el.location())))
    } else if equate-settings != none and not with-subnumbers and is-sub-equation {
      link(el.location(), numbering(
        el.numbering,
        counter(eq).at(el.location()).at(0) - 1,
      ))
    } else if equate-settings != none and is-sub-equation {
      link(el.location(), numbering(
        el.numbering,
        ..el.body.value,
      ))
    } else {
      it
    }
  }
  show math.equation: box // no line breaks in equations
  show: great-theorems-init // great-theorems settings

  // ------------------  Other settings  ---------------------
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)

  // -------------------  Front Matter  ---------------------
  // University given cover page
  set text(font: body-font)
  if frontmatter != none {
    frontmatter
    pagebreak(weak: true)
  }

  set page(numbering: "i")
  counter(page).update(1)

  // -------------------  Cover  ---------------------
  set page(footer: none)
  set text(font: cover-font)

  v(1fr)
  // Logos
  grid(
    columns: (1fr, 1fr),
    rows: auto,
    column-gutter: 100pt,
    row-gutter: 7pt,
    grid.cell(
      colspan: 1,
      align: center,
      uni-logo,
    ),
    grid.cell(
      colspan: 1,
      align: center,
      lab-logo,
    ),
  )
  v(5fr)
  // Title
  line(length: 100%, stroke: 1.5pt + cover-color)
  align(center, text(3em, weight: "bold", smallcaps(title)))
  line(length: 100%, stroke: 1.5pt + cover-color)
  v(5fr)
  // Author
  align(center, text(1.5em, weight: 500, "Thesis by " + author))
  // Date
  align(center, text(1.3em, weight: 100, deadline))
  // Supervisors
  align(center + bottom, text(1.3em, weight: 100, "Supervised by " + linebreak() + supervisor))
  v(1fr)
  pagebreak()

  set page(footer: auto)
  set text(font: body-font)
  // ---------------------  Settings for headings -----------------------
  show: it => thesis-heading(it)
  show heading: it => {
    if equate-settings == none {
      reset-counters(it)
    } else {
      it
    }
  }

  // ----------------  Citation / Abstract / Resume / Aknowledgements  ------------------
  if quote-text != none and quote-author != none {
    set quote(block: true)
    align(center + horizon, text(1.6em, weight: "regular", quote(attribution: quote-author)[
      #quote-text
    ]))
    pagebreak(weak: true)
  }

  if abstract != none {
    abstract
    pagebreak(weak: true)
  }

  if resume != none {
    resume
    pagebreak(weak: true)
  }

  if acknowledgments != none {
    acknowledgments
    pagebreak(weak: true)
  }

  // -------------------  Outline  ------------------
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }

  show outline.entry.where(
    level: 1,
  ): it => {
    v(14.75pt, weak: true)
    it.prefix()
    h(0.5em)
    smallcaps(it.body())
    h(1fr)
    it.page()
  }
  // ------------------- Tables of ... -------------------
  // Table of contents
  set outline.entry(fill: line(length: 100%, stroke: (thickness: 1pt, dash: "loosely-dotted")))
  outline(depth: 2, indent: 1.5em)
  pagebreak()

  if list_symbols != none {
    list_symbols
    pagebreak(weak: true)
  }

  if list_acronyms != none {
    list_acronyms
    pagebreak(weak: true)
  }

  if list_figures != none {
    list_figures
    pagebreak(weak: true)
  }
  if list_tables != none {
    list_tables
    pagebreak(weak: true)
  }

  // Change page counter
  set page(numbering: "1", header: context {
    align(left, emph(hydra(1)))
  })
  counter(page).update(1)

  // Content
  body
}
