#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

#pagebreak()

#align(center + horizon)[
  = Teoría de grafos
]

#pagebreak()

#include "introduccion-a-grafos.typ"
#include "arboles.typ"
#include "recorridos.typ"
#include "caminos-minimos.typ"
#include "agm.typ"
#include "flujo.typ"
#include "matching.typ"
#include "circuitos-y-caminos.typ"
#include "coloreo.typ"
#include "planaridad.typ"
#include "homomorfismo.typ"


#load-bib()