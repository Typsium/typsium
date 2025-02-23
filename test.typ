#import "lib.typ": ce

#set page(margin: 1em, width: auto, height: auto)

// 1. 普通燃烧反应（带热条件）
#ce("2H2 + O2 -> 2H2O", condition: "heat")
#v(1em)

// 2. 带电荷的氧化还原反应
#ce("Zn + Cu^(2+) = Zn^(2+) + Cu")
#v(1em)

// 3. 复杂的离子反应（带多个生成物）
#ce("2KMnO4 + 8HCl -> KCl + MnCl2 + 4H2O + 2Cl2")
#v(1em)

// 4. 可逆反应（带温度压力条件）
#ce("N2 + 3H2 <-> 2NH3", condition: "450°C, 200atm")
#v(1em)

// 5. 带复杂条件的分解反应
#ce("2KClO3 -> 2KCl + 3O2", condition: "MnO2,Delta")
#v(1em)

// 6. 复杂离子带括号反应
#ce("3Ca^(2+) + 2PO4^(3-) -> Ca3(PO4)2")
#v(1em)

// 7. 带温度的热分解反应
#ce("CaCO3 -> CaO + CO2", condition: "900°C")
#v(1em)

// 8. 带催化剂的气相反应
#ce("2SO2 + O2 -> 2SO3", condition: "V2O5,450°C")
#v(1em)

// 9. 电离反应
#ce("H2SO4 -> 2H^+ + SO4^(2-)")
#v(1em)

// 10. 简单的沉淀反应
#ce("AgNO3 + NaCl -> AgCl + NaNO3")
