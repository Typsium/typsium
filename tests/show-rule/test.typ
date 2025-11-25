#import "../../src/lib.typ" : *

#set page(width: auto, height: auto, margin: 0.5em)

#show: set-element(roman-charge:true, roman-oxidation:false)
$ce("Cu-2^^2O^^-2 + H2^^0 &-> Cu^^0 + H2^^1O^^-2")$\

#show: set-element(roman-oxidation:true,affect-layout:true)
$ce("Cu-2^^2O^^-2 + H2^^0 &-> Cu^^0 + H2^^1O^^-2")$

$ce("NH4-")$
#show: set-element(spaced-charge: true)
$ce("NH4-")$
