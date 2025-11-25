#import "@preview/tidy:0.4.3"
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
#show: tidy.render-examples.with(scope:(ce:ce, ))

= What is Typsium?
Typsium is a tool for writing beautiful chemical equations easily.

This is the manual for Typsiums input syntax and show rules.
First, we import *typsium*: 
```typ
#import "@preview/tidy:0.0.0"
```

#let docs = tidy.parse-module(read("../src/lib.typ"), name: "Chemical Equations",scope: (typsium:typsium), preamble: "#import typsium: *\n")

 #tidy.show-module(docs, show-outline: false)

== Simple Equations and Reactions

```example
$ce("CO2 + C -> 2CO")$
```

```example
$ce("Hg^2+ ->[I-] HgI2 ->[I-] [Hg^^II I4]^2-")$
```

```example
$C_p [ce("H2O(l)")]$
```

== Formulas
```example
$ce("H2O")$
```
```example
$ce("Sb2O3")$
```

== Charges

```example
$ce("H+")$
```
```example
$ce("CrO4^2-")$
```

#pagebreak()
```example
$ce("[AgCl2]-")$
```
```example
$ce("Y^99+")$
```
```example
$ce("Fe^II Fe^III_2O4")$
```

== Oxidation Numbers

```example
$ce("Mn^^2 + H2^^1O2^^-1 -> Mn^^4O2^^-2 + H2^^1O^^-2")$
```

 == Unpaired Electrons
 You can add a radical dot to your molecules like this:
 ```example
 $ce("CO^.")$
 ```
 The appearance of the radical can be further customized by the set-element show rule.
 
 == Stoichiometric Numbers<ge>
 Spaces get moved to before the molecule, since there shouldn't be a space between stochiometric numbers and the molecule.
  ```example
$
  ce("2H2O")\
  ce("2 H2O")\
  ce("$1/2$H2O")\
$
 ```

== Isotopes
When writing Isotopes it is important that this specific order is used. Otherwise the notation is similar to counts and charges, just before the Symbol.
```example
$ce("^227_90Th+")$
 ```

= Show Rules

#let typing = tidy.parse-module(read("../src/typing.typ"), scope: (typsium:typsium), preamble: "#import typsium: *\n")
 #tidy.show-module(typing, show-outline: false)

