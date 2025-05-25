#import "utils.typ": (
  try-at,
  count-to-content,
  charge-to-content,
  get-bracket,
  get-arrow,
  phase-to-content,
  typst-builtin-styled,
  none-coalesce,
  reconstruct-content,
)
#let display-element(data) = {
  let isotope = data.at("isotope", default: none)
  let symbol = data.symbol
  let t = data.at("oxidation-number", default: none)
  let tr = charge-to-content(data.at("charge", default: none), radical: data.at("radical", default: false))
  let br = count-to-content(data.at("count", default: none))
  let tl = try-at(isotope, "mass-number")
  let bl = try-at(isotope, "atomic-number")

  symbol = reconstruct-content(data.at("symbol-body", default: none), symbol)
  tr = reconstruct-content(data.at("charge-body", default: none), tr)
  br = reconstruct-content(data.at("count-body", default: none), br)

  math.attach(
    symbol,
    t: t,
    tr: tr,
    br: br,
    tl: tl,
    bl: bl,
  )
}

#let display-group(data) = {
  let children = data.at("children", default: ())
  let kind = data.at("kind", default: 1)
  let tr = charge-to-content(data.at("charge", default: none))
  let br = count-to-content(data.at("count", default: none))

  tr = reconstruct-content(data.at("charge-body", default: none), tr)
  br = reconstruct-content(data.at("count-body", default: none), br)

  let result = math.attach(
    math.lr({
      get-bracket(kind, open: true)
      for child in children {
        if child.type == "content" {
          child.body
        } else if child.type == "element" {
          display-element(child)
        } else if data.type == "align" {
          $&$
        } else if child.type == "group" {
          display-group(child)
        }
      }
      get-bracket(kind, open: false)
    }),
    tr: tr,
    br: br,
  )

  return reconstruct-content(data.at("body", default: none), result)
}

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

#let display-ir(data) = {
  if data == none {
    none
  } else if type(data) == array {
    for value in data {
      display-ir(value)
      //this removes spacing for groups that have long charges (looks better)
      if value.type == "molecule" {
        let last = value.children.last()
        if (
          last.type == "group" and (last.at("charge", default: none) != none or last.at("count", default: none) != none)
        ) {
          h(-0.4em)
        }
      }
    }
  } else if type(data) == dictionary {
    if data.type == "molecule" {
      display-molecule(data)
    } else if data.type == "+" {
      h(0.4em, weak: true)
      math.plus
      h(0.4em, weak: true)
    } else if data.type == "group" {
      display-group(data)
    } else if data.type == "element" {
      display-element(data)
    } else if data.type == "content" {
      data.body
    } else if data.type == "align" {
      $&$
    } else if data.type == "arrow" {
      h(0.4em, weak: true)
      let top = display-ir(data.at("top", default: none))
      let bottom = display-ir(data.at("bottom", default: none))
      math.attach(
        math.stretch(
          get-arrow(data.at("kind", default: 0)),
          size: 100% + 2em,
        ),
        t: top,
        b: bottom,
      )
      h(0.4em, weak: true)
    }
  } else if type(data) == content {
    data
  }
}
