#import "../../src/parse-formula-intermediate-representation.typ" : molecule-string-to-ir

#let co2 = (
             type: "molecule",
             children: (
               (type: "element", symbol: "C"),
               (type: "element", symbol: "O", count: 2),
             ),
           )
#let ir-co2 = molecule-string-to-ir("CO2")

#let no = (
           type: "molecule",
           children: (
             (type: "element", symbol: "N"),
             (
               type: "element",
               symbol: "O",
               charge: -2,
               radical: true,
             ),
           ),
         )
#let ir-no = molecule-string-to-ir("NO^2.-")

#let na = (
            type: "molecule",
            children: (
              (type: "element", symbol: "Na", count: 3, charge: 1),
            ),
          )
#let ir-na1 = molecule-string-to-ir("Na_3^+")
#let ir-na2 = molecule-string-to-ir("Na_3^+")

#let cl = (
            type: "molecule",
            children: (
              (
                type: "element",
                symbol: "Cl",
                count: 2,
                charge: -1,
              ),
            ),
          )
#let ir-cl = molecule-string-to-ir("Cl2-1")

#let fe = (
            type: "molecule",
            children: (
              (
                type: "element",
                symbol: "Fe",
                count: 2,
                charge: "III",
              ),
            ),
          )
#let ir-fe = molecule-string-to-ir("Fe2^III)")

#assert(co2 == ir-co2)
#assert(no == ir-no)
#assert(na == ir-na1)
#assert(na == ir-na2)
#assert(cl == ir-cl)
#assert(fe == ir-fe)