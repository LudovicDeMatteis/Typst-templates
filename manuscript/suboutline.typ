#let suboutline(
  title: none,
  target: heading.where(outlined: true),
  depth: none,
  indent: auto,
  fill: repeat([.], gap: 0.15em),
) = {
  if depth == none {
    depth = calc.inf
  }

  set outline.entry(fill: fill)

  context {
    let current_location = here()

    let previous_chapter = query(selector(figure.where(kind: "chapter", outlined: true)).before(current_location))
    // This should not happen at all
    if previous_chapter == () {
      outline(title: title, target: target, depth: depth, indent: indent)
    }
    let current_chapter = previous_chapter.last()

    let min_level = 0
    let max_level = min_level + depth

    let following_headings = query(selector(heading
      .where(outlined: true)
      .or(figure.where(kind: "chapter", outlined: true))).after(current_location))
    if following_headings == () {
      max_level = if max_level == calc.inf {
        none
      } else {
        max_level
      }
      outline(
        title: title,
        target: selector(target).after(
          current_chapter.location(),
          inclusive: false,
        ),
        depth: max_level,
        indent: indent,
      )
    } else {
      let last_subheading = none
      for following_heading in following_headings {
        if following_heading.func() == figure {
          break
        } else if following_heading.level <= min_level {
          break
        }
        last_subheading = following_heading
      }

      max_level = if max_level == calc.inf {
        calc.max(..following_headings.map(s => s.level))
      } else {
        max_level
      }

      if last_subheading != none {
        outline(
          title: title + [\ #v(-0.5cm) #line(length: 100%, stroke: 1pt + black.lighten(50%)) #v(-0.5cm)],
          target: selector(target)
            .after(
              current_chapter.location(),
              inclusive: false,
            )
            .before(last_subheading.location()),
          depth: max_level,
          indent: indent,
        )
        line(length: 100%, stroke: 1pt + black.lighten(50%))
      }
    }
  }
}
