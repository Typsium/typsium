// tokenizer.typ
#import "lexer.typ"

#let tokenize(input, parse) = {
  let tokens = ()
  let remaining = input

  while remaining.len() > 0 {
    if remaining.at(0) == "&" {
      tokens.push((kind: "align"))
      remaining = remaining.slice(1)
      continue
    }

    let bond-match = lexer.match-bond(remaining)
    if bond-match != none {
      tokens.push((kind: "bond", node: bond-match.node))
      remaining = remaining.slice(bond-match.end)
      continue
    }

    let math-match = lexer.match-math(remaining)
    if math-match != none {
      tokens.push((kind: "math", node: math-match.node))
      remaining = remaining.slice(math-match.end)
      continue
    }

    let particle-match = lexer.match-particle(remaining)
    if particle-match != none {
      tokens.push((kind: "particle", symbol: particle-match.symbol, charge: particle-match.charge))
      remaining = remaining.slice(particle-match.end)
      continue
    }

    let element-match = lexer.match-element(remaining)
    if element-match != none {
      tokens.push((kind: "element", node: element-match.node))
      remaining = remaining.slice(element-match.end)
      continue
    }

    let precipitation-match = lexer.match-precipitation(remaining)
    if precipitation-match != none {
      tokens.push((kind: "precipitation", node: precipitation-match.node))
      remaining = remaining.slice(precipitation-match.end)
      continue
    }

    let aggregation-match = lexer.match-aggregation(remaining)
    if aggregation-match != none {
      tokens.push((kind: "aggregation", phase: aggregation-match.phase))
      remaining = remaining.slice(aggregation-match.end)
      continue
    }

    let group-match = lexer.match-group(remaining)
    if group-match != none {
      tokens.push((kind: "group", node: group-match.node))
      remaining = remaining.slice(group-match.end)
      continue
    }

    let count-match = lexer.match-count(remaining)
    if count-match != none {
      tokens.push((kind: "count", value: count-match.value))
      remaining = remaining.slice(count-match.end)
      continue
    }

    let plus-match = lexer.match-plus(remaining)
    if plus-match != none {
      tokens.push((kind: "plus"))
      remaining = remaining.slice(plus-match.end)
      continue
    }

    let arrow-match = lexer.match-arrow(remaining)
    if arrow-match != none {
      tokens.push((kind: "arrow", node: arrow-match.node))
      remaining = remaining.slice(arrow-match.end)
      continue
    }

    let char = remaining.codepoints().at(0)
    tokens.push((kind: "char", text: char, is-space: char == " "))
    remaining = remaining.slice(char.len())
  }

  tokens
}
