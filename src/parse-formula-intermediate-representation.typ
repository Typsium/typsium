#import "model/molecule-element.typ": molecule
#import "model/particle-element.typ": particle

#import "tokenizer.typ"
#import "utils.typ": is-default

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

#let apply-token(state, token) = {
  if token.kind == "align" {
    state = flush-molecule(state)
    state.output.push($&$)
  } else if token.kind == "precipitation" {
    state = flush-molecule(state)
    state.output.push(token.node)
  } else if token.kind == "bond" {
    state = flush-random(state)
    state.children.push(token.node)
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
    state.children.push(token.node)
  } else if token.kind == "aggregation" {
    state = flush-random(state)
    state.phase = token.phase
    state = flush-molecule(state)
  } else if token.kind == "group" {
    state = flush-random(state)
    state.children.push(token.node)
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
    state.output.push(token.node)
  } else if token.kind == "char" {
    if token.is-space {
      state = flush-molecule(state)
    }
    state.random += token.text
  }
  state
}

#let build-reaction(tokens) = {
  let state = new-builder-state()
  for token in tokens {
    state = apply-token(state, token)
  }
  state = flush-molecule(state)
  state = flush-random(state)
  state.output
}

#let string-to-reaction(
  reaction-string,
) = {
  let normalized = reaction-string.replace("--", "——")
  if normalized.len() == 0 {
    return ()
  }
  build-reaction(tokenizer.tokenize(normalized, string-to-reaction))
}
