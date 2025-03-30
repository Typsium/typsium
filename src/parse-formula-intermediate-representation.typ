#let patterns = (
  // element: regex("^(?P<element>[A-Z][a-z]?)(?:(?P<count>_?\d+)|(?P<charge>\^?[+-]?\d*\.?-?))?(?:(?P<count2>_?\d+)|(?P<charge2>\^?[+-]?\d*\.?-?))?"),
  element: regex("^(?P<element>[A-Z][a-z]?)(?:(?P<count>_?\d+)|(?P<charge>(?:\^[+-]?[IV]+|\^?[+-]?\d?)\.?-?))?(?:(?P<count2>_?\d+)|(?P<charge2>(?:\^[+-]?[IV]+|\^?[+-]?\d?)\.?-?))?"),
  // group: regex("^(\((?:[^()]|(?R))*\)|\{(?:[^{}]|(?R))*\}|\[(?:[^\[\]]|(?R))*\])"),
  group: regex("^(?P<group>\((?:[^()]|(?R))*\)|\{(?:[^{}]|(?R))*\}|\[(?:[^\[\]]|(?R))*\])(?:(?P<count>_?\d+)|(?P<charge>(?:\^[+-]?[IV]+|\^?[+-]?\d?)\.?-?))?(?:(?P<count2>_?\d+)|(?P<charge2>(?:\^[+-]?[IV]+|\^?[+-]?\d?)\.?-?))?"),
  
  // Match physical states (s/l/g/aq)
  state: regex("^\((s|l|g|aq|solid|liquid|gas|aqueous)\)"),
)

#let get-count-and-charge(count1, count2, charge1, charge2) = {
  let radical = false
  let count = if count1 != none and count1 != ""{
    int(count1.replace("_", ""))
  } else if count2 != none and count2 != ""{
    int(count2.replace("_", ""))
  } else {
    none
  }
  
  let charge = if charge1 != none and charge1 != ""{
    charge1.replace("^", "")
  } else if charge2 != none and charge2 != ""{
    charge2.replace("^", "")
  } else{
    none
  }
  
  if charge != none and charge != ""{
    if charge.contains("."){
      charge = charge.replace(".", "")
      radical = true
    }
    if charge == "-"{
      charge = -1
    } else if charge.contains("-"){
      charge = -int(charge.replace("-", ""))
    } else if charge == "+" {
      charge = 1
    } else if charge.replace("+", "").contains(regex("^[0-9]+$")){
      charge = int(charge.replace("+", ""))
    }
  }
  
  return (count, charge, radical)
}

#let element-string-to-ir(formula) = {
  let element-match = formula.match(patterns.element)

    if element-match != none{
        let element = (
          type: "element",
          symbol: element-match.captures.at(0),
        )
        let x = get-count-and-charge(element-match.captures.at(1),
          element-match.captures.at(3),
          element-match.captures.at(2),
          element-match.captures.at(4),
        )
        if x.at(0) != none{
          element.count = x.at(0)  
        }
        if x.at(1) != none{
          element.charge = x.at(1)  
        }
        if x.at(2) {
          element.radical = x.at(2)  
        }
      return (true, element, element-match.end)
    }
    return (false,)
}

#let group-string-to-ir(formula) = {
  let group-match = formula.match(patterns.group)
  if group-match != none{

    let group-content = group-match.captures.at(0)
    let kind = if group-content.at(0) == "("{
      group-content = group-content.trim(regex("[()]"), repeat:false)
      0
    } else if group-content.at(0) == "["{
      group-content = group-content.trim(regex("[\[\]]"), repeat:false)
      1
    }else if group-content.at(0) == "{"{
      group-content = group-content.trim(regex("[{}]"), repeat:false)
      2
    }
    let x = get-count-and-charge(group-match.captures.at(1),
      group-match.captures.at(3),
      group-match.captures.at(2),
      group-match.captures.at(4),
    )
    
    let group = (
        type: "group",
        kind:kind,
        children:()
      )
    if x.at(0) != none{
      group.count = x.at(0)  
    }
    if x.at(1) != none{
      group.charge = x.at(1)  
    }
    if x.at(2) {
      group.radical = x.at(2)  
    }
    
    let remaining = group-content
    while remaining.len() > 0 {
      let element = element-string-to-ir(remaining)
      if element.at(0) {
        group.children.push(element.at(1))
        remaining = remaining.slice(element.at(2))
        continue
      }
  
      let result = group-string-to-ir(remaining)
      if result.at(0) {
        group.children.push(result.at(1))
        remaining = remaining.slice(result.at(2))
        continue
      }
        
      remaining = remaining.slice(remaining.codepoints().at(0).len())
    }
  
    return (true, group, group-match.end)
  }
  return (false,)
}

//this will assume that the string is a molecule for performance reasons
#let molecule-string-to-ir(formula) = {
  let remaining = formula.trim()
  if remaining.len() == 0 {
    return none
  }
  let molecule = (
    type: "molecule",
    children:()
  )

  while remaining.len() > 0 {
    let element = element-string-to-ir(remaining)
    if element.at(0) {
      molecule.children.push(element.at(1))
      remaining = remaining.slice(element.at(2))
      continue
    }

    let group = group-string-to-ir(remaining)
    if group.at(0) {
      molecule.children.push(group.at(1))
      remaining = remaining.slice(group.at(2))
      continue
    }
      
    remaining = remaining.slice(remaining.codepoints().at(0).len())
  }
  return molecule
}