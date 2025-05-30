#import "utils.typ": get-all-children, is-metadata, typst-builtin-styled, typst-builtin-context, length
#import "parse-formula-intermediate-representation.typ": patterns

#import "utils.typ": arrow-string-to-kind, is-default, roman-to-number
#import "model/molecule.typ": molecule
#import "model/reaction.typ": reaction
#import "model/element.typ": element
#import "model/group.typ": group
#import "model/arrow.typ": arrow

#let get-count-and-charge(count1, count2, charge1, charge2, index, templates) = {
  let radical = false
  let roman-charge = false
  let count = if not is-default(count1) {
    templates.slice(index + if count1.contains("_"){1}, index + length(count1)).sum()
  } else if not is-default(count2) {
    templates.slice(index + length(charge1) + if count2.contains("_"){1}, index + length(charge1) + length(count2)).sum()
  } else {
    none
  }

  let charge = if not is-default(charge1) {
    templates.slice(index + if charge1.contains("^"){1}, index + length(charge1)).sum()
  } else if not is-default(charge2) {
    templates.slice(index + length(count1) + if charge2.contains("^"){1}, index + length(count1) + length(charge2)).sum()
  } else {
    none
  }

  // if not is-default(charge) {
  //   if charge.contains(".") {
  //     charge = charge.replace(".", "")
  //     radical = true
  //   }
  //   if charge.contains("I") or charge.contains("V") {
  //     let multiplier = if charge.contains("-") { -1 } else { 1 }
  //     charge = charge.replace("-", "").replace("+", "")
  //     charge = roman-to-number(charge) * multiplier
  //     roman-charge = true
  //   } else if charge == "-" {
  //     charge = -1
  //   } else if charge.contains("-") {
  //     charge = -int(charge.replace("-", ""))
  //   } else if charge == "+" {
  //     charge = 1
  //   } else if charge.replace("+", "").contains(regex("^[0-9]+$")) {
  //     charge = int(charge.replace("+", ""))
  //   } else {
  //     charge = 0
  //   }
  // }

  return (count, charge, radical, roman-charge)
}

#let string-to-element(formula, templates, index) = {
  let element-match = formula.match(patterns.element)
  if element-match == none {
    return (false,)
  }
  let symbol = element-match.captures.at(0)
  let oxidation = element-match.captures.at(5)
  let x = get-count-and-charge(
    element-match.captures.at(1),
    element-match.captures.at(3),
    element-match.captures.at(2),
    element-match.captures.at(4),
    index + symbol.len(),
    templates
  )
  let oxidation-number = none
  let roman-oxidation = true
  let roman-charge = false
  if oxidation != none {
    oxidation = upper(oxidation)
    oxidation = oxidation.replace("^", "", count: 2)
    let multiplier = if oxidation.contains("-") { -1 } else { 1 }
    oxidation = oxidation.replace("-", "").replace("+", "")
    if oxidation.contains("I") or oxidation.contains("V") {
      oxidation-number = roman-to-number(oxidation)
    } else {
      roman-oxidation = false
      oxidation-number = int(oxidation)
    }
    if oxidation-number != none {
      oxidation-number *= multiplier
    }
  }

  if x.at(0) == none and x.at(1) == none and x.at(2) == false {
    if formula.at(element-match.end + 1, default: "").match(regex("[a-z]")) != none {
      return (false,)
    }
  }

  return (
    true,
    element(
      templates.slice(index, index + element-match.captures.at(0).len()).sum(),
      count: x.at(0),
      charge: x.at(1),
      radical: x.at(2),
      oxidation: oxidation-number,
      roman-oxidation: roman-oxidation,
      roman-charge: x.at(3),
    ),
    element-match.end,
  )
}

#let string-to-math(formula) = {
  let match = formula.match(patterns.math)
  if match == none {
    return (false,)
  }
  return (true, eval(match.text), match.end)
}

#let string-to-reaction(
  reaction-string,
  templates,
  create-molecules: true,
) = {
  let remaining = reaction-string
  if remaining.len() == 0 {
    return ()
  }
  let full-reaction = ()
  let current-molecule-children = ()
  let current-molecule-count = 1
  let current-molecule-phase = none
  let current-molecule-charge = 0
  let random-content = ""

  let index = 0
  while remaining.len() > 0 {
    if remaining.at(0) == "&" {
      if current-molecule-children.len() > 0 {
        full-reaction.push(molecule(current-molecule-children))
        current-molecule-children = ()
      }
      full-reaction.push($&$)
      remaining = remaining.slice(1)
      index+=1
      continue
    }
    let math-result = string-to-math(remaining)
    if math-result.at(0) {
      if not is-default(random-content) {
        full-reaction.push([#random-content])
      }
      random-content = ""
      full-reaction.push(math-result.at(1))
      remaining = remaining.slice(math-result.at(2))
      index+=math-result.at(2)
      continue
    }

    let element = string-to-element(remaining, templates, index)
    if element.at(0) {
      if not is-default(random-content) {
        if current-molecule-children.len() == 0 {
          full-reaction.push([#random-content])
        } else {
          current-molecule-children.push([#random-content])
        }
      }
      random-content = ""
      current-molecule-children.push(element.at(1))
      remaining = remaining.slice(element.at(2))
      index+= element.at(2)
      continue
    }


    let group-match = remaining.match(patterns.group)
    if group-match != none {
      if not is-default(random-content) {
        if current-molecule-children.len() == 0 {
          full-reaction.push([#random-content])
        } else {
          current-molecule-children.push([#random-content])
        }
      }
      random-content = ""

      let group-content = group-match.captures.at(0)
      let kind = if group-content.at(0) == "(" {
        group-content = group-content.trim(regex("[()]"), repeat: false)
        0
      } else if group-content.at(0) == "[" {
        group-content = group-content.trim(regex("[\[\]]"), repeat: false)
        1
      } else if group-content.at(0) == "{" {
        group-content = group-content.trim(regex("[{}]"), repeat: false)
        2
      }
      let x = get-count-and-charge(
        group-match.captures.at(1),
        group-match.captures.at(3),
        group-match.captures.at(2),
        group-match.captures.at(4),
      )
      let group-children = string-to-reaction(group-content, create-molecules: false)

      current-molecule-children.push(group(group-children, kind: kind, count: x.at(0), charge: x.at(1)))
      remaining = remaining.slice(group-match.end)
      continue
    }

    let plus-match = remaining.match(patterns.reaction-plus)
    if plus-match != none {
      if current-molecule-children.len() > 0 {
        full-reaction.push(
          molecule(
            current-molecule-children,
            count: current-molecule-count,
            phase: current-molecule-phase,
            charge: current-molecule-charge,
          ),
        )
        current-molecule-children = ()
      }
      if not is-default(random-content) {
        full-reaction.push([#random-content])
      }
      random-content = ""
      full-reaction.push([+])
      remaining = remaining.slice(plus-match.end)
      continue
    }

    let arrow-match = remaining.match(patterns.reaction-arrow)
    if arrow-match != none {
      if current-molecule-children.len() > 0 {
        full-reaction.push(
          molecule(
            current-molecule-children,
            count: current-molecule-count,
            phase: current-molecule-phase,
            charge: current-molecule-charge,
          ),
        )
        current-molecule-children = ()
      }
      if not is-default(random-content) {
        full-reaction.push([#random-content])
      }
      random-content = ""
      let kind = arrow-string-to-kind(arrow-match.captures.at(0))
      let top = ()
      let bottom = ()
      if arrow-match.captures.at(1) != none {
        top = string-to-reaction(arrow-match.captures.at(1))
      }
      if arrow-match.captures.at(2) != none {
        bottom = string-to-reaction(arrow-match.captures.at(2))
      }
      full-reaction.push(arrow(kind: kind, top: top, bottom: bottom))
      remaining = remaining.slice(arrow-match.end)
      continue
    }

    random-content += remaining.codepoints().at(0)
    remaining = remaining.slice(remaining.codepoints().at(0).len())
  }
  if current-molecule-children.len() != 0 {
    full-reaction.push(
      molecule(current-molecule-children, count: current-molecule-count, phase: current-molecule-phase),
    )
  }
  if not is-default(random-content) {
    full-reaction.push([#random-content])
  }

  return full-reaction
}





#let create-full-string(children) = {
  let full-string = ""
  let templates = ()
  for child in children {
    if type(child) == content {
      let func-type = child.func()
      if child == [ ] {
        full-string += " "
      } else if func-type == text {
        full-string += child.text
        for value in child.text {
          templates.push([#value])
        }
        // templates += child.text.map(x=> [#x])
      } else if func-type == typst-builtin-styled {
        let x = create-full-string(get-all-children(child.child))
        full-string += x.at(0)
        templates.push(child)
      } else if (
        func-type
          in (
            math.overbrace,
            math.underbrace,
            math.underbracket,
            math.overbracket,
            math.underparen,
            math.overparen,
            math.undershell,
            math.overshell,
            pad,
            strong,
            highlight,
            overline,
            underline,
            strike,
            math.cancel,
            //TODO: implement missing methods in utils:
            figure,
            quote,
            emph,
            smallcaps,
            sub,
            super,
            box,
            block,
            hide,
            move,
            scale,
            circle,
            ellipse,
            rect,
            square,
          )
      ) {
        let x = create-full-string(get-all-children(child.body))
        full-string += x.at(0)
        templates.push(child)
      } else {
        continue
      }
    }
  }
  return (full-string, templates)
}

#let content-to-reaction(body) = {
  if type(body) != content {
    return ()
  }
  let children = get-all-children(body)
  let (full-string, templates) = create-full-string(children)

  return string-to-reaction(full-string, templates)
}
