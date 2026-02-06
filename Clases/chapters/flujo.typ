
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Flujo
#defi[
  Una *red de flujo* $G$ es una 5-tupla $G = (V, E, s, t, c)$, tal que $(V, E)$ es un grafo, $s in V, t in V$, y $c: E arrow RR_(gt.eq 0)$.

  Un *flujo* en tal red es una función $f: E arrow RR_(gt.eq 0)$, tal que:

  - $0 lt.eq f(e) lt.eq c(e)$ para todo $e in E$.
  - Para todo $v in V without {s, t}$, $sum_(u in V) f(u, v) = sum_(u in V) f(v, u)$.

  En tal caso decimos que el *valor de $f$* es $|f| = sum_(v in V) f(s, v) - sum_(v in V) f(v, s)$. Un flujo se dice *máximo* cuando tiene valor máximo entre todos los flujos en $G$.

  Dada una tal red de flujo, un *corte* es una partición de $V$ en $(S, T)$, tal que $s in S$, y $t in T$. Dado un flujo $f$ en esa red, el *flujo neto de $(S, T)$* se define como $f(S, T) = sum_(u in S, v in T) f(u, v) - sum_(u in S, v in T) f(v, u)$. La *capacidad de $(S, T)$* se define como $c(S, T) = sum_(u in S, v in T) c(u, v)$.
]
#ej[
  Sea $G = (V, E, s, t, c)$ una red de flujo, y $f$ un flujo máximo en $G$. Sea $lambda in RR_(> 0)$. Definimos $c'$ como $c'(x) = lambda c(x)$ para todo $x in E$.

  Sea $f'$ un flujo máximo en $G' = (V, E, s, t, c')$.

  Demostrar que $|f'| = lambda |f|$.
]
#demo[
  Vamos a construir una biyección explícita $phi$ entre flujos en $G$, y flujos en $G'$.

  Sea $f: E arrow RR_(gt.eq 0)$ un flujo en $G$. Definimos $phi(f): E arrow RR_(gt.eq 0)$ como $phi(f)(e) = lambda f(e)$ para todo $e in E$. Notemos que $phi(f)$ es un flujo en $G'$, pues como $f$ es un flujo en $G$, sabemos que $0 lt.eq f(e) lt.eq c(e)$ para todo $e in E$, y luego $0 lt.eq phi(f)(e) = lambda f(e) lt.eq lambda c(e) = c'(e)$ para todo $e in E$. Además, como $f$ es un flujo, tenemos que para todo $v in V without {s, t}$, se cumple que $sum_(u in V) f(u, v) = sum_(u in V) f(v, u)$, y luego $sum_(u in V) phi(f)(u, v) = lambda sum_(u in V) f(u, v) = lambda sum_(u in V) f(v, u) = sum_(u in V) phi(f)(v, u)$, y luego $phi(f)$ es un flujo en $G'$.

  Notamos que $phi$ es monótona en valores. Es decir, si $|f| gt.eq |g|$, entonces $|phi(f)| = lambda |f| gt.eq lambda |g| = |phi(g)|$. Luego, si $f$ es un flujo máximo en $G$, entonces $phi(f)$ es un flujo máximo en $G'$. Entonces si $f'$ es el valor de cualquier flujo máximo en $G'$, tenemos que $|f'| = |phi(f)| = lambda |f|$, y luego $|f'| = lambda |f|$, que es lo que queríamos demostrar.
]

#ej[
  Sea $G = (V, E, s in V, t in V, c: E arrow RR_(gt.eq 0))$ una red de flujo. Sea $f: E arrow RR_(gt.eq 0)$ un flujo en $G$. Sea $(S, T)$ un corte en $G$.

  Mostrar que $|f| = f(S, T) lt.eq c(S, T)$.
]
#demo[
  Como $f$ es un flujo, sabemos que para todo $u in V without {s, t}$, tenemos $sum_(v in V) f(u, v) = sum_(v in V) f(v, u)$. Esto es lo mismo que decir $0 = sum_(v in V) f(u, v) - sum_(v in V) f(v, u)$. Por definición, $|f| = sum_(v in V) f(s, v) - sum_(v in V) f(v, s)$. Si a esta última ecuación le sumamos la primera, por todo $u in S without {s}$, tenemos que
  $
    |f| &= sum_(v in V) f(s, v) - sum_(v in V) f(v, s) + sum_(u in S without {s}) (sum_(v in T) f(u, v) - sum_(v in T) f(v, u))\
    &= sum_(v in V) f(s, v) - sum_(v in V) f(v, s) + sum_(u in S without {s}) sum_(v in T) f(u, v) - sum_(u in S without {s}) sum_(v in T) f(v, u)\
    &= sum_(v in V) (f(s, v) sum_(u in S without {s}) f(u, v)) - sum_(v in V) (f(v, s) + sum_(u in S without {s}) f(v, u))\
    &= sum_(v in V) sum_(u in S) f(u, v) - sum_(v in V) sum_(u in S) f(v, u)\
    &"Ahora usamos que "V = S union.sq T,\
    &= (sum_(v in S) sum_(u in S) f(u, v) + sum_(v in T) sum_(u in S) f(u, v)) - (sum_(v in S) sum_(u in S) f(v, u) - sum_(v in T) sum_(u in S) f(v, u))\
    &= sum_(v in T) sum_(u in S) f(u, v) - sum_(v in T) sum_(u in S) f(v, u)\
    &= f(S, T)
  $

  Para ver una cota superior de $f(S, T)$, basta usar sólo la primer sumatoria:

  $
    |f| &= f(S, T) \
    &= sum_(v in T) sum_(u in S) f(u, v) - sum_(v in T) sum_(u in S) f(v, u)", al ser "f(v, u) gt.eq 0" "forall" " v, u in V\
    &lt.eq sum_(v in T) sum_(u in S) f(u, v)\
    &lt.eq sum_(v in T) sum_(u in S) c(u, v)\
    &= sum_(u in S, v in T) c(u, v)\
    &= c(S, T)
  $]

#ej[
  Sea $G = (V, E, s, t, c)$ una red de flujo, y $f$ un flujo máximo en $G$. Sea $n = |V|, m = |E|$. Ahora elegimos un $e in E$, y construímos $G' = (V, E, s, t, c')$, tal que:

  $
    c'(x) = cases(
      c(x) & " si "x eq.not e,
      c(x) + 1 & " si " x = e
    )
  $

  Dar un algoritmo que encuentre un flujo máximo en $G'$. El algoritmo debe hacer $O(n + m)$ operaciones en el peor caso. Demostrar que el algoritmo es correcto.
]
#demo[
  Primero vamos a citar dos teoremas que ven en la teórica.

  #teo[
    Sea $G$ una red de flujo, y $f$ un flujo en $G$. Sea $G_f$ la red residual. $f$ es un flujo máximo en $G$ si y sólo si $G_f$ no tiene caminos de aumento.
  ]<teo:aumento>

  Por el teorema de flujo máximo - corte mínimo, como $f$ es un flujo máximo, existe un corte $(S, T)$ en $G$ tal que $|f| = c(S, T)$. Veamos ahora cuál es la capacidad del corte $(S, T)$ en $G'$. Si $e$ no cruza la partición $(S, T)$, entonces $c'(S, T) = c(S, T)$. Si $e$ cruza la partición, entonces $c'(S, T) = c(S, T) + 1$. En ambos casos, tenemos que $c(S, T) lt.eq c'(S, T) lt.eq c(S, T) + 1 = |f| + 1$.

  Como $f$ es un flujo en $G$, también es un flujo en $G'$, puesto que las condiciones de sumatoria en cada vértice se siguen cumpliendo, y las condiciones de capacidad también (pues meramente _agregamos_ capacidad a $e$). Podemos entonces construir la red residual de $f$, $G'_f$.

  Esto nos sugiere correr una iteración más del algoritmo de Edmonds-Karp en $G'_f$, y si encontramos un camino de aumento $P$, podemos aumentar el flujo en $f$ en $c(P)$, obteniendo un flujo $f'$, y luego $|f'| = |f| + c(P) = |f| + min_(e in P) c(e)$. Como vimos, $|f'| lt.eq |f| + 1$, entonces $c(P)$ va a ser $1$, si $P$ existe, pues todos los flujos encontrados por Edmonds-Karp son de enteros, siendo las capacidades de$G'$ enteros. Si no encontramos un camino, por el @teo:aumento $f$ es un flujo máximo en $G'$, y luego $|f'| = |f|$.]


#load-bib()