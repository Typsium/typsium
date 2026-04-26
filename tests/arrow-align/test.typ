#import "../../src/lib.typ": ce
#set page(width: auto, height: auto, margin: 0em)

$
  #ce("A &-> B")\
  #ce("AAAAAAAAAA &-> BBBB")\
  #ce("A &<-> B")\
  #ce("A &<- B")\
  #ce("A &<= B")\
  #ce("A &=> B")\
  #ce("A &-/> B")\
  #ce("A &</- B")\

  #ce("A &<=>[Hello][World] B")\
  #ce("A &<=>>[Hello][World] B")\
  #ce("A &<<=>[Hello][World] B")\
$

