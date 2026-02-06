
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Coloreo
#defi[
  Sea $G = (V, E)$ un grafo. Un *coloreo de $G$ con $k$ colores* es una función $f: V arrow {1 dots k}$, tal que para todo $(u, v) in E$, $f(u) eq.not f(v)$.

  Si existe un coloreo de $G$ con $k$ colores, se dice que $G$ es *$k$-coloreable*.

  El *número cromático* de $G$ es el mínimo $k$ tal que $G$ es $k$-coloreable, y se denota $chi(G)$.
]
#ej[
  Dado un $n in NN$, el grafo $C_n$ tiene $n$ vértices $v_1, dots, v_n$, y hay una arista entre $v_i$ y $v_((i + 1) mod n)$ para todo $0 lt.eq i lt.eq n$.

  ¿Para cuáles $n in NN$, $C_n$ es 2-coloreable?
]
#demo[
  Sea $C_n = (V, E) = [v_1, dots, v_n]$ el ciclo de $n$ vértices. Supongamos que tenemos $f: V arrow {0, 1}$ que colorea a $C_n$ con 2 colores. Luego, claramente los valores de $f(v_1), f(v_2), f(v_3), dots$ tienen que alternarse, pues si no no sería un coloreo válido. La única restricción va a ser qué pasa cuando el ciclo vuelve a $v_1$. Supongamos sin pérdida de generalidad que $f(v_1) = 1$, entonces vamos a tener $f(v_i) = i mod 2$. Entonces, si tuvieramos un ciclo de longitud impar, tendríamos $f(v_n) = n mod 2 = 1$, pero $f(v_1) = 1$, y ${v_n, v_1} in E$. Luego, si queremos que $C_n$ sea 2-coloreable, debemos tener $n equiv 0 (mod 2)$.]


#ej[
  Probar que el número cromático de todo árbol es menor o igual a $2$.
]
#demo[
  Sea $T$ un árbol con $n$ vértices.

  - Si $n = 1$, puedo colorear al único vértice de un color, y tengo un 1-coloreo. No existen 0-coloreos, luego el número cromático de $T$ es uno.
  - Si $n > 1$, entonces al ser $T$ bipartito, podemos tomar las dos particiones $U, W$ de sus vértices, colorear $U$ de un color y $W$ de otro, y obtenemos un 2-coloreo válido. Como un árbol es conexo, y hay más de un vértice, debe existir al menos una arista $e = {u, w}$, con $u in U$ y $w in W$. Esa arista previene que $u$ y $w$ tengan el mismo color, luego no existen 1-coloreos. Como se puede colorear con 2 colores, y no con 1 color, el número cromático de $T$ es 2.
]

#ej(title: [Teorema de Ramsey])[
  Probar que toda forma de colorear las *aristas* de $K_6$ con dos colores, azul y rojo, tiene un triángulo rojo o un triángulo azul.
]
#demo[
  #let rc = circle(fill: red, radius: 5pt)
  #let bc = circle(fill: blue, radius: 5pt)
  Sea $G = (V, E) = K_6$ el grafo completo en $6$ vértices, y sea $f:E arrow {rc, bc}$ una manera de colorear $E$ con dos colores. Sea $v in V$. Como $d_G (v) = 5$, tiene o 3 aristas incidentes $bc$, o aristas incidentes $rc$. Sin pérdida de generalidad, asumamos que tiene tres aristas incidentes $rc$. Sean $x, y, z$ los vértices que unen a estas aristas con $v$. Luego, $f({v, x}) = f({v, y}) = f({v, z}) = rc$. Si $f({x, y}) = f({y, z}) = f({z, x}) = bc$, encontramos un triángulo $bc$, y terminamos. De otra forma, existe una arista $rc$ entre algunos de esos tres vértices. Sin pérdida de generalidad, asumamos que es $f({x, y}) = rc$. Entonces tenemos un triángulo $rc$, $({v, x}, {x, y}, {y, v})$, y terminamos.
]

#ej[
  Sea $G$ un grafo de $n$ vértices, denotemos $alpha(G)$ el máximo tamaño de un conjunto independiente en $G$.

  Probar que $n/alpha lt.eq chi$.
]
#demo[
  Sea $G = (V, E)$. Nombramos por comodidad $chi = chi(G)$, y $alpha = alpha(G)$, y $n = |V|$. y consideremos un coloreo óptimo $f: V arrow {1, dots, chi}$. Sean $S_i = f^(-1)(i) subset.eq V$ los conjuntos de cada color, para $1 lt.eq i lt.eq chi$. Si $u, v in S_i$, entonces ${u, v} in.not E$, puesto que $f$ es un coloreo válido. Luego $S_i$ es un conjunto independiente.

  Como $V = union.sq.big_(1 lt.eq i lt.eq chi) S_i$, entonces $n = sum_(i = 1)^chi |S_i|$. Como cada $S_i$ es un conjunto independiente, $|S_i| lt.eq alpha$. Luego, $n lt.eq sum_(i = 1)^chi alpha = chi alpha$, y luego $n/alpha lt.eq chi$.]

#ej[
  Sea $G = (V, E)$ un grafo con $n = |V|$ vértices, y $overline(G)$ su complemento.

  Demostrar que $chi(G) + chi(overline(G)) lt.eq n + 1$.
]<ejchi>
#demo[
  Por inducción. Si $n = 1$, $G = overline(G)$, y $chi(G) = chi(overline(G))$, luego $chi(G) + chi(overline(G)) = 1 + 1 = 2 lt.eq 1 + 1$. En el paso inductivo, si $n > 1$, podemos tomar $G$ y sacarle un vértice $v$, obteniendo $G' = G - v$. También llamamos $overline(G)' = overline(G) - v$. Usamos la hipótesis inductiva en $n - 1$, y obtenemos un coloreo con $k$ colores de $G'$, y un coloreo con $l$ colores de $overline(G)'$, tal que $k + l lt.eq (n - 1) + 1 = n$.
  + Si $d_G (v) < k$, extendemos el coloreo de $G'$ a un coloreo de $G$ con $k$ colores. Coloreamos $overline(G)$ usando el coloreo de $l$ colores de $overline(G)'$, y usando un nuevo color para $v$ que agregamos. Luego, $chi(G) + chi(overline(G)) lt.eq (n - 1 + 1) + 1 = n + 1$, que es lo que queríamos demostrar.
  + Si $d_G (v) gt.eq k$, entonces $d_(overline(G)) (v) lt.eq n - k = l - 1 < l$, y podemos extender el $l$-coloreo de $overline(G)'$ a un $l$-coloreo de $overline(G)$. En $G$, usamos el $k$-coloreo de $G'$, y usamos un color nuevo para $v$. Luego, $chi(overline(G)) + chi(G) lt.eq l + k + 1 = lt.eq n + 1$, que es lo que queríamos demostrar.
]

#ej[
  Sea $G = (V, E)$ un grafo con $n = |V|$ vértices, y $overline(G)$ su complemento.

  Demostrar que $chi(G) + chi(overline(G)) gt.eq 2 sqrt(n)$.]
#demo[
  Consideremos $G union overline(G) = K_n$, el grafo completo. Si $chi(G)$-coloreamos $G$ con $c$, y $chi(overline(G))$-coloreamos $overline(G)$ con $c'$, entonces podemos construir un $chi(G)chi(overline(G))$-coloreo de $K_n$, coloreando a cada vértice $v in V$ con $(c(v), c'(v))$. Como $chi(K_n) = n$, entonces $n lt.eq chi(G)chi(overline(G))$.

  Ahora bien:

  $
                               (chi(G) - chi(overline(G)))^2 & gt.eq 0 \
    chi(G)^2 - 2 chi(G)chi(overline(G)) + chi(overline(G))^2 & gt.eq 0 \
    chi(G)^2 + 2 chi(G)chi(overline(G)) + chi(overline(G))^2 & gt.eq 4 chi(G)chi(overline(G)) \
                               (chi(G) + chi(overline(G)))^2 & gt.eq 4 chi(G)chi(overline(G)) gt.eq 4n \
                               (chi(G) + chi(overline(G)))^2 & gt.eq 4n \
                                   chi(G) + chi(overline(G)) & gt.eq sqrt(4n) \
                                   chi(G) + chi(overline(G)) & gt.eq 2 sqrt(n)
  $]

#ej[
  Sea $G = (V, E)$ un grafo con $n = |V|$ vértices, y $overline(G)$ su complemento.

  Demostrar que $n lt.eq chi(G) chi(overline(G)) lt.eq ((n + 1)/2)^2$.

  Para la segunda desigualdad, puede serles útil la desigualdad aritmética-geométrica.
]
#demo[
  Consideremos el grafo $H = (V times V, E')$, con $E' = {{(u, v), (x, y)} | {u, x} in E or {v, y} in.not E}$. Es decir, un par $(u, v)$ está conectado a un par $(x, y)$, exactamente cuando $u$ está conectado a $x$ en $G$, o $v$ está conectado a $y$ en $overline(G)$.

  Sea $c$ un $chi(G)$-coloreo para $G$, y $c'$ un $chi(overline(G))$-coloreo para $overline(G)$. Obtenemos entonces un coloreo $f$ con $chi(G) chi(overline(G))$ colores para $H$, donde $f((u, v)) = (c(u), c'(v))$, para cualquier $(u, v) in V times V$. Veamos que $f$ es un coloreo válido. Si ${(u, x), (v, y)) in E'$, entonces o bien ${u, v} in E$, o bien ${x, y} in.not E$. En el primer caso, $c(u) eq.not c(v)$, y en el segundo, $c'(x) eq.not c'(y)$. Luego, el color asignado a $(u, x)$ no puede ser igual al color asignado a $(x, y)$. Luego, $f$ es un coloreo válido, y $chi(G) lt.eq chi(G) chi(overline(G))$.

  Ahora bien, tomemos el conjunto de vértices de $H$, $F = {(v, v) | v in V}$. Sea cualquier par de vértices en $F$, $a = (v, v)$, y $b = (w, w)$. Entonces o bien ${v, w} in E$, o bien ${v, w} in.not E$. En el primer caso, ${(v, v), (w, w)} in E'$ porque $(v, w) in E$. En el segundo, ${(v, v), (w, w)} in E'$ porque $(v, w) in.not E$. Luego, par cada par de vértices distintos en $F$, tenemos una arista entre ellos en $H$. Luego $F$ es una clique en $H$, de $n$ vértices, y luego todo coloreo de $H$ debe asignarle $n$ colores distintos a los vértices de $F$. Luego, $chi(G) gt.eq n$.

  Juntando ambas ecuaciones, vemos que $n lt.eq chi(G) chi(overline(G))$.

  #line(length: 100%)

  Para ver que $chi(G) chi(overline(G)) lt.eq ((n+1)/2)^2$, podemos usar la desigualdad aritmética-geométrica. Esta nos dice que para todo $x, y$ reales no-negativos, tenemos $(x+y)/2 gt.eq sqrt(x y)$. Aplicando esto a $x = chi(G), y = chi(overline(G))$, sabemos que $(chi(G) + chi(overline(G)))/2 gt.eq sqrt(chi(G) chi(overline(G)))$, o lo que es lo mismo, $((chi(G) + chi(overline(G)))/2)^2 gt.eq chi(G) chi(overline(G))$. Por la desigualdad del @ejchi, sabemos que $chi(G) + chi(overline(G)) lt.eq n+1$.

  Luego, $chi(G) chi(overline(G)) lt.eq ((n+1)/2)^2$, que es lo que queríamos demostrar.]

#ej[
  Sea $G$ un grafo, denotemos $Delta(G)$ el máximo grado de cualquier vértice en $G$.

  Probar que $chi lt.eq Delta + 1$.
]
#demo[
  Vamos a demostrar esto con un algoritmo, el algoritmo greedy para coloreo.
  ```python
  def color(V: list[int], E: dict[int, list[int]]) -> list[int]:
    (V, E) = G
    n = len(V)
    Delta = max(len(vs) for vs in E.values())
    all_colors = set(range(Delta + 1))
    colors = [-1 for _ in range(n)]
    for (i, v) in enumerate(V):
      used = set(colors[w] for w in E[v] if colors[w] != -1)
      colors[i] = min(all_colors - used)
    return colors
  ```

  La variable `Delta` representa $Delta(G)$, el máximo grado entre todos los vértices. `all_colors` es el conjunto ${0, 1, dots, Delta}$. El invariante que mantenemos es que al terminar la $i$-ésima iteración, le asignamos correctamente un color entre $0$ y $Delta$ a los primeros $i$ vértices. Como hay sólo $Delta$ vecinos, `len(used)` siempre tiene como mucho $Delta$ elementos. Como `len(all_colors) = `$Delta + 1$, siempre hay algún color no usado al calcular `all_colors - used`, y por lo tanto podemos tomar el mínimo color en esa resta. Como estamos sacando `used` de `all_colors`, nunca vamos a asignarle a `colors[i]` un color idéntico a `colors[j]` con `j in E[v]`. Luego, esta asignación de colores nos da un coloreo válido de los primeros $i$ vértices, si ya teníamos un coloreo válido de los primeros $i - 1$ vértices. Al terminar el ciclo, coloreamos los $n$ vértices.

  Este algoritmo, entonces, colorea $G$ usando a lo sumo $Delta + 1$ colores, que están en `all_colors`. Como el algoritmo termina, y asigna un $(Delta+1)$-coloreo válido, entonces $Delta + 1 gt.eq chi(G)$, donde $chi(G)$ es el número cromático de $G$.
]

#ej[
  Sea $G = (V, E)$ un grafo, y sea $v in V$.

  Probar que $chi(G - v) in {chi(G), chi(G) - 1}$.
]
#demo[
  Sea $H = G - v$. Si $f:G arrow {1, dots, chi(G)}$ es un coloreo óptimo de $G$, entonces $g: H arrow {1, dots, chi(G)}, g(v) = f(v)$ es un $chi(G)$-coloreo válido de $H$. Luego, $chi(H) lt.eq chi(G)$.

  Sólo nos queda probar que $chi(H) gt.eq chi(G) - 1$. Sea $f: V without {v} arrow {1, dots, chi(H)}$ un coloreo óptimo de $H$. Podemos entonces agregar $v$ a $H$, con las mismas aristas que tenía $v$ en $G$. Vamos a definir:

  $
        g: & V arrow {1, dots, chi(H) + 1} \
    g(w) = & cases(
               f(w) & "si " w eq.not v,
               chi(H) + 1 & "si " w = v
             )
  $

  Como estamos agregando un vértice nuevo, $v$, que tiene un color distinto al color de todos los otros vértices (pues $f(w) lt.eq chi(H) forall w in V without {v}$), entonces $g$ no introduce conflictos de colores. Vemos que $g$ es, entonces, un $(chi(H) + 1)$-coloreo válido de $G$. Por lo tanto, $chi(G) lt.eq chi(H) + 1$, o lo que es lo mismo, $chi(H) gt.eq chi(G) - 1$, que es lo que queríamos demostrar.]

#load-bib()