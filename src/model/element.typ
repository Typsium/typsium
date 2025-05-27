#import "../libs/elembic/lib.typ" as e
#import "../utils.typ": (
  count-to-content,
  charge-to-content,
  none-coalesce,
  customizable-attach,
)

#let element(
  symbol: "",
  count: 1,
  charge: 0,
  oxidation: none,
  a: none,
  z: none,
  rest: none,
  radical: false,
  affect-layout: true,
) = { }

#let draw-element(it) = {
  let base = it.symbol
  if it.rest != none {
    if type(it.rest) == content {
      base += it.rest
    } else if type(it.rest) == int {
      base += box['] * it.rest
    }
  }

  let mass-number = it.a
  if type(it.a) == int {
    mass-number = [#it.a]
  }
  let atomic-number = it.z
  if type(it.z) == int {
    atomic-number = [#it.z]
  }

  customizable-attach(
    base,
    t: it.oxidation,
    tr: charge-to-content(it.charge, radical: it.radical),
    br: count-to-content(it.count),
    tl: mass-number,
    bl: atomic-number,
    affect-layout: it.affect-layout,
  )
}
}

#let element = e.element.declare(
  "element",
  prefix: "typsium",

  display: draw-element,

  fields: (
    e.field("symbol", e.types.union(str, content), default: none, required: true),
    e.field("count", e.types.union(int, content), default: 1),
    e.field("charge", e.types.union(int, content), default: 0),
    e.field("oxidation", e.types.union(int, content), default: none),
    e.field("a", e.types.union(int, content), default: none),
    e.field("z", e.types.union(int, content), default: none),
    e.field("rest", e.types.union(int, content), default: none),
    e.field("radical", bool, default: false),
    e.field("affect-layout", bool, default: true),
  ),
)