
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble
== Planaridad

#defi[
  Un grafo $G$ es *planar* cuando existe una forma de dibujarlo en el plano, de tal forma que las aristas no se crucen.
]
#teo[
  En un grafo planar con $m > 1$ aristas, toda cara tiene al menos 3 aristas en su borde. Esto incluye la cara exterior.
]<teo:planar>
#ej(title: [Formula de Euler])[
  Sea $G$ un grafo conexo y planar, con $n$ vértices, $m$ aristas, y dibujado con $r$ caras (incluyendo una cara exterior).

  Probar que $r = m - n + 2$.

  Por ejemplo, el siguiente grafo tiene $n = 4$ vértices, $m = 6$ aristas, y $r = 4$ caras:
  #align(center)[
    #diagram(node-shape: circle, node-stroke: 0.5pt, {
      node((0.5, 0), name: "a", radius: 5pt)
      node((1, 2), name: "b", radius: 5pt)
      node((2, -1), name: "c", radius: 5pt)
      node((4, 2), name: "d", radius: 5pt)
      edge(label("a"), label("b"))
      edge(label("a"), label("c"))
      edge(label("b"), label("d"))
      edge(label("d"), label("c"))
      edge(label("d"), label("a"))
      edge(label("c"), label("b"), bend: -90deg)
    })]


]
#demo[
  Vamos a probar esto por inducción en $r$, el número de caras. Sea $P(r):$ Todo grafo $G = (V, E)$ conexo y planar con $r$ caras cumple que $|V| - |E| + r = 2$.

  + Caso base, $P(1)$. Sea $G = (V, E)$ un grafo conexo planar con $r = 1$ caras, y sean $n = |V|$ y $m = |E|$. Como $r = 1$, no podemos tener ciclos, pues un ciclo generaría una cara, y ya tenemos una (la externa). Luego, al ser $G$ conexo y acíclico, $G$ es un árbol. Luego, $m = n - 1$, y tenemos $n - m + r = n - (n - 1) + 1 = 2$, que muestra $P(1)$.
  + Paso inductivo. Sabemos $P(r)$, queremos probar $P(r+1)$. Sea $G = (V, E)$ un grafo conexo y planar, con $r + 1 gt.eq 2$ caras. Si $G$ fuera un árbol, $r = 1$, luego $G$ no es un árbol, y al ser conexo, tiene un ciclo $C$. Sea $e in C$ cualquiera arista en $C$. Sea ahora $G' = (V, E - {e})$. Como $e$ pertenecía a un ciclo, $G'$ sigue siendo conexo, con $|E - {e}| = |E| - 1$. Al haber roto un ciclo sacando $e$, $G'$ tiene una cara menos que $G$. Luego, usando $P(r)$, vemos que $|V| - (|E| - 1) + r = 2$. Esto nos dice que $|V| - |E| + (r + 1) = 2$, que es prueba $P(r+1)$.

  Luego probamos $P(r)$ para todo $r in NN, r gt.eq 1$. Como todo grafo planar tiene un número positivo de caras, esto prueba que todo grafo conexo planar cumple la ecuación.
]

#ej[
  Sea $G$ un grafo planar de $n$ vértices y $m$ aristas, con $n gt.eq 3$.

  Probar que $m lt.eq 3n - 6$.
]
#demo[
  Vamos a probar esto para grafos conexos. Si nos dan un grafo no conexo, podemos agregarle aristas hasta hacerlo conexo, sin perder planaridad, y vamos a ver que la desigualdad sigue valiendo. Como estamos aumentando $m$, sin cambiar $n$, valía antes de agregar las aristas.

  Sea entonces $G = (V, E)$ un grafo planar conexo, con $n = |V|, m = |E|$, y $r$ caras. Si $m lt.eq 2$, esto es cierto pues $3n - 6 gt.eq 3$. De otra manera, podemos usar
  el @teo:planar, y sabemos que toda cara tiene al menos 3 aristas en su borde. Para cada $i in NN$, $f_i$ el número de caras con exactamente $i$ aristas en $G$. Luego, la siguiente suma va a contar a cada arista dos veces (una vez en cada una de las dos caras que parte, o dos veces en la misma cara si la arista está enteramente en una cara):
  $
     2m = & 1 f_2 + 2 f_2 + 3 f_3 + dots \
        = & sum_(i in NN) i f_i \
        = & sum_(i in NN,\ i gt.eq 3) i f_i \
    gt.eq & sum_(i in NN) 3 f_i \
        = & 3 sum_(i in NN) f_i \
        = & 3r
  $

  Por el teorema de Euler, $n - m + r = 2$. Luego, $r = m - n + 2$, y luego $3r = 3m - 3n + 6$. Usando la desigualdad de arriba, $3m - 3n + 6 lt.eq 2m$. Simplificando, $m - 3n + 6 lt.eq 0$, y luego $m lt.eq 3n - 6$.
]

#ej[
  Sea $G$ un grafo conexo y planar, y sea $delta(G)$ el mínimo grado entre todos los vértices de $G$.

  Probar que $delta(G) lt.eq 5$.
]
#demo[
  Sea $G = (V, E)$ un grafo conexo y planar, con $n = |V|, m = |E|$, y $r$ caras.

  Si $n lt.eq 2$, la propiedad es obvia.

  Si $n gt.eq 3$, contemos:

  $
    2m = sum_(v in V) d_G (v) gt.eq 6n
  $

  La primera igualdad es porque en todo grafo tenemos $sum_(v in V) d_G (v) = 2m$, y la segunda es porque $d_G (v) gt.eq 6$ para todo $v in V$, por el enunciado.

  Por el ejercicio anterior, vemos que $m lt.eq 3n - 6$. Luego, $2m lt.eq 6n - 12$. Pero entonces tenemos $6n lt.eq 2m lt.eq 6n - 12$, que no tiene sentido.

  Luego no puede ser que todos los vértices tienen grado al menos $6$, y tiene que haber algún vértice con grado a lo sumo $5$.
]

#load-bib()