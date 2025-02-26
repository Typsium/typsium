#import "utils.typ": regex-patterns, config

// === Basic Processing Functions ===
#let process-element(element, count) = { $element-count$ }
#let process-bracket(bracket, count) = { $bracket-count$ }
#let process-charge(input, charge) = context {
  show "+": math.plus
  show "-": math.minus
  $input #block(height:measure(input.at("children", default: (input,)).last()).height)^charge$
}

// === Formula Parser ===
#let parse-formula(formula) = {
  let remaining = formula.trim()
  let result = none
  while remaining.len() > 0 {
    let matched = false
    for pattern in config.match-order.basic {
      let match = remaining.match(regex-patterns.at(pattern))
      if match != none {
        result += if pattern == "coef" { $#match.text$ } else if pattern == "element" {
          process-element(match.captures.at(0), match.captures.at(1))
        } else { process-bracket(match.captures.at(0), match.captures.at(1)) }
        remaining = remaining.slice(match.end)
        matched = true
        break
      }
    }
    if not matched {
      result += text(remaining.first())
      remaining = remaining.slice(1)
    }
  }
  return if result == none { formula } else { result }
}

// === Condition Processing ===
#let process-condition(cond) = {
  let cond = cond.trim()
  if cond in config.conditions.bottom.symbols.heating {
    return (none, { sym.Delta })
  }
  let is-bottom = (
    config.conditions.bottom.identifiers.any(ids => ids.any(id => cond.starts-with(id)))
      or config.conditions.bottom.units.any(unit => cond.ends-with(unit))
  )
  return if is-bottom { (none, cond) } else { (parse-formula(cond), none) }
}

// === Arrow Processing ===
#let process-arrow(arrow-text, condition: none) = {
  let arrow = if arrow-text.contains("<-") {
    $stretch(#sym.harpoons.rtlb, size: #config.arrow.reversible-size)$
  } else if arrow-text.contains("=") {
    $stretch(=, size: #config.arrow.arrow-size)$
  } else {
    $stretch(->, size: #config.arrow.arrow-size)$
  }
  let top = ()
  let bottom = ()
  if condition != none {
    for cond in condition.split(",") {
      let (t, b) = process-condition(cond)
      if t != none { top.push(t) }
      if b != none { bottom.push(b) }
    }
  }
  $arrow^top.join(",")_bottom.join(",")$
}

// === Main Function ===
#let ce = (formula, condition: none, debug: false) => {
  
  if type(formula) == dictionary and  formula.formula != none{
    formula = formula.formula
  }
  
  let remaining = formula.trim()
  let result = none
  while remaining.len() > 0 {
    let matched = false
    for pattern in config.match-order.full {
      let match = remaining.match(regex-patterns.at(pattern))
      if match != none {
        result += if pattern == "plus" {
          math.plus
        } else if pattern == "coef" {
          $#match.text$ 
        } else if (  pattern == "element") {
          process-element(match.captures.at(0), match.captures.at(1)) 
        } else if pattern == "bracket" {
          process-bracket(match.captures.at(0), match.captures.at(1))
        } else if pattern == "charge" { 
          process-charge(result, match.captures.at(0)) 
        } else {
          process-arrow(match.text, condition: condition)
        }
        remaining = remaining.slice(match.end)
        matched = true
        break
      }
    }
    if not matched {
      let char = remaining.codepoints().at(0)
      result += char
      remaining = remaining.slice(char.len())
    }
  }
  if debug {
    return repr(result)
  }
  $upright(display(result))$
}