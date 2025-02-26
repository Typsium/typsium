#import "lib.typ": ce

#set page(margin: 1em, width: auto, height: auto)

// 1. Test long formula with multiple large coefficients
#ce("114Fe2(SO4)3 + 514H2O -> 1919Fe(OH)3 + 810H2SO4")
#v(1em)

// 2. Test complex charges with multiple digits
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
#ce("CaH (2n+1) O x")

// === 新增的边缘情况测试 ===

// 11. 测试超过2字符的元素符号 (当前正则只匹配2字符)
#ce("Uuo + Uup -> UuoUup")
#v(1em)

// 12. 测试分数系数 (当前正则只支持小数点形式)
#ce("1/2 H2 + 1/4 O2 -> 1/2 H2O")
#v(1em)

// 13. 测试复杂下标 (当前只匹配简单数字或字母)
#ce("H(2n+1) + O(n) -> H2O + CnH2n")
#v(1em)

// 14. 测试科学计数法系数
#ce("1.2e3 NaCl + 5.4E-2 HCl")
#v(1em)

// 15. 测试多级嵌套括号
#ce("K4[Fe(CN)2{Co(NH3)4}]")
#v(1em)

// 16. 测试混合电荷表示
#ce("Fe^(2+/3+) + Cu^(I/II)")
#v(1em)

// 17. 测试未包含在状态规则中的状态
#ce("CO2(sc) + H2O(supercrit)")
#v(1em)

// 18. 测试带特殊符号的条件
#ce("A + B -> C", condition: "pH=7.4, 0.1M")
#v(1em)

// 19. 测试同位素表示
#ce("^235U + n -> ^236U -> X + Y")
#v(1em)

// 20. 测试化学平衡常数表示
#ce("A + B <-> C + D", condition: "K_eq=10^-7")
