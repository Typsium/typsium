// Import required modules
#import "utils.typ": parser-config
#import "regex.typ": patterns

// [CHANGE] Replaced direct pattern access with cached patterns for better performance
#let PATTERNS = {
  let cache = (:)
  for pattern in patterns.keys() {
    cache.insert(pattern, patterns.at(pattern))
  }
  cache
}

// [CHANGE] Added symbol map for consistent rendering and better maintainability
#let SYMBOL_MAP = (
  arrows: (
    "<-": (sym.harpoons.rtlb, parser-config.arrow.reversible_size),
    "=": ($=$, parser-config.arrow.arrow_size),
    "->": ($->$, parser-config.arrow.arrow_size),
  ),
  charges: (
    "+": (math.plus, 0.8em),
    "-": (math.minus, 0.75em),
  ),
)

// [CHANGE] Simplified charge processing with explicit symbol hiding
#let process_charge = (input, charge) => {
  let first = charge.first()
  show "-": text(size: 0.75em, baseline: -0.15em)[#math.minus]
  show "+": text(size: 0.75em, baseline: -0.15em)[#math.plus]
  show "^": none
  context { $#block(height: measure(input).height)^#charge$ }
}

// Process reaction conditions (temperature, pressure, catalyst, etc.)
#let process_condition(cond) = {
  let cond = cond.trim()
  if cond.match(patterns.heating) != none {
    return (none, { sym.Delta })
  }

  let is_bottom = (
    parser-config.conditions.bottom.identifiers.any(ids => ids.any(id => cond.starts-with(id)))
      or parser-config.conditions.bottom.units.any(unit => cond.ends-with(unit))
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
    $stretch(#sym.harpoons.rtlb, size: #parser-config.arrow.reversible_size)$
  } else if arrow_match.contains("=") {
    $stretch(=, size: #parser-config.arrow.arrow_size)$
  } else {
    $stretch(->, size: #parser-config.arrow.arrow_size)$
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

// [CHANGE] Added pattern handlers for better code organization and reusability
#let PATTERN_HANDLERS = (
  charge: (r, c) => process_charge(r, c),
  arrow: t => process_arrow(t),
)

// [CHANGE] Optimized main parser with single-pass matching and improved error handling
#let ce = formula => {
  let remaining = formula.trim()
  if remaining.len() == 0 { return [] }

  let result = none
  let pattern_group = parser-config.match_order.full

  while remaining.len() > 0 {
    let best = (pattern: none, match: none)

    // [CHANGE] Single pass scan replaces multiple pattern attempts
    for pattern in pattern_group {
      let match = remaining.match(PATTERNS.at(pattern))
      if match != none {
        best = (pattern: pattern, match: match)
        break
      }
    }

    // [CHANGE] Simplified pattern handling using direct math mode
    if best.match != none {
      let pattern = best.pattern
      let match = best.match

      result += if pattern == "plus" { $+$ } else if pattern == "element" {
        // [CHANGE] reduce some $$ used, need attention
        match.captures.at(0) + if match.captures.at(1) != none [$#h(0em)_#match.captures.at(1)$]
      } else if pattern == "bracket" {
        match.captures.at(0) + if match.captures.at(1) != none [$#h(0em)_#match.captures.at(1)$]
      } else if pattern == "charge" { (PATTERN_HANDLERS.charge)(result, match.captures.at(0)) } else if (
        pattern == "arrow"
      ) { (PATTERN_HANDLERS.arrow)(match.text) }

      remaining = remaining.slice(match.end)
    } else {
      // [CHANGE] Better Unicode support with codepoints handling
      result += text(remaining.at(0))
      remaining = remaining.slice(remaining.codepoints().at(0).len())
    }
  }

  $upright(display(result))$
}
