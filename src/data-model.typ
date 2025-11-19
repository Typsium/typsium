#import "utils.typ": (
  is-sequence,
  is-kind,
  is-heading,
  is-metadata,
  padright,
  get-all-children,
  hydrates,
  elements,
  get-element-dict,
  get-molecule-dict,
  to-string,
)
#import "parse-content-intermediate-representation.typ": patterns

#let get-element(
  symbol: auto,
  atomic-number: auto,
  common-name: auto,
  cas: auto,
) = {
  let element = if symbol != auto {
    elements.find(x => x.symbol == symbol)
  } else if atomic-number != auto {
    elements.find(x => x.atomic-number == atomic-number)
  } else if common-name != auto {
    elements.find(x => x.common-name == common-name)
  } else if cas != auto {
    elements.find(x => x.cas == cas)
  }
  return metadata(element)
}

#let validate-element(element) = {
  let type = type(element)
  if type == str {
    if element.len() > 2 {
      return get-element(common-name: element)
    } else {
      return get-element(symbol: element)
    }
  } else if type == int {
    return get-element(atomic-number: element)
  } else if type == content {
    return get-element-dict(element)
  } else if type == dictionary {
    return element
  }
}

//TODO: properly parse bracket contents
// maybe recursively with a bracket regex, passing in the bracket content and multiplier(?)
//TODO: Properly apply stochiometry
#let get-element-counts(molecule) = {
  let found-elements = (:)
  let remaining = molecule.trim()
  while remaining.len() > 0 {
    let match = remaining.match(patterns.element)
    if match != none {
      remaining = remaining.slice(match.end)
      let element = match.captures.at(2)
      let count = 1 //int(if match.captures.at(1, default: "") == "" {1} else{match.captures.at(1)})
      let current = found-elements.at(element, default: 0)
      found-elements.insert(element, count)
    } else {
      let char-len = remaining.codepoints().at(0).len()

      remaining = remaining.slice(char-len)
    }
  }
  return found-elements
}

#let get-weight(molecule) = {
  let element = get-element-dict(molecule)
  molecule = get-molecule-dict(molecule)
  if type(element) == dictionary and element.at("atomic-weight", default: none) != none {
    return element.atomic-weight
  }
  let weight = 0
  for value in molecule.elements {
    let element = elements.find(x => x.symbol == value.at(0))

    weight += element.atomic-weight * value.at(1)
  }
  return weight
}

#let define-ion(
  element,
  charge: 0,
  delta: 0,
  override-common-name: none,
  override-iupac-name: none,
  override-CAS: none,
  override-h-p: none,
  override-ghs: none,
  validate: true,
) = {
  if validate {
    element = validate-element(element)
  }
  element = if charge != 0 {
    element.charge = charge
  } else {
    element.charge = element.at("charge", default: 0) + delta
  }
  return element
}

#let define-isotope(
  element,
  mass-number,
  override-atomic-weight: none,
  override-common-name: none,
  override-iupac-name: none,
  override-cas: none,
  override-h-p: none,
  override-ghs: none,
  validate: true,
) = {
  if validate {
    element = validate-element(element)
  }

  element.mass-number = mass-number
  if override-atomic-weight != none {
    element.atomic-weight = override-atomic-weight
  }
  if override-common-name != none {
    element.common-name = override-common-name
  }
  if override-iupac-name != none {
    element.iupac-name = override-iupac-name
  }
  if override-cas != none {
    element.override-cas = override-cas
  }
  if override-common-name != none {
    element.common-name = override-common-name
  }
  if override-common-name != none {
    element.common-name = override-common-name
  }
  if override-common-name != none {
    element.common-name = override-common-name
  }
  return element
}

#let define-molecule(
  common-name: none,
  iupac-name: none,
  formula: "",
  smiles: "",
  inchi: "",
  cas: "",
  h-p: (),
  ghs: (),
  validate: true,
) = {
  let found-elements
  if validate {
    // TODO: continue to add more validation as we go
    // things should fail here instead of causing errors down the line
    if common-name == none {
      common-name = formula
    }

    if smiles == "" {
      smiles == none
    } else if formula == "" {
      //TODO: actually calculate the formula based on the smiles code (don't forget to add H on Carbon atoms)
      formula = smiles
    }

    if cas == "" {
      cas = none
    }

    found-elements = get-element-counts(formula)

    if inchi != "" {
      // TODO: create InChI keys from provided InChI:
      // https://typst.app/universe/package/jumble
      // https://www.inchi-trust.org/download/104/InChI_TechMan.pdf
    } else {
      inchi = none
    }
  }

  return metadata((
    kind: "molecule",
    common-name: common-name,
    iupac-name: iupac-name,
    formula: formula,
    smiles: smiles,
    inchi: inchi,
    cas: cas,
    h-p: h-p,
    ghs: ghs,
    elements: found-elements,
  ))
}

#let define-hydrate(
  molecule,
  amount: 1,
  override-common-name: none,
  override-iupac-name: none,
  override-smiles: none,
  override-inchi: none,
  override-cas: none,
  override-h-p: none,
  override-ghs: none,
) = {
  molecule = get-molecule-dict(molecule)
  define-molecule(
    common-name: if override-common-name != none { override-common-name } else {
      molecule.common-name + sym.space + hydrates.at(amount)
    },
    iupac-name: if override-iupac-name != none { override-iupac-name } else {
      molecule.iupac-name + sym.semi + hydrates.at(amount)
    },
    formula: molecule.formula + sym.space.narrow + sym.dot + sym.space.narrow + str(amount) + "H2O",
    smiles: if override-smiles != none { override-smiles } else { molecule.smiles },
    inchi: if override-inchi != none { override-inchi } else { molecule.inchi },
    cas: if override-cas != none { override-cas } else { molecule.cas },
    h-p: if override-h-p != none { override-h-p } else { molecule.h-p },
    ghs: if override-ghs != none { override-ghs } else { molecule.ghs },
  )
}

#let reaction(body) = {
  let children = get-all-children(body)

  // repr(body)

  // linebreak()
  let result = ""
  for child in children {
    if is-metadata(child) {
      if is-kind(child, "molecule") {
        result += child.value.formula
      } else if is-kind(child, "element") {
        result += child.value.symbol
      }
    } else {
      result += child
    }
  }
  ce(to-string(result))
}