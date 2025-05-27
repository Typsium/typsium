#import "../../src/lib.typ" : ce
#import "../../src/libs/elembic/lib.typ" as e
#import "../../src/model/element.typ":*

#set page(width: auto, height: auto, margin: 0.5em)

#ce("O^^-ii")
#ce("S^^+VI")
#ce("C^^+4")
#ce("H^^+1")

#show: e.set_(element, roman-oxidation:false)
#ce("O^^-2")
#ce("S^^+6")
#ce("C^^+IV")
#ce("H^^+I")

#ce("O^1^^-2")
#ce("S^2^^+6")
#show: e.set_(element, roman-oxidation:true)
#ce("C^-2^^+4")

#ce("H^.-^^+1")
#ce("H_3^^+IO+^^-2")
