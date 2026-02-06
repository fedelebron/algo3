
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Circuitos y caminos
#defi[
  Sea $G$ un grafo. Un camino en $G$ se dice *camino euleriano* cuando pasa por todas las aristas de $G$ exactamente una vez.

  Un ciclo de $G$ se dice *ciclo euleriano* cuando pasa por todas las aristas de $G$ exactamente una vez.

  Si $G$ tiene un ciclo euleriano, se dice que *$G$ es euleriano*.]
#defi[
  Sea $G$ un grafo. Un camino en $G$ se dice *camino Hamiltoniano* cuando pasa por todos los vértices exactamente una vez.

  Un ciclo de $G$ se dice *ciclo Hamiltiniano* cuando pasa por todos los vértices exactamente una vez.

  Si $G$ tiene un ciclo Hamiltoniano, entonces se dice que *$G$ es Hamiltoniano*
]
#ej[
  Sea $G$ un grafo conexo, y sean $P$ y $Q$ dos caminos de longitud máxima en $G$. Probar que $P$ y $Q$ comparten al menos un vértice.
]
#demo[
  Por contradicción, asumamos que no. Luego, $P = [p_1, dots, p_k]$ y $Q = [q_1, dots, q_k]$ no comparten vértices. Notar que como ambos tienen longitud máxima, ambos tienen que tener la misma longitud, que llamamos $k$.


  Como $G$ es conexo, existen vértices $p_i$ y $q_j$, tal que hay un camino $R$ entre $p_i$ y $q_j$. Sin pérdida de generalidad, podemos asumir que $R$ no tiene vértices en $P$ ni en $Q$, salvo $p_i$ y $q_j$ (siempre podemos quedarnos con el sub-camino de $R$ que cruce los caminos, sin tocar a nadie de $P$ ni $Q$ en el medio).

  #let vi(pos, label, idx) = {
    node(pos, label, name: str(idx))
  }
  #let ei(x, y, ..attrs) = {
    edge(label(str(x)), label(str(y)), ..attrs)
  }
  #align(center)[
    #diagram({
      vi((0, 0), $p_1$, 1)
      vi((1, 0), $p_2$, 2)
      vi((2.5, 0), $$, 9)
      vi((4, 0), $p_i$, 3)
      vi((8, 0), $p_k$, 4)

      vi((0, 2), $q_1$, 5)
      vi((1, 2), $q_2$, 6)
      vi((4, 2), $q_j$, 7)
      vi((6, 2), $$, 10)
      vi((8, 2), $q_k$, 8)

      ei(1, 2)
      ei(2, 3, "--")
      ei(3, 4, "--")
      ei(5, 6)
      ei(6, 7, "--")
      ei(7, 8, "--")

      ei(3, 7, decorations: old_decorations.wave.with(segments: 1), text(red, $R$), label-angle: -30deg, stroke: red)
    })]

  Sin pérdida de generalidad, podemos asumir que $i gt.eq ceil(k/2)$. Si esto no sucediera, simplemente revertimos el orden de los vértices de $P$. Por el mismo motivo, podemos asumir que $j gt.eq ceil(k/2)$. Vemos que $|R| gt.eq 1$, pues si no, $P$ y $Q$ compartirían vértices.

  Considermos ahora el camino $alpha = [p_1, p_2, dots, p_i] + R + [q_j, dots, q_1]$. Este camino tiene longitud $|alpha| = i + |R| + j gt.eq 2 ceil(k/2) + |R| gt.eq k + |R| > k$. Esto no puede suceder, pues $P$ y $Q$ eran caminos de longitud máxima, $k$, y acabamos de encontrar un camino de longitud mayor a $k$.

  Luego no puede pasar que $P$ y $Q$ sean disjuntos, y tienen que compartir algún vértice.
]



#ej[
  Probar que si un grafo tiene algún vértice de grado impar, entonces no tiene un circuito euleriano.
]
#demo[
  Un ciclo euleriano usa cada arista exactamente una vez, y termina donde comienza. Cada vez que tomamos una arista $u arrow v$ en el camino, visitando a $v$, inmediatamente tomamos $v arrow w$, saliendo de $v$. Luego, cada vez que usamos una arista hacia $v$, usamos otra que sale desde $v$. Como las aristas incidentes a $v$ se usan siempre de a pares, y al terminar el ciclo todas las aristas son usadas exactamente una vez, si llamamos $f(v)$ al número de veces que $C$ visita $v$, tenemos $d_G (v) = 2 f(v)$. Luego, $d_G (v)$ es par, para todo $v in V$.]

#ej[
  Probar que si un grafo tiene un camino euleriano, entonces tiene exactamente dos vértices con grado impar.]
#demo[
  Sea $G = (V, E)$ un grafo, tal que más de dos vértices en $V$ tienen grado impar.

  Supongamos que $G$ tiene un camino euleriano, $P$, desde $u$ a $w$. Sea $v in V, v eq.not u, v eq.not w$. Si $v$ aparece $k$ veces en $P$, entonces como $P$ usa todas las aristas de $G$ exactamente una vez, y cada vez que $P$ pasa por $v$ toca dos de sus aristas incidentes, $v$ debe tener grado $2k$. En el caso de $u$ y $w$, la primera vez que $P$ visita a $u$, y la última vez que visita a $w$, $P$ sólo usa una de sus aristas incidentes.

  Luego los únicos dos vértices que tienen grado impar son $u$ y $w$, y todos los otros vértices tienen grado par. Notar que como $P$ es un camino euleriano, y no un ciclo, sabemos que $u$ y $w$ son distintos.
]

#ej[
  Sea $G = (V, E)$ un grafo dirigido, tal que para todo par de vértices $u, v in V$, exactamente uno de $(u, v)$ o $(v, u)$ está en $E$.

  Probar que $G$ contiene un camino Hamiltoniano.
]
#demo[
  Vamos a probar esto por inducción. Por comodidad, defino $Q(G = (V, E)): forall u, v in V. ((u, v) in E) eq.not ((v, u) in E)$. Definimos entonces $P(n):$ Para todo grafo dirigido $G$ con $n$ vértices tal que $Q(G)$, $G$ tiene un camino Hamiltoniano. Por comodidad, dedo un subconjunto $X subset.eq V$ de vértices de un grafo $G = (V, E)$, definimos $G[X] = (X, {(a, b) in E | a in X, b in X})$, el subgrafo inducido por $X$ en $G$.

  + Caso base, $P(0)$. Esto es trivialmente cierto porque no hay ningún grafo sin vértices, luego no existe ningún tal $G$.
  + Caso base, $P(1)$. También trivial, si $V = {v}$, $[v]$ un camino Hamiltoniano.
  + Paso inductivo. Sea $n in NN, n gt.eq 2$. Asumimos que vale $P(k)$ para todo $k in NN, k < n$, queremos probar $P(n)$. Sea $G = (V, E)$ un grafo dirigido, con $|V| = n$. Como $n gt.eq 2$, sea cuaquier $v in V$, y $W = V without {v}$. Sea $W^(arrow) = {w in W | (w, v) in E}$, y $W^(arrow.l) = {w in W | (v, w) in E}$. Como para todo $w in W subset.eq V$ sabemos que o bien $(w, v)$ in E, o bien $(v, w) in E$, y ocurre exactamente una de las dos, entonces vemos que $W = W^arrow union.sq W^(arrow.l)$, la unión disjunta.

    Como $W = V without {v}$, tenemos $|W| = |V| - 1 = n - 1 < n$. Como ambos $W^arrow subset.eq W$ y $W^(arrow.l) subset.eq W$, tenemos $|W^arrow| < n$, y $|W^arrow.l| < n$, y es más, $|W^arrow| + |W^arrow.l| = |W| = n - 1$.

    - Si $W^arrow.l = emptyset$, entonces $W = W^arrow$, y luego $|W^arrow| = |W| = n - 1 gt.eq 1$. Construímos $G' = G[W^arrow]$, con $n - 1$ vértices. Como $Q(G)$, sigue valiendo $Q(G')$. Ahora usamos $P(n - 1)$ para obtener un camino Hamiltoniano $R = [r_1, dots, r_(n - 1)]$ en $G'$. Como es Hamiltoniano, no repite vértices. $R$ existe en $G$, por ser $G'$ subgrafo de $G$. Como $r_(n - 1) in W^arrow$, por definición $(r_(n - 1), v) in E$. Sea $R' = [r_1, dots, r_(n - 1), v]$. Como $R$ es un camino en $G'$, y $v in.not V(G')$, entonces $v in.not R$. Luego $R'$ es un camino de longitud $n$ en $G$ que no repite vértices, y luego es Hamiltoniano en $G$.
    - Si $W^arrow = emptyset$, pasa algo análogo, tomando el subgrafo inducido por $W^arrow.l$ en $G$.
    - Si ninguna de las dos particiones está vacía, sea $k = |W^arrow|, t = |W^arrow.l|$, con $1 lt.eq k, t < n$. Tomemos $G^arrow = G[W^arrow]$, $G^arrow.l = G[W^arrow.l]$, y como seguimos teniendo $Q(G^arrow)$ y $Q(G^arrow.l)$ por ser subgrafos inducidos de $G$, usamos $P(k)$ y $P(t)$, y vemos que ambos tienen un camino Hamiltoniano. Sean $R^arrow = [x_1, dots, x_k]$ y $R^arrow.l = [y_1, dots, y_t]$ tales caminos en $G^arrow$ y $G^arrow.l$, respectivamente. Por ser Hamiltonianos, sabemos que no repiten vértices, y sabiendo que $|W^arrow| + |W^arrow.l| = n - 1$, sabemos que $k + t = n + 1$. Como $W^arrow inter W^arrow.l = emptyset$, vemos que $R^arrow$ y $R^arrow.l$ no comparten vértices. Como $x_k in W^arrow$, tenemos que $(x_k, v) in E$. Como $y_1 in W^arrow.l$, tenemos que $(v, y_1) in E$. Luego, $R = R^arrow + [v] + R^arrow.l = [underbrace(x_1\, dots\, x_k, in W^arrow), v, underbrace(y_1\, dots\, y_t, in W^arrow.l)]$ es un camino en $G$ de longitud $k + t + 1 = n - 1 + 1 = n$. Como $v in.not W^arrow$ y $v in.not W^arrow.l$, $R$ no repite vértices, y luego es Hamiltoniano en $G$.
]

#ej(title: [Teorema de Bondy-Chvátal@chvatal])[
  Sea $G$ un grafo de $n$ vértices, y sean $u$ y $v$ vértices no adjacentes, tal que $d_G (u) + d_G (v) gt.eq n$.

  Probar que si $G + {u, v}$ es Hamiltoniano, entonces $G$ también lo es.
]
#demo[
  Llamemos $G = (E, V)$, y $n = |V|$. Sea $C$ un ciclo Hamiltoniano de $G + {u, v}$. Si ${u, v} in.not C$, entonces $C$ también es un ciclo Hamiltoniano en $G$, y terminamos. Luego, asumamos que ${u, v} in C$. Consideremos el camino $C - {u, v} = [c_1 = u, c_2, dots, c_n = v]$. Sean $S_u = {i | 1 lt.eq i lt.eq n - 1, {u, c_(i + 1)} in E}$, y $S_v = {i | 1 lt.eq i lt.eq n - 1, {c_i, v} in E}$. Vemos que $|S_u| = d_G (u)$, y $|S_v| = d_G (v)$. Luego, $|S_u| + |S_v| gt.eq n$, por hipótesis, mientras que luego $|S_u union S_v| lt.eq n - 1$, dado que en sus definiciones, $i in [0, dots, n - 1]$. Luego, $S_u inter S_v eq.not emptyset$. Sea entonces $i in S_u inter S_v$.

  #let nf(pos, content, label, ..attrs) = {
    node(pos, content, name: label, stroke: 1pt, radius: 2pt, ..attrs)
  }
  #let ef(a, b, c, ..attrs) = {
    edge(label(a), label(b), stroke: c, ..attrs)
  }
  #align(center)[
    #diagram({
      nf((0, 0), $u$, "u")
      nf((6, 0), $v$, "v")

      nf((0.75, -1), $c_2$, "c2")
      nf((6 - 0.75, -1), $c_(n-1)$, "cnm1")

      nf((2.5, -1.4), $c_i$, "ci")
      nf((3.5, -1.4), $c_(i+1)$, "cip1")

      ef("u", "v", blue)
      let ee = ("u", "c2", "ci", "cip1", "cnm1", "v")
      for (a, b) in ee.zip(ee.slice(1)) {
        ef(a, b, if a == "ci" { black } else { red }, if (a == "c2" or a == "cip1") { "--" } else { "-" })
      }
      ef("ci", "v", red)
      ef("cip1", "u", red)
    })
  ]

  Como $c_1 = u$ y $c_n = v$ no son adjacentes en $G$, vemos que $2 lt.eq i lt.eq n - 2$. Pero ahora, $C' = [c_1 = u, c_2, dots, c_i, v = c_n, c_(n-1), dots, c_(i+1), c_1 = u]$ es un ciclo Hamiltoniano en $G$, y luego $G$ es Hamiltoniano.]

#ej(title: [Teorema de Dirac])[
  Si $G$ tiene $n gt.eq 3$ vértices y mínimo grado $delta(G) gt.eq n/2$, entonces $G$ es Hamiltoniano.
]
#demo[
  Sea $C$ la componente conexa más chica de $G = (V, E)$, y $v in C$. Como $delta(G) gt.eq n/2$, tenemos $d(v) gt.eq n/2$. Como al menos $1 + n/2$ vértices (i.e. más de la mitad de los vértices) están en la componente conexa _más chica_, tiene que haber sólo una componente conexa. Luego $G$ es conexo.

  Sea $P = [x_1, dots, x_k]$ un camino de máxima longitud en $G$. Como $delta(G) gt.eq n / 2$, entonces $d(x_k) gt.eq n/2$, y $d(x_1) gt.eq n/2$. Si algún vecino de $x_1$ o $x_k$ no estuviera en $P$, podríamos extender alguno de los extremos de $P$, obteniendo un camino de mayor longitud de $P$. Por ende todos los vecinos de $x_1$, y todos los vecinos de $x_k$ están en $P$.

  Probemos que existen dos vértices, $x_j$ y $x_(j+1) in V$, tal que ${x_j, x_k} in E$, y ${x_(j+1), x_1} in E$. Sea $A = {{x_t, x_(t+1)} | {x_(t+1), x_1} in E}$, y $B = {{x_t, x_(t+1)} | {x_t, x_k} in E}$. Vemos que $|A| = d(x_1) gt.eq n/2$, y $|B| = d(v_k) gt.eq n/2$. Como $P$ tiene a lo sumo $n - 1$ aristas, y $|A| + |B| gt.eq n$, por el principio del palomar existe alguna arista que está en ambos $|A|$ y $|B|$. Esa arista, luego, es de la forma $e = {a, b}$ con ${a, x_k} in E$ (pues $e in A$) y ${x_1, b} in E$ (pues $e in B$).

  #align(center)[
    #diagram(node-stroke: 0.5pt, node-shape: circle, {
      node((0, 0), $x_1$, name: "x_1", radius: 17pt)
      node((1, 0), $x_2$, name: "x_2", radius: 17pt)
      node((3, 0), $x_i$, name: "x_i", radius: 17pt)
      node((4, 0), $x_(i+1)$, name: "x_ip1", radius: 17pt)
      node((6, 0), $x_(k-1)$, name: "x_km1", radius: 17pt)
      node((7, 0), $x_k$, name: "x_k", radius: 17pt)

      edge(label("x_1"), label("x_2"))
      edge(label("x_2"), label("x_i"), "..")
      edge(label("x_i"), label("x_ip1"), $e$)
      edge(label("x_ip1"), label("x_km1"), "..")
      edge(label("x_km1"), label("x_k"))

      edge(label("x_i"), label("x_k"), stroke: red, bend: 30deg)
      edge(label("x_1"), label("x_ip1"), stroke: red, bend: -30deg)
    })]

  Sea $C = [x_1, x_2, dots, x_i, x_k, x_(k-1), dots, x_(i+1), x_1]$, de longitud $k + 1$. $C$ es un ciclo.

  Si no fuera Hamiltoniano, entonces como $G$ es conexo, existiría un vértice $y in V$, adjacente a algún $x_j in C$, con $y in.not C$. Luego existe ${x_j, y} in E$. Pero entonces podríamos tomar $C$, sacarle una arista incidente a $x_j$, y agregarle $e$, y obtendríamos un _camino_ en $G$, de longitud $k + 1$, que no puede pasar pues $P$, de longitud $k$, era de longitud máxima.

  Luego $C$ es un ciclo Hamiltoniano en $G$, y luego $G$ es Hamiltoniano.]

#load-bib()