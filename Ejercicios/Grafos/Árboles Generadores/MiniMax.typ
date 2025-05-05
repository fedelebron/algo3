= AGM $arrow.l.r.double$ Minimax

== Proposiciones

*Proposición 1*. Sea $T = (V, E)$ un árbol, y $u, v in V$. Entonces existe un único camino en $T$ entre $u$ y $v$.

*Demostración*. Existe al menos un camino en $T$ entre $u$ y $v$ porque $T$ es un árbol, a fortiori conexo. Asumamos, por el contrario, que existen dos caminos $P, P' subset.eq T$, entre $u$ y $v$, con $P eq.not P'$. Van a tener algún prefijo y sufijo de vértices en común, al menos ambos empiezan con $c_1 = u$ y terminan con $d_f = v$. Sea $k$ la longitud del prefijo en común, y $f$ la longitud del sufijo en común. Escribimos:

$
P &= [{c_1, c_2}, dots, {c_(k-1), c_k}, x_1, dots, x_s, {d_1, d_2}, dots, {d_(f-1), d_f}]\
P' &= [{c_1, c_2}, dots, {c_(k-1), c_k}, y_1, dots, y_t, {d_1, d_2}, dots, {d_(f-1), d_f}]
$

Como $x_1 eq.not y_1$ y $x_s eq.not y_t$, tenemos que $C = [c_k, x_1, dots, x_s, d_1, y_t, dots, y_1, c_k]$ es un circuito. Luego, $C$ contiene al menos un ciclo. Esto no puede pasar, dado que $C subset.eq T$, y $T$ siendo árbol no contiene ciclos.

Luego, no existen tales caminos distintos, y tenemos que existe un único tal camino.


*Proposición 2*. Sea $G = (V, E)$ un grafo, $u, v in V$, $T$ un árbol generador de $G$, $P$ el único camino en $T$ de $u$ a $v$, y $e in P$ una arista. Entonces $T - e$ es un bosque con dos árboles $T_1$ y $T_2$, con $u in T_1$, $v in T_2$.

*Demostración*. Que $T - e$ es un bosque sale de que $T$ era un árbol, luego acíclico, y luego sacarle una arista sigue siendo acíclico. Por la *Proposición 1*, sabemos que en $T$ había una única forma de llegar de $u$ a $v$, y era $P$. Si sacamos $e in P$ de $T$, ahora $P$ no existe más en $T - e$, y luego $u$ y $v$ están desconectados. Luego $e$ era una arista puente, y remover una arista puente de un grafo conexo deja dos componentes conexas.

Luego tenemos que $T - e$ es un grafo acíclico con dos componentes conexas, y luego es un bosque con dos árboles.


Si $u$ y $v$ estuvieran en la misma componente conexa, habría un camino $P^*$ en $T - e$ que va de $u$ a $v$, pero este camino existía ya con más razón en $T$ (porque $T'$ es subgrafo de $T$), y $P^* eq.not P$, puesto que $e in P$, $e in.not P^*$. Luego en $T$ hay dos caminos distintos entre $u$ y $v$, lo cual contradice la *Proposición 1*. Luego, $u$ y $v$ están uno en cada árbol de $T - e$.

*Proposición 3*. Sea $G = (V, E)$ un grafo, $(V_1, V_2)$ una partición de $V$, tal que $V = V_1 union V_2$, y $V_1 inter V_2 = emptyset$. Sean $v_1 in V_1, v_2 in V_2$, y $P$ un camino en $G$ entre $v_1$ y $v_2$. Entonces $P$ tiene al menos una arista $e = {u, w}$ tal que $u in V_1, w in V_2$.

*Demostración*. Consideremos la lista de vértices de $P$:

$
P = [v_1 = x_1, x_2, dots, x_(k - 1), x_k = v_2]
$

Como ${V_1, V_2}$ particiona $V$, cada uno de los $x_i$ está en $V_1$ o $V_2$. Luego, consideremos a quién pertenece cada vértice. $x_1 = v_1 in V_1$, y $x_k = v_2 in V_2$. No puede pasar que $V(P) subset.eq V_1$, porque $v_2 in V(P)$, y $v_2 in.not V_1$. Tampoco puede pasar que $V(P) subset.eq V_2$, porque $v_1 in V(P)$, y $v_1 in.not V_2$. Luego, como no pueden estar todos en $V_1$ ni todos en $V_2$, y empezamos en $V_1$, en algún momento tiene que haber una arista ${x_i, x_(i+1)}$, donde $x_i in V_1$, y $x_(i+1) in V_2$.

*Notación*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$, y $X$ un conjunto de aristas. Notamos *$display(C(X) = sum_(e in X) c(e))$*.

*Notación*. Sean $A$ y $B$ conjuntos disjuntos. Se nota *$A union.sq  B$* a la unión disjunta de $A$ y $B$. Es decir, $A union.sq  B = A union B$, y además sabemos que $A$ y $B$ son disjuntos.

*Notación*. Sean $A$ y $B$ conjuntos. Notamos *$Delta(A, B) = (A without B) union.sq  (B without A)$* a la diferencia simétrica entre $A$ y $B$.

*Proposición 4*. Sean $A$ y $B$ conjuntos de igual tamaño $|A| = |B|$. Entonces:

  1. $|A without B| = |B without A|$.
  2. $|Delta(A, B)|$ es par.
  3. Si $Delta(A, B) eq.not emptyset$, entonces $(A without B) eq.not emptyset$ y $(B without A) eq.not emptyset$.

*Demostración*. Usemos esta imagen para recordar cómo funcionan las uniones e intersecciones.

#figure(
  image("venn.png", width: 60%),
)

Sabemos que $A = (A without B) union.sq  (A inter B)$, y $B = (B without A) union.sq  (A inter B)$. Llamando a $|A without B| = alpha$, $|B without A| = beta$, y $|A inter B| = gamma$, tenemos que $|A| = alpha + gamma$, y $|B| = beta + gamma$. Como $|A| = |B|$, tenemos que $alpha + gamma = beta + gamma$. Luego, $alpha = beta$, es decir, $|A without B| = |B without A|$.
Para el segundo punto, como $Delta(A, B) = (A without B) union.sq  (B without A)$, tenemos que $|Delta(A, B)| = |(A without B)| + |(B without A)| = alpha + beta = 2 alpha = 2 beta$, luego es par.
Finalmente, si $Delta(A, B) eq.not emptyset$, entonces $|Delta(A, B)| = 2alpha = 2beta > 0$, luego $alpha = beta > 0$, y luego $(A without B) eq.not emptyset$, como también $(B without A) eq.not emptyset$.

*Definición*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$. Para cada camino $p$ en $G$, definimos *$display(c^*(p) = max_(e in p){c(e)})$* como el peso de la arista más pesada en $p$.

*Definición*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$, y $u, v in V$. Un camino $p$ en $G$ que va desde $u$ a $v$ se llama *minimax en $G$* si y sólo si para todo otro camino $p'$ en $G$ que va desde $u$ a $v$, $c^*(p') gt.eq c^*(p)$. Es decir, $p$ minimiza el peso de la arista más pesada, entre todos los caminos de $u$ a $v$ en $G$.

*Definición*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$, y $T$ un árbol generador de $G$. Si para todo par de vértices $u, v$ en $V$, el único camino en $T$ es minimax en $G$, entonces $T$ se conoce como un *árbol minimax*.

== $T$ es AGM $arrow.r.double$ $T$ es árbol minimax

*Proposición 5*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$, $T$ un árbol generador mínimo de $G$, $u, v in V$, y $P$ el único camino en $T$ desde $u$ a $v$. Entonces $P$ es minimax en $G$. Como corolario, $T$ es un árbol minimax.

*Demostración*. En lo que sigue, pueden tener las siguientes imágenes para guiarse, si se pierden en la prosa o el álgebra.

#figure(
  image("agm.jpeg", width: 50%),
)

Sea $P'$ cualquier camino en $G$ entre $u$ y $v$. Queremos ver que $c^*(P) lt.eq c^*(P')$. Es decir, que la arista más pesada de $P$, es tan o más ligera que la arista más pesada de $P'$. Como corolario, vamos a tener que si $P'$ es minimax, entonces $P$ también lo es. Como $P'$ es arbitrario entre $u$ y $v$, vamos a poder _elegirlo_ minimax, y tenemos que cualquier camino en un árbol generador mínimo entre $u$ y $v$ también va a ser minimax en $G$.

Asumamos que no es cierto, y que $c^*(P) > c^*(P')$. Luego, sea $e in P$ una arista de máximo peso en $P$. Entonces tenemos que, para toda arista $e' in P'$:

$
c(e) &= c^*(P) & "por definición de " c^*(P)\
     &> c^*(P') & "asumido"\
     &gt.eq c(e') & "por definición de " c^*(P')
$

Es decir, todas las aristas de $P'$ son estrictamente más ligeras que $e$.

Consideremos $T' = T - e$. Por la *Proposición 2*, $T'$ es un bosque con dos árboles, y $u$ y $v$ están uno en cada una de las dos componentes conexas.

Como $u$ y $v$ están en componentes conexas distintas en $T'$, podemos particionar los vértices de $T'$ en los vértices que están en una de las componentes, y los que están en la otra. Entonces, por la *Proposición 3*, existe una arista $e' in P'$ que cruza las componentes conexas.

Consideremos $T'' = T' + e' = T - e + e'$. Como $e'$ cruza las únicas dos componentes conexas que había en $T' = T - e$, tenemos que $T''$ es nuevamente un árbol. Como $T''$ es subgrafo de $G$, y tiene $|V|$ vértices, es un árbol generador de $G$. Ahora veamos la suma de pesos de $T''$:

$
C(T'') &= C(T' + e')\ 
       &= C(T') + c(e') \
       &= C(T - e) + c(e') \
       &= C(T) - c(e) + c(e')
$

Pero como sabíamos, $c(e) > c(e')$. Luego, $- c(e) + c(e') < 0$, y $C(T'') < C(T)$.

Tenemos que $T''$ es un árbol generador de $G$, con suma de pesos estrictamente menor que $T$, que era un árbol generador mínimo de $G$. Esto es absurdo, por definición de árbol generador mínimo.

Luego, no puede pasar que $c^*(P) > c^*(P')$, y tenemos que $c^*(P) lt.eq c^*(P')$, que es lo que queríamos demostrar.

== $T$ es árbol minimax $arrow.r.double$ $T$ es AGM

*Proposición 6*. Sea $G = (V, E)$ un grafo pesado por $c:E arrow RR$, $T$ un árbol generador minimax de $G$. Entonces $T$ es un árbol generador mínimo de $G$.

*Demostración*. Sea $T'$ un árbol generador mínimo que minimiza $|Delta(T, T')|$, entre todos los árboles generadores mínimos. Si $|Delta(T, T')| = 0$, entonces $T = T'$ y $T$ también es un árbol generador mínimo. Si no, $|Delta(T, T')| > 0$, y por la *Proposición 4*, existe un $e' = {u, v} in T' without T$. Consideremos $T'' = T' - e'$. Por la *Proposición 2*, esto es un bosque con dos árboles $T_A$ y $T_B$, con $u$ en un árbol y $v$ en el otro. Llamemos $A = V(T_A)$, $B = V(T_B)$, donde $V = A union.sq  B$ es una partición de $V$. Por la *Proposición 1*, en $T$ existe un (único) camino $P$ de $u$ a $v$, y obviamente este camino existe en $G$, puesto que $T$ es subgrafo de $G$. Por la *Proposición 3*, este camino tiene que cruzar al menos una vez la partición $(A, B)$. Sea $e in P subset.eq T$ una tal arista que cruza. Vemos que $e eq.not e'$, dado que $e' in T' without T$, y $e in T$. Vemos también que $e in.not T'$, puesto que si $e in T'$, no hubieramos desconectado $(A, B)$ al sacar $e'$ de $T'$, dado que $e$ seguiría en $T' - e'$, conectando $A$ y $B$.

Como $e$ cruza la partición $(A, B)$ en $T''$, conecta los dos árboles $T_A$ y $T_B$, y tenemos que $T''' = T'' + e = T' - e' + e$ es un árbol. $T'''$ también es generador porque $|T'''| = |T'|$ y $T'$ es generador. 

Como $e' = {u, v}$ es un camino en $G$ entre $u$ y $v$, y $P$ es un camino en $T$ de $u$ a $v$ con $T$ minimax, tenemos que
$
c(e') &= c^*(e') & "por definición de "c^* \
      &gt.eq c^*(P) & " porque " T " es minimax "\
      &gt.eq c(e) & "por definición de "c^*(P)
$
Luego, $c(e) lt.eq c(e')$. Finalmente, $T'''$ tiene peso $C(T''') = C(T') - c(e') + c(e) lt.eq C(T')$, con $T'$ un árbol generador mínimo, y luego $C(T''') = C(T')$. Luego $T'''$ es un árbol generador mínimo, con $|Delta(T, T''')| = |Delta(T, T')| - 2 < |Delta(T, T')|$, porque al crear $T'''$, le sacamos a $T'$ una arista $e'$ que estaba en $T'$ y no en $T$ (reduciendo la diferencia simétrica en 1), y le pusimos una arista $e$ que estaba en $T$ y no en $T'$ (nuevamente reduciendo la diferencia simétrica en 1). Pero $T'$ minimizaba $|Delta(T, T')|$, entonces no puedo haber llegado a este caso, y, tiene que haber sido el caso de la primer oración, donde $|Delta(T, T')| = 0$, y luego $T$ es un árbol generador mínimo.