// #import "../../src/lib.typ": get-element

// #let iron = get-element(symbol: "Fe")
// #let hydrogen = get-element(common-name: "Hydrogen")
// #let chlorine = get-element(cas: "7782-50-5")
// #let radon = get-element(atomic-number: 86)

// #assert(iron.value.common-name == "Iron")
// #assert(hydrogen.value.atomic-number == 1)
// #assert(chlorine.value.common-name == "Chlorine")
// #assert(chlorine.value.most-common-isotope == 35)
// #assert(radon.value.symbol == "Rn")

