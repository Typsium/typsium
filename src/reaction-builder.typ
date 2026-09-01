// reaction-builder.typ
#import "model/molecule-element.typ": molecule
#import "model/particle-element.typ": particle
#import "model/bond-element.typ": bond
#import "model/reaction-element.typ": reaction
#import "model/element-element.typ": element
#import "model/group-element.typ": group
#import "model/arrow-element.typ": reaction-arrow
#import "model/particle-element.typ": particle

#import "tokenizer.typ"
#import "utility.typ": is-default

#let new-builder-state() = (
  output: (),
  children: (),
  count: 1,
  phase: none,
  random: "",
)

#let flush-molecule(state) = {
  if state.children.len() > 0 {
    state.output.push(molecule(state.children, count: state.count, aggregation: state.phase))
    state.children = ()
    state.phase = none
    state.count = 1
  }
  state
}

#let flush-random(state) = {
  if not is-default(state.random) and state.random != " " {
    if state.children.len() == 0 {
      state.output.push([#state.random])
    } else {
      state.children.push([#state.random])
    }
  }
  state.random = ""
  state
}

#let apply-token(state, token, parse) = {
  if token.kind == "align" {
    state = flush-molecule(state)
    state.output.push($&$)
  } else if token.kind == "precipitation" {
    state = flush-molecule(state)
    state = flush-random(state)
    state.output.push(if token.node == "v" { sym.arrow.b } else { sym.arrow.t })
  } else if token.kind == "bond" {
    state = flush-random(state)
    state.children.push(bond(..token.node))
  } else if token.kind == "math" {
    // a count in front of math isn't a molecule count
    if state.count != 1 {
      state.random += str(state.count)
      state.count = 1
    }
    state = flush-random(state)
    state.output.push(token.node)
  } else if token.kind == "particle" {
    state = flush-molecule(state)
    let applied-count = state.count
    state.count = 1
    state = flush-random(state)
    state.output.push(particle(token.symbol, charge: token.charge, count: applied-count))
  } else if token.kind == "element" {
    state = flush-random(state)
    state.children.push(element(..token.node))
  } else if token.kind == "aggregation" {
    state = flush-random(state)
    state.phase = token.phase
    state = flush-molecule(state)
  } else if token.kind == "group" {
    state = flush-random(state)
    token.node.children = parse(token.node.children)
    state.children.push(group(..token.node))
  } else if token.kind == "count" {
    state = flush-random(state)
    state.count = token.value
  } else if token.kind == "plus" {
    state = flush-molecule(state)
    state = flush-random(state)
    state.output.push([+])
  } else if token.kind == "arrow" {
    state = flush-molecule(state)
    state = flush-random(state)
    let node = (kind: token.node.kind)
    let top = parse(token.node.top)
    if top != () {
      node.top = top.join()
    }
    let bottom = parse(token.node.bottom)
    if bottom != () {
      node.bottom = bottom.join()
    }
    state.output.push(reaction-arrow(..node))
  } else if token.kind == "char" {
    if token.is-space {
      state = flush-molecule(state)
    }
    state.random += token.text
  }
  state
}

#let build-reaction(tokens, parse) = {
  let state = new-builder-state()
  for token in tokens {
    state = apply-token(state, token, parse)
  }
  state = flush-molecule(state)
  state = flush-random(state)
  state.output
}

#let string-to-reaction(
  reaction-string,
) = {
  if reaction-string == none {
    return ()
  }
  let normalized = reaction-string.replace("--", "——")
  if normalized.len() == 0 {
    return ()
  }
  build-reaction(tokenizer.tokenize(normalized, string-to-reaction), string-to-reaction)
}
