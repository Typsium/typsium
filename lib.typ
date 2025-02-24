#import "@preview/unify:0.7.0": qty
// === Declarations & Configurations ===
// regular expressions of patterns
// for parsing `[Co(NH3)6]2+(aq)`
#let counts = "[0-9a-z\(\)\[\]/+-]"
#let regular_patterns = (
  reactions: regex("\s(=+|-+>|<-+>|<=+>)\s"),
  // -> | = : One-way reaction.
  // <->|<=>: Reversible reaction.
  // parse from right to left, separating the formula to sums
  
  mixtures: regex("\s+[+-]"),
  // in a chemical equation, use + to express mixing of species
  // in a half-cell equation, - is also used for expressing  
  // A SPACE should be provided as a PREDecessor, 
  // to distinguish mixture `O2 +` from ion `O2- `
  // like `O2 + 4e- --> 2O2-`
  // parse from left to right, separating the sum to terms, but don't worry

  equivalents: regex("^(" + counts + "+\s+|\d+)"),
  // at the beginning of each term, ONCE
  // available for `2NOx + (2-x)O2 -> 2NO2`
  // but not suitable for `Co2+ + 2py -> [Co(py)2]2+(aq)`
  // where a space `2 py` could terminate parsing the equiv's.
  // e is for electron, not used

  phases: regex("\s+(\([a-z]+\))$"),
  // at the end of each term, ONCE

  charges: regex("(\^" + counts + "*|\d?)([+-])$"),
  // after parsing coefficients
  // at the end of each parsed term?
  // H+, Fe2+, NO3 -, SO4 2-, NH4 +, VO2+, VO2 +, [Fe(OH)x]^(3-x)+
  // Na+Cl-, [PCl4]+[PCl6]-
  // parse from right to left, for ionic compounds, 
  // to imply hidden multiplies? well, just use the *.

  brackets: regex("([^\^_])(\([^\(\)]*\)|\[[^\[\]]*\])(_" + counts + "*|\d*)$"),
  // a char distinguishing it from counter is needed

  bonds: regex("([-=#@<>…])$"), 
  // DON'T SPACE!
  // CH3CH(-OH)COOH
  // CH3C(=O)CH3
  // CH2=CHCH3
  // Cl2Cu<NH3

  elements: regex("([A-Za-z][a-z]*)(_" + counts + "*|\d*)$"),
  // O, Al, Uun; e; en, py, ...
)
#let matching_order = ("elements", "brackets", "charges", 
  "phases", "equivalents", "mixtures", "reactions")

#let fire = "\u{1f702}"


#let bond_dict = (
  "-": $-$, "=": $=$, "#": $equiv$,
  "<": $<-$, ">": $->$, "…": $dots.c$, "@": $@$, 
)

#let config = (
  conditions: (
    bottom: (
      symbols: (heating: ("Delta", "triangle", "Δ", "fire", "heat")),
      identifiers: (("T=", "t="), ("P=", "p=")),
      units: ("°C", "K", "atm", "bar"),
    ),
  ),
  // the counts are parsed just with elements and brackets.
  // the unary operator + of charge (e.g. Fe^2+) are never confused with binary operator +. 
)


// === Formula Parser ===

#let parse_counts(formula) = {
  if formula == "" {return none}
  // 简单角标就是纯数字
  if formula.first() == "^" or formula.first() == "_" {
    // 复杂角标, 采用数学模式处理可能含小写字母的算式
    // #let counts = "[0-9a-z\(\)\[\]/+-]"
    formula = formula.slice(1)
    if formula == "" {return none}
    if formula.first() == "(" and formula.last() == ")" {
      // 对括号的处理, 让它的表现和 Typst 内置数学模式类似
      // 如果有多项式相乘? $a_(n+1)(n+2)$ Typst自己也过不了, 需要外加圆括号. 
      formula = formula.slice(1, -1)
    }
    formula = eval(formula, mode: "math")
  }
  formula
}

// 从 formula 的最后切一个化学元素, 贴到 result 的最前面
// 
// 如果最后一个不是元素, 那么原样返回, 并报未切 (false), 否则报切 (true)
#let clip_element(formula, result) = {
  let my_form = formula.trim() 
  let element_match = my_form.match(regular_patterns.elements)
  // elements: regex("([A-Za-z][a-z]*)(_" + counts + "*|\d*)$"),
  if element_match == none {return (my_form, result, false)}
  // 对 match 在未找到匹配时返回 none 的匹配

  // RegEx使用两个圆括号分别存储两部分匹配值
  let (element, count) = element_match.captures
  if count != "" {element = math.attach(element, b:parse_counts(count))}
  return (my_form.slice(0, element_match.start).trim(), element + result, true)
}


#let clip_bond(formula, result) = {
  let my_form = formula.trim() 
  let bond_match = my_form.match(regular_patterns.bonds) 
  // bonds: regex("([-=#@<>…])$"), 
  if bond_match == none {return (my_form, result, false)}

  result = h(0pt) + bond_dict.at(bond_match.captures.at(0)) + h(0pt) + result
  return (my_form.slice(0, bond_match.start).trim(), result, true) 
}

#let clip_bracket(formula, result) = {
  // 还没找到除了嵌套以外的解决方案
  let parse_brackets(formula, result: none) = {
    let (f, f1) = (true,)*2
    while formula != "" and f {
      f = false
      for i in (clip_bracket, clip_bond, clip_element){
        (formula, result, f1) = i(formula, result)
        f = f or f1
    }}
    result
  }
  let my_form = " " + formula.trim() 
  let bracket_match = my_form.match(regular_patterns.brackets) 
  // brackets: regex("([^\^_])(\([^\(\)]*\)|\[[^\[\]]*\])(_" + counts + "*|\d*)$"),
  if bracket_match == none {return (my_form, result, false)}

  let (_, bracket, count) = bracket_match.captures
  let brac = parse_brackets(bracket.slice(1, -1))
  brac = if bracket.first() == "(" {
    math.lr([(] + brac + [)])
  } else {math.lr([\[] + brac + [\]])}
  
  if count != "" {brac = math.attach(brac, b: parse_counts(count))}
  // +1 for the ([^\^_]) considered not to distinguish from scripts
  return (my_form.slice(0, bracket_match.start+1).trim(), brac + result, true)
}


#let clip_charge(formula, result) = {
  let my_form = formula.trim() 
  let charge_match = my_form.match(regular_patterns.charges)
  // charges: regex("(\^" + counts + "*|\d?)([+-])"),
  if charge_match == none {return (my_form, result, false)}

  let (count, sign) = charge_match.captures
  sign = if sign == "+" {math.plus} else {math.minus}
  sign = parse_counts(count) + sign
  // 给角标找个基底, 就需要再切一刀. 
  let my_form2 = my_form.slice(0, charge_match.start).trim()
  let ch = my_form2.last()
  let f = if ch == ")" or ch == "]" {clip_bracket} else {clip_element}
  let base = none
  (my_form, base, _) = f(my_form2, none)
  // let atta = if math.attach(base, t: si
  return (my_form, math.attach(base, t: sign) + result, true)
}

#let clip_phase(formula, result) = {
  let my_form = formula.trim() 
  let phase_match = my_form.match(regular_patterns.phases)
  // phases: regex("\s+\(([a-z]+)\)$"),
  if phase_match == none {return (my_form, result, false)}

  let (myphase,) = phase_match.captures
  return (my_form.slice(0, phase_match.start).trim(), myphase + result, true)
}

#let clip_equiv(formula) = {
  let my_form = formula.trim() 
  let equiv_match = my_form.match(regular_patterns.equivalents)
  // equivalents: regex("^(" + counts + "+\s+|\d+)"),
  if equiv_match == none {return (my_form, none, false)}

  let (myequiv,) = equiv_match.captures
  return (my_form.slice(equiv_match.end).trim(), myequiv.trim(), true)
}


#let parse_compound(formula, result: none) = {
    let equiv = 0
    let flag = false
    (formula, equiv, flag) = clip_equiv(formula)
    (formula, result, _) = clip_phase(formula, result)
    (formula, result, _) = clip_charge(formula, result)
    let (f, f1) = (true,)*2
    while formula != "" and f {
      f = false
      for i in (clip_bracket, clip_bond, clip_element){
        (formula, result, f1) = i(formula, result)
        f = f or f1
    }}
    if flag {equiv+math.med}
    result
  }


#let clip_mix(formula) = {
  let my_form = formula.trim() 
  let mix_match = my_form.matches(regular_patterns.mixtures)
  // mixtures: regex("\s+[+-]"),

  let last_end = 0
  let result = none
  for i in mix_match {
    let parsed = parse_compound(formula.slice(last_end, i.start)) 
    parsed = parsed + if i.text.last() == "+" {math.plus} else {math.minus}
    result = result + parsed
    last_end = i.end
  }
  let parsed = parse_compound(formula.slice(last_end)) 

  result + parsed
} 

#let clip_react(formula) ={
  let my_form = formula.trim() 
  let react_match = my_form.matches(regular_patterns.reactions)
  // reactions: regex("\s(=+|-+>|<-+>|<=+>)\s"),

  let last_end = 0
  let result = none
  for i in react_match {
    i
    let parsed = clip_mix(formula.slice(last_end, i.start)) 
    parsed = parsed + if "<" in i.text.last() {math.arrow.rtlb} else {math.arrow}
    result = result + parsed
    last_end = i.end
  }
  let parsed = clip_mix(formula.slice(last_end)) 

  return result + parsed
}  

#let parse_formula(formula) = {
  let remaining = formula.trim()
  let result = none
  while remaining.len() > 0 {
    let matched = false
    for pattern in config.match_order {
      let match = remaining.match(reg_pats.at(pattern))
      if match != none {
        result += if pattern == "coef" { $#match.text$ } else if pattern == "element" {
          process_element(match.captures.at(0), match.captures.at(1))
        } else { process_bracket(match.captures.at(0), match.captures.at(1)) }
        remaining = remaining.slice(match.end)
        matched = true
        break
      }
    }
    if not matched {
      result += text(remaining.first())
      remaining = remaining.slice(1)
    }
  }
  return if result == none { formula } else { result }
}

// === Condition Processing ===
#let process_condition(cond) = {
  let cond = cond.trim()
  if cond in config.conditions.bottom.symbols.heating {
    return (none, { sym.Delta })
  }
  let is_bottom = (
    config.conditions.bottom.identifiers.any(ids => ids.any(id => cond.starts-with(id)))
      or config.conditions.bottom.units.any(unit => cond.ends-with(unit))
  )
  return if is_bottom { (none, cond) } else { (parse_formula(cond), none) }
}

// === Arrow Processing ===
#let process_arrow(arrow_text, condition: none) = {
  let myarrow = if arrow_text.contains("<-") {
    $stretch(#sym.harpoons.rtlb, size: #config.arrow.reversible_size)$
  } else if arrow_text.contains("=") {
    $stretch(=, size: #config.arrow.arrow_size)$
  } else {
    $stretch(->, size: #config.arrow.arrow_size)$
  }
  let top = ()
  let bottom = ()
  if condition != none {
    for cond in condition.split(",") {
      let (t, b) = process_condition(cond)
      if t != none { top.push(t) }
      if b != none { bottom.push(b) }
    }
  }
  $myarrow^top.join(",")_bottom.join(",")$
}

// === Main Function ===
// 可以处理化学式、当量和式、化学方程式。化学式可以是离子的。
// 应当允许 A <=> B -> C 的复合方程式存在。
#let ce(formula, condition: none) = {
  assert(type(formula) == str)
  return 0
  let remaining = formula.trim()
  let result = none
  let matched = false
  while remaining.len() > 0 {
    matched = false
    for pattern in config.match_order {
      let match = remaining.match(reg_pats.at(pattern))
      if match != none {
        result += if pattern == "plus" { $+$ } else if pattern == "coef" { $#match.text$ } else if (
          pattern == "element"
        ) { process_element(match.captures.at(0), match.captures.at(1)) } else if pattern == "bracket" {
          process_bracket(match.captures.at(0), match.captures.at(1))
        } else if pattern == "charge" { process_charge(result, match.captures.at(0)) } else {
          process_arrow(match.text, condition: condition)
        }
        remaining = remaining.slice(match.end)
        matched = true
        break
      }
    }
    if not matched {
      result += text(remaining.first())
      remaining = remaining.slice(1)
    }
  }
  $upright(display(result))$
}
