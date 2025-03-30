#let _plugin = plugin("../bin/plugin.wasm")

#let _bail(msg) = assert(false, message: msg)

#let _construct_arrow(arr) = {
  if arr.type == "special" {
    return sym.harpoons.rtlb
  } else if arr.type == "single" {
    if arr.data.left {
      sym.arrow.l.r.long
    } else {
      sym.arrow.r.long
    }
  } else if arr.type == "double" {
    if arr.data.left {
      if arr.data.right {
        sym.arrow.l.r.double.long
      } else {
        sym.arrow.l.double.long
      }
    } else {
      if arr.data.right {
        sym.arrow.r.double.long
      } else {
        sym.eq
      }
    }
  } else {
    _bail("Unknown arrow variant")
  }
}

#let _construct_component(c) = {
  let _construct_grouped(g) = {
    if g.type == "parenthesized" {
      if g.bracket == "round" {
        $lr((#(g.children.map(_construct_component).join())))$.body
      } else if g.bracket == "square" {
        $lr([#(g.children.map(_construct_component).join())])$.body
      } else {
        _bail("Unknown bracket type")
      }
    } else if g.type == "single" {
      $#g.symbol$.body
    } else {
      _bail("Unknown grouped variant")
    }
  }
  let t = if c.charge > 0 {
    if c.charge == 1 [+] else [#c.charge;+]
  } else if c.charge < 0 {
    if c.charge == -1 [-] else [#c.charge;-]
  }
  let b = if c.count > 1 [#c.count]
  math.attach(_construct_grouped(c.base), t: t, b: b)
}


#let ce(formula) = {
  for part in json(_plugin.ce(bytes(formula))) {
    if part.type == "component" {
      _construct_component(part.body)
    } else if part.type == "plus" {
      $+$.body
    } else if part.type == "number" {
      [#part.body]
    } else if part.type == "arrow" {
      _construct_arrow(part.body)
    } else {
      _bail("Unknown part variant")
    }
  }
}
