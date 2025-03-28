#import "utils.typ": try-at, count-to-content, charge-to-content, get-bracket, get-arrow, phase-to-content

#let display-element(data) = {
  let isotope = data.at("isotope", default: none)
  math.attach(
    data.symbol,
    t: data.at("oxidation-number", default: none),
    tr: charge-to-content(data.at("charge", default: none)),
    br: count-to-content(data.at("count", default: none)),
    tl: try-at(isotope, "mass-number"),
    bl: try-at(isotope, "atomic-number"),
  )
}

#let display-group(data) = {
  let children = data.at("children", default:())
  math.attach(
      math.lr({
        get-bracket(data.kind, open:true)
        for child in children {
          if child.type == "element"{
            display-element(child)
          } else if child.type == "group" {
            display-group(child)
          }
        }
        get-bracket(data.kind, open:false)  
      }),
      tr: charge-to-content(data.at("charge", default: none)),
      br: count-to-content(data.at("count", default: none)),
    )
}

#let display-ir(data) = {
  if data== none{
    none
  } else if type(data) == array{
    for value in data {
      display-ir(value)
    }
  } else if data.type == "molecule" {
    count-to-content(data.at("count", default: none))
    math.attach(
      [
        #let children = data.at("children", default:())
        #for child in children {
          if child.type == "element"{
            display-element(child)
          } else if child.type == "group" {
            display-group(child)
          }
        }
      ],
      tr: charge-to-content(data.at("charge", default: none)),
      // br: phase-to-content(data.at("phase", default:none)),
    )
    context {
      text(phase-to-content(data.at("phase", default:none)), size: text.size * 0.75)  
    }
  } else if data.type == "+"{
    math.plus
  } else if data.type == "group"{
    display-group(data)
  } else if data.type == "element"{
    display-element(data)
  } else if data.type == "arrow"{
    if data.at("align", default: 0) == 1{
      $&$
    }
    let top = display-ir(data.at("top", default:none))
    let bottom = display-ir(data.at("bottom", default:none))
    math.attach(
      math.stretch(
        get-arrow(data.at("kind", default:0)),
        size: 100% + 2em
      ),
      t: top,
      b: bottom,
    )
    if data.at("align", default: 0) == 2{
      $&$
    }
  } else if data.type == "content" {
    data.body
  }
}