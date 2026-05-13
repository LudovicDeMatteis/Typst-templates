// global
#import "@preview/great-theorems:0.1.2": great-theorems-init
#import "@preview/hydra:0.6.1": hydra
#import "@preview/equate:0.3.2": equate
#import "@preview/i-figured:0.2.4": reset-counters, show-equation, show-figure
#import "suboutline.typ": suboutline
#import "variables.typ": *

#let in-outline = state("in-outline", false)

#let flex-caption(long, short) = context if in-outline.get() { short } else { long }

#let chapter = figure.with(kind: "chapter", numbering: "I", supplement: "Chapter", caption: [])

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
    numbering: enum-numbering,
  )
  show link: set text(fill: link-color)
  show ref: set text(fill: link-color)
  set page(paper: "a4", margin: (inside: 3cm, outside: 2cm, top: 3cm))
  set text(
    size: text_base_size,
    font: body-font,
  )
  set list(marker: list_markers)

  // ------------------  Math settings  ---------------------
  show: equate.with(..equate-settings)
  set math.equation(numbering: equation-numbering)
  // Reference equations with parentheses (for equate)
  // cf. https://forum.typst.app/t/how-can-i-set-numbering-for-sub-equations/1603/4
  show ref: it => {
    let eq = math.equation
    let el = it.element

    let is-normal-equation = el != none and el.func() == eq
    let with-subnumbers = (
      equate-settings.keys().contains("sub-numbering") and equate-settings.sub-numbering
    )
    let is-sub-equation = el != none and el.func() == figure and el.kind == eq
    if is-normal-equation {
      link(el.location(), numbering(el.numbering, ..counter(eq).at(el.location())))
    } else if not with-subnumbers and is-sub-equation {
      link(el.location(), numbering(
        el.numbering,
        counter(eq).at(el.location()).at(0) - 1,
      ))
    } else if is-sub-equation {
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
  show figure: it => {
    block(show-figure(it, numbering: figure-numbering), inset: (y: 0.5em))
  }
  show figure.caption: box.with(width: 80%)
  // -------------------  Front Matter  ---------------------
  // University given cover page
  set text(font: body-font)
  if frontmatter != none {
    frontmatter
    pagebreak(weak: true)
  }

  set page(numbering: page-numbering-preface, footer: none, header: none)
  counter(page).update(1)

  // -------------------  Cover  ---------------------
  set page(footer: none, header: none)
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
  align(center, text(25pt, weight: "bold", title))
  line(length: 100%, stroke: (thickness: 2pt, paint: cover-color, cap: "round"))
  v(5fr)
  // Author
  align(center, text(1.5em, weight: 500, "Thesis by " + author))
  // Date
  align(center, text(1.3em, weight: 100, deadline))
  // Supervisors
  align(center + bottom, text(1.3em, weight: 100, "Supervised by " + linebreak() + supervisor))
  v(1fr)
  pagebreak()

  set page(footer: auto, header: none)
  set text(font: body-font, hyphenate: true)
  set par(justify: true, first-line-indent: 0.5cm, spacing: text_base_size)

  // ---------------- Chapters display -------------
  show figure.where(kind: "chapter"): it => {
    pagebreak()
    // set page(header: none)
    set align(left)
    counter(heading).update(0)
    if it.numbering != none {
      block(
        width: chapter_cfg.at("block_width"),
        stroke: chapter_cfg.at("block_stroke"),
        radius: chapter_cfg.at("block_radius"),
        inset: chapter_cfg.at("block_inset"),
      )[
        #set text(
          size: chapter_cfg.at("size"),
          weight: chapter_cfg.at("weight"),
          hyphenate: false,
        )
        #set par(
          justify: false,
          hanging-indent: chapter_cfg.at("hanging-indent"),
          first-line-indent: chapter_cfg.at("first-line-indent"),
          spacing: chapter_cfg.at("spacing"),
        )
        #text(
          size: chapter_cfg.at("num_size"),
          weight: chapter_cfg.at("num_weight"),
          [Chapter #counter(figure.where(kind: "chapter")).display("I" + it.numbering) -],
        )
        #parbreak()
        #smallcaps(it.body)
      ]
      set text(12pt)
      suboutline(title: "Content", depth: 2)
    } else {
      block(width: 100%)[
        #v(3cm)
        #set text(chapter_cfg.at("size"), weight: chapter_cfg.at("weight"))
        #let res = it.body
        #if chapter_cfg.at("emph") {
          res = emph(res)
        }
        #if chapter_cfg.at("smallcaps") {
          res = smallcaps(res)
        }
        #res
        #v(1em)
      ]
    }
  }
  // --------------------- Headings Display -----------------------
  show heading: it => {
    let lvl = calc.min(it.level, 4)
    let key = "h" + str(lvl)
    set text(size: headings_cfg.at(key).at("size"), weight: headings_cfg.at(key).at("weight"))
    let res = it
    if headings_cfg.at(key).at("emph") {
      res = emph(res)
    }
    if headings_cfg.at(key).at("smallcaps") {
      res = smallcaps(res)
    }
    block(res, inset: headings_cfg.at(key).at("inset"))
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
  // emulate element function by creating show rule
  let chapters-and-headings = figure.where(kind: "chapter", outlined: true).or(heading.where(outlined: true))
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }
  show outline.entry: it => {
    if it.element.func() == figure and it.element.kind == "chapter" {
      let res = link(
        it.element.location(),
        if it.element.numbering != none {
          [#numbering(it.element.numbering, ..it.element.counter.at(it.element.location())) #h(0.5em)]
        }
          + smallcaps(it.element.body),
      )
      if it.fill != none {
        res += [ ] + box(width: 1fr, it.fill) + [ ]
      } else {
        res += h(1fr)
      }
      res += link(it.element.location(), it.page())
      strong(res)
    } else if it.element.func() == heading {
      show link: set text(black)
      let res = h(1em) * it.level
      res += link(it.element.location(), it.prefix() + "   ")
      if it.element.level == 1 {
        res += link(it.element.location(), smallcaps(it.element.body))
        res = strong(res)
      } else {
        res += link(it.element.location(), it.element.body)
      }
      if it.fill != none {
        res += [ ] + box(width: 1fr, it.fill) + [ ]
      } else {
        res += h(1fr)
      }
      res += link(it.element.location(), it.page())
      res
    } else {
      it
    }
    linebreak()
  }

  // ------------------- Tables of ... -------------------
  // Table of contents
  set outline.entry(fill: line(length: 100%, stroke: (thickness: 1pt, dash: "loosely-dotted")))

  chapter(numbering: none, outlined: false)[Table of Contents]
  outline(title: none, depth: 2, indent: 1.5em, target: chapters-and-headings)
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
  set page(numbering: page-numbering, header: context {
    let previous_chapter = query(selector(figure.where(kind: "chapter", outlined: true)).before(here()))
    let next_chapter = query(selector(figure.where(kind: "chapter", outlined: true).after(here(), inclusive: true)))
    let skip_header = false
    let current_chapter = previous_chapter.last()
    if next_chapter != () {
      let next_chapter_page = next_chapter.first().location().page()
      if next_chapter_page == here().page() {
        skip_header = true
      }
    }
    if previous_chapter != () and not skip_header {
      if calc.odd(here().page()) {
        align(right, emph(current_chapter.body))
      } else {
        let last_headings = query(selector(heading
          .where(level: 1, outlined: true)
          .after(current_chapter.location())
          .before(here())))
        if last_headings != () {
          align(left, emph(hydra(1)))
        }
      }
    }
  })
  counter(page).update(1)

  // Content
  body
}
