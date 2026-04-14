/// [max-delta: 50]
#import "../../src/lib.typ" : ce, set-group

#set page(width: auto, height: auto, margin: 0.5em)

#show: set-group(grow-brackets:true, affect-layout:true)

#ce("{[({[(Na2)2]2}2)]2}2")\
#ce("2[Fe(CN)6]^4+")\
#ce("[FeCo(CN)4 (NH3)2]^5-")\
#show: set-group(grow-brackets:false, affect-layout:false)
#ce("3[Co(NH3)4]^2+")\
#ce("[Co(en2)3]^3- + 3[HCl]^+")
\
#ce("[CH2(NH3)5]2SO2")\
