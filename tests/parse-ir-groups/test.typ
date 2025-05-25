#import "../../src/parse-formula-intermediate-representation.typ": molecule-string-to-ir

#let trisethylendiamin = (
  type: "molecule",
  children: (
    (
      type: "group",
      kind: 1,
      children: (
        (type: "element", symbol: "Co"),
        (
          type: "group",
          kind: 0,
          children: ((type: "content", body: [en]),),
          count: 3,
        ),
      ),
    ),
    (type: "element", symbol: "Cl", count: 3),
  ),
)
#let ir-trisethylendiamin = molecule-string-to-ir("[Co(en)3]Cl3")

#let fenh3 = (
  type: "molecule",
  children: (
    (type: "element", symbol: "Fe"),
    (
      type: "group",
      kind: 1,
      children: (
        (type: "element", symbol: "N"),
        (type: "element", symbol: "H", count: 3),
      ),
      count: 2,
      charge: 1,
    ),
  ),
)
#let ir-fenh3 = molecule-string-to-ir("Fe[NH3]2+")

#assert(trisethylendiamin == ir-trisethylendiamin)
#assert(fenh3 == ir-fenh3)
