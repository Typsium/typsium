#import "data-model.typ": get-element-counts, get-element, get-weight, define-molecule, define-hydrate
#import "display-shell-configuration.typ": (
  get-electron-configuration,
  get-shell-configuration,
  display-electron-configuration,
)
#import "model/reaction.typ": reaction
#import "parse-formula-intermediate-representation.typ": string-to-reaction
#import "parse-content-intermediate-representation.typ": content-to-reaction

#let ce(formula) = {
  if type(formula) == str{
    reaction(string-to-reaction(formula))
  } else if type(formula) == content{
    // formula
    let r = content-to-reaction(formula)
    if type(r) == content{
      r
    } else{
      reaction(content-to-reaction(formula))
    }
  }
}
