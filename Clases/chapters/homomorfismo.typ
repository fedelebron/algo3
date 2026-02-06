
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Homomorfismo e isomorfismo de grafos

#defi[
  Sean $G = (V, E), H = (V', E')$ grafos. Se dice que una función $f:V arrow V'$ es un *homomorfismo de grafos* cuando para todo $u, v in V$, ${u, v} in E implies {f(u), f(v)} in E'$.

  Un *isomorfismo de grafos* entre $G$ y $H$ es una función $f: V arrow V'$, tal que para todo $u, v in V$, ${u, v} in E iff {f(u), f(v)} in E'$.

  Una definición análoga vale para grafos dirigidos, donde las aristas son pares ordenados, en vez de conjuntos de tamaño 2.
]

#ej[
  Sean $G, H, K$ grafos, y $f: G arrow H, g: H arrow K$ homomorfismos. Probar que $g compose f$ es un homomorfismo.
]
#demo[
  Para ver que $g compose f$ es un homomorfismo, tenemos que tomar dos vértices $u, v in V(G)$, y ver que si ${u, v} in E(G)$, entonces ${g(f(u)), g(f(v))} in E(K)$.

  Sean $u, v$ tales que ${u, v} in E(G)$. Entonces como $f$ es un homomorfismo, ${f(u), f(v)} in E(H)$. Como $g$ es un homorfismo, ${g(f(u)), g(f(v))} in E(K)$, que es lo que queríamos demostrar.
]

#ej[
  Sean $G, H$ grafos, y $f: G arrow H$ un isomomorfismo. Probar que si $G$ es conexo, entonces $H$ también lo es.
]
#demo[
  Sean $(V_H, E_H) = H$, y $(V_G, E_G) = G$. Vamos a probar que para todo par de vértices en $H$, hay un camino entre ellos. Sean $u, v in V_H$ cualquier par de vértices. Como $f$ es un isomorfismo, en particular es biyectiva, y luego existen $x = f^(-1)(u)$, $y = f^(-1)(v)$. Como $G$ es conexo, existe un camino $P = [x = p_1, p_2, dots, p_k = y]$ en $G$. Para todo $1 lt.eq i < k$, ${p_i, p_(i+1)} in E_G$. Luego, como $f$ es un isomorfismo, para todo $1 lt.eq i < k$, $e = {f(p_i), f(p_(i+1))} in E_H$. Consideremos $P' = [f(x) = f(p_1), f(p_2), dots, f(p_k) = f(y)]$. Como vimos, cada transición es una arista en $E_H$. Luego, $P'$ es un camino en $H$, entre $f(x) = u$, y $f(y) = v$.
]

#ej[
  Sean $G = (V, E)$ y $H = (V', E')$ grafos.

  Notemos por $chi(G)$ el número de coloreo de un grafo $G$, y $omega(G)$ el tamaño de la clique máxima en $G$.

  Mostrar que si hay un homomorfismo $f:G arrow H$, entonces:
  + $omega(G) lt.eq omega(H)$
  + $chi(G) lt.eq chi(H)$
]
#demo[
  Notemos $G = (V, E), H = (W, F)$.

  + Sea $K subset.eq V$ una clique máxima en $G$. Luego $|K| = omega(G)$. Sea $K' = {f(w) | w in K} subset.eq W$. Sean $u, v in K$. Entonces ${u, v} in E$, y por lo tanto, ${f(u), f(v)} in F$. $H$ es un grafo, y no pseudografo, $f(u) eq.not f(v)$. Luego, todos los vértices en $K$ van a parar a vértices distintos en $K'$, y luego $f_(|K): K arrow K'$ es biyectiva. Entre cada par de vértices $x, y in K'$, vamos a encontrar entonces una arista ${f^(-1)(x), f^(-1)(y)}$ en $G$, pues $f^(-1)(x)$ y $f^(-1)(y)$ son vértices distintos en $K$, una clique. Luego $K'$ también es una clique. Como $f_(|K)$ es una biyección, tenemos que $|K'| = |K| = omega(G)$. Luego, $H$ contiene una clique de tamaño $omega(G)$, y entonces la clique máxima de $H$ tiene tamaño como mínimo $omega(G)$. Luego, $omega(G) lt.eq omega(H)$.
  + Sea $g:W arrow {1, dots, chi(H)}$ un coloreo óptimo de $H$. Vamos a ver que $g compose f$ es un $chi(H)$-coloreo de $G$. Claramente le asigna a cada vértice de $H$ un número entre $1$ y $chi(H)$, por cómo definimos $g$. Ahora tomemos cualquier par de vértices $u, v in V(G)$, tal que ${u, v} in E(G)$. Luego, como $f$ es un homomorfismo, ${f(u), f(v)} in E(H)$. Como $g$ es un coloreo, entonces $g(f(u)) eq.not g(f(v))$. Luego, el coloreo que creamos, $g compose f$, es un coloreo válido para $G$, con $chi(H)$ colores. Entonces $chi(G) lt.eq chi(H)$.
]

#ej[
  Dado un grafo dirigido $D = (V, E)$, se lo llama _orientado_ cuando para todo par de vértices $v, w in V$, tenemos que $(v, w) in.not E$, o $(w, v) in.not E$. Puede no estar ninguna de las dos aristas en $E$. Equivalentemente, $G$ se obtiene de tomar un grafo, y darle una dirección a cada una de sus aristas.

  Demostrar que para todo $n in NN, n gt.eq 1$, existe un único (salvo isomorfismo) grafo dirigido orientado $G$ con $n$ vértices tal que todos los vértices de $G$ tienen un grado de salida distinto.
]

Vamos a dar dos demostraciones distintas. La primera es por inducción, que es la manera más sencilla de probar esto. La segunda usa un argumento combinatorio.

#demo[
  Dos observaciones:
  + Si $G$ es un tal grafo dirigido, como todos los grados de salida están en ${0, dots, n - 1}$, cuyo tamaño es $n$, y hay $n$ vértices con $n$ grados de salida distintos, entonces el conjunto de grados de salida es exactamente ${0, dots, n - 1}$.
  + La suma de los grados de salida de todos los vértices es igual al número de aristas, $|E(G)|$. Por el punto anterior, llamemos $v_i$ al único vértice con grado de salida $i$. Luego, si notamos por $d^+_G (v)$ el grado de salida de un vértice $v in V(G)$, entonces $|E(G)| = sum_(v_i in V(G)) d^+_G (v_i) = sum_(i = 0)^(n - 1) i = n(n - 1)/2$. Pero esto es el máximo número de aristas que puede haber en un grafo, teniendo una arista entre cada par de vértices. Luego $G$ resulta de darle una orientación a las aristas de un grafo completo, $K_n$.

  Sea $P(n)$: Existe un único grafo dirigido orientado de $n$ vértices tal que todos los vértices tienen grados de salida distintos. Vamos a probar $forall n in NN. (n gt.eq 1 implies P(n))$ por inducción.

  - Caso base, $P(1)$. Hay un sólo grafo dirigido orientado con un sólo vértice, salvo isomorfismo, y es $G = ({0}, emptyset)$. El único vértice tiene grado de salida $0$, y luego $P(1)$ es cierto.
  - Paso inductivo. Tenemos $n in NN, n gt.eq 1$. Asumimos $P(n)$, y queremos probar $P(n+1)$. Para probar existencia, vamos a construir un tal grafo explícitamente. Sea $V = {0, dots, n}$, y $E = {(i, j) | 0 lt.eq i, j lt.eq n, i > j}$, y $G = (V, E)$. Tenemos que $G$ es un grafo dirigido de $|V| = n + 1$ vértices. Notemos por $d^+_G (v)$ el grado de salida de un vértice $v in V(G)$. Entonces, $d^+_G (i) = i$, pues $i$ es mayor que $0, 1, 2, ..., i - 1$, y hay $i$ de esos otros números entre $0$ y $n$, es decir en $V$. Luego, si $i eq.not j$, entonces $d^+_G (i) = i eq.not j = d^+_G (j)$. Luego, todos los vértices tienen grados de salida distintos.

    Ahora tenemos que mostrar unicidad salvo isomorfismo. Sean $G = (V, E), H = (W, F)$ dos grafos dirigidos orientados con $n + 1$ vértices, tal que en cada grafo, todos los vértices tienen grados de salida distintos. Por la primera observación al principio de la demostración, el conjunto de grados de salida de $G$ y $H$ es ${0, dots, n}$. Nombremos entonces, para cada $0 lt.eq i lt.eq n$, $v_i in V(G)$ al vértice en $G$ con grado de salida $d^+_G (v_i) = i$, y $w_i in V(H)$ al vértice en $H$ con grado de salida $d^+_H (w_i) = i$. Ahora consideremos $G' = G - v_n$, y $H' = H - w_n$. Por la segunda observación, como $v_n$ tiene grado de salida $n$, y entre todo par de vértices en $G$ hay exactamente una arista, entonces ningún vértice en $G$ tiene una arista hacia $v_n$, y luego para todo $v in V without {v_n}$, $d^+_(G') (v) = d^+_G (v)$. Luego, los grados de salida de los vértices en $G'$ son exactamente ${0, dots, n - 1}$, y todos los grados de salida son distintos. Análogamente, los grados de salida de los vértices en $H'$ son exactamente ${0, dots, n - 1}$, y todos los grados de salida son distintos.

    Por la hipótesis inductiva, existe un isomorfismo $f: G' arrow H'$. Vamos a ver que $f$ se extiende a un isomorfismo entre $G$ y $H$. Definimos $g: V arrow W$, como $g(v) = f(v)$ para todo $v in V without {v_n}$, y $g(v_n) = w_n$. Veamos que es un isomorfismo. Es claro que $g$ es una función biyectiva, pues $f$ lo era, y estamos agregando un elemento al dominio y al codominio, y asignando el uno al otro. Ahora tenemos que ver que para todo par de vértices $u, v in V$, $(u, v) in E iff (g(u), g(v)) in F$. Los vértices de $V$ se particionan en ${v_n}$ y $V without {v_n}$.
    + Si $u, v in V without {v_n}$, entonces $(u, v) in E iff (f(u), f(v)) in F iff (g(u), g(v)) in F$, pues $f$ ya es un isomorfismo entre $G'$ y $H'$.
    + Si $u = v_n$, y $v in V without {v_n}$, entonces sabemos que $(u, v) in E$, pues $u$ tiene grado de salida $n$, y luego tiene una arista hacia todos los otros vértices en $G$. Por otro lado, $g(u) = w_n$, y $g(v) = f(v) in V(H')$, con $f(v) eq.not w_n$. Como $w_n$ también tiene grado de salida $n$, entonces $(g(u), g(v)) in F$. Para probar la vuelta del si y sólo si, no hace falta hacer nada, pues sabemos que la conclusión, $(u, v) in E$, es cierta.
    + Si $v = v_n$, y $u in V without {v_n}$, entonces sabemos que $(u, v) in.not E$, pues $v$ no tiene aristas entrantes. Para probar la ida del si y sólo si, no hace falta hacer nada, pues falso implica todo. Para probar la vuelta, tenemos que ver que $(g(u), g(v)) in.not F$. Como $g(v) = w_n$, con $w_n$ el vértice en $H$ con grado de salida $n$, entonces $w_n$ no tiene aristas entrantes, y luego $(g(u), g(v)) in.not F$.

    Luego, $g$ es un isomorfismo entre $G$ y $H$. Esto prueba que $G$ es único salvo isomorfismo.
]

#demo[
  Para mostrar que existe un único tal grafo dirigido orientado, salvo isomorfismo, debemos mostrar que existe al menos uno, y que ese uno es único. Sea entonces $n in NN, n gt.eq 1$. Vamos a construir el grafo dirigido ordenado $G = (V, E)$, donde $V = {0, dots, n-1}$, y $E = {(i, j) | 0 lt.eq i, j lt.eq n-1, i > j}$. Es decir, hay una arista dirigida desde $i$ a $j$ si y sólo si $i > j$.

  Claramente, $G$ es un grafo dirigido. Para cada $0 lt.eq i, j lt.eq n-1$, o bien $i lt.eq j$, o bien $j lt.eq i$, y luego al menos una de $(i, j)$ o $(j, i)$ no está en $E$, y luego $G$ es un grafo dirigido orientado. Notando $d^+_G (v)$ como el grado de salida de cada vértice $v in V(G)$, vemos que $d^+_G (i) = i$, pues $i$ es mayor que $0, 1, 2, ..., i - 1$, y hay $i$ de esos otros números entre $0$ y $n - 1$, es decir en $V$. Luego, si $i eq.not j$, entonces $d^+_G (i) = i eq.not j = d^+_G (j)$. Luego, todos los vértices tienen grados de salida distintos.

  Para ver que $G$ es único salvo isomorfismo, sea $H = (W, F)$ cualquier tal grafo, con $|H| = n$. Como todos los grados de salida de los vértices de $H$ están en ${0, dots, n - 1}$, cuyo tamaño es $n$, y hay $n$ grados de salida distintos, entonces el conjunto de grados de salida de $W$ es exactamente ${0, dots, n - 1}$. Nombremos entonces $w_i$ al vértice en $H$ con grado de salida $d^+_H (w_i) = i$.

  Como sabemos, el número de aristas de un grafo dirigido es igual a la suma de los grados de salida de todos los vértices. Luego, $|F| = sum_(w_i in V) d^+_H (w_i) = sum_(i = 0)^(n - 1) i = n(n - 1)/2$. La suma de los grados de salida es igual a la suma de los grados de entrada, pues toda arista suma 1 a ambas sumatorias, y luego

  $
    |F| = sum_(w_i in V) d^-_H (w_i) = n(n-1)/2
  $ <eq-indeg>

  donde $d^-_H (w_i)$ es el grado de entrada de $w_i$. Por otro lado, para cualquier vértice $w in W$, tenemos $d^+_H (w) + d^-_H (w) lt.eq n - 1$, pues $w$ puede tener como mucho una arista saliente o entrante a cada uno de los otros $n - 1$ vértices. En nuestro caso, tenemos $d^+_H (w_i) = i$, luego

  $
    d^-_H (w_i) lt.eq n - 1 - i
  $ <ineq-indeg>

  Sumando esta desigualdad sobre todos los vértices, y usando la igualdad #xref(<eq-indeg>), obtenemos

  $
    n(n-1)/2 = |F| = sum_(i = 0)^(n - 1) d^-_H (w_i) lt.eq sum_(i = 0)^(n - 1) n - 1 - i = n(n - 1)/2
  $

  Como esto es cierto, todos los términos de la sumatoria tienen que cumplir su cota superior #xref(<ineq-indeg>), de otra forma la suma de la izquierda sería menor la suma de la derecha. Luego, la desigualdad #xref(<ineq-indeg>) es en realidad una igualdad, es decir $d^-_H (w_i) = n - 1 - i$ para todo $i$. Luego, para todo vértice $w in W$, tenemos que el número de aristas incidentes a $w$ es $d^+_H (w) + d^-_H (w) = n - 1$. Esto significa que $H$ vino de orientar las aristas en un grafo completo, $K_n$. Luego, para cada par de vértices $w_i, w_j in W$, o bien $(w_i, w_j) in F$, o bien $(w_j, w_i) in F$.

  Consideremos la dirección de estas aristas. Sean $w_i, w_j$ cualquier par de vértices en $H$, con $i > j$. Vamos a probar que $(w_i, w_j) in F$. Sea $U = {w_k | k gt.eq i}$. Vemos que $|U| = n - i$. Tenemos también que la suma de los grados de salida de los vértices en $U$ es #text(red, $sum_(k=i)^(n-1) d^+_H (w_k) = sum_(k=i)^(n-1) k = (n-1 + i)(n - i)/2$). Cada arista que sale de algún vértice en $U$ puede ir a o a $U$, o a $W without U$. El número de aristas salen de $U$ y van a $U$ es exactamente #text(blue, $|U|(|U| - 1)/2 = (n - i)(n - i - 1)/2$), recordando que para cada par de vértices en $W$, a fortiori en $U$, hay exactamente una arista entre ellos. El número de aristas que salen de $U$ y van a $W without U$ es, entonces

  $
      & #text(red, $(n -1 + i)(n - i)/2$) - #text(blue, $(n - i)(n - i - 1)/2$) \
    = & (n-i)/2 (n-1+i-n+i+1) \
    = & (n-i)/2 (2i) \
    = & i(n-i)
  $

  El máximo número de aristas que pueden salir de $U$ y entrar en $W without U$ es $|U||W without U| = (n - i)i = i(n - i)$, y como vimos que el número de aristas que salen de $U$ y van a $W without U$ es exactamente $i(n - i)$, entonces todas las aristas posibles entre $U$ y $W without U$ existen. En particular, $(w_i, w_j) in F$.

  Luego, para todo grafo dirigido orientado $H = (W, F)$ con todos los grados de salida distintos, para cualquier par de vértices $u, v in W$, si $d^+_H (u) > d^+_H (v)$, entonces $(u, v) in F$, y si $d^+_H (u) < d^+_H (v)$, entonces $(v, u) in F$.


  Luego, el isomorfismo entre $G$ y $H$ es $f: V arrow W, f(i) = w_i$. Claramente es biyectiva. Además, para cualquier par de vértices $i, j in V$, si $(i, j) in E$, entonces $i > j$, y luego $(f(i), f(j)) = (w_i, w_j) in F$. De la misma forma, si $(f(i), f(j)) in F$, entonces $i = d^+_H (w_i) > d^+_H (w_j) = j$, y luego $i > j$, y luego $(i, j) in E$. Luego, $f$ es un isomorfismo entre $G$ y $H$.]

#load-bib()