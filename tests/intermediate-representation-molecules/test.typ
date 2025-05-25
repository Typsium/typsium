#import "../../src/display-intermediate-representation.typ": display-ir
#set page(width: auto, height: auto, margin: 0.5em)

#let co2 = (
  type: "molecule",
  count: 1,
  phase: "g",
  charge: 0,
  align: none,
  arrow: none,
  children: (
    (
      type: "element",
      count: 1,
      symbol: "C",
      charge: 0,
      oxidation-number: none,
      isotope: none,
      align: none,
    ),
    (
      type: "element",
      count: 2,
      symbol: "O",
      charge: 0,
      oxidation-number: none,
      isotope: none,
      align: none,
    ),
  ),
)

#let hexacyanidoferrat = (
  type: "molecule",
  count: 3,
  phase: "s",
  charge: 0,
  align: none,
  arrow: none,
  children: (
    (
      type: "group",
      count: 2,
      kind: 1,
      charge: 4,
      align: none,
      children: (
        (
          type: "element",
          count: 1,
          symbol: "Fe",
          charge: 0,
          oxidation-number: none,
          isotope: none,
          align: none,
        ),
        (
          type: "group",
          count: 6,
          kind: 0,
          charge: 0,
          align: none,
          children: (
            (
              type: "element",
              count: 1,
              symbol: "C",
              charge: 0,
              oxidation-number: none,
              isotope: none,
              align: none,
            ),
            (
              type: "element",
              count: 1,
              symbol: "N",
              charge: 0,
              oxidation-number: none,
              isotope: none,
              align: none,
            ),
          ),
        ),
      ),
    ),
  ),
)

#display-ir(co2)\
#display-ir(hexacyanidoferrat)
