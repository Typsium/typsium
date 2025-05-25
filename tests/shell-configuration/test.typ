#import "../../src/display-shell-configuration.typ": (
  get-shell-configuration,
  display-electron-configuration,
  get-electron-configuration,
)
#import "../../src/lib.typ": get-element
#set page(width: auto, height: auto, margin: 0.5em)

#let carbon = get-element(symbol: "Y")
#let shells = get-shell-configuration(carbon)
#let orbitals = get-electron-configuration(carbon)
#display-electron-configuration(carbon)
