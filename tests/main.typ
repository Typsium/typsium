// #import "/src/parse-content-intermediate-representation.typ": content-to-ir
// #import "/src/parse-formula-intermediate-representation.typ": string-to-ir
#import "/src/lib.typ": ce
#import "@preview/alchemist:0.1.4": *

// #let ce(body) = display-ir(string-to-ir(body))
// #let cem(body) = display-ir(content-to-ir(body))

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
#set page(width: auto, height: auto, margin: 0.5em)



// #cem[H2SO4 + H2O <=[H2O] OH- + #alchemist-molecule + #text("H2O",red)]
// $#cem[#text("H2O",red)]$
// 
// 
// #let x = 3
// #let x = x*5
// #x

// #ce[H2O]
// #linebreak()
#let x = (
  (
    type: "molecule",
    children: (
      (type: "element", symbol: "H", count: 2, symbol-body:text(red)[H], count-body:math.cancel(angle:50deg)[2]),
      (type: "element", symbol: "O"),
    ),
  ),
)
#let y = (
  (
    type: "molecule",
    children: (
      (type: "element", symbol: "Na", symbol-body:strong[N]),
      (type: "element", symbol: "H", count: 3, charge:2, count-body:text(green)[3], charge-body:text(red)[2+]),
    ),
    body:math.cancel(angle:90deg)[]
  ),
  (type: "+"),
  (
    type: "molecule",
    children: (
      (type: "element", symbol: "O",symbol-body:text("H",red)),
      (type: "element", symbol: "H", charge:-1, symbol-body:text("H",blue)),
    ),
    body:math.overbrace[#text(red)[OH-]][Hydroxide-ion]
  ),
)

// #text(red)[Hello #text(blue)[World] ]
// #math.cancel(angle: 90deg)[Hello #math.attach("H", br:"ello", tr: "world") world]
// #display-ir(x)\
// #display-ir(y)
// #let x = math.underbrace[2][Hello World]
// #math.attach("H", br:)
// #linebreak()
$
#ce("AgCl + 2NH3 &<=> [Ag(NH3)2]+ + Cl-")\
#ce("Co3^2- + H2O &<=> HCO3- + OH-")\
#ce("Pb+2 + Co3-2 &-> PbCO3")\
#ce("Pb+2 + 2OH- &-> Pb(OH)2")\
#ce("2HClO &->[entwässern] H2O + Cl2O")\
#ce("3ClO- &->[$Delta$][Disproportionierung] 2Cl- + ClO3- | ")\
#ce("6KOH + 3Cl2 &->[][Disproportionierung] 5KCl- + KClO3 + H2O")\
#ce("3HClO3 &->[][Disproportionierung] HClO4 + 2ClO2 + H2O")\
#ce("6HCl^^+IVO2 + 3H2O &->[][Disproportionierung] 5HCl^^+VO3 + HCl^^-I")\
#ce("ClO3- + H2SO4&-> HClO3 + HSO4-")\
#ce("3HClO3 &->[H2SO4] HClO4 + H2O + ClO2 (gelb-grünes gas)")\
#ce("2ClO2 &->[$Delta$][Explosionsartiger Zerfall] Cl2 + 2O2")\
#ce("K+ + ClO4- &<=> KClO4")\
#ce("8Fe(OH)2 + ClO4- + 4H2O &-> Fe(OH)3 + Cl-")\
#ce("3Ti+3 + ClO4- + 12H2O &-> TiO+2 + Cl- + 8H3O+")\
#ce("Br2 + 2OH- &-> BrO- + Br- + H2O")\
#ce("3BrO- &->[$Delta$Raumtemperatur] 2Br- + BrO3-")\
#ce("3IO- &->[$Delta$Tiefe Temp] 2I- + IO3-")\
#ce("BrO3- + 5SO2 + 12H2O &-> Br2 + 5SO4-2 + 8H3O+")\
#ce("Br2 + SO2 + 6H2O &-> 2Br- + 5SO4-3 + 4H3O+")\
#ce("H2SO4 + 2BrO3- &-> 2HBrO3 + 2HSO4-")\
#ce("2HBrO3 &->[H2SO4][-H2O] Br2O5")\
#ce("Br2O5 &->2Br2 + 5O2")\
#ce("S2- + 2HCl &->H2S + 2Cl")\
#ce("H2S + Pb(OAc)2 &-> PBS + 2HOAc")\
#ce("SO3-2 + 2H+ &-> H2O + SO2 (Schwefelpulvergeruch)")\
#ce("2KHSO4 + SO3-2 &-> K2SO4 + So4-2 + H2O + SO2")\
#ce("2KHSO4 + SO3-2 &-> K2SO4 + So4-2 + H2O + SO2")\
#ce("4Zn + NO3- + 7OH- + 6H2O &-> NH3(g) + 4[Zn(OH4)]-2")\
#ce("NH3 + H2O &<=> NH4+ + OH-")\
#ce("NH3(g) + konz. HCl(g) &-> NH4Cl")\
#ce("NO2- &-> HNO3 | 2HNO2 + O2 -> 2HNO3")\
#ce("2HNO2 + CN2H4O(Harnstoff) &-> CO2 + 2N2")\
#ce("HNO2 + Sulfonsäure &->  2N2 + H2SO4")\
#ce("[Fe(H2O)6]+2 + NO2- + 2H+&-> [Fe((H2O)6)]+3 + NO + H2O")\
#ce("[Fe(H2O)6]+2 + NO &-> [Fe(H2O)5(NO)]+2 + H2O")\
#ce("3[Fe(H2O)6]+2 + NO3- + 4H+ &-> [Fe(H2O)6]+3 + NO + 2H2O")\
#ce("[Fe(H2O)6]+2 + NO &-> [Fe(H2O)5(NO)]+2 + H2O")\
#ce("Sulfanilsäure + HNO2 + H+ &-> Diazoniumsalze (diazotierung)")\
#ce("Zn+2 + 2H+ + NO3- &-> Zn+2 + H2O + NO2-")\
#ce("HPO42- + 23H+ + 3NH4+ + 12MoO4 &-> (NH4)3[P(Mo3O10)4](aq) + 12H2O")\
#ce("B(OH)3 + 3MeOH &->[konz. H2SO4] B(OMe)3 + 3H2O")\
//HNO3 + (NH4)6Mo7O24*4H2O
$

$
  #ce("H2S &<=> H+ + HS- &&<=> 2H + S2-")\
  #ce("H2O + SO2 &<=> SO2(aq) &&<=> SO2*H2O &&<=> H2SO3")\
  #ce("H2O + SO3 &<=> H2SO4 &&<-> HSO4- &&<-> SO4-2")\
$
// #ce[H#text(red)[2]O]
// $#ce[#strike("H2SO4")]$
// #linebreak()
// #ce[*Fe2* + #[H2O] ]
// #linebreak()
// #linebreak()
// $#ce[12Fe2(SO4)3]$
// #linebreak()
// #linebreak()
// $#ce[514H2O]$
// #linebreak()
// #linebreak()
// $#ce[9Fe(OH)3 + ]$
// #linebreak()
// #linebreak()
// $cem("H2SO4" + "H2O" -/> "[H2O]" "OH-")$