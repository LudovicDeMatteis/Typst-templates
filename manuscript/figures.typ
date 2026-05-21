#import "counters.typ": *
#import "variables.typ": *

/****************************/
/***** Caption settings *****/
/****************************/
#let flex-caption(long, short) = context if in-outline.get() { short } else { long }


/***************************/
/*** Creating Subfigures ***/
/***************************/
// A superfigure contains a grid of figures of kind "subfigures"
#let superfigure(..args) = {
  // sub figures are positional
  let sub_figures = args.pos()
  // split grid and figure arguments
  let figure_attr = ("alt", "placement", "scope", "caption", "kind", "supplement", "numbering", "gap", "outlined")
  let grid_attr = ("columns", "rows", "gutter", "column-gutter", "row-gutter", "inset", "align", "fill", "stroke")
  let super_figure_args = (:)
  let grid_args = (:)
  for (k, v) in args.named() {
    if k in figure_attr { super_figure_args += ((k): v) }
    if k in grid_attr { grid_args += ((k): v) }
  }
  // create the super figure
  figure(
    {
      // reset sub_figure counter
      subfig_counter.update(0)
      set figure(numbering: none, supplement: none, outlined: false, kind: "subfigure")
      show figure: it => {
        subfig_counter.step()
        // manual caption formatting
        show figure.caption: caption => context {
          subfig_counter.display("(a) ") + caption.body
        }
        it
      }
      grid(..grid_args, ..sub_figures)
    },
    ..super_figure_args,
  )
}

