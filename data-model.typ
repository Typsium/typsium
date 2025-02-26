#import "utils.typ": is-sequence, is-kind, is-heading, is-metadata, padright, get-all-children, regex_patterns

#let hydrates = (
  "anhydrous",
  "monohydrate",
  "dihydrate",
  "trihydrate",
  "tetrahydrate",
  "pentahydrate",
  "hexahydrate",
  "heptahydrate",
  "octahydrate",
  "nonahydrate",
  "decahydrate",
)

//TODO: properly parse bracket contents
// maybe recursively with a bracket regex, passing in the bracket content and multiplier(?)
//TODO: Properly apply stochiometry
#let get-element-counts(molecule)={
  
  // how the f do you create an empty dictionary?
  let elements = (H:0)
  let remaining = molecule.trim()
  while remaining.len() > 0 {
    let match = remaining.match(regex_patterns.at("element"))
    if match != none {
      remaining = remaining.slice(match.end)
      let element = match.captures.at(0)
      let count = int(if match.captures.at(1, default: "") == "" {1} else{match.captures.at(1)})
      let current = elements.at(element, default: 0)
      elements.insert(element, count)
    }
    else{
      let char-len = remaining.codepoints().at(0).len()
      
      remaining = remaining.slice(char-len)
    }
  }
  //hack because no empty dict
  if elements.H == 0{
    elements.remove("H")
  }
  return elements
}

#let define-molecule(
  common-name:none,
  iupac-name:none,
  formula:"",
  smiles:"",
  InChI:"",
  CAS:"",
  h-p:(),
  ghs:(),
)={
  // TODO: continue to add more validation as we go
  // things should fail here instead of causing errors down the line
  if common-name == none{
    common-name = formula
  }
  
  if smiles == ""{
    smiles == none
  } else if formula == ""{
    //TODO: actually calculate the formula based on the smiles code (don't forget to add H on Carbon atoms)
    formula = smiles
  }
  
  if CAS == ""{
    CAS = none
  }
  
  let elements = get-element-counts(formula)

  if InChI != ""{
    // TODO: create InChI keys from provided InChI:
    // https://typst.app/universe/package/jumble
    // https://www.inchi-trust.org/download/104/InChI_TechMan.pdf
  }else{
    InChI = none
  }
  
  return (
    common-name: common-name, 
    iupac-name:iupac-name, 
    formula: formula, 
    smiles: smiles, 
    InChI: InChI, 
    CAS: CAS, 
    h-p: h-p, 
    ghs: ghs, 
    elements: elements
  )
}

#let define-hydrate(
  molecule,
  amount:1,
  override-common-name:none,
  override-iupac-name:none,
  override-smiles:none,
  override-InChI:none,
  override-CAS:none,
  override-h-p:none,
  override-ghs:none,
) = define-molecule(
    common-name: if override-common-name != none {override-common-name} else {molecule.common-name + sym.space + hydrates.at(amount)},
    iupac-name: if override-iupac-name != none {override-iupac-name}else{molecule.iupac-name + sym.semi + hydrates.at(amount)},
    formula: molecule.formula + sym.space.narrow + sym.dot + sym.space.narrow + str(amount) + "H2O",
    smiles:  if override-smiles != none {override-smiles}else{molecule.smiles},
    InChI:  if override-InChI != none {override-InChI}else{molecule.InChI},
    CAS:  if override-CAS != none {override-CAS}else{molecule.CAS},
    h-p:  if override-h-p != none {override-h-p}else{molecule.h-p},
    ghs:  if override-ghs != none {override-ghs}else{molecule.ghs}
  )

#let reaction(body)={
  let children = get-all-children(body)
  
  for child in children {
    if is-metadata(child){
      if is-kind(child, "quick-cards.question"){
      }
    }
  }
        
}