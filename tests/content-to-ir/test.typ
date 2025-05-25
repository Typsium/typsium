#import "../../src/parse-content-intermediate-representation.typ": content-to-ir
#import "../../src/display-intermediate-representation.typ": display-ir
#set page(width: auto, height: auto, margin: 0.5em)

#let x = (
  (
    type: "molecule",
    children: (
      (type: "element", symbol: "H", count: 2, charge:2, symbol-body:text(red)[H], count-body:strike("gugugaga"), charge-body:strike("gugugaga")),
      (type: "element", symbol: "O"),
    ),
  ),
)
#display-ir(x)