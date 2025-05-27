#import "@preview/theorion:0.3.3": *
#import cosmos.fancy: *
// #import cosmos.rainbow: *
// #import cosmos.clouds: *
#show: show-theorion


#set text(
  lang: "es"
)
#let colred(x) = text(fill: red, $#x$)
#let colgreen(x) = text(fill: green, $#x$)
#let colblue(x) = text(fill: blue, $#x$)
// 3. Custom theorem environment for yourself
#let (ej-counter, ej-box, ej, show-ej) = make-frame(
  "ej",
  theorion-i18n-map.at("exercise"),  // supplement, string or dictionary like `(en: "Theorem")`, or `theorion-i18n-map.at("theorem")` for built-in i18n support
  counter: theorem-counter,  // inherit the old counter, `none` by default
  render: fancy-box.with(
    get-border-color: get-tertiary-border-color,
    get-body-color: get-tertiary-body-color,
    get-symbol: get-tertiary-symbol,
  ),
)
#show: show-theorem
#show: show-ej

#definition[Sea $G = (V, E)$ un grafo dirigido con función de pesos $c: E arrow NN$. Sea $d$ la función de distancia inducida por $f$, que nos da la longitud de un camino mínimo entre un par de vértices.

Decimos que una arista $e = (v, w)$ es $s$-$t$ _eficiente_ cuando $e$ pertenece a algún camino mínimo en $G$ entre $s$ y $t$.]
#lemma(title:"Subestructura óptima de caminos mínimos")[Sea $G = (V, E)$ un grafo dirigido pesado por una función $c: E arrow RR$. Sean $s, t in V$, y $P = s, u_1, u_2, dots, u_r, t$ un camino en $G$ entre $s$ y $t$, de longitud mínima entre todos los tales caminos. Sea $Q = u_i, u_(i+1), dots, u_j$ un sub-camino de $P$. Entonces $Q$ es un camino mínimo entre $u_i$ y $u_j$.]<opt>
#proof[
  Podemos dividir a $P$ en tres sub-caminos, que vamos a llamar $A = s arrow.squiggly u_i$, $Q = u_i arrow.squiggly u_j$, y $B = u_j arrow.squiggly t$. Notar que cualquiera de estos puede ser trivial, es decir, tener cero aristas.
  
  Vamos a notar la longitud de un camino $X$ como $|X|$. Entonces, vemos que $|P| = |A| + |Q| + |B|$. Como $P$ es un camino mínimo entre $s$ y $t$, y $d$ nos fa la longitud de un camino mínimo, tenemos que $|P| = d(s, t)$.

  Queremos probar que $|Q| = d(u_i, u_j)$. Para probar que dos números son iguales, podemos probar que cada uno es mayor o igual que el otro.
  + Como $d(u_i, u_j)$ es la longitud del camino más corto entre $u_i$ y $u_j$, y $Q$ es _un_ camino entre $u_i$ y $u_j$, y , entonces $|Q| gt.eq d(u_i, u_j)$.
  + Sea $Q'$ un camino mínimo entre $u_i$ y $u_j$. Entonces $|Q'| = d(u_i, u_j)$. Consideremos $P$, pero reemplazando $u_i arrow.squiggly u_j$ (es decir, $Q$) por $Q'$. Llamemos a este camino $P'$. Tenemos que $|P'| = |A| + |Q'| + |B|$. Como $P$ es un camino mínimo entre $s$ y $t$, y $P'$ es _un_ camino entre $s$ y $t$, tenemos que $|P| lt.eq |P'|$. Con un poco de aritmética:
    $
      |P| &lt.eq |P'| \
      |A| + |Q| + |B| &lt.eq |A| + |Q'| + |B| \
      |Q| &lt.eq |A| + |Q'| + |B| - |A| - |B| \
      |Q| &lt.eq |Q'| \
      &= d(u_i, u_j)
    $

    Por lo tanto, $|Q| &lt.eq d(u_i, u_j)$.
  Como vale que $|Q| &gt.eq d(u_i, u_j)$, y $|Q| &lt.eq d(u_i, u_j)$, tenemos que $|Q| = d(u_i, u_j)$, y por lo tanto $Q$ es un camino mínimo entre $u_i$ y $u_j$. 
]

#ej[Probar que una arista $e = (v, w)$ es $s$-$t$ eficiente sí y sólo sí $d(s, v) + c(v, w) + d(w, t) = d(s, t)$.]

#proof[Para mostrar un sí y sólo sí, tenemos que mostrar la ida ($arrow.double$) y la vuelta ($arrow.l.double$).
  - $arrow.double.r$) Sabemos que $e = (v, w)$ es $s$-$t$ eficiente. Es decir, sabemos que existe en $G$ un camino entre $s$ y $t$, de mínima distancia entre todos los tales caminos, y que $e in P$. Escribamos quién es $P$:
    $
    P = s, u_1, u_2, dots, u_k, v, w, u_(k+1), u_(k+2), dots, u_r, t
    $

    Para algunos $u_1, dots, u_r$ en $V$. Esto se divide en tres sub-caminos:
    + $A = s, u_2, u_2, dots, u_k, v$
    + $B = v, w$
    + $C = w, u_(k+1), u_(k+2), dots, u_r, t$

    y tenemos que la longitud de $P$ es la suma de las longitudes de estos sub-caminos, $|P| = |A| + |B| + |C|$. Usando el @opt, y que $A$ y $C$ son sub-caminos de un camino mínimo $P$, tenemos que $A$ y $C$, son caminos mínimos entre $s$ y $v$, y entre $w$ y $t$, respectivamente.
  
    Luego, por cómo definimos $d$, $|A| = d(s, v)$, y $|C| = d(w, t)$. Como $B$ es sólo una arista, $v arrow w$, tenemos que $|B| = c(v, w)$. Tenemos entonces que $|P| = |A| + |B| + |C| = d(s, v) + c(v, w) + d(w, t)$, que es lo que queríamos demostrar.
  
  - $arrow.double.l$) Sabemos que $d(s, t) = d(s, v) + c(v, w) + d(w, t)$. Queremos ver que $e = (v, w)$ es $s$-$t$ eficiente.

    Encontremos, entonces, un camino mínimo $P$, entre $s$ y $t$, que incluya $e$.

    Como $d(s, v)$ es la mínima distancia entre todos los caminos entre $s$ y $v$, sea $A$ un tal camino mínimo entre $s$ y $v$, con $|A| = d(s, v)$. De la misma manera, sea $B$ un camino mínimo entre $w$ y $t$, de longitud $|B| = d(w, t)$.

    Consideremos $P = A, B$, concatenando los caminos. Notamos que como $v$ es el último vértice de $A$, y $w$ es el primer vértice de $B$, tenemos que $(v, w) = e in P$, y que $|P| = |A| + c(v, w) + |B|$. Por cómo construímos $A$ y $B$, podemos reemplazar sus distancias en esta última ecuacion, obteniendo $|P| = d(s, v) + c(v, w) + d(w, t)$. Pero sabíamos que $d(s, v) + c(v, w) + d(w, t) = d(s, t)$. Luego, sabemos que $|P| = d(s, t)$, con $P$ un camino entre $s$ y $t$, y luego $P$ es un camino mínimo entre $s$ y $t$.

    Como $P$ es un camino mínimo entre $s$ y $t$, y $e in P$, vemos que $e$ pertenece a un camino mínimo entre $s$ y $t$, y luego $e$ es $s$-$t$ eficiente, que es lo que queríamos demostrar.
]