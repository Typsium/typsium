#import "../libs/elembic/lib.typ" as e
#import "../utils.typ": (
  count-to-content,
  charge-to-content,
  is-default,
  customizable-attach,
  phase-to-content,
)

#let molecule(
  count: 1,
  charge: 0,
  phase: none,
  affect-layout: true,
  ..children,
) = { }

#let display-molecule(data) = {
  count-to-content(data.at("count", default: none))

  let result = math.attach(
    [
      #let children = data.at("children", default: ())
      #for child in children {
        if child.type == "content" {
          child.body
        } else if data.type == "align" {
          $&$
        } else if child.type == "element" {
          display-element(child)
        } else if child.type == "group" {
          display-group(child)
        }
      }
    ],
    tr: charge-to-content(data.at("charge", default: none)),
    // br: phase-to-content(data.at("phase", default:none)),
  )
  if data.at("phase", default: none) != none {
    result += context {
      text(phase-to-content(data.at("phase", default: none)), size: text.size * 0.75)
    }
  }

  return reconstruct-content(data.at("body", default: none), result)
}

#let draw-molecule(it) = {
  let result = count-to-content(it.count)
  result += customizable-attach(
    for child in it.children {
      child
    },
    tr: charge-to-content(it.charge),
    affect-layout: it.affect-layout,
  )
  if not is-default(it.phase) {
    result += context {
      text(phase-to-content(it.phase), size: text.size * 0.75)
    }
  }
  return result
}

#let molecule = e.element.declare(
  "molecule",
  prefix: "typsium",

  display: draw-molecule,

  fields: (
    // e.field("children", e.types.any, required: true),
    e.field("children", e.types.array(content), required: true),
    e.field("count", e.types.union(int, content), default: 1),
    e.field("charge", e.types.union(int, content), default: 0),
    e.field("phase", e.types.union(str, content), default: none),
    e.field("affect-layout", bool, default: true),
  ),
  // parse-args: (default-parser, fields: none, typecheck: none) => (args, include-required: false) => {
  //   let args = if include-required {
  //     let values = args.pos()
  //     arguments(values, ..args.named())
  //   } else if args.pos() == () {
  //     args
  //   } else {
  //     assert(
  //       false,
  //       message: "element 'diagram': unexpected positional arguments\n  hint: these can only be passed to the constructor",
  //     )
  //   }
  //   default-parser(args, include-required: include-required)
  // },
)
