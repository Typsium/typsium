#import "data-model.typ": get-element-counts, get-element, get-weight, define-molecule, define-hydrate
#import "display-shell-configuration.typ": (
  get-electron-configuration,
  get-shell-configuration,
  display-electron-configuration,
)
#import "display-intermediate-representation.typ": display-ir
#import "parse-formula-intermediate-representation.typ": string-to-ir

#let ce(formula) = {
  display-ir(string-to-ir(formula))
}
