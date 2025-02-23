#import "lib.typ": ce

#set page(margin: 1em, width: auto, height: auto)

// 1. Test long formula with multiple large coefficients
#ce("114Fe2(SO4)3 + 514H2O -> 1919Fe(OH)3 + 810H2SO4")
#v(1em)

// 2. Test complex charges with multiple digits
// result in error: equation does not have filed "children"
#ce("Fe^(3+) + PO4^(3-) + OH^(1-) -> Fe(OH)2^(1+) + PO4^(3-)")
#v(1em)

// 3. Test nested brackets with multiple coefficients
#ce("2[Fe(CN)6]^4- + 3[Co(NH3)4]^2+ -> [FeCo(CN)4(NH3)2]^5-")
#v(1em)

// 4. Test multiple conditions with special characters
#ce("A^+ + B^+ <-> C^+ + D^+", condition: "T=1000K, P=500atm, catalyst=Pt, δ, Al2O3")
#v(1em)

// 5. Test empty components and spaces
#ce(" H2 + O2  ->  H2O ", condition: " ")
#v(1em)

// 6. Test single character elements and numbers
#ce("H + 2H -> H3")
#v(1em)

// 7. Test mixed arrow types in same document
#ce("A + B = C -> D + (E <-> F)")
#v(1em)

// 8. Test special symbols in conditions
// need to add check for special symbols in conditions, do not need to show multiple times
#ce("X -> Y", condition: "Δ,δ,heat,Delta")
#v(1em)

// 9. Test maximum length element symbols
#ce("Uuu + Zzz -> UuuZzz")
#v(1em)

// 10. need to add support for x in number of elements
#ce("CaH2xOx")
