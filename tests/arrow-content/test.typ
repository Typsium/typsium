// /// [max-delta: 50]
#import "../../src/lib.typ": ce
#import "../../src/model/element-element.typ": element
#import "../../src/model/group-element.typ": group
#import "../../src/model/molecule-element.typ": molecule
#import "../../src/model/arrow-element.typ": reaction-arrow
#import "@preview/unify:0.8.0": num, numrange, qty, qtyrange, unit
#set page(width: auto, height: auto, margin: 1em)


#let g = group((element("H"),[ello]),)
#let m = molecule((element("H"),[ello]))

#reaction-arrow(kind:1, top:g, bottom:g)\
\
#reaction-arrow(kind:1, top:molecule((g,)), bottom:molecule((g,)))\
\
#reaction-arrow(kind:1, top:m, bottom:m)\

#ce[A ->[#qty("2.3", "electronvolt")] B]

#ce[A ->[LiAlH4][($Delta H$, reflux)] B]

// #ce("A ->[Delta] B")

// #ce("CH3COOH <=>[+ OH-][+ H+] CH3COO-")
