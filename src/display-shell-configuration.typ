#import "utils.typ": get-element-dict, shell-capacities, orbital-capacities

#let get-shell-configuration(element) = {
  element = get-element-dict(element)
  let charge = element.at("charge", default: 0)
  let electron-amount = element.atomic-number - charge

  let result = ()
  for value in shell-capacities {
    if electron-amount <= 0 {
      break
    }

    if electron-amount >= value.at(1) {
      result.push(value)
      electron-amount -= value.at(1)
    } else {
      result.push((value.at(0), electron-amount))
      electron-amount = 0
    }
  }
  return result
}

//TODO: fix Cr and Mo
#let get-electron-configuration(element) = {
  element = get-element-dict(element)
  let charge = element.at("charge", default: 0)
  let electron-amount = element.atomic-number - charge

  let result = ()
  for value in orbital-capacities {
    if electron-amount <= 0 {
      break
    }
    if electron-amount >= value.at(1) {
      result.push(value)
      electron-amount -= value.at(1)
    } else {
      result.push((value.at(0), electron-amount))
      electron-amount = 0
    }
  }
  return result
}

#let display-electron-configuration(element, short: false) = {
  let configuration = get-electron-configuration(element)

  if short {
    let prefix = ""
    if configuration.at(14, default: (0, 0)).at(1) == 6 {
      configuration = configuration.slice(15)
      prefix = "[Rn]"
    } else if configuration.at(10, default: (0, 0)).at(1) == 6 {
      configuration = configuration.slice(11)
      prefix = "[Xe]"
    } else if configuration.at(7, default: (0, 0)).at(1) == 6 {
      configuration = configuration.slice(8)
      prefix = "[Kr]"
    } else if configuration.at(4, default: (0, 0)).at(1) == 6 {
      configuration = configuration.slice(5)
      prefix = "[Ar]"
    } else if configuration.at(2, default: (0, 0)).at(1) == 6 {
      configuration = configuration.slice(3)
      prefix = "[Ne]"
    } else if configuration.at(0, default: (0, 0)).at(1) == 2 {
      configuration = configuration.slice(1)
      prefix = "[He]"
    }

    return prefix + configuration.map(x => $#x.at(0)^#str(x.at(1))$).sum()
  } else {
    return configuration.map(x => $#x.at(0)^#str(x.at(1))$).sum()
  }
}
