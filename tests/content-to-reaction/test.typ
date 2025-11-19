/// [max-delta: 50]
#import "../../src/lib.typ" : ce, define-molecule, get-element
#import "../../src/utils.typ" : *
#import "@preview/elembic:1.1.0" as e
// #import "../../src/model/group-element.typ":*
// #import "../../src/model/element-element.typ":*
// #import "../../src/parse-formula-intermediate-representation.typ": string-to-reaction,
#import "@preview/alchemist:0.1.8": *
// #show: e.set_(group, grow-brackets:false, affect-layout:false)

#set page(width: auto, height: auto, margin: 0.5em)

// #show: show-roman.with(roman: false)

// #show: e.set_(element, affect-layout:true,roman-charge:false)


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

$
#ce[H2SO4 ->H2O + #math.overbrace[#alchemist-molecule][Hello World]]\
$

#ce[#text(green)[He2]#math.cancel[S]O4^#text(blue)[#math.cancel[5]-]]

#ce[A + B =>[PO4-3][Hello World] C + D]\

#let sulfuric-acid = define-molecule(formula: "H2SO4")
#let iron = get-element(symbol:"Fe")

#ce[#sulfuric-acid + 2#iron]
