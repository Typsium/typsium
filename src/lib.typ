#import "data-model.typ": get-element-counts, get-element, get-weight, define-molecule, define-hydrate
#import "display-shell-configuration.typ": get-electron-configuration,get-shell-configuration,display-electron-configuration,
#import "parse-formula-intermediate-representation.typ": string-to-reaction
#import "parse-content-intermediate-representation.typ": content-to-reaction
#import "typing.typ": set-arrow, set-element, set-group, set-molecule, set-reaction, elembic, fields, selector
#import "model/arrow.typ": arrow
#import "model/element.typ": element
#import "model/group.typ": group
#import "model/molecule.typ": molecule
#import "model/reaction.typ": reaction

#let ce(formula) = {
  if type(formula) == str{
    let result = string-to-reaction(formula)
    if result.len() == 1{
      result.at(0)
    } else {
      reaction(result)
    }
  } else if type(formula) == content{
    let result = content-to-reaction(formula)
    if result.len() == 1{
      result.at(0)
    } else {
      reaction(result)
    }
  }
}
