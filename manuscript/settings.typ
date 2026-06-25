#import "../global/colors.typ": *
/***************************************************************/
/** Text-related variables (size, font, weight, modifiers...) **/
/***************************************************************/
#let text_base_size = 12pt
#let list_markers = (text(20pt, gray.darken(20%), [•], baseline: -2.5pt), [-])

#let headings_cfg = (
  "h1": (
    size: 20pt,
    weight: "bold",
    emph: false,
    smallcaps: true,
    inset: (y: 1em),
  ),
  "h2": (
    size: 18pt,
    weight: "bold",
    emph: false,
    smallcaps: true,
    inset: (y: 0.5em),
  ),
  "h3": (
    size: 14pt,
    weight: "bold",
    emph: false,
    smallcaps: true,
    inset: (y: 0.2em),
  ),
  "h4": (
    size: text_base_size,
    weight: "bold",
    emph: false,
    smallcaps: true,
    inset: (y: 0.0em),
  ),
)

#let part_cfg = (
  "size": 32pt,
  "weight": "regular",
  "smallcaps": true,
  "justify": false,
  "emph": false,
  //
  "block_width": 90%,
  "block_stroke": (bottom: 2pt, top: 2pt),
  "block_radius": 0pt,
  "block_inset": (bottom: 5em, top: 5em),
  //
  "num_size": 36pt,
  "num_weight": "bold",
)

#let chapter_cfg = (
  "size": 28pt,
  "weight": "regular",
  "smallcaps": true,
  "emph": false,
  //
  "num_size": 28pt,
  "num_weight": "bold",
  //
  "first-line-indent": 0pt,
  "hanging-indent": 1.0em,
  "spacing": 1.0em,
  //
  "block_width": 95%,
  "block_stroke": (bottom: 2pt, right: 2pt),
  "block_radius": 10pt,
  "block_inset": (bottom: 2em, top: 3em, right: 2em),
)
/*********************/
/** Color variables **/
/*********************/
#let cover-color = black
#let heading-color = proper-purple
#let link-color = ugent-blue
#let outline-part-color = proper-purple

/*********************/
/* Equation settings */
/*********************/
#let equate-settings = (
  breakable: true,
  sub-numbering: true,
  number-mode: "line",
)

/**********************/
/* Numbering settings */
/**********************/
#let equation-numbering = "(1.a)"
#let heading-numbering = "1.1"
#let page-numbering-preface = "i'"
#let page-numbering = "1"
#let enum-numbering = "(i)"
#let figure-numbering = "1.1"
