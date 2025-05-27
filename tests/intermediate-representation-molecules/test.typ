#import "../../src/model/element.typ": element
#import "../../src/model/molecule.typ": molecule
#import "../../src/model/group.typ": group
#set page(width: auto, height: auto, margin: 0.5em)

#let co2 = molecule(
  (
    element(
      "C",
      count: 1,
      charge: 0,
      oxidation: none,
      a: none,
      z: none,
    ),
    element(
      "O",
      count: 2,
      charge: 0,
      oxidation: none,
      a: none,
      z: none,
    ),
  ),
  count: 1,
  phase: "g",
  charge: 0,
)

#let hexacyanidoferrat = molecule(
  (
    group(
      (
        element(
          "Fe",
          count: 1,
        ),
        group(
          (
            element(
              "C",
              count: 1,
            ),
            element(
              "N",
              count: 1,
            ),
          ),
          count: 6,
          kind: 0,
        ),
      ),
      count: 2,
      kind: 1,
      charge: 4,
    ),
  ),
  count: 3,
  phase: "s",
  charge: 0,
)

#co2\
#hexacyanidoferrat
// #display-ir(hexacyanidoferrat)
