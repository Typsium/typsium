/// [max-delta: 70]
#import "../../src/lib.typ" : ce
#import "@preview/alchemist:0.1.8": *
// #import "../../src/typing.typ": e

#set page(width: auto, height: auto, margin: 0.5em)

#let alchemist-molecule = skeletize({
  molecule(name: "A", "A")
  single()
  molecule("B")
  branch({
    single(angle: 1)
    molecule(
      "W",
      links: (
        "A": double(stroke: red),
      ),
    )
    single()
    molecule(name: "X", "X")
  })
  branch({
    single(angle: -1)
    molecule("Y")
    single()
    molecule(
      name: "Z",
      "Z",
      links: (
        "X": single(stroke: black + 3pt),
      ),
    )
  })
  single()
  molecule(
    "C",
    links: (
      "X": cram-filled-left(fill: blue),
      "Z": single(),
    ),
  )
})
// #let sulfuric-acid = define-molecule(formula: "H2SO4")
// #let iron = get-element(symbol:"Fe")

$
#ce[H2SO4 ->H2O + #math.overbrace[#alchemist-molecule][Hello World]]\

#ce[#text(green)[He2]#math.cancel[S]O4^#text(blue)[#math.cancel[5]-]]

#ce[A + B =>[PO4-3][Hello World] C + D]\

// #ce[#sulfuric-acid + 2#iron]
$
