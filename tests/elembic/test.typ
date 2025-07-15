
#import "../../src/parse-formula-intermediate-representation.typ":*
#set page(width: auto, height: auto, margin: 0.5em)

#[
  $
  #string-to-element("H5+3").at(1)\
  #reaction(string-to-reaction("(H5+3)5+3"))\

    #reaction((
      molecule((element("C"),
      group((element("H", count:2), element("S"), element("O", count:4)),
      charge:-2,
      // count:5,
      ),)),

    arrow(kind:1, top:(molecule((element("H", count:2), element("O")),count:2, ), ), bottom:(element("C", z:6, a:14),)),

    molecule((element("He", count: 2, charge: 1, a: 15, z: 11, oxidation: "+IV"),),
    count:2,
    phase:"aq",
  ),)
  )

    #group((
      group((
        group((
          element("H", count: 2, oxidation: "+I"),
          element("O", oxidation: "-II"),
        ),
          charge: -2,
          count: 2,
          kind: 1,
        ),
        element("R", ),
      ),count: 2,),
    ))
  $
]

