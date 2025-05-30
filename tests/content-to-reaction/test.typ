#import "../../src/lib.typ" : ce
#import "../../src/utils.typ" : *
#import "../../src/libs/elembic/lib.typ" as e
#import "../../src/model/group.typ":*
#import "../../src/model/element.typ":*
#import "../../src/parse-formula-intermediate-representation.typ": string-to-reaction,
// #show: e.set_(group, grow-brackets:false, affect-layout:false)

#set page(width: auto, height: auto, margin: 0.5em)

// #show: show-roman.with(roman: false)

// #show: e.set_(element, affect-layout:true,roman-charge:false)

#ce[#text(red)[He2]#math.cancel[S]O4^#math.cancel[5-]]

// // #ce[#text(red)[H]e_2#math.cancel[S]O4^IV]\
// #ce("He2SO4-5")\
// 
// #reconstruct-content-from-strings("Hello", ((text(red)[],), (text(red)[],), (text(red)[],), (text(blue)[],), (text(blue)[],)))
// #reconstruct-content-from-strings("Hello", ((math.cancel[],), (math.cancel[],), (math.cancel[],), (text(blue)[],), (text(blue)[],)))
// #reconstruct-nested-content(([Hello World], text(red)[h], math.cancel[h], underline[], math.overbrace[Hello][Hello]))

// #ce[12Fe2(SO4)3]\
// #ce("12Fe2(SO4)3")\
// #ce[514H2O]\
// #ce("514H2O")\
// #ce[9Fe(OH)3]\
// #ce("9Fe(OH)3")\


// #ce("A + B =>[H2SO4][Hello World] C + D")\
// 
// #ce("2[Fe(CN)6]^4+")
// #linebreak()
// #ce("3[Co(NH3)4]^2+")
// #linebreak()
// #ce("[FeCo(CN)4 (NH3)2]^5-")
// #linebreak()
// #ce("[Co(en)3]^3- + 3[HCl]^+")