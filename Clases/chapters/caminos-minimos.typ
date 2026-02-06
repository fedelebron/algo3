
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Caminos mínimos
#ej[
  Tenemos un mapa con ciudades y rutas entre pares de ciudades. Para cada ruta $e$, tenemos un número $0 lt.eq p(e) < 1$ que nos indica la probabilidad de que nos caiga un rayo mientras estamos en esa ruta.

  Diseñar un algoritmo que, dado un tal mapa y dos ciudades $a$ y $b$, devuelva un camino entre $a$ y $b$, que minimice la probabilidad de que nos caiga un rayo.
]
#demo[
  Si tenemos dos eventos independientes, $x$ e $y$, entonces $P(x and y) = P(x) P(y)$. En general, si tenemos eventos disjuntos ${x_i}_(i in I)$, la probabilidad de que pasen todos es $product_(i in I) P(x_i)$.

  Consideremos ahora cualquier camino $P = [e_1, e_2, dots, e_k]$ desde $a$ hasta $b$. La probabilidad de que no nos caiga un rayo en ningún momento es la probabilidad de que no nos caiga un rayo mientras estamos en $e_1$, y que no nos caiga un rayo mientras estamos en $e_2$, etc. Luego, esta probabilidad es $X(P) = product_(e in P) (1 - p(e))$. Luego, si queremos maximizar la probabilidad de que no nos caiga un rayo, como la función logaritmo es monótona creciente, podemos maximizar $log X(P) = sum_(e in P) log (1 - p(e))$. Esto es lo mismo que minimizar $-log X(P) = -sum_(e in P) log (1 - p(e)) = sum_(e in P) -log (1 - p(e))$.

  Luego, podemos tomar cada probabilidad $p(e)$, y transformarla en una función de peso, $w$, con $w(e) = -log (1 - p(e))$. Como $0 lt.eq p(e) < 1$, entonces $1 gt.eq 1 - p(e) > 0$, y luego $0 lt.eq -log (1 - p(e)) < infinity$. Entonces vemos que $w: EE arrow RR_(gt.eq 0)$.


  Luego, consideramos el grafo pesado $G = (V, E, w)$, donde los vértices $V$ son las ciudades, las aristas $E$ son las rutas entre ciudades, y $w$ nos da el peso de cada camino. Como vimos, maximizar la probabilidad de que no nos caiga un rayo es lo mismo que encontrar un camino $P$ desde $a$ hasta $b$ que minimice $sum_(e in P) -log (1 - p(e))$. Si usamos $w$ como pesos en las aristas, esto es encontrar un camino de suma de pesos mínima entre todos los caminos entre $a$ y $b$. Para esto podemos usar el algoritmo de Dijkstra para caminos mínimos.

  ```py
  from math import log
  def F(Ciudades: set[int],
        Rutas: dict[int, list[int]],
        p: Callable[[int, int], float],
        a: int,
        b: int):
    def w(i, j):
      return - log(1.0 - p(i, j))
    G = (Ciudades, Rutas, w)
    return Dijkstra(G, a)[b]
  ```
]


#ej[
  Demostrar la correctitud del algoritmo de caminos mínimos de Dijkstra.
]<ej:dijkstra>
#quote-box[
  Este va a ser un ejemplo de una demostración con menos formalismo que el típico para algoritmos con ciclos (es decir, el teorema del invariante), pero el mismo rigor. Tenemos que tener cuidado cuando hacemos esto, porque arriesgamos caer en "porque el vértice que no era el último sino el anteúltimo que en la anterior iteración cambiamos al valor que el otro vértice tenía antes de ser agregado cuando sabíamos el valor de $d$ para todos los otros vértices", y demás oraciones incomprensibles.
]
#demo[
  Recordemos el algoritmo de Dijkstra para caminos mínimos.
  #algorithm({
    import algorithmic: *
    Procedure(
      "Dijkstra",
      ($G = (V, E)$, $s in V$, $w: E arrow RR_(gt.eq 0)$),
      {
        Assign[$Q$][$V$]
        Assign[$d[v]$][$infinity" " forall" "v in V without {s}$]
        Assign[$p[v]$][#smallcaps("null")$" "forall" "v in V$]
        Assign[$d[s]$][$0$]
        While($Q eq.not emptyset$, {
          Assign[$u$][$arg min_(u in Q) d[u]$]
          Assign[$Q$][$Q without {u}$]
          For($(u, v) in E$, {
            If($d[u] + w(u, v) < d[v]$, {
              Assign[$d[v]$][$d[u] + w(u, v)$]
              Assign[$p[v]$][$u$]
            })
          })
        })
        Return[$d, p$]
      },
    )
  })


  Vamos a demostrar y usar los dos invariantes del algoritmo.

  #lemma[En todo momento, para todo $v in V$, si $d[v] < infinity$, entonces $d[v]$ es la longitud de algún camino desde $s$ a $v$. En particular, $d[v] gt.eq delta(s, v)$, con $delta(x, y)$ la distancia en $G$ entre los vértices $x$ e $y$.

    Además, si $d[v] < infinity$ y $v eq.not s$, entonces $p[v]$ es un vértice inmediatamente anterior a $v$ en algún camino desde $s$ a $y$ con longitud $d[v]$. Si $d[v] = infinity$ o $v = s$, entonces $p[v] =$ #smallcaps("null").]<dijkstra:1>
  #demo[
    - Antes de comenzar el ciclo, $d[s] = 0$, y $d[v] = infinity$ para todo $v in V without {s}$. Como hay un camino de longitud $0$ de $s$ a $s$, y $delta(s, s) = 0$ al ser todas las aristas de peso positivo, $d[s] = delta(s, s)$. Para todos los otros vértices no hace falta probar nada sobre $d$ (pues el antecedente en "si $d[v] < infinity$, entonces $d[v]$ es la longitud de algún camino entre $s$ y $v$" es falso para ellos), probamos el caso base. Vemos también que $p[v] =$#smallcaps("null") para todo $v in V$, luego lo que dijimos sobre $p$ es correcto.
    - Ahora en cualquier iteración del ciclo, cuando asignamos $d[v] arrow.l d[u] + w(u, v)$, por hipótesis inductiva $d[u]$ es la longitud de algún camino $P$ desde $s$ hasta $u$. Luego, como hay una arista $(u, v) in E$, de peso $w(u, v)$, tenemos un camino $Q = P + [(u, v)]$ de costo $d[u] + w(u, v)$ desde $s$ hasta $v$, y luego $d[v]$ es la longitud de algún camino entre $s$ y $v$. Asimismo, este camino tiene a $u$ como antecesor directo de $v$ en este camino de longitud $d[v]$, y luego nuestra asignación de $p[v] arrow.l u$ es correcta.

    Como estas son las únicas dos formas de modificar $d$ y $p$, probamos que esto se cumple en cualquier iteración del algoritmo.
  ]

  #lemma[Cuando sacamos a $u$ de $Q$, $d[u] = delta(s, u)$.]<dijkstra:2>
  #demo[
    Vamos a probar esto por inducción en el número de iteraciones del ciclo. Sea $P(i)$: Al comenzar la $i$-ésima iteración del ciclo, tenemos $d[v] = delta(s, v)$ para todo $v in V without Q$.

    + $P(0)$. Al comenzar el ciclo, no hay nada que probar, pues $Q = V$, entonces no hay nadie en $V - Q$.
    + $P(1)$. El único vértice que sacamos de $Q$ en la primer iteración fue $s$, y luego al comenzar la segunda, $Q = V without {s}$. En este caso, $d[s] = 0$, y no lo modificamos porque en la primer iteración no vemos aristas $(s, s)$ ($G$ es un grafo, no multigrafo). Como $delta(s, s) = 0 = d[s]$, vale $P(1)$.
    + Paso inductivo. Sabemos $P(k)$ para todo $k lt.eq i$, queremos ver que vale $P(i+1)$. Sea $u$ el vértice que estamos sacando en la $i$-ésima iteración. Este es el vértice que, al sacar de $Q$ en la $i$-ésima iteración, estamos "agregando" a $V without Q$. Luego, como para todos los otros vértices $v$ en $V without Q$ sabemos que $d[v] = delta(s, v)$ por el @dijkstra:1, y no van a cambiar más porque en cada iteración sólo pueden decrecer, lo único que nos queda probar es que para $u$, también tenemos que $d[u] = delta(s, u)$.

      Si $d(s, u) = infinity$, es decir no hay ningún camino entre $s$ y $u$, terminamos, pues por el @dijkstra:1, sabemos que $d[u] = infinity$.

      De otra forma, consideremos un camino $P$ de longitud mínima desde $s$ hasta $u$. Sea $y$ el primer vértice en $P$ que está en $Q$, y sea $x$ su predecesor en $P$ (podríamos tener $y = u$, o $x = s$).


      #let curve_points = ((-2, -1), (-2, 0), (-0.5, 1), (0, 2), (4, 2), (3.5, 1), (2, 0), (1.5, -1), (0, -2))
      #align(center)[
        #scale(70%, reflow: true, diagram(
          {
            let blue_node(pos, content, name) = {
              let fill_color = rgb(78, 171, 233)
              let border_color = rgb(57, 130, 178)
              node(
                pos,
                text(content, fill: white, size: 15pt),
                stroke: 0.5pt + border_color,
                fill: fill_color,
                name: name,
              )
            }
            let yellow_node(pos, content, name) = {
              let fill_color = rgb(250, 229, 185)
              let border_color = rgb(230, 136, 60)
              node(
                pos,
                text(content, fill: black, size: 15pt),
                fill: fill_color,
                stroke: 0.5pt + border_color,
                name: name,
              )
            }
            blue_node((-1, -1), $s$, "s")
            blue_node((2.5, 2), $x$, "x")
            for pt in curve_points { node(pt, $$) }
            yellow_node((5, 1.5), $y$, "y")
            yellow_node((3, -1), $u$, "u")
            edge(label("x"), label("y"), stroke: 1pt, marks: "-}>")
            node((0, -1), text($V without Q$, size: 15pt))
          },
          render: (grid, nodes, edges, options) => {
            old_canvas({
              let cloud_border_color = rgb(78, 171, 233)
              let cloud_color = rgb(182, 223, 246)
              let nns = for pt in curve_points {
                fletcher.find-node-at(nodes, pt).pos.xyz
              }.chunks(2)
              old_draw.hobby(..nns, fill: cloud_color, stroke: cloud_border_color, close: true)
              fletcher.draw-diagram(grid, nodes, edges)
              let s = fletcher.find-node(nodes, label("s"))
              let x = fletcher.find-node(nodes, label("x"))
              let u = fletcher.find-node(nodes, label("u"))
              let y = fletcher.find-node(nodes, label("y"))
              fletcher.get-node-anchor(x, -180deg, px => {
                let cx = (to: px, rel: (180deg, 20mm))
                fletcher.get-node-anchor(s, -90deg, ps => {
                  let cs = (to: ps, rel: (-90deg, 10mm))
                  old_draw.hobby(ps, cs, (5, 1.7), cx, px, mark: (end: "stealth", fill: black))
                })
              })
              fletcher.get-node-anchor(u, -90deg, pu => {
                let cu = (to: pu, rel: (-90deg, 20mm))
                fletcher.get-node-anchor(y, 90deg, py => {
                  let cy = (to: py, rel: (-1300deg, 20mm))
                  old_draw.hobby(py, cy, (6, 2), cu, pu, mark: (end: "stealth", fill: black))
                })
              })
            })
          },
        ))]

      Como $y$ aparece no-después que $u$ en $P$, y $P$ es un camino mínimo con todas las aristas de peso no-negativo, tenemos que $delta(s, y) lt.eq delta(s, u)$. Como $u = arg min_(u in Q) d[u]$, y sabemos que $y in Q$, entonces $d[u] lt.eq d[y]$. Por el @dijkstra:1, sabemos que $delta(s, u) lt.eq d[u]$.

      Como $x in V without Q$, fue removido de $Q$ en alguna iteración $j lt.eq i$. Podemos usar $P(j)$, entonces, para ver que $d[x] = delta(s, x)$ al removerlo. Durante la iteración $j$, nos aseguramos que $d[y] lt.eq d[x] + w(x, y) = delta(s, x) + w(x, y)$. Como $s arrow.squiggly x -> y$ es parte de un camino mínimo $P$, entonces $s arrow.squiggly x -> y$ es también un camino mínimo, y entonces $delta(s, x) + w(x, y) = delta(s, y)$. Como $d[y] lt.eq delta(s, y)$, y por el @dijkstra:1 sabemos que $d[y] gt.eq delta(s, y)$, tenemos que $d[y] = delta(s, y)$ al final de la iteración $j$, y luego por el @dijkstra:1, sigue valiendo en la iteración $i + 1$.

      Luego sabemos que $delta(s, y) lt.eq delta(s, u) lt.eq d[u] lt.eq d[y]$, y $d[y] = delta(s, y)$. Luego, $delta(s, y) = delta(s, u) = d[u] = d[y]$. Luego $d[u] = delta(s, u)$ al terminar la iteración $i$, es decir, vale también al comenzar la iteración $i + 1$, y luego vale $P(i + 1)$.
  ]

  Como el algoritmo termina cuando $Q = emptyset$, y empieza con $Q = V$, habremos al final sacado de $Q$ todos los vértices $v in V$. Por el @dijkstra:2, Al momento de sacar cada $v in V$ de $Q$, tendremos $d[v] = delta(s, v)$, y luego $d[v]$ es la longitud de un camino mínimo entre $s$ y $v$. Por el @dijkstra:1, como cada vez que actualizamos $d[v]$ sólo lo hacemos decrecer, y siempre es la longitud de un camino entre $s$ y $v$, nunca puede ser actualizado a algo menor a $delta(s, v)$. Vemos entonces que luego de sacar a $v$ de $Q$, $d[v]$ nunca más se actualiza, y permanece en $delta(s, v)$.

  Luego, al terminar el algoritmo, tenemos $d[v]$ para todo $v in V$, y es igual a $delta(s, v)$. Más aún, para todo $v in V$, $p[v]$ es o bien #smallcaps("null") (cuando $s = v$, o cuando $d[v] = infinity$), o es el antecesor directo de $v$ en algún camino mínimo desde $s$ hasta $v$.]

#ej[
  Sea $G = (V, E)$ un grafo dirigido pesado con pesos positivos, y $s, t in V$. Queremos encontrar el camino de menor peso entre $s$ y $t$. De todos los caminos con menor peso, queremos el que menos aristas tenga.

  Dar un algoritmo que devuelva un tal camino. Demostrar que es correcto.
]
#demo[
  Para entender cómo resolver este ejercicio es crucial ver la demostración de por qué funciona el algoritmo de Dijkstra, que damos en el @ej:dijkstra.

  El invariante que mantiene el algoritmo de Dijkstra es que para todos los vértices que sacamos de la cola $Q$, sabemos exactamente su distancia desde $s$, el vértice inicial. Mantenemos este invariante removiendo de $Q$ el vértice $u$ con menor distancia estimada $d[u]$, y actualizando el estimado de las distancias para todos vecinos $v$ de $u$ ($d[v] arrow.l min(d[v], d[u] + w(u, v))$).

  Si queremos comparar dos cosas, en orden, la estructura típica para esto son los pares, con su orden lexicográfico. En este caso, si queremos comparar primero por distancia (suma de pesos), y habiendo empates, por número de aristas, podemos definir:
  - $delta(s, v)$ como la suma de los pesos en un camino de mínima distancia desde $s$ hasta $v$,
  - $kappa(s, v)$ como el mínimo número de aristas entre todos los caminos de mínima distancia entre $s$ y $v$,
  - $epsilon(s, v) = (delta(s, v), kappa(s, v))$

  Vemos que $epsilon$ se comporta de manera similar a $delta$. Si tenemos un camino de mínima distancia y mínimo número de aristas entre todos los caminos mínimos $P = [s, dots, x, y]$, entre $s$ y $y$, entonces no solo $delta(s, y) = delta(s, x) + w(x, y)$ (que usamos en la demostración del algoritmo de Dijkstra), sino que $epsilon(s, y) = epsilon(s, x) + (w(x, y), 1)$, donde definimos la suma componente-a-componente.

  Veamos si podemos adaptar el algoritmo original a esta nueva noción de "distancia".

  #note-box[
    Como estamos cambiando el algoritmo, tenemos que demostrar que este nuevo algoritmo es correcto con respecto a la nueva especificación que estamos pidiendo. No podemos usar la demostración de un algoritmo distinto, y sólo decir que "sigue valiendo", primero porque no lo demostramos (y en general es muy difícil decir que "siguen valiendo" absolutamente todas las deducciones que se hicieron en otra demostración), y segundo porque el anterior algoritmo cumple un objetivo _distinto_ al nuevo.

    Tenemos que ir oración por oración de la demostración anterior, ver qué sigue valiendo, y qué no y hay que cambiar y probar. En particular, vamos a necesitar un nuevo lema acá, el @dijkstra2:0.]

  #algorithm({
    import algorithmic: *
    Procedure(
      "Dijkstra",
      ($G = (V, E)$, $s in V$, $w: E arrow RR_(gt.eq 0)$),
      {
        Assign[$Q$][$V$]
        Assign[$d[v]$][$(infinity, infinity)" " forall" "v in V without {s}$]
        Assign[$p[v]$][#smallcaps("null")$" "forall" "v in V$]
        Assign[$d[s]$][$(0, 0)$]
        While($Q eq.not emptyset$, {
          Assign[$u$][$arg min_(u in Q) d[u]$]
          Assign[$Q$][$Q without {u}$]
          For($(u, v) in E$, {
            If($d[u] + (w(u, v), 1) < d[v]$, {
              Assign[$d[v]$][$d[u] + (w(u, v), 1)$]
              Assign[$p[v]$][$u$]
            })
          })
        })
        Return[$d, p$]
      },
    )
  })

  #defi[
    Llamamos a un camino $[s, dots, u]$ *$epsilon$-óptimo* cuando tiene longitud mínima entre todos los caminos desde $s$ hasta $u$, y dentro de todos esos caminos de longitud mínima, tiene el mínimo número de aristas.]
  #lemma(title: [Subestructura óptima de caminos $epsilon$-óptimos])[
    Sea $P = [s, dots, x, y]$ un camino $epsilon$-óptimo, y sea $Q = [s, dots, x]$ su prefijo. Entonces $Q$ es $epsilon$-óptimo.

    En particular, $epsilon(s, x) lt.eq epsilon(s, y)$.
  ]<dijkstra2:0>
  #demo[
    Vamos a probar esto por inducción. Por conveniencia notamos $w(X) = sum_(e in X) w(e)$, para cualquier camino $X$.

    Como $P$ es $epsilon$-óptimo, entonces tiene mínina distancia hasta $y$, y luego $w(P) = delta(s, y)$. Asimismo, vemos que $w(P) = w(Q) + w(x, y)$. Como $Q$ es un camino desde $s$ hasta $x$, y $delta(s, x)$ es la mínima distancia desde $s$ hasta $x$, entonces $w(Q) gt.eq delta(s, x)$.

    Si $w(Q) > delta(s, x)$, podemos tomar cualquier camino mínimo $Q'$ entre $s$ y $x$, con $w(Q') = delta(s, x)$. Entonces, $Q' + (x, y)$ es un camino entre $s$ e $y$, con distancia $w(Q') + w(x, y) < w(Q) + w(x, y) = w(P)$, pero $P$ era de mínima distancia entre $s$ e $y$, entonces $Q'$ no puede existir. Luego, $w(Q) = delta(s, x)$.

    Como $Q$ es un camino de mínima longitud desde $s$ hasta $x$, y $kappa(s, x)$ es el mínimo número de aristas entre todos los caminos mínimos desde $s$ hasta $x$, entonces $|Q| gt.eq kappa(s, x)$, con $|Q|$ el número de aristas de $Q$. Si $|Q| > kappa(s, x)$, entonces sea $Q'$ cualquier camino de mínima longitud entre $s$ y $x$, y de entre ellos, uno de mínimo número de aristas (es decir, $kappa(s, x)$ aristas). Tenemos $w(Q') = w(Q)$, pues ambos son caminos mínimos entre $s$ y $x$. Luego $Q' + (x, y)$ es un camino de longitud $w(Q') + w(x, y) = w(Q) + w(x, y) = w(P)$, y número de aristas $|Q'| + 1 = kappa(s, x) + 1 < |Q| + 1 = |P|$. Pero $P$ era un camino $epsilon$-óptimo, entonces esto no puede pasar. Luego, $Q'$ no puede existir, y tenemos $|Q| = kappa(s, x)$. Luego, como $w(Q) = delta(s, x)$, y $|Q| = kappa(s, x)$, tenemos que $Q$ es $epsilon$-óptimo.
  ]

  #lemma[En todo momento, para todo $v in V$, si $d[v] = (a, b) < (infinity, infinity)$, entonces existe un camino entre $s$ y $v$, con longitud $a$, y $b$ aristas. En particular, $d[v] gt.eq epsilon(s, v)$.

    Además, si $d[v] eq.not (infinity, infinity)$ y $v eq.not s$, entonces $p[v]$ es un vértice inmediatamente anterior a $v$ en algún camino desde $s$ a $y$ con longitud $d[v][0]$ y número de aristas $d[v][1]$. Si $d[v] = (infinity, infinity)$ o $v = s$, entonces $p[v] =$ #smallcaps("null").]<dijkstra2:1>
  #demo[
    - Antes de comenzar el ciclo, $d[s] = (0, 0)$, y $d[v] = (infinity, infinity)$ para todo $v in V without {s}$. Como hay un camino de longitud $0$ de $s$ a $s$, y $delta(s, s) = 0$ al ser todas las aristas de peso positivo, $d[s] = (delta(s, s), kappa(s, s)) = epsilon(s, s)$. Para todos los otros vértices no hace falta probar nada sobre $d$ (pues el antecedente en "si $d[v] < (infinity, infinity)$, entonces $dots$" es falso para ellos). Vemos también que $p[v] =$#smallcaps("null") para todo $v in V$, luego lo que dijimos sobre $p$ es correcto.

    - Ahora en cualquier iteración del ciclo, cuando cambiamos $d[v] = d[u] + (w(u, v), 1)$, por hipótesis inductiva, notando $d[u] arrow.l (a, b)$, $a$ es la longitud de algún camino $P$ desde $s$ hasta $u$, y $b$ es el número de aristas de $P$. Luego, como hay una arista $(u, v) in E$, de peso $w(u, v)$, tenemos un camino $Q = P + [(u, v)]$ de costo $d[u] + w(u, v)$ desde $s$ hasta $v$, con $b + 1$ aristas. Luego, existe un camino $Q$ tal que $d[v] = (a', b')$, con $a'$ la longitud de $Q$, y $b'$ el número de aristas de $Q$. En $P$, el antecesor directo de $v$ es $u$, y luego nuestra asignación $p[v] arrow.l u$ es correcta.

    Como estas son las únicas dos formas de modificar $d$ y $p$, probamos que esto se cumple en cualquier iteración del algoritmo.
  ]

  #lemma[Cuando sacamos a $u$ de $Q$, $d[u] = epsilon(s, u)$.]<dijkstra2:2>
  #demo[
    Vamos a probar esto por inducción en el número de iteraciones del ciclo. Sea $P(i)$: Al comenzar la $i$-ésima iteración del ciclo, tenemos $d[v] = epsilon(s, v)$ para todo $v in V without Q$.

    + $P(0)$. Al comenzar el ciclo, no hay nada que probar, pues $Q = V$, entonces no hay nadie en $V - Q$.
    + $P(1)$. El único vértice que sacamos de $Q$ en la primer iteración fue $s$, y luego al comenzar la segunda, $Q = V without {s}$. En este caso, $d[s] = (0, 0)$, y no lo modificamos porque en la primer iteración no vemos aristas $(s, s)$ ($G$ es un grafo, no multigrafo). Como $delta(s, s) = 0$, y $kappa(s, s) = 0$, vale $P(1)$.
    + Paso inductivo. Sabemos $P(k)$ para todo $k lt.eq i$, queremos ver que vale $P(i+1)$. Sea $u$ el vértice que estamos sacando en la $i$-ésima iteración. Este es el vértice que, al sacar de $Q$ en la $i$-ésima iteración, estamos "agregando" a $V without Q$. Luego, como para todos los otros vértices $v$ en $V without Q$ sabemos que $d[v] = epsilon(s, v)$ por el @dijkstra2:1, y no van a cambiar más porque en cada iteración sólo pueden decrecer, lo único que nos queda probar es que para $u$, también tenemos que $d[u] = epsilon(s, u)$.

      Si $delta(s, u) = infinity$, es decir no hay ningún camino entre $s$ y $u$, usamos el contrarecíproco del @dijkstra2:1, y al no haber ningún camino, entonces $d[u] = (infinity, infinity)$.

      De otra forma, consideremos un camino $epsilon$-óptimo $P$ desde $s$ hasta $u$. Sea $y$ el primer vértice en $P$ que está en $Q$, y sea $x$ su predecesor en $P$ (podríamos tener $y = u$, o $x = s$).

      Como $P$ es $epsilon$-óptimo, por el @dijkstra2:0, $epsilon(s, y) lt.eq epsilon(s, u)$.
      Como $u = arg min_(u in Q) d[u]$, y sabemos que $y in Q$, entonces $d[u] lt.eq d[y]$. Por el @dijkstra2:1, sabemos que $epsilon(s, u) lt.eq d[u]$.

      Como $x in V without Q$, fue removido de $Q$ en alguna iteración $j lt.eq i$. Podemos usar $P(j)$, entonces, para ver que $d[x] = epsilon(s, x)$ al removerlo. Durante la iteración $j$, nos aseguramos que $d[y] lt.eq d[x] + (w(x, y), 1) = epsilon(s, x) + (w(x, y), 1)$. Por @dijkstra2:0, como $s arrow.squiggly x -> y$ es parte de un camino $epsilon$-óptimo $P$, entonces $s arrow.squiggly x -> y$ es también $epsilon$-óptimo, y entonces $epsilon(s, x) + (w(x, y), 1) = epsilon(s, y)$. Como $d[y] lt.eq epsilon(s, y)$, y por el @dijkstra2:1 sabemos que $d[y] gt.eq epsilon(s, y)$, tenemos que $d[y] = epsilon(s, y)$ al final de la iteración $j$, y luego por el @dijkstra2:1, sigue valiendo en la iteración $i + 1$.

      Luego sabemos que $epsilon(s, y) lt.eq epsilon(s, u) lt.eq d[u] lt.eq d[y]$, y $d[y] = epsilon(s, y)$. Luego, $epsilon(s, y) = epsilon(s, u) = d[u] = d[y]$. Luego $d[u] = epsilon(s, u)$ al terminar la iteración $i$, es decir, vale también al comenzar la iteración $i + 1$, y luego vale $P(i + 1)$.
  ]

  Como el algoritmo termina cuando $Q = emptyset$, y empieza con $Q = V$, habremos al final sacado de $Q$ todos los vértices $v in V$. Por el @dijkstra2:2, Al momento de sacar cada $v in V$ de $Q$, tendremos $d[v] = epsilon(s, v)$, y luego $d[v]$ es la longitud de un camino mínimo entre $s$ y $v$. Por el @dijkstra2:1, como cada vez que actualizamos $d[v]$ sólo lo hacemos decrecer, y siempre es un par con la longitud de un camino entre $s$ y $v$ y su número de aristas, nunca puede ser actualizado a algo menor a $epsilon(s, v)$. Vemos entonces que luego de sacar a $v$ de $Q$, $d[v]$ nunca más se actualiza, y permanece en $epsilon(s, v)$.

  Luego, al terminar el algoritmo, tenemos $d[v]$ para todo $v in V$, y es igual a $epsilon(s, v)$. Más aún, para cada $v in V$, $p[v]$ es o #smallcaps("null") cuando $v = s$ o $d[v] = (infinity, infinity)$, o el antecesor inmediato de $v$ en algún camino $epsilon$-óptimo desde $s$ hasta $v$.
]


#ej[
  Sea $G = (V, E)$ un grafo dirigido pesado por $w: E arrow RR_(>0)$, y $s in V$.

  Dar un algoritmo que calcule el número de caminos de mínimo peso entre $s$ y $v$, para cada $v in V$.
]
#demo[
  La idea de este algoritmo es primero encontrar el grafo dirigido acíclico $G'$ de caminos mínimos desde $s$. Luego, queremos encontrar el número de caminos en $G'$, desde $s$ hasta $v$, para cada $v$. Para la segunda parte, podemos usar un simple algoritmo de programación dinámica. Para la primer parte, tenemos dos opciones:
  - Podemos modificar el algoritmo de Dijkstra. Normalmente, el algoritmo devuelve un array $p$, donde $p[v]$ nos da un vértice inmediatamente anterior a $v$ en un camino mínimo desde $s$ hasta $v$. Podemos modificar esto para que $p[v]$ guarde un conjunto de _todos_ los vértices que están inmediatamente antes que $v$, en algún camino mínimo desde $s$ hasta $v$. La modificación sería que al iterar cada arista $(u, v) in E$, incidente al vértice $u$ que sacamos de $Q$, hacemos:
    #algorithm({
      import algorithmic: *
      IfElseChain(
        $d[v] < d[u] + w(u, v)$,
        {
          Assign[$d[v]$][$d[u] + w(u, v)$]
          Assign[$p[v]$][${u}$]
        },
        $d[v] = d[u] + w(u, v)$,
        {
          Assign[$p[v]$][$p[v] union {u}$]
        },
      )
    })

    Esta es una modificación útil, pero como vimos en el ejercicio anterior, tenemos que volver a demostrar que el algoritmo de Dijkstra con esta modificación es correcto con respecto a su nueva especificación, que va a hablar sobre _todos_ los posibles antecesores inmediatos de cada vértice $v$.

    Otra modificación que podríamos hacer es una que sólo cuente cuántos caminos hay:
    #algorithm({
      import algorithmic: *
      IfElseChain(
        $d[v] < d[u] + w(u, v)$,
        {
          Assign[$d[v]$][$d[u] + w(u, v)$]
          Assign[$p[v]$][$p[u]$]
        },
        $d[v] = d[u] + w(u, v)$,
        {
          Assign[$p[v]$][$p[v] + p[u]$]
        },
      )
    })
    donde $p[s] = 1$ es el valor inicial, y para todo otro vértice $v$, $p[v] = 0$ inicialmente.

    Esto requiere una demostración aún más extensa. Tendremos que argumentar que el conjunto de caminos desde $s$ hasta $v$, se particiona de forma disjunta en los caminos desde $s$ hasta $u$, y luego la arista $(u, v)$, para todos los vértices $u$ tal que $delta(s, v) = delta(s, u) + w(u, v)$.

  - Podemos usar el algoritmo de Dijkstra canónico. Luego, podemos reconstruir $G'$, usando sólo $d$, el array de distancias que devuelve el algoritmo de Dijkstra. Hay que escribir más código para esto, pero el código cuya correctitud debemos demostrar es simple y corto.

  Como usamos el primer método en el ejercicio anterior, en este vamos a usar el segundo.

  El algoritmo que vamos a usar es el siguiente:

  ```python
  from collections import defaultdict
  def F(G, w, s):
    d, _ = Dijkstra(G, w, s)
    (V, E) = G
    preds = defaultdict(list)
    for (u, v) in E:
      if d[v] == d[u] + w(u, v):
        preds[v].append(u)

    n = len(V)
    x = [-1 for _ in range(n)]
    x[s] = 1
    def rec(v):
      if x[v] == -1:
        x[v] = sum(rec(u) for u in preds[v])
      return x[v]

    for v in range(n): rec(v)
    return x
  ```

  Demostremos que este algoritmo es correcto. La función `rec` es meramente usar programación dinámica top-down, en la siguiente función recursiva:

  $
    f(v) = cases(
      1 & "si" v = s,
      display(sum_((u, v) in E,\ d[v] = d[u] + w(u, v)) f(u)) & "si no"
    )
  $

  Y al correr `f(v)` para todo `i in range(n)`, estamos asegurándonos de llenar el cache `x` para todos los vértices, con lo cual devolvemos un array cuya $i$-ésima coordenada contiene $f(i)$. La semántica que le asignamos a la función $f$ es que *$f(i)$ devuelve el número de caminos mínimos desde $s$ hasta $i$*.


  #warning-box[
    #let t = [Recordemos que no tiene sentido probar que una función "es correcta" sin decir cuál es su semántica. Una función que siempre devuelve el string `"banana"` es correcta si nuestra semántica es "una función que siempre devuelve el string `"banana"`".

      *Siempre* que vamos a probar que una función es correcta, *tenemos* que definir cuál es su semántica. Por esto ven especificación antes de correctitud formal de algoritmos.]
    #let img = image("/images/proof_banana.png", width: 90%)
    #wrap-content(img, t, align: right)
  ]


  Probemos que $f$ es correcta con respecto a esa semántica. Como es una función recursiva, vamos a usar inducción. ¿En qué vamos a hacer inducción? En lo que está decreciendo en cada llamada: El máximo número de aristas en un camino mínimo entre $s$ y $v$. Por comodidad, llamemos $C(v)$ al conjunto de caminos mínimos entre $s$ hasta $v$, y llamemos $M(v) = max_(P in C(v)) {|P|}$, el máximo número de aristas en cualquier camino mínimo desde $s$ hasta $v$.

  Sea $P(i)$: Para todo $v in V$, tal que $M(v) = i$, $f(v) = |C(v)|$.

  + Caso base, $i = 0$. Si $v$ es un vértice tal que $M(v) = 0$, entonces hay un camino de longitud $0$ desde $s$ hasta $v$. Luego, $v$ _es_ $s$. Como hay un único camino desde $s$ hasta $s$, vemos que $|C(s)| = |{[]}| = 1$. Como $f$ precisamente devuelve $1$, $f$ es correcta para este caso.
  + Paso inductivo. Sea $i > 0 in NN$. Podemos asumir $P(k)$ para todo $k < i$, y queremos ver $P(i)$. Sea $v in V$ tal que $M(v) = i$. Como $M(v) = i > 0$, sabemos que $v eq.not s$, pues $M(s) = 0$. Luego, todo camino mínimo $Q$ desde $s$ hasta $v$, pasa por algún vértice $u$ anterior a $v$. Notar que $u$ puede ser $s$ mismo, si hay un camino mínimo desde $s$ hasta $v$ que es puramente $[(s, v)]$. También, como los caminos mínimos tienen subestructura óptima, el prefijo de $Q$ tiene que ser un camino mínimo desde $s$ hasta ese vértice $u$. Notemos que tendremos $delta(s, u) + w(u, v) = delta(s, v)$, por definición de $delta$ y que $Q$ y su prefijo hasta $u$ son caminos mínimos. Finalmente, por la postcondición del algoritmo de Dijkstra, sabemos que $d[v] = delta(s, v)$ para todo $v in V$.

  $
    C(v) & = {Q | Q in C(v)} \
         & = {Q' + [(u, v)] | u in V, Q' in C(u), Q' + [(u, v)] in C(v)} \
         & = {Q' + [(u, v)] | u in V, Q' in C(u), delta(s, u) + w(u, v) = delta(s, v)} \
         & = {Q' + [(u, v)] | u in V, Q' in C(u), d[u] + w(u, v) = d[v]}
  $

  Luego,

  $
    |C(v)| & = |{Q' + [(u, v)] | u in V, Q' in C(u), d[u] + w(u, v) = d[v]}| \
           & = sum_(u in V\ Q' in C(u)\ d[u] + w(u, v) = d[v]) 1 \
           & = sum_(u in V\ d[u] + w(u, v) = d[v]) |C(u)|
  $

  Si probamos que $M(u) < M(v)$ para todo $u$ en esa sumatoria, probamos que $f$ es correcta, porque podemos usar la hipótesis inductiva $P(M(u))$ para saber que $f(u) = |C(u)|$, y llegar a

  $
    |C(v)| = sum_(u in V\ d[u] + w(u, v) = d[v]) f(u)
  $

  que probaría $P(i)$, pues el lado derecho es la definición exacta de $f$, y estaríamos probando $|C(v)| = f(v)$. Sea $u in V$ tal que $d[u] + w(u, v) = d[v]$, y tomemos un camino $Q$ de máximo número de aristas en $C(u)$. Por cómo definimos $M(u)$, tenemos que $M(u) = |Q|$. Vemos que $Q' = Q + [(u, v)]$ es un camino en $C(v)$, y que $|Q'| = |Q| + 1$. Como $M(v) = max_(R in C(v)) {|R|}$, y $Q'$ es un tal $R$, tenemos que $M(v) gt.eq |Q'| = |Q| + 1 > M(u)$. Luego $M(u) < M(v)$, y entonces podemos usar la hipótesis inductiva, $P(M(u))$, que nos deja concluir que $f$ es correcta.]

#ej[
  Sea $G = (V, E)$ un grafo dirigido pesado, y $s in V$.

  Queremos encontrar el camino más ligero entre $s$ y cada $v in$V. Dar una modificación del algoritmo de Bellman-Ford tal que:
  - Si $G$ no tiene ciclos de peso negativo alcanzables desde $s$, devuelve la distancia entre $s$ y $v$, para todo $v in V$.
  - Si $G$ tiene un ciclo de peso negativo alcanzable desde $s$, devuelve un tal ciclo.

  Demostrar que es correcto. El algoritmo debería seguir haciendo $O(|V| |E|)$ operaciones en el peor caso.
]
#demo[
  Recordemos el invariante del algoritmo de Bellman-Ford para caminos mínimos en grafos pesados.

  #algorithm({
    import algorithmic: *
    Procedure(
      "Bellman-Ford",
      ($G = (V, E)$, $s in V$, $w: E arrow RR$),
      {
        Assign[$d[v]$][$infinity$ $forall" " v in V$]
        Assign[$d[s]$][$0$]
        Assign[$p[v]$][#smallcaps("null") $forall" " v in V$]
        For([$i = 1$ to $|V| - 1$], {
          For($(u, v) in E$, {
            If($d[v] gt d[u] + w(u, v)$, {
              Assign[$d[v]$][$d[u] + w(u, v)$]
              Assign[$p[v]$][$u$]
            })
          })
        })
        Return($d, p$)
      },
    )
  })

  El invariante de este algoritmo es que al terminar la $i$-ésima iteración del ciclo externo, para todo $v in V$, $d[v]$ es la distancia mínima desde $s$ hasta $v$ usando sólo caminos de a lo sumo $i$ aristas. Luego, al terminar el algoritmo, tenemos que $d[v]$ es la distancia mínima desde $s$ hasta $v$, usando a lo sumo $|V| - 1$ aristas, para todo $v in V$.

  Si no hay ciclos de peso negativo alcanzables desde $s$, entonces la distancia "usando a lo sumo $|V| - 1$ aristas" es lo mismo que la distancia, dado que si nuestro camino tiene más de $|V| - 1$ aristas, tiene algún ciclo, que si fuera de peso no-negativo podríamos simplemente remover, y no-empeorar la distancia.

  Si hay ciclos de peso negativo alcanzables desde $s$, entonces las distancias hacia algunos vértices no están bien definidas.

  #lemma[
    Hay un ciclo negativo alcanzable desde $s$ si y sólo si al hacer una iteración más del ciclo externo, en algún momento cambiamos $d$.
  ]
  #demo[
    - $arrow.double.l$) Sea $n = |V|$. Por el invariante del algoritmo, al terminar la $n-1$-ésima iteración, tenemos en $d[v]$ las distancias desde $s$ hasta $v$, usando a lo sumo $n - 1$ aristas. Si hacemos una iteración más, y cambiamos $d[v]$, entonces ocurrió que $d[v] > d[u] + w(u, v)$ para algún $u$ tal que $(u, v) in E$. Por el invariante del algoritmo, sabemos que $d[v]$ es la distancia mínima desde $s$ hasta $u$, usando a lo sumo $n - 1$ aristas. Luego, si $d[v] > d[u] + w(u, v)$, entonces el mejor camino desde $s$ hasta $v$ usando $n - 1$ aristas es más pesado que un camino que va hasta $u$ usando a lo sumo $n - 1$ aristas, y luego usa la arista $(u, v)$. Este camino necesariamente debe tener más de $n - 1$ aristas, pues por inducción $d[v]$ ya tiene la menor distancia entre todos los caminos que usan a lo sumo $n - 1$ aristas.

      Un camino $P$ de más de $n - 1$ aristas debe tener algún ciclo $C$. Si ese ciclo fuese de peso no-negativo, podríamos removerlo, y obtener $P - C$, que sigue empezando en $s$, terminando en $v$, y tiene peso igual a $P$, es decir $d[u] + w(u, v)$. Pero entonces $P - C$ es un camino de a lo sumo $n - 1$ aristas, y tiene peso $d[u] + w(u, v) < d[v]$, lo cual no puede pasar porque $d[v]$ era la mínima distancia entre $s$ y $v$ usando caminos de a lo sumo $n - 1$ aristas.

      Luego $P$ debe tener algún ciclo de peso negativo, y como $P$ empieza en $s$ y termina en $v$, entonces $v$ es alcanzable desde $s$ por un ciclo $C$ de peso negativo.

    - $arrow.double.r$) Sea $C = [v_0, dots, v_k = v_0]$ un ciclo de peso negativo alcanzable desde $s$. Luego, $sum_(i = 1)^k w(v_(i-1), v_i) < 0$. Supongamos que no actualizamos ningún $d$ en la $n$-ésima iteración. Entonces, en esa iteración tenemos que $d[v_i] <= d[v_(i-1)] + w(v_(i-1), v_i)$ para todo $1 lt.eq i lt.eq k$. Sumando todas estas desigualdades, tenemos

      $
        sum_(i=1)^k d[v_i] & lt.eq sum_(i=1)^k d[v_(i-1)] + sum_(i=1)^k w(v_(i-1), v_i)
      $

      Vemos también que como $v_0 = v_k$, la suma $sum_(i=1)^k d[v_i]$ es igual a la suma $sum_(i=1)^k d[v_(i-1)]$, y en ambas aparecen todos los vértices de $C$ una sola vez. Luego, restando esta suma de cada lado, obtenemos

      $
        0 & lt.eq sum_(i=1)^k w(v_(i-1), v_i)
      $

      Pero esto no puede pasar, pues sabemos que $C$ tiene peso negativo. Luego, en la $n$-ésima iteración, tuvimos que haber actualizado $d[v]$ para algún $v in C$.
  ]

  Esto nos dice que para saber si hay algún ciclo de peso negativo alcanzable desde $s$, podemos hacer una iteración más del ciclo externo, y si en algún momento cambiamos $d[v]$, entonces $v$ es alcanzable desde $s$ por un ciclo de peso negativo. Si no cambiamos nada, entonces no hay ciclos de peso negativo alcanzables desde $s$. Más aún, si ese ciclo de peso negativo $C$ existe, entonces debemos actualizar $d[v]$ en la $n$-ésima iteración para algún $v in C$.

  Notemos que no necesariamente vamos a cambiar _sólo_ los $d[v]$ donde $v in C$. Como recorremos $e in E$ en algún orden, puede ser que primero actualizamos $d[v]$ para algún $v in C$, y luego actualizamos $d[u]$ para algún $u$ alcanzable desde $v$. Lo que vamos a saber es que si actualizamos $d[u]$, entonces $u$ es alcanzable desde algún ciclo negativo, que a su vez es alcanzable desde $s$.

  #align(center)[
    #diagram({
      let wavy(src, dst, ..style) = {
        edge(
          label(src),
          label(dst),
          "-",
          dash: "dotted",
          stroke: 1pt,
          decorations: old_decorations.wave.with(amplitude: 0.3, segments: 5),
          ..style,
        )
      }

      node((0, 0), $s$, name: "s", radius: 10pt, stroke: 1pt)
      node((4, 0), name: "v", radius: 10pt, stroke: 1pt)
      node((5.5, 0.5), $v$, name: "v2", radius: 10pt, stroke: 1pt)
      node((8, 1), $u$, name: "u", radius: 10pt, stroke: 1pt)
      node((4.75, 0.25), text(fill: red)[$C$], stroke: 0pt)

      wavy("v", "v2", bend: -90deg, stroke: 1pt + red)
      wavy("v2", "v", bend: -90deg, stroke: 1pt + red)
      wavy("s", "v")
      wavy("v2", "u")
    })]

  Luego, si actualizamos $d[u]$ en la $n$-ésima iteración, podemos seguir la cadena de padres, $p$, y vamos a llegar hasta algún vértice (en este caso $v$) que pertenece a $C$.

  Cuando actualizamos $d[v]$ en la última iteración, como el mejor camino desde $s$ hasta $v$ ahora tiene un ciclo (pues tiene más de $n-1$ aristas), si seguimos la cadena de padres $p$, vamos a encontrar que $v arrow.squiggly v$, pues el mejor camino usa un ciclo que involucra a $v$. Luego, podemos retroceder $n$ pasos usando $p$, y vamos a caer en $C$, porque la distancia entre $v$ y $u$ es a lo sumo $n - 1$ aristas, y luego siguiendo $p[u]$, $p[p[u]]$, $dots$, vamos a llegar a $v$. Una vez que llegamos a $v$, vamos a pasar por $C$ una y otra vez si seguimos siguiendo $p$.

  Luego, para recuperar un ciclo de peso negativo alcanzable desde $s$, podemos usar el siguiente algoritmo:

  #algorithm({
    import algorithmic: *
    Procedure(
      "Bellman-Ford-Negative-Cycle",
      ($G = (V, E)$, $s in V$, $w: E arrow RR$),
      {
        Assign[$d[v]$][$infinity$ $forall" " v in V$]
        Assign[$d[s]$][$0$]
        Assign[$p[v]$][#smallcaps("null") $forall" " v in V$]
        For([$i = 1$ to $|V| - 1$], {
          For($(u, v) in E$, {
            If($d[v] gt d[u] + w(u, v)$, {
              Assign[$d[v]$][$d[u] + w(u, v)$]
              Assign[$p[v]$][$u$]
            })
          })
        })
        Assign[$z$][#smallcaps("null")]
        For($(u, v) in E$, {
          If($d[v] gt d[u] + w(u, v)$, {
            Assign[$z$][$v$]
          })
        })
        If([$z eq$ #smallcaps("null")], {
          Return($d, p$)
        })
        For([$i = 1$ to $|V|$], {
          Assign[$z$][$p[z]$]
        })
        Assign[$z_0$][$z$]
        Assign[$C$][$[z_0]$]
        While($p[z] eq.not z_0$, {
          Assign[$z$][$p[z]$]
          Assign[$C$][$C + [z]$]
        })
        Return[$C$]
      },
    )
  })
]

#ej[
  Es nuestro primer día trabajando en un banco, en el departamento de comercio internacional. Sabemos que hay $n$ monedas en el mundo, y tenemos una tabla $Q in RR^(n times n)$, que nos dice que si tenemos 1 unidad de la moneda $i$, se puede intercambiar por $0 < Q_(i, j)$ unidades de la moneda $j$.

  Queremos saber si existe una secuencia $S = (s_1, s_2, dots, s_k)$ de intercambios de monedas que podemos hacer, tal que al intercambiar una moneda $s_1$ por la moneda $s_2$, y luego $s_2$ por $s_3, dots,$ y luego $s_k$ por $s_1$, terminamos con más dinero que con el que empezamos.

  Dar un algoritmo que determine si es posible hacer esto. El algoritmo debería tardar tiempo $O(n^3)$ en el peor caso. Demostrar que es correcto.
]
#sol[
  Podemos construir un grafo dirigido pesado $G = (V, E)$, donde $V = {1, dots, n}$ son las monedas, hay una arista entre todo par de vértices, y el peso de la arista $(v_i, v_j)$ es $w(v_i, v_j) = -log Q_(i, j)$.

  Si conseguimos un ciclo de peso negativo en $G$, entonces sabremos que existe una cadena de transacciones que podemos hacer, yendo de la moneda $a_1$ a $a_2$, dots, $a_k$, y finalmente a $a_1$, tal que:

  $
              w(a_k, a_1) + sum_(i = 1)^(k - 1) w(a_i, a_(i+1)) & < 0 \
    log Q_(a_k, a_1) + sum_(i = 1)^(k - 1) log Q_(a_i, a_(i+1)) & > 0 \
    Q_(a_k, a_1) times product_(i = 1)^(k - 1) Q_(a_i, a_(i+1)) & > 1 \
  $

  que es precisamente lo que significa obtener más dinero que con el que empezamos.

  Podemos transformar $A$ en $B$, con $B_(i, j) = -log A_(i, j)$, y luego usar el algoritmo de Floyd-Warshall en $B$. Luego, si $B_(i, i) < 0$ para algún $i$, entonces existe un ciclo de peso negativo (que incluye a $v_i$). Como vimos arriba, la existencia este ciclo implica que existe una manera de intercambiar monedas que nos deja con más dinero del que empezamos.
]

#ej[
  Sea $G = (V, E)$ un grafo dirigido pesado, con $V = {v_1, dots, v_n}$, y sin ciclos de peso negativo. Se tiene una matriz $A in RR^(n times n)$, donde $A_(i, j)$ es la distancia entre $v_i$ y $v_j$ en $G$.

  Se agrega un vértice $v_(n+1)$ a $G$, con algunas aristas, obteniendo $G'$, con $n + 1$ vértices.

  Dar un algoritmo que calcule las distancias entre *todo* par de vértices en $G'$. El algoritmo debe hacer $O(n^2)$ operaciones en el peor caso. Demostrar que es correcto.
]
#sol[
  Vamos a construir una matriz $B in RR^((n + 1) times (n + 1))$, donde $B_(i, j)$ es la distancia entre $v_i$ y $v_j$ en $G'$. Realizamos el siguiente procedimiento:

  #algorithm({
    import algorithmic: *
    Procedure(
      "Add-Vertex",
      ($A in RR^(n times n)$, $w: E arrow RR$),
      {
        Assign[$B in RR^((n + 1) times (n + 1))$][$#smallcaps("null")$]
        // k - 1 in the paper is n here
        // so k = n + 1
        For([$l = 1$ to $n$], {
          Assign[$B_(n + 1, l)$][$min_(1 lt.eq j lt.eq n) w(n + 1, j) + A_(j, l)$]
          Assign[$B_(l, n + 1)$][$min_(1 lt.eq j lt.eq n) w(j, n + 1) + A_(l, j)$]
        })
        Assign[$B_(n + 1, n + 1)$][$min_(1 lt.eq j lt.eq n) B_(n + 1, j) + B_(j, n + 1)$]
        For([$i = 1$ to $n$], {
          For([$j = 1$ to $n$], {
            Assign[$B_(i, j)$][$min(A_(i, j), B_(i, n + 1) + B_(n + 1, j))$]
          })
        })
        Return($B$)
      },
    )
  })
  #demo[
    Queremos demostrar que el algoritmo correctamente computa las distancias entre todo par de vértices en $G'$. Inicialmente, sabemos que $A$ contiene las mínimas distancias entre todo par de vértices en $G$.

    Veamos por qué cada una de las partes del algoritmo es correcto.

    + El camino más corto para ir desde $v_(n+1)$ hasta $v_l$, para cada $1 lt.eq l lt.eq n$, empieza con alguna arista $(v_(n+1), v_j)$, con $1 lt.eq j lt.eq n$, y luego va desde $v_j$ hasta $v_l$ usando el camino más corto en $G$ (es decir, sin volver a pasar por $v_(n+1)$, pues $v_(n+1)$ no está en $G$, sino en $G'$). Por eso es correcto asignar a $B_(n+1, l)$ el valor $min_(1 lt.eq j lt.eq n) w(n + 1, j) + A_(j, l)$, dado que $A$ contiene las distancias en $G$.
    + Algo análogo sucede con $B_(l, n + 1)$.
    + La mejor forma de ir desde $v_(n+1)$ hasta $v_(n+1)$ es ir desde $v_(n+1)$ hasta algún vértice $v_j$ con $1 lt.eq j lt.eq n$, usando el camino más corto en $G$, y luego volver a $v_(n+1)$, usando el camino más corto en $G$. Por eso es correcto asignar a $B_(n + 1, n + 1)$ el valor $min_(1 lt.eq j lt.eq n) B_(n + 1, j) + B_(j, n + 1)$.
    + La mejor forma de ir desde $v_i$ hasta $v_j$, con $1 lt.eq i, j lt.eq n$, puede o usar o no usar $v_k$. Si no lo usa, entonces es simplemente $A_(i, j)$. Si lo usa, entonces va desde $v_i$ hasta $v_k$, usando el camino más corto en $G$, y luego desde $v_k$ hasta $v_j$, también usando el camino más corto en $G$. Luego, la mejor forma de ir desde $v_i$ hasta $v_j$ es $min(A_(i, j), B_(i, n + 1) + B_(n + 1, j))$, que es lo que asignamos a $B_(i, j)$.

    Este algoritmo inmediatamente nos da un algoritmo para distancias mínimas entre todo par de vértices en un grafo. Empezamos con un subgrafo generador por el primer vértice, y una matriz trivial de distancias (un único escalar, $0$). Luego, $n - 1$ veces agregamos un vértice más, con las aristas que corresponde.

    Nuestro algoritmo usa $O(n^2)$ operaciones en todos los casos, al ser una simple composición de ciclos. Luego, el algoritmo general para caminos mínimos entre todo par de vértices, que hace #smallcaps("Add-Vertex") $n - 1$ veces, va a usar $O(n^3)$ operaciones en el peor caso. Este algoritmo se conoce como el algoritmo de Dantzig@dantzig.
  ]
]

#load-bib()