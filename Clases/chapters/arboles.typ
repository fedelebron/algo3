#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


== Árboles
#ej[
  Un bosque es un grafo acíclico. Demostrar que cualquier bosque con $n$ vértices y $k$ árboles tiene $n - k$ aristas.
]<demo:arboles>
#demo[
  Sea $G$ un bosque, y sean $G_1 = (V_1, E_1), dots, G_k = (V_k, E_k)$ sus $k$ componentes conexas, con $1 lt.eq k lt.eq n$. Cada componente conexa es acíclica, pues $G$ lo es, y es conexa. Luego cada componente conexa es un árbol, y luego $|E_i| = |V_i| - 1$ para todo $1 lt.eq i lt.eq k$. Como ninguna arista puede cruzar componentes conexas (pues las conectaría), cada arista en $E$ está en exactamente un $E_i$ para algún $i$, y tenemos que $E = union.sq.big_(1 lt.eq i lt.eq k) E_i$. Cada vértice, mientras tanto, está en exactamente una componente conexa, y luego $V = union.sq.big_(1 lt.eq i lt.eq k) V_i$.

  Luego,
  $
    |E| & = lr(|union.sq.big_(1 lt.eq i lt.eq k) E_i|) \
        & = sum_(i = 1)^k |E_i| \
        & = sum_(i = 1)^k |V_i| - 1 \
        & = (sum_(i = 1)^k |V_i|) - k \
        & = lr(|union.sq.big_(1 lt.eq i lt.eq k) V_i|) - k \
        & = |V| - k \
        & = n - k
  $
  que es lo que queríamos demostrar.
]

#ej[
  Probar que todo árbol con $n gt.eq 2$ vértices tiene al menos $2$ hojas.
]
#demo[
  Sea $G = (V, E)$ un árbol, con $n = |V| gt.eq 2$, y $m = |E|$. Luego, $G$ es conexo y $m = n - 1$. Una hoja es un vértice de grado $1$. Sea $d:V arrow NN$ la función de grado de cada vértice. No puede haber vértices $v$ con $d(v) = 0$, pues como $n > 1$, $G$ no sería conexo. Luego, $d(v) gt.eq 1$ para todo $v in V$. Sea $H subset.eq V$ el conjunto de hojas de $T$. Luego, $d(v) gt.eq 2$ para todo vértice en $V without H$.

  $
    sum_(v in V) d(v) & = sum_(v in H) d(v) + sum_(v in V without H) d(v) \
                      & = |H| + sum_(v in V without H) d(v) \
                      & gt.eq |H| + 2|V without H| \
                      & = |H| + 2(|V| - |H|) \
                      & = 2|V| - |H|
  $

  También sabemos que $sum_(v in V) d(v) = 2|E| = 2m$, que vale para todo grafo. Como $G$ es un árbol, $m = n - 1$, y luego $sum_(v in V) d(v) = 2m = 2(n - 1) = 2|V| - 2$.

  Luego, $2|V| - 2 gt.eq 2|V| - |H|$, y luego $2 lt.eq |H|$, con lo cual $G$ tiene al menos dos hojas.
]

#ej[
  Un puente es una arista que, al ser removida, aumenta el número de componentes conexas en un grafo. Mostrar que en un bosque, todas las aristas son puentes.
]
#demo[
  Una forma simple de demostrar esto es usando el @demo:arboles, y viendo que al sacar una arista, el número de componentes conexas aumenta. Vamos a dar otra demostración.

  Sea $G = (V, E)$ un bosque, y consideremos las componentes conexas $G_1, dots, G_k$ de $G$. Cada $G_i$ es un árbol, para todo $1 lt.eq i lt.eq k$, por ser conexo y acíclico. Sea $e = {u, v}$ una arista en $E$. Esa arista pertenece a exactamente un $G_i$, pues de no ser así, $e$ conectaría vértices de dos componentes conexas, que no puede suceder. Sea $G_i = (V_i, E_i)$ el árbol al que pertenece $e$.

  Claramente el sacar $e$ de $G_i$ no va a cambiar nada sobre $G_j$ con $j eq.not i$. Al sacar una $e$ de $G_i$, estamos desconectando $u, v$, que antes estaban conectados. Veamos que hay dos componentes conexas en $G'_i = G_i without {e}$. Sea $u$ un vértice en $G'_i = G_i without {e}$.
  + Si hay un camino $P$ entre $w$ y $u$ en $G_i$ que no usa $v$, entonces $P$ sigue estando en $G'_i$, y por tanto $w$ pertenece en $G'_i$ a la componente conexa de $u$.
  + Si no, el único camino $P$ de $w$ a $u$ en $G_i$ pasaba por $v$. Escribimos $P = [w, x_1, dots, x_r, v, dots, u]$. Entonces el camino $[w, x_1, dots, x_r, v]$ existe en $G'_i$ entre $w$ y $v$ (que no pasa por $u$). Luego $w$ está en la componente conexa de $v$.

  Si hubiera un camino en $G'_i$ entre $u$ y $v$, concatenar $e$ a ese camino nos daría un ciclo en $G_i$, pero $G_i$ era un árbol. Luego, $u$ y $v$ están en componentes conexas en $G'_i$, y todos los otros vértices de $G'_i$ están en una de dos componentes conexas.

  Luego $G'_i$ tiene exactamente dos componentes conexas. Como antes de remover $e$ de $G$ teníamos una sola componente conexa en $G_i$, y al resto de los $G_j$ con $j eq.not i$ no le hacemos nada al remover $e$ de $G$, entonces $G - {e}$ tiene exactamente una componente conexa más que $G$, y luego $e$ es un puente.]

#ej[
  Sea $G = (V, E)$ un grafo conexo pesado, con todos sus pesos distintos. Sea $(U_1, U_2) = V$ una partición de los vértices de $G$. Sea $e$ una arista de mínimo peso que cruza las particiones. Entonces $e$ está en algún árbol generador mínimo de $G$.
]
#demo[
  Sea $e = (u, v)$ tal arista. Llamemos $w: E arrow RR$ a la función de peso de $G$, y por comodidad escribamos $w(H) = sum_(v in V(H)) w(v)$ dado un subgrafo $H$ de $G$. Sea $T$ un árbol generador mínimo de $G$.

  Como $T$ es árbol generador, existe en $T$ un único camino $P$ entre $u$ y $v$. Como conecta $u$ y $v$, con $u in U_1$ y $v in U_2$, en algún momento $P$ cruza las particiones. Sea $f$ una arista en $P$ que cruza esas particiones. El enunciado nos dice que $w(e) lt.eq w(f)$.

  Tomemos ahora $T' = T - f + e$. Al remover $f$, estamos desconectando las particiones $U_1$ y $U_2$, pero como $e$ cruza esas mismas particiones, agregar $e$ las reconecta. Luego $T'$ sigue siendo un árbol generador de $G$. Sin embargo, ahora tenemos que $w(T') = w(T) - w(f) + w(e) lt.eq w(T)$. Como $T$ es un árbol generador mínimo, y $T'$ un árbol generador, debemos tener $w(T) lt.eq w(T')$. Luego, $w(T) = w(T')$, y $T'$ es un árbol generador mínimo que incluye a $e$.]

#ej[
  El algoritmo de Kruskal (resp. Prim) con orden de selección es una variante del algoritmo de Kruskal (resp. Prim) donde a cada arista $e$ se le asigna una prioridad $q(e)$ además de su peso $p(e)$. Luego, si en alguna iteración del algoritmo de Kruskal (resp. Prim) hay más de una arista posible para ser agregada, entre esas opciones se elije alguna de mínima prioridad.

  + Demostrar que para todo árbol generador mínimo $T$ de $G$, si las prioridades de selección están definidas por la función:
    $
      q_T (e) = cases(
        0 " si" e in T,
        1 " si " e in.not T
      )
    $

    entonces se obtiene $T$ como resultado del algoritmo de Kruskal (resp. Prim) con orden de selección ejecutado sobre $G$ (resp. cualquiera sea el vértice inicial en el caso de Prim).

  + Usando el inciso anterior, demostrar que si los pesos de $G$ son todos distintos, entonces $G$ tiene un único árbol generador mínimo.
]
#demo[
  + Probemos primero que el algoritmo de Kruskal encuentra todos los árboles generadores mínimos, y luego lo mismo para el algoritmo de Prim. Llamemos $w(e) = (p(e), q_T (e))$, donde ordenamos las tuplas por orden lexicográfico. Es decir, $w(e) lt.eq w(e') iff p(e) < p(e') or (p(e) = p(e') and q_T (e) < q_T (e'))$.

    #lemma[El algoritmo de Kruskal con selección devuelve $T$.]
    #proof[Por "Calamardo" en Telegram. Sea $K$ el árbol generador que devuelve el algoritmo de Kruskal con selección. Asumimos que $K eq.not T$. Luego, existe una primer arista $e$ que el algoritmo agregó a $K$ que no está en $T$. Consideremos $T' = T union {e}$. Este subgrafo de $G$ contiene un único ciclo $C$, con $e in C$. Como $K$ es un árbol, $C subset.eq.not K$, puesto que un árbol no tiene ciclos. Luego existe alguna arista $f in C$ tal que $f in.not K$. Como $f in.not K$ pero $e in K$, tenemos que $f eq.not e$. Como $f eq.not e$, y $f in C subset.eq T + e$, entonces $f in T$. Consideremos entonces $T'' = T' without {f} = (T union {e}) without {f}$. Esto es un árbol generador, puesto que rompimos el único ciclo, $C$, que había en $T'$. Vemos que $p(T'') = p(T) + p(e) - p(f)$. Como $T$ es un árbol generador mínimo, debemos tener $p(T'') gt.eq p(T)$, con lo cual $p(e) gt.eq p(f)$.

      Como $e in.not T$, y $f in T$, tenemos $q_T (f) = 0, q_T (e) = 1$. Luego, $w(f) < w(e)$, y el algoritmo de Kruskal con selección vio primero a $f$. Sea $j$ el paso en el que el algoritmo vio (y decidió agregar) a $e$, e $i$ el paso en el que el algoritmo vio a $f$. Tenemos que $j > i$. Dada una iteración $t$, sea $F_t$ el conjunto de aristas que el algoritmo agregó al comenzar la iteración $t$. Tenemos que $F_t subset.eq F_(t+r)$ para todo $r gt.eq 1$. Como $j > i$, tenemos que $F_i subset.eq F_j$. El algoritmo de Kruskal con selección va a agregar a una arista $x$ si y sólo si, al verla en un paso $k$, $x$ no genera ciclos con $F_k$.

      Como $e$ es la primer arista que el algoritmo agrega que no está en $T$, entonces $F_j subset.eq T$ (y $F_(j+1) subset.eq.not T$). Como $f in T$, y $T$ es un árbol, $f$ no genera ciclos con nadie en $T$, menos aún con aristas en $F_j$, y como $F_i subset.eq F_j$, menos aún va a generar ciclos con $F_i$. Luego, al ver a $f$ en el paso $i$, el algoritmo pudo haber agregado a $f$, y no lo hizo, pero eso no puede pasar.

      Luego, $e$ no existe, y $K = T$.]

    #lemma[El algoritmo de Prim con selección devuelve $T$.]
    #proof[Sea $P$ el árbol generador que construye el algoritmo de Prim con selección. Recordemos que este algoritmo mantiene una partición $(S_i, overline(S_i))$ de $V(G)$, y un conjunto de aristas $F_i$, donde $F_i$ genera $S_i$ (la componente conexa). Inicialmente $S_0 = {v_0}$ para algún $v_0$ arbitrario, y $F_0 = emptyset$. En cada iteración, el algoritmo busca la arista de mínimo $w$ que cruza la partición. Si esta arista es ${u, v}$, con $u in S_i$ y $v in.not S_i$, tenemos $S_(i+1) = S_i union {v}$, y $F_(i+1) = F_i union {e}$. El algoritmo se detiene cuando $S_(n-1) = V(G)$, y devuelve $F_(n-1)$, donde $n = |V(G)|$.

      Asumimos que $P eq.not T$. Luego, existe una primer arista $e$ que el algoritmo agregó a la componente conexa, que no está en $T$. Sean ${u, v} = e$ los extremos de $e$. Asumimos sin pérdida de generalidad que $u$ es el extremo que está en $S_i$, y $v$ el extremo que está en $overline(S_i)$. Entonces, tenemos $S_(i+1) = S_i union {v}$, $F_(i+1) = F_i union {e}$.

      Como $T$ es un árbol generador, pero $e in.not T$, existe un (único) camino $Q$ en $T$ entre $u$ y $v$. Como $u$ y $v$ están en diferentes lados de la partición $(S_i, overline(S_i))$, entonces en $Q$ existe alguna arista $f$ que cruza la partición. Consideremos entonces $T' = (T without {f}) union {e}$. Esto es un árbol generador, por haber separado a $T$ en dos pedazos cuando sacamos $f$, uno que genera $S$ y otro que genera $overline(S)$, y luego haberlos juntado al agregar $e$. Como $T$ es un árbol generador mínimo, tenemos que $p(T) lt.eq p(T') = p(T) - p(f) + p(e)$, con lo cual $p(e) gt.eq p(f)$.

      Como $f$ está en $T$, tenemos que $q_T (f) = 0$. Como $e$ no está en $T$, tenemos que $q_T (e) = 1$. Como $p(f) lt.eq p(e)$, y $q_T (f) < q_T (e)$, tenemos que $w(f) < w(e)$. Como ambas aristas cruzan la partición $(S_i, overline(S_i))$, al considerar la arista $e$, el algoritmo también consideró la arista $f$. Pero entonces, el algoritmo no eligió a la arista que cruza la partición, de menor $w$. Esto no puede suceder.

      Luego, $e$ no existe, y $P = T$.]
  + Lo que nos dice el ejercicio anterior es que para todo árbol generador mínimo $T$, ambos el algoritmo de Kruskal y el algoritmo de Prim tienen ejecuciones que devuelven $T$, dependiendo sólo de cómo se desempata cuando encuentran aristas del mismo peso, en cada ejecución. Es decir, el conjunto de resultados posibles del algoritmo de Kruskal sobre $G$ (resp. Prim), es igual al conjunto de árboles generadores mínimos de $G$

    Luego, si para un grafo $G$ en ningún momento hace falta desempatar, porque todos los pesos de las aristas de $G$ son distintos, entonces en toda ejecución el resultado del algoritmo de Kruskal (resp. Prim) es único.

    Como el conjunto de árboles generadores mínimos es igual al conjunto de resultados de correr estos algoritmos, y este último tiene un sólo elemento cuando los pesos de $G$ son todos distintos, entonces $G$ tiene un único árbol generador mínimo.
]
#load-bib()