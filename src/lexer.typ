

#import "patterns.typ": *
#import "utils.typ": arrow-string-to-kind, is-default, roman-to-number

#let get-count-and-charge(count-a, count-b, charge-a, charge-b) = {
  let radical = false
  let roman-charge = false

  let count = if not is-default(count-a) {
    if count-a.at(0) == "_" and count-a.at(1) == "(" {
      count-a.slice(2, count-a.len() - 1)
    } else {
      int(count-a.replace("_", ""))
    }
  } else if not is-default(count-b) {
    int(count-b.replace("_", ""))
  } else {
    none
  }

  let custom-charge = false
  let charge = if not is-default(charge-a) {
    if charge-a.at(0) == "^" and charge-a.at(1) == "(" {
      custom-charge = true
      charge-a.slice(2, charge-a.len() - 1)
    } else {
      charge-a.replace("^", "")
    }
  } else if not is-default(charge-b) {
    if charge-b.at(0) == "^" and charge-b.at(1) == "(" {
      custom-charge = true
      charge-b.slice(2, charge-b.len() - 1)
    } else {
      charge-b.replace("^", "")
    }
  } else {
    none
  }

  if not is-default(charge) and not custom-charge {
    if charge.contains(".") {
      charge = charge.replace(".", "")
      radical = true
    }
    if charge.contains("I") or charge.contains("V") {
      let multiplier = if charge.contains("-") { -1 } else { 1 }
      charge = charge.replace("-", "").replace("+", "")
      charge = roman-to-number(charge) * multiplier
      roman-charge = true
    } else if charge == "-" {
      charge = -1
    } else if charge.contains("-") {
      charge = -int(charge.replace("-", ""))
    } else if charge == "+" {
      charge = 1
    } else if charge.replace("+", "").contains(regex("^[0-9]+$")) {
      charge = int(charge.replace("+", ""))
    } else {
      charge = 0
    }
  }

  (count: count, charge: charge, radical: radical, roman-charge: roman-charge)
}

#let match-precipitation(remaining) = {
  let m = remaining.match(patterns.precipitation)
  if m == none or not m.text.contains(" ") { return none }
  (node: m.captures.at(0), end: m.end)
}

#let match-bond(remaining) = {
  let m = remaining.match(patterns.bond)
  if m == none { return none }
  let n = if m.text.contains("=") { 2 } else if m.text.contains("~") { 3 } else { 1 }
  let dotted-at = m.text.position("..")
  let kind = if dotted-at == none { 0 } else { dotted-at + 1 }
  (node: (n: n, kind: kind), end: m.end)
}

#let match-math(remaining) = {
  let m = remaining.match(patterns.math)
  if m == none { return none }
  (node: eval(m.text), end: m.end)
}

#let simple-particles = (
  ("proton", "p", 1),
  ("antiproton", "ap", 0),
  ("neutrino", "ne", 0),
  ("antineutrino", "ane", 0),
  ("neutron", "n", 0),
  ("antineutron", "an", 0),
  ("electron", "e", -1),
  ("positron", "e", 1),
  ("photon", "g", 0),
  ("gamma", "g", 0),
  ("alpha", "a", 0),
)

#let match-particle(remaining) = {
  for (name, symbol, charge) in simple-particles {
    if remaining.starts-with(name) {
      return (symbol: symbol, charge: charge, end: name.len())
    }
  }
  if remaining.starts-with("muon") {
    let charge = if remaining.len() > 4 { if remaining.at(4) == "-" { -1 } else { 0 } }
    return (symbol: "m", charge: charge, end: 4 + calc.abs(charge))
  }
  if remaining.starts-with("mu") {
    let charge = if remaining.len() > 2 { if remaining.at(2) == "-" { -1 } else { 0 } }
    return (symbol: "m", charge: charge, end: 2 + calc.abs(charge))
  }
  if remaining.starts-with("beta") {
    let charge = if remaining.len() > 4 {
      if remaining.at(4) == "-" { -1 } else if remaining.at(4) == "+" { 1 } else { 0 }
    } else { 0 }
    return (symbol: "b", charge: charge, end: 4 + calc.abs(charge))
  }
  none
}

#let match-element(remaining) = {
  let m = remaining.match(patterns.element)
  if m == none { return none }

  let symbol = m.captures.at(element-capture.symbol)
  let a = m.captures.at(element-capture.a)
  let z = m.captures.at(element-capture.z)
  if a != none { a = a.slice(1) }
  if z != none { z = z.slice(1) }

  let parsed = get-count-and-charge(
    m.captures.at(element-capture.count-a),
    m.captures.at(element-capture.count-b),
    m.captures.at(element-capture.charge-a),
    m.captures.at(element-capture.charge-b),
  )

  let oxidation-text = m.captures.at(element-capture.oxidation)
  let oxidation-number = none
  if oxidation-text != none {
    oxidation-text = upper(oxidation-text).replace("^", "", count: 2)
    let sign = if oxidation-text.contains("-") { -1 } else { 1 }
    oxidation-text = oxidation-text.replace("-", "").replace("+", "")
    oxidation-number = if oxidation-text.contains("I") or oxidation-text.contains("V") {
      roman-to-number(oxidation-text)
    } else {
      int(oxidation-text)
    }
    if oxidation-number != none {
      oxidation-number *= sign
    }
  }

  let are-attachements-none = (
    parsed.count == none
      and parsed.charge == none
      and not parsed.radical
      and oxidation-number == none
      and a == none
      and z == none
  )

  if are-attachements-none and lower(m.text) == m.text {
    return none
  }

  let node = (
    symbol: symbol,
    count: parsed.count,
    charge: parsed.charge,
    radical: parsed.radical,
    oxidation: oxidation-number,
    a: a,
    z: z,
  )
  if parsed.roman-charge {
    node.roman-charge = true
  }

  (node: node, end: m.end)
}

#let match-aggregation(remaining) = {
  let m = remaining.match(patterns.aggregation)
  if m == none { return none }
  (phase: m.text, end: m.end)
}

#let match-group(remaining) = {
  let m = remaining.match(patterns.group)
  if m == none { return none }

  let group-content = m.captures.at(group-capture.content)
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

  let parsed = get-count-and-charge(
    m.captures.at(group-capture.count-a),
    m.captures.at(group-capture.count-b),
    m.captures.at(group-capture.charge-a),
    m.captures.at(group-capture.charge-b),
  )

  (
    node: (children: group-content, kind: kind, count: parsed.count, charge: parsed.charge),
    end: m.end,
  )
}

#let match-count(remaining) = {
  let m = remaining.match(patterns.count)
  if m == none { return none }
  (value: int(m.text), end: m.end)
}

#let match-plus(remaining) = {
  let m = remaining.match(patterns.reaction-plus)
  if m == none { return none }
  (end: m.end)
}

#let match-arrow(remaining) = {
  let m = remaining.match(patterns.reaction-arrow)
  if m == none { return none }

  let kind = arrow-string-to-kind(m.captures.at(arrow-capture.symbol))

  let node = (
    kind: kind,
    top: m.captures.at(arrow-capture.top),
    bottom: m.captures.at(arrow-capture.bottom),
  )

  (node: node, end: m.end)
}
