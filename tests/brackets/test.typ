#import "../../src/lib.typ" : ce
#import "@preview/elembic:1.1.0" as e
#import "../../src/model/group-element.typ":*

#show: e.set_(group, grow-brackets:true, affect-layout:true)

#set page(width: auto, height: auto, margin: 0.5em)

// #ce("({[(Na2)2]2}2)")\
// #ce("A + B =>[H2SO4][Hello World] C + D")\
// 
#ce("2[Fe(CN)6]^4+")
#linebreak()
#ce("3[Co(NH3)4]^2+")
#linebreak()
#ce("[FeCo(CN)4 (NH3)2]^5-")
#linebreak()
#ce("[Co(en)3]^3- + 3[HCl]^+")
\
#ce("[CH2[NH3]]2SO2")