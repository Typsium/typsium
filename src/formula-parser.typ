// Import required modules
#import "utils.typ": config
#import "regex.typ": patterns

// Process chemical elements with their subscripts
#let process_element(element, count) = { 
$#element _count$
}

// Process brackets with their subscripts
#let process_bracket(bracket, count) = { 
  $#bracket _count$
}

// Process ion charges, converting + and - to proper math symbols
#let process_charge(input, charge) = context {
  show "+": text(size:0.8em, baseline: -0.15em)[#math.plus]
  show "-": text(size:0.75em, baseline: -0.15em)[#math.minus]
  $#block(height: measure(input).height)^#charge$
}

// Main formula parsing function that converts text into chemical notation
#let parse_formula(formula) = {
  let remaining = formula.trim()
  let result = none
  
  while remaining.len() > 0 {
    let matched = false
    for pattern in config.match_order.basic {
      let match = remaining.match(patterns.at(pattern))
      if match != none {
        result += if pattern == "coefficient" { 
          $#match.captures.at(0)$ 
        } else if pattern == "element" {
          process_element(match.captures.at(0), match.captures.at(1))
        } else if pattern == "bracket" { 
          process_bracket(match.captures.at(0), match.captures.at(1))
        } else if pattern == "charge" {
          process_charge(result, match.captures.at(0))
        }
        
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

// Process reaction conditions (temperature, pressure, catalyst, etc.)
#let process_condition(cond) = {
  let cond = cond.trim()
  if cond.match(patterns.heating) != none {
    return (none, { sym.Delta })
  }
  
  let is_bottom = (
    config.conditions.bottom.identifiers.any(ids => ids.any(id => cond.starts-with(id)))
      or config.conditions.bottom.units.any(unit => cond.ends-with(unit))
  )
  
  return if is_bottom { (none, cond) } else { (parse_formula(cond), none) }
}

// Process reaction arrows with top and bottom conditions
#let process_arrow(arrow_text, condition: none) = {
  let (arrow_match, bracket_content) = if arrow_text.contains("[") {
    let match = arrow_text.match(patterns.arrow)
    (match.captures.at(0), match.captures.at(1))
  } else {
    (arrow_text, none)
  }

  let arrow = if arrow_match.contains("<-") {
    $stretch(#sym.harpoons.rtlb, size: #config.arrow.reversible_size)$
  } else if arrow_match.contains("=") {
    $stretch(=, size: #config.arrow.arrow_size)$
  } else {
    $stretch(->, size: #config.arrow.arrow_size)$
  }
  
  let top = ()
  let bottom = ()
  
  if bracket_content != none {
    top.push(bracket_content)
  }
  
  if condition != none {
    for cond in condition.split(",") {
      let (t, b) = process_condition(cond)
      if t != none { top.push(t) }
      if b != none { bottom.push(b) }
    }
  }
  
  $arrow^#top.join(",")_#bottom.join(",")$
}

// Main chemical equation formatter function
// Converts text-based chemical equations into properly formatted math
#let ce = (formula) => {
  let remaining = formula.trim()
  let result = none
  
  while remaining.len() > 0 {
    let matched = false
    for pattern in config.match_order.full {
      let match = remaining.match(patterns.at(pattern))
      if match != none {
        result += if pattern == "plus" { 
          $+$
        } else if pattern == "element" {
          process_element(match.captures.at(0), match.captures.at(1))
        } else if pattern == "bracket" {
          process_bracket(match.captures.at(0), match.captures.at(1))
        } else if pattern == "charge" { 
          process_charge(result, match.captures.at(0)) 
        } else {
          process_arrow(match.text)
        }
        
        remaining = remaining.slice(match.end)
        matched = true
        break
      }
    }
    
    if not matched {
      result += text(remaining.first())
      remaining = remaining.slice(remaining.at(0).len())
    }
  }
  
  $upright(display(result))$
}

// Test section for previewing the output
#import "@preview/shadowed:0.2.0": shadowed

#set page(margin: 0.3em, width: auto, height: auto)

#shadowed(inset: 0.7em, radius: 6pt)[#ce("NH4 4+ +2SO4 4-  ->[awa] 2NH3 + H2SO4")]