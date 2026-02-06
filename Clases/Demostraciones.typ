// Main book file - compiles the complete "Demostraciones matemáticas" book
// This file imports preamble and includes all chapters

#import "/preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

#set document(
  title: [Demostraciones matemáticas],
  author: "Federico Lebrón",
)

#align(center + horizon)[
  #text(size: 20pt)[Demostraciones matemáticas]
  #pad(top: -5mm)[
    #text(size: 10pt)[Federico Lebrón]
  ]
]
#place(center + horizon, dy: 30mm)[
  #scale(x: 100%, y: 100%)[
    #pitagoras
  ]]

/*#place(left + horizon, dx: -43mm, dy: -13mm)[
#scale(x: 40%, y: 40%)[
  #stereographic
]]
*/

#set page(numbering: none)
#pagebreak()
#set page(numbering: "1")

A la Universidad de Buenos Aires.

#pagebreak()

#outline()

#pagebreak()

#include "chapters/demostraciones.typ"
#include "chapters/fundamentos-matematicos.typ"
#include "chapters/algoritmos.typ"
#include "chapters/teoria-de-grafos.typ"
#include "chapters/apendice.typ"


#load-bib(main: true)
