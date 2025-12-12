/// [max-delta: 50]
#import "../../src/lib.typ" : ce, set-group

#show: set-group(grow-brackets:true, affect-layout:true)

#set page(width: auto, height: auto, margin: 0.5em)

// #ce("({[(Na2)2]2}2)")\
// #ce("A + B =>[H2SO4][Hello World] C + D")\
// 
#ce("2[Fe(CN)6]^4+")
#linebreak()
#ce("3[Co(NH3)4]^2+")
#linebreak()
#ce("[FeCo(CN)4 (NH3)2]^5-")
#show: set-group(grow-brackets:true, affect-layout:false)

#linebreak()
#ce("[Co(en)3]^3- + 3[HCl]^+")
#show: set-group(grow-brackets:false, affect-layout:false)
\
#ce("[CH2(NH3)5]2SO2")\
#ce("[CH2][CH2]2")