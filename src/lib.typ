#import "data-model.typ": get-element-counts, get-element, get-weight, define-molecule, define-hydrate
#import "display-shell-configuration.typ": (
  get-electron-configuration,
  get-shell-configuration,
  display-electron-configuration,
)
#import "model/reaction.typ": reaction
#import "parse-formula-intermediate-representation.typ": string-to-reaction

#let ce(formula) = {
  reaction(string-to-reaction(formula))
}
