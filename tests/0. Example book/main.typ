#import "@preview/cram-snap:0.2.2": *
#import "../../src/lib.typ": *
//#import "@preview/typsium:0.3.0": *
#import "@preview/zebraw:0.5.5": *
#import "@preview/cuti:0.3.0":*

#set page(margin: 0.8cm, height: auto)
#set text(size: 14pt)
#show raw: set text(font: "IBM Plex Sans", size: 11pt)
#show: set-group(grow-brackets:false, affect-layout:false)
#show: cram-snap.with(
  title: [Example sheet],
  subtitle: [
    #v(-1em)
    For: 0.3.0\
    Written on: #datetime.today().display()
  ],
  column-number: 1,
  fill-color: "d0e0d0",
  stroke-color: "343434",
)

#align(center)[
  #text(size: 24pt, weight: "bold", fill: rgb("2c5aa0"))[
    #show raw: set text(size: 24pt)
    Basic Usage
  ]
  #v(-0.9em)
  #line(length: 60%, stroke: 1pt + rgb("2c5aa0"))
  #v(-0.3em)
]

#table(inset: 0.7em)[
  Effect
][
  Grammar
][
  #ce[H2O]
][
  ```typ #ce[H2O]``` or ```typ #ce("H2O")```
][
  #ce[H+]
][
  ```typ #ce[H^+]``` or ```typ #ce[H+]```
][
  #ce[H-]
][
  ```typ #ce[H^-]``` or ```typ #ce[H-]```
][
  #ce[O^2-]
][
  ```typ #ce[O^2-]```
][
  #ce("[Fe(CN)6]^4+")
][
  ```typ #ce("[Fe(CN)6]^4+")```
][
  #ce[CuSO4*5H2O]
][
  ```typ #ce[CuSO4*5H2O]```
][
  #ce[->]
][
  ```typ #ce("->")``` or ```typ #ce[->]```
][
  #ce("->[600°C][200atm]")
][
  ```typ #ce("->[600°C][200atm]")```
][
  #ce[Cu-2^^2]
][
  ```typ #ce[Cu-2^^2]```
][
  roman-charge\
  roman-oxidation
][
  ```typ #show: set-element(roman-charge: true)``` \ ```typ #show: set-element(roman-oxidation: true)```
]
#align(center)[
  #text(size: 24pt, weight: "bold", fill: rgb("2c5aa0"))[
    #show raw: set text(size: 24pt)
    Content in #raw("ce", lang: "typ")
  ]
  #v(-0.9em)
  #line(length: 60%, stroke: 1pt + rgb("2c5aa0"))
  #v(-0.3em)
]

#table(inset: 0.7em)[
  effect
][
  content
][
  #ce[#text(red)[H2]]
][
  ```typ #ce[2#text(red)[H2]]```
][
  $overbrace(#ce("H2O"),"water")$
][
  ```typ   $overbrace(#ce("H2O"),"water")$ ```
][
  #ce[*H2O*]
][
  ```typ #ce[*H2O*]```
][
  #ce[#fakeitalic[H2O]]
][
  ```typ 
  #import "@preview/cuti:0.3.0":* //or newer
  #ce[#fakeitalic[H2O]]
  
  ```
]
//...