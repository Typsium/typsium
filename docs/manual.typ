#import "@preview/tidy:0.4.3"
#import "@preview/unify:0.8.0": qty
#import "../src/lib.typ" as typsium
#import "../src/lib.typ":ce
// #import "@preview/typsium:0.3.1" as typsium
#import "template.typ": *

#let package = toml("../typst.toml").package
#show "typsium:0.0.0": "typsium:" + package.version
#show regex("<https://github.com/.*>"): it=> {
  linebreak()
  link(it.text.slice(1, it.text.len()-1))[#it.text.slice(1, it.text.len()-1)]
}

#show: project.with(
  title: package.name,
  subtitle: package.description,
  authors: package.authors,
  date: datetime.today().display("[month repr:long] [day], [year]"),
  version: package.version,
  url: package.repository
)
#show: tidy.render-examples.with(scope:(ce:ce, qty:qty))

= What is Typsium?
Typsium is a tool for writing beautiful chemical equations easily.

First, we import *typsium*: 
```typ
#import "@preview/typsium:0.3.2":*
```

#let docs = tidy.parse-module(read("../src/lib.typ"), name: "Chemical Equations",scope: (typsium:typsium), preamble: "#import typsium: *\n")

 #tidy.show-module(docs, show-outline: false)

```example
#ce("CO2 + C -> 2CO")
```

```example
#ce("Hg^2+ ->[I-] HgI2 ->[I-] [Hg^^II I4]^2-")
```


== Formulas
```example
$ce("H2O")$
```
```example
$ce("Sb2O3")$
```
```example
$C_p (ce("H2O(l)"))$
```

== Charges

```example
#ce("H+")
```
We try to understand the intent behind many different ways of writing the same Compound:
```example
#ce("CrO4-2")
#ce("CrO4^2-")
#ce("CrO-2_4")
#ce("CrO_4^2-")
```

```example
#ce("[AgCl2]-")
```
```example
#ce("Y^99+")
```
```example
#ce("Fe^II Fe^III_2O4")
```
```example
#ce("SiO5^(1-x)")
```

== Oxidation Numbers
Use double ^ to add oxidation numbers to individual elements in your compound. This can also be combined with charges, but only if the oxidation numbers appear after the charges are declared.
```example
#ce("Mn^^2 + H2^^1O2^^-1 -> Mn^^4O2^^-2 + H2^^1O^^-2")
```

 == Unpaired Electrons
 You can add a radical dot to your molecules like this:
 ```example
 #ce("CO^.")
 ```
 The appearance of the radical can be further customized by the set-element show rule.
 
 == Stoichiometric Numbers<ge>
 Spaces get moved to before the molecule, since there shouldn't be a space between stochiometric numbers and the molecule.
  ```example
  #ce("2H2O")\
  #ce("2 H2O")\
  #ce("$1/2$H2O")\
 ```

== Isotopes
When writing Isotopes it is important that this specific order is used. Otherwise the notation is similar to counts and charges, just before the Symbol.
```example
#ce("^227_90Th+")
 ```

 == Precipitation arrows
 
```example
 #ce("A v +B v &-> B ^ +B ^")
 ```

 == Aggregation states
```example
 #ce("NaCl(aq) + He(g) + C(s)")\
 #ce("H2O(l) + NaOH(aq,oo)")\
 ```
== Alignment
```example
$
  #ce("A &-> B")\
  #ce("AAAAAAAAAA &-> BBBB")\
$
 ```

 #pagebreak()
== Arrows

There exist many different kinds of arrows:

```example
#ce("1A -> B")\
#ce("2A <- B")\
#ce("3A <=> B")\
#ce("4A => B")\
#ce("5A <= B")\
#ce("6A -/> B")\
#ce("7A </- B")\
#ce("8A <=>> B")\
#ce("9A <<=> B")\
```

You can add any content you like on top of arrows, including full reactions or content from other packages.
```example
#ce("A ->[Hello][World] B")

#ce[A ->[#qty("2.3", "electronvolt")] B]

#ce[A ->[LiAlH4][($Delta H$, reflux)] B]
 ```

== Particles
You can use shorthand versions of particle names to display nicely rendered particles
```example
#ce("electron") #ce("e-") #ce("beta-") \
#ce("proton") #ce("p+") #ce("antiproton")\
#ce("neutron") #ce("antineutron")\
#ce(" neutrino antineutrino")\
#ce("mu-") #ce("muon-")\
#ce("alpha")\
 ```



= Show Rules

#let typing = tidy.parse-module(read("../src/typing.typ"), scope: (typsium:typsium), preamble: "#import typsium: *\n")
 #tidy.show-module(typing, show-outline: false)

