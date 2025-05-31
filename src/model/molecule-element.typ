#import "../libs/elembic/lib.typ" as e
#import "../utils.typ": (
  count-to-content,
  is-default,
  customizable-attach,
  phase-to-content,
)

#let molecule(
  count: 1,
  phase: none,
  //TODO: add up and down arrows
  phase-transition: 0,
  affect-layout: true,
  ..children,
) = { }

#let draw-molecule(it) = {
  let result = count-to-content(it.count)
  for child in it.children {
    result += child
  }
  if not is-default(it.phase) {
    result += context {
      text(phase-to-content(it.phase), size: text.size * 0.75)
    }
  }
  return result
}

#let molecule = e.element.declare(
  "molecule",
  prefix: "@preview/typsium:0.3.0",

  display: draw-molecule,

  fields: (
    e.field("children", e.types.array(content), required: true),
    e.field("count", e.types.union(int, content), default: 1),
    e.field("phase", e.types.union(str, content), default: none),
    e.field("affect-layout", bool, default: true),
  ),
)
