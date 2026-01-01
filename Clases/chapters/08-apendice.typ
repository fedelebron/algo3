// Chapter 8: Apéndice
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble
= Apéndice

== Demostración del Teorema Maestro <demo:master>

Primero unos lemmas elementales.
#lemma[
Para todo $x in RR$ con $x gt.eq 1$, se cumple
$floor(x) gt.eq x/2$.
]<lemma:piso-mitad>
#demo[
Si $1 lt.eq x lt 2$, entonces $floor(x)=1 gt.eq x/2$.
Si $x gt.eq 2$, entonces $floor(x) gt.eq x-1$ y $x-1 gt.eq x/2$ (pues $x gt.eq 2$).
]

#lemma[
Para todo $x in RR$ con $x gt.eq 1$, se cumple
$ceil(x) lt.eq 2x$.
]<lemma:techo-doble>
#demo[
Si $1 lt.eq x lt 2$, entonces $ceil(x) lt.eq 2 = 2 dot 1 lt.eq 2x$.
Si $x gt.eq 2$, entonces $ceil(x) lt.eq x+1 lt.eq 2x$ (pues $x gt.eq 1$).
]

#lemma[
Sean $x, y, z in RRg0$, con $y eq.not 1$. Entonces $x^(log_y z) = z^(log_y x)$.
]<lemma:logaritmo-cambio-base>
#demo[
Sabemos que $x = y^(log_y x)$, por definición del logaritmo. Entonces $x^(log_y z) = y^(log_y x dot log_y z) = y^(log_y z dot log_y x) = z^(log_y x)$.
]


#teo(title:[Teorema maestro (versión piso)])[
Sea $T: NN arrow RR0$ una función tal que:

$
  T(n) = cases(
    b_n &"si" 0 lt.eq n < n_0,
    a_1 T(floor(n/b)) + a_2 T(ceil(n/b)) + f(n) &"si" n gt.eq n_0
  )
$

para alguna función $f: NN arrow RR0$, algunas constantes $b_0, dots, b_(n_0-1) in RR0$, $a_1, a_2 in NN$, $b in NN gt.eq 2$, $n_0 in NN$, y asumiendo $n_0 gt.eq 2$ si $a_2 > 0$ para estar bien definida. Llamemos $a = a_1 + a_2$, y $c = log_b a$. Entonces:

- Si $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$, entonces $T in Theta(n^(c))$.
- Si $f in Theta(n^(c) log^k n)$ para algún $k in NN$, entonces $T in Theta(n^(c) log^(k+1) n)$.
- Si $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$, y además existen $n_1 in NN$ y $r < 1 in RR0$ tal que $a_1 f(floor(n/b)) + a_2 f(ceil(n/b)) lt.eq r f(n)$ para todo $n gt.eq n_1$, entonces $T in Theta(f)$.
]
#demo[
Si $n_0 = 1$, entonces el caso $a_2 > 0$ está mal definido, pues $T(ceil(1/b)) = T(1)$, que crearía un ciclo en la definición. Sin pérdida de generalidad, asumimos $n_0 gt.eq 2$. Si tuviésemos $n_0 = 1$, podríamos definir una nueva recurrencia $T'$ idéntica a $T$ pero con $n_0' = 2$, extendiendo los casos base (por ejemplo, definiendo $T'(1) = T(1)$ explícitamente como base). Como tendríamos $T'(n) = T(n)$ para todo $n$, $T in Theta(f) iff T' in Theta(f)$. Esta asunción nos asegura que en los pasos recursivos los argumentos son mayores o iguales a 2, y que términos como $log (n_0 - 1)$ están bien definidos.

Vamos a definir dos funciones, una que acota $T$ por arriba, y otra por abajo.
$
  V(n) &= cases(
    k_min "si" n < n_0,
    a V(floor(n/b)) + f(n) "si" n gt.eq n_0
  )\
  W(n) &= cases(
    k_max "si" n < n_0,
    a W(ceil(n/b)) + f(n) "si" n gt.eq n_0
  )
$
con $k_min = min {b_0, dots, b_(n_0-1)}$ y $k_max = max {b_0, dots, b_(n_0-1)}$. Sin pérdida de generalidad, asumimos $k_min > 0$. Si no, podemos extender el conjunto de casos base considerando $T(n_0), T(n_0+1), dots$ (calculados mediante la recurrencia) hasta encontrar al menos un valor positivo. Tal valor debe existir, pues de lo contrario $T$ sería idénticamente cero, lo cual es trivial y no requiere el teorema maestro. Por #xref(<teo:domrec>) y #xref(<teo:domrecmin>), sabemos que $V(n) lt.eq T(n) lt.eq W(n)$ para todo $n in NN$.

Viendo el árbol de recursión de $V$, vemos que cada vez, $n$ se transforma en $floor(n/b)$. Como $floor(floor(n/b)/b) = floor(n/b^2)$, vemos que el valor en el $j$-ésimo nivel será $floor(n/b^j)$. Análogamente, el valor en el $j$-ésimo nivel de $W$ será $ceil(n/b^j)$.

Sea $d_v$ el mínimo $k$ tal que $floor(n/b^k) < n_0$, y $d_w$ el mínimo $k$ tal que $ceil(n/b^k) < n_0$. Estas son las alturas de los árboles de recursión de $V$ y $W$, respectivamente.

#lemma[
Sea $n gt.eq n_0$. Entonces:
- $d_v > log_b n - log_b n_0$
- $d_w lt.eq log_b n - log_b (n_0 - 1) + 1$
]
#demo[
Para todo $x in RR0$, si $floor(x) < n_0$, entonces $x < n_0$. Luego, usando la definición de $d_v$ sabemos que $n/b^(d_v) < n_0$. Por lo tanto, $b^(d_v) > n/n_0$, y tomando logaritmos, $d_v = log_b (b^(d_v)) > log_b (n/n_0)$. Esto nos da una cota inferior, $d_v > log_b n - log_b (n_0)$.

Por otro lado, $d_w$ es el mínimo entero que cumple $ceil(n/b^(d_w)) < n_0$. Luego, $ceil(n/b^(d_w - 1)) gt.eq n_0$. Luego, $n/b^(d_w - 1) gt.eq n_0 - 1$, y tomando logaritmos, obtenemos $d_w - 1 = log_b (b^(d_w-1)) lt.eq log_b (n/(n_0 - 1)) = log_b n - log_b (n_0 - 1)$, y por lo tanto $d_w lt.eq log_b n - log_b (n_0 - 1) + 1$.
]

Expandiendo ambas funciones mientras caemos en los casos recursivos, obtenemos:

$
  V(n) &= k_min a^(d_v) + sum_{j=0}^(d_v-1) a^j f(floor(n/b^j))\
  W(n) &= k_max a^(d_w) + sum_{j=0}^(d_w-1) a^j f(ceil(n/b^j))
$

El número de hojas en $V$ es $a^(d_v)$, y en $W$ es $a^(d_w)$. Queremos ver si el valor de $V$ y $W$ está dominado por el valor en las hojas, o por la sumatoria que le sigue. 

#lemma[
 - $a^(d_v) in Omega(n^c)$
 - $a^(d_w) in O(n^c)$
]
#demo[
- Como $d_v > log_b n - log_b (n_0)$, entonces $a^(d_v) > a^(log_b n - log_b (n_0)) = n^c/n_0^c = (1/n_0^c) n^c$, y por lo tanto $a^(d_v) in Omega(n^c)$.
- Como $d_w lt.eq log_b n - log_b (n_0 - 1) + 1$, entonces $a^(d_w) lt.eq a^(log_b n - log_b (n_0 - 1) + 1) = a n^c/(n_0 - 1)^c = (a/(n_0 - 1)^c) n^c$, y por lo tanto $a^(d_w) in O(n^c)$.

Acá usamos el @lemma:logaritmo-cambio-base con $(x,y,z)=(a,b,n)$, con $(x,y,z)=(a,b,n_0)$, y con $(x,y,z)=(a,b,n_0-1)$.
]

Comparemos, entonces, $f$ con $n^c$:

- Caso 1, existe un $epsilon in RRg0$, tal que $f in O(n^(c - epsilon))$. Es decir, existe un $alpha > 0, n_1 in NN$, tal que para todo $n gt.eq n_1$, $f(n) lt.eq alpha n^(c - epsilon)$. Queremos ver que el valor de $T$ es asintóticamente igual al costo en las hojas. 

  $
    W(n) =  k_max a^(d_w) + sum_(j=0)^(d_w - 1) a^j f(ceil(n/b^j))
  $

  Llamemos $S(n) = sum_(j=0)^(d_w - 1) a^j f(ceil(n/b^j))$.

  Queremos acotar $f(ceil(n/b^j))$. Notemos que en la sumatoria, el argumento de la llamada recursiva siempre cumple $ceil(n/b^j) gt.eq n_0 gt.eq 2$. Esto implica que $n/b^j gt.eq 1$, y por lo tanto $n/b^j lt.eq ceil(n/b^j)$. Además, por el @lemma:techo-doble aplicado a $x = n/b^j$, tenemos $ceil(n/b^j) lt.eq 2 n/b^j$.
  
  Si $c - epsilon gt.eq 0$, usamos la cota superior del argumento: $ceil(n/b^j)^(c - epsilon) lt.eq (2 n/b^j)^(c - epsilon)$.
  Si $c - epsilon < 0$, usamos la cota inferior del argumento: $ceil(n/b^j)^(c - epsilon) lt.eq (n/b^j)^(c - epsilon)$.

  En ambos casos, existe una constante $K$ ($K=2$ o $K=1$) tal que $ceil(n/b^j)^(c - epsilon) lt.eq (K n/b^j)^(c - epsilon)$.

  Entonces, para todo $n gt.eq max(n_0, n_1)$:
  $
    S(n) lt.eq sum_(j=0)^(d_w - 1) a^j alpha (K n/b^j)^(c - epsilon)
  $.

  Factorizando constantes:
  $
    S(n) &lt.eq alpha dot K^(c - epsilon) dot n^(c - epsilon) sum_(j=0)^(d_w - 1) a^j dot (1/b^j)^(c - epsilon)\
    &= alpha dot K^(c - epsilon) dot n^(c - epsilon) sum_(j=0)^(d_w - 1) a^j dot b^(-j(c - epsilon))\
    &= alpha dot K^(c - epsilon) dot n^(c - epsilon) sum_(j=0)^(d_w - 1) b^(j c) dot b^(-j(c - epsilon))\
    &= alpha dot K^(c - epsilon) dot n^(c - epsilon) sum_(j=0)^(d_w - 1) b^(j epsilon)
  $

  Como $b gt.eq 2$ y $epsilon > 0$, tenemos que $b^epsilon > 1$. Luego, la suma es geométrica con razón mayor que 1:
  $
    sum_(j=0)^(d_w - 1) b^(j epsilon) = (b^(d_w epsilon) - 1)/(b^epsilon - 1) < b^(d_w epsilon)/(b^epsilon - 1)
  $

  Como $d_w lt.eq log_b n - log_b (n_0 - 1) + 1$, tenemos:
  $
    b^(d_w epsilon) lt.eq b^(epsilon(log_b n - log_b (n_0 - 1) + 1)) = b^epsilon dot n^epsilon dot (n_0 - 1)^(-epsilon)
  $

  Por lo tanto:
  $
    S(n) &lt.eq alpha dot K^(c - epsilon) dot n^(c - epsilon) dot (b^epsilon dot n^epsilon dot (n_0 - 1)^(-epsilon))/(b^epsilon - 1)\
    &= (alpha dot K^(c - epsilon) dot b^epsilon)/((b^epsilon - 1) dot (n_0 - 1)^epsilon) dot n^c
  $

  Luego, $S in O(n^c)$. Como $a^(d_w) in O(n^c)$, tenemos que $W in O(n^c)$.

  Para $V(n)$, como el sumando $a^(d_v)$ está en $Omega(n^c)$, y su otro sumando es no-negativo, tenemos que $V in Omega(n^c)$.

  Por lo tanto, para todo $n gt.eq max(n_0, n_1)$, tenemos que $V(n) lt.eq T(n) lt.eq W(n)$, con $V in Omega(n^c)$ y $W in O(n^c)$, concluímos que $T in Theta(n^c)$.

- Caso 2. $f in Theta(n^c log^k n)$ para algún $k in NN$. Es decir, existen $alpha, beta > 0$ y $n_1 in NN$ tales que para todo $n gt.eq n_1$, $alpha n^c log^k n lt.eq f(n) lt.eq beta n^c log^k n$. Queremos ver que $T in Theta(n^c log^(k+1) n)$.

  Recordemos que $W(n) = k_max a^(d_w) + sum_(j=0)^(d_w - 1) a^j f(ceil(n/b^j)) = k_max a^(d_w) + S_W(n)$, expandiendo la recursión $d_w$ veces. Vemos que $k_max a^(d_w) in O(n^c)$, por el mismo argumento del punto anterior.
  
  Como $k_max a^(d_w) in O(n^c) subset O(n^c log^(k+1) n)$, consideremos $S_W(n)$. Como $n/b^j gt.eq 1$, por el @lemma:techo-doble tenemos $ceil(n/b^j) lt.eq 2n/b^j$. Como $c gt.eq 0$, entonces $ceil(n/b^j)^c lt.eq 2^c (n/b^j)^c$. Para el logaritmo, como $ceil(n/b^j) lt.eq 2n/b^j lt.eq 2n$ (pues $b^j gt.eq 1$), tenemos $log ceil(n/b^j) lt.eq log 2 + log n lt.eq 2 log n$ para $n gt.eq 2$.

  Luego, para $n gt.eq max(n_0, n_1, 2)$:
  $
    S_W (n) &lt.eq sum_(j=0)^(d_w - 1) a^j beta 2^c (n/b^j)^c (2 log n)^k = beta 2^(c+k) n^c log^k n sum_(j=0)^(d_w - 1) (a/b^c)^j
  $

  Como $a = b^c$, la suma es $sum_(j=0)^(d_w-1) 1 = d_w lt.eq log_b n + 1 lt.eq 2 log_b n$ para $n gt.eq b$. Entonces $S_W (n) lt.eq (2^(c+k+1) beta) / (log b) dot n^c log^(k+1) n$. Como $a^(d_w) in O(n^c) subset O(n^c log^(k+1) n)$, tenemos $W in O(n^c log^(k+1) n)$.

  Para la cota inferior, nuevamente expandimos $V(n) = k_min a^(d_v) + sum_(j=0)^(d_v - 1) a^j f(floor(n/b^j)) = k_min a^(d_v) + S_V(n)$. Como $k_min a^(d_v) gt.eq 0$, entonces si $S_V in Omega(n^c log^(k+1) n)$, entonces $V in Omega(n^c log^(k+1) n)$. Consideremos entonces $S_V(n)$. Sea $m = floor((log_b n)/2) - 1$. Vamos a acotar la suma por debajo, considerando sólo los índices $0 lt.eq j lt.eq m$.

  Primero verificamos que estos índices están dentro del rango: si $n gt.eq max(n_0^2, b^2)$, entonces $log_b n gt.eq 2$ y por lo tanto $m lt.eq (log_b n)/2 < d_v$, pues por el lema anterior $d_v > log_b n - log_b n_0 gt.eq (log_b n)/2$. Así, $0 lt.eq j lt.eq m$ implica $j < d_v$, y entonces $floor(n/b^j) gt.eq n_0 gt.eq 2$.

  Además, para $j lt.eq m = floor((log_b n)/2) - 1$ tenemos $j+1 lt.eq (log_b n)/2$, y por lo tanto $b^(j+1) lt.eq b^((log_b n)/2) = sqrt(n)$, es decir, $n/b^j gt.eq b sqrt(n)$. Como $b gt.eq 2$ y $n gt.eq 1$, entonces $b sqrt(n) gt.eq 1$. Juntando, obtenemos $n/b^j gt.eq 1$. Usando el @lemma:piso-mitad con $x = n/b^j$, obtenemos $floor(n/b^j) gt.eq (n/b^j)/2$. Para acotar $log$, usamos que $log$ es creciente y $b gt.eq 2$, y obtenemos: $floor(n/b^j) gt.eq (b sqrt(n))/2 gt.eq sqrt(n)$, y por ende $log floor(n/b^j) gt.eq log sqrt(n) = (1/2) log n$.

  Ahora aplicamos la hipótesis $f(n) gt.eq alpha n^c log^k n$ para $n gt.eq n_1$.
  Si $n gt.eq n_1^2$, entonces $floor(n/b^j) gt.eq sqrt(n) gt.eq n_1$ para todo $0 lt.eq j lt.eq m$,
  y podemos escribir:

  $
  S_V(n)
  &gt.eq sum_(j=0)^m a^j alpha floor(n/b^j)^c log^k floor(n/b^j) \
  &gt.eq sum_(j=0)^m a^j alpha ((n/b^j)/2)^c ((log n)/2)^k \
  &= alpha / 2^(c+k) dot n^c log^k n sum_(j=0)^m a^j / b^(j c).
  $

  Como $a = b^c$, tenemos $a^j / b^(j c) = 1$, y entonces
  $
  S_V(n) &gt.eq alpha / 2^(c+k) dot n^c log^k n dot (m+1).
  $

  Finalmente, si $n gt.eq b^2$, entonces $log_b n gt.eq 2$ y por lo tanto $(log_b n)/2 gt.eq 1$. Aplicando el @lemma:piso-mitad con $x = (log_b n)/2$, obtenemos $m+1 = floor((log_b n)/2) gt.eq (log_b n)/4$.

  Luego, $S_V(n) &gt.eq (alpha/(2^(c+k) dot 4 log b)) dot n^c log^(k+1) n$, y luego $S_V in Omega(n^c log^(k+1) n)$, y luego $V in Omega(n^c log^(k+1) n)$. Concluimos que $T in Theta(n^c log^(k+1) n)$.

- Caso 3. Supongamos que $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$, y que además existen
  $n_1 in NN$ y $r < 1 in RR0$ tales que para todo $n gt.eq n_1$ se cumple $a_1 f(floor(n/b)) + a_2 f(ceil(n/b)) lt.eq r f(n)$.

  Por la hipótesis $f in Omega(n^(c + epsilon))$, existen $alpha > 0$ y $n_2 in NN$ tales que para todo $n gt.eq n_2$ se cumple $f(n) gt.eq alpha n^(c + epsilon) gt 0$. Definimos $N = max(n_0, n_1, n_2)$.

  Vamos a probar que $T in Theta(f)$. Primero, la cota inferior es inmediata: para todo $n gt.eq n_0$, $T(n) = a_1 T(floor(n/b)) + a_2 T(ceil(n/b)) + f(n) gt.eq f(n)$, luego $T in Omega(f)$.

  Para la cota superior, vamos a definir una constante explícita. Consideremos el conjunto finito $S = { n in NN : N lt.eq n lt.eq b N }$. Como $f(n) gt 0$ para todo $n in S$, definimos $C_0 = max_{n in S} (T(n) / f(n))$. Definimos finalmente $C = max(C_0, 1 / (1 - r))$.
  
  Vamos a probar por inducción que para todo $n gt.eq N$ se cumple $T(n) lt.eq C f(n)$.

  - Caso base. Si $N lt.eq n lt.eq b N$, entonces por definición de $C_0$ tenemos $T(n) / f(n) lt.eq C_0 lt.eq C$, y por lo tanto $T(n) lt.eq C f(n)$.
  - Paso inductivo. Sea $n > b N$, y supongamos que para todo $m$ con $N lt.eq m lt n$ se cumple $T(m) lt.eq C f(m)$. Como $b gt.eq 2$ y $n > b N$, tenemos $floor(n/b) gt.eq N$ y $ceil(n/b) gt.eq N$, y además $floor(n/b) lt n$ y $ceil(n/b) lt n$, por lo que podemos aplicar la hipótesis inductiva.

    Entonces:
    $
    T(n)
    &= a_1 T(floor(n/b)) + a_2 T(ceil(n/b)) + f(n) \
    &lt.eq a_1 C f(floor(n/b)) + a_2 C f(ceil(n/b)) + f(n) \
    &= C (a_1 f(floor(n/b)) + a_2 f(ceil(n/b))) + f(n) \
    &lt.eq C r f(n) + f(n) quad "(por la hipótesis de regularidad)" \
    &= (C r + 1) f(n).
    $

    Como $C gt.eq 1 / (1 - r)$, tenemos $C r + 1 lt.eq C$, y por lo tanto $T(n) lt.eq C f(n)$.

  Por inducción fuerte, $T(n) lt.eq C f(n)$ para todo $n gt.eq N$, y luego $T in O(f)$.

  Concluimos que $T in Theta(f)$.
]

#load-bib()