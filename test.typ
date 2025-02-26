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
#v(1em)

// 11. Plus should indicate charge instead of adding educts: this should be a proton
#ce("H+")
#v(1em)

// 12. the 4 should be directly below the 2-, instead of appearing next to each other
#ce("CrO4^2-")
#v(1em)

// 13. oxidation states for metals should be shown on the top right. normal underscore numbers should still work
#ce("Fe^II Fe^III_2O4")
#v(1em)

//14. unpaired electrons and radical dots. they should not be the '.' character
#ce("OCO^.-")
#ce("NO^2.-")
#v(1em)

//15. brackets should automatically size to the content and get larger to encompass everything
#ce("[{(X2)3}2]^3+"
#v(1em)

// Add text on top of brackets or on top and bottom
#ce("A ->[some text] B")
#ce("A ->[some text][other text] B")
#v(1em)

// states of aggregation
#ce("H2(aq)")
#ce("H2O(s)")
#ce("H2O(g)")
#v(1em)

// math mode and aligning multiple equations:
$
#ce("H2SO4 (aq) &<-> H+ (aq) + HSO4^- (aq)")\
#ce("H+ (aq) + HSO4^- (aq) &<-> H2SO4 (aq)")
$
#v(1em)

// using in combination with other methods 
$
K_a = (#h(1.3em) [#ce("H+")] overbrace(#ce("[A-]"), "conjugate acid"))/ underbrace(#ce("[HA]"), "acid")
$
