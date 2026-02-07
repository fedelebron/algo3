// Chapter 8: Apéndice
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

#pagebreak()
= Apéndice

== Demostración del Teorema Maestro <demo:master>
#teo(title:[Teorema maestro])[
Sea $T: NN arrow RR0$ una función tal que:

$
  T(n) = cases(
    b_n &"si" 0 lt.eq n < n_0,
    a_1 T(floor(n/b)) + a_2 T(ceil(n/b)) + f(n) &"si" n gt.eq n_0
  )
$

para alguna función $f: NN arrow RR0$, algunas constantes $b_0, dots, b_(n_0-1) in RR0$, $a_1, a_2 in NN$, $b in NN gt.eq 2$, $n_0 in NN$, y asumiendo $n_0 gt.eq 2$ si $a_2 > 0$ para estar bien definida. Llamemos $a = a_1 + a_2 gt.eq 1$, y $c = log_b a$. Entonces:

- Si $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$, entonces $T in Theta(n^(c))$.
- Si $f in Theta(n^(c) log^k n)$ para algún $k in NN$, entonces $T in Theta(n^(c) log^(k+1) n)$.
- Si $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$, y además existen $n_1 in NN$ y $r < 1 in RR0$ tal que $a_1 f(floor(n/b)) + a_2 f(ceil(n/b)) lt.eq r f(n)$ para todo $n gt.eq n_1$, entonces $T in Theta(f)$.
]
#demo[

#show_master_theorem_infographic()

Vamos a asumir sin pérdida de generalidad que $n_0 gt.eq 2$. Si $n_0 = 1$, es decir hay un sólo caso base, podemos definir una función $T'$, idénticamente definida a $T$, sólo que $T'$ contiene un caso base extra, $b_(n_0) = T(n_0)$. Como $T(n) = T'(n)$ para todo $n in NN$, tendrán el mismo comportamiento asintótico, y podemos asumir que estamos analizando $T'$ con $n_0 gt.eq 2$. Hacemos esto para que expresiones como $1/(log_2 n_0)$ estén bien definidas.

Definamos $k_min = min_(0 lt.eq i < n_0) b_i$, y $k_max = max_(0 lt.eq i < n_0) b_i$.

También vamos a asumir sin pérdida de generalidad que $k_min > 0$. Si todos los casos base son $0$, al igual que en el párrafo anterior, tomamos el primer $k$ tal que $T(k) > 0$, y creamos casos base $b_(n_0), dots, b_k$, tal que al menos un caso base no es cero. Si no hay tal primer $k$ con $T(k) > 0$, entonces $T$ es la función constantemente cero, y no hay nada que analizar.

Vamos a analizar el árbol de recursión de $T(n)$. Definimos $d$ como el primer nivel en el que hay una hoja, $d = floor(log_b (n / n_0)) + 1$.

Definimos el _argumento_ de un vértice como el valor que se le pasa a la función $T$ en él.

Definimos el _peso_ de un vértice en el árbol de recursión de forma inductiva: la raíz tiene peso 1,
y si un vértice tiene peso $w$, su hijo izquierdo (correspondiente a $floor(n / b)$) tiene peso
$w dot a_1$, y su hijo derecho (correspondiente a $ceil(n / b)$) tiene peso $w dot a_2$.

#lemma[
En el nivel $j$, los argumentos de los vértices son o bien $floor(n / b^j)$ o bien $ceil(n / b^j)$.
En particular, difieren en a lo sumo 1 entre sí.
]
#demo[
Por inducción sobre $j$. Para $j = 0$, el único vértice es la raíz con argumento $n = floor(n / b^0) = ceil(n / b^0)$.

Para $j gt.eq 1$, por hipótesis inductiva los argumentos en el nivel $j - 1$ están en ${floor(n / b^(j-1)), ceil(n / b^(j-1))}$. Los hijos de estos vértices tienen argumentos de la forma $floor(q / b)$ o $ceil(q / b)$ donde $q in {floor(n / b^(j-1)), ceil(n / b^(j-1))}$.

Tenemos que $floor(floor(x/y)/y) = floor(x/y^2)$, y $ceil(ceil(x/y)/y) = ceil(x/y^2)$ para todo $x, y$, con $y eq.not 0$. Asimismo, $ceil(x)$ y $floor(x)$ son enteros, y difieren en a lo sumo $1$.

El máximo argumento en el nivel $j$-ésimo, entonces, va a ser $ceil(n / b^j)$, y el mínimo será $floor(n / b^j)$. Como todos los otros argumentos están entre esos dos, y son enteros que difieren en a lo sumo $1$, todos los argumentos del nivel $j$ son o bien $floor(n / b^j)$ o bien $ceil(n / b^j)$.
]

#lemma[
Si hay un vértice interno en el nivel $d$, su argumento es exactamente $n_0$.
]
#demo[
En el nivel $d$, los argumentos posibles son $floor(n / b^d)$ y $ceil(n / b^d)$, que difieren en a lo sumo 1. Por definición de $d$, tenemos $floor(n / b^d) < n_0$ (esto es lo que hace que $d$ sea el primer nivel con una hoja).

Para que haya un vértice interno en el nivel $d$, necesitamos $ceil(n / b^d) gt.eq n_0$. Como $ceil(n / b^d) - floor(n / b^d) lt.eq 1$ y $floor(n / b^d) < n_0$, tenemos $ceil(n / b^d) lt.eq n_0$.

Combinando $ceil(n / b^d) gt.eq n_0$ y $ceil(n / b^d) lt.eq n_0$, concluimos que $ceil(n / b^d) = n_0$.
]

Por lo tanto, el árbol de recursión tiene la siguiente estructura:
- Niveles $j = 0, 1, dots, d-1$: Hay a lo sumo $2^j$ vértices, todos son internos (i.e. no son hojas). La suma de sus pesos es $a^j$.
- Nivel $j = d$: Hay a lo sumo $2^d$ vértices. Algunos son internos, otros hojas. Los internos tienen argumento $n_0$.
- Nivel $j = d+1$: A lo sumo $2^(d+1)$ vértices, todos son hojas, con valor entre $k_min$ y $k_max$.


#lemma[
En cada nivel $j lt.eq d$, la suma de los pesos de todos los vértices es exactamente $a^j$.
]
#demo[
Por inducción sobre $j$. Para $j = 0$, la raíz es el único vértice y tiene peso $1 = a^0$.

Para $d gt.eq j gt.eq 1$, cada vértice en el nivel $j - 1$ tiene dos hijos cuyos pesos suman
$w dot a_1 + w dot a_2 = w dot a$, donde $w$ es el peso del padre. Por lo tanto, la suma de
pesos en el nivel $j$ es $a$ veces la suma de pesos en el nivel $j - 1$, que por hipótesis
inductiva es $a^(j-1)$. Luego la suma en el nivel $j$ es $a dot a^(j-1) = a^j$.

(Esto vale para $j - 1 lt.eq d - 1$ pues en esos niveles todos los vértices son internos, y por lo tanto
todos tienen exactamente dos hijos, ambos en el nivel $j$.)
]

Para cada nivel $j < d$, definimos:
$
  l_j^- = min(f(floor(n/b^j)), f(ceil(n/b^j))), quad l_j^+ = max(f(floor(n/b^j)), f(ceil(n/b^j)))
$

Pensemos en la descomposición por nivel de nuestro árbol de recursión. En los primeros $d$ niveles, todos los vértices son internos, y por lo tanto la suma de sus pesos es $a^j$. En los últimos dos niveles, hay a lo sumo $a^d$ peso total de vértices internos, con valor $f(n_0)$, y a lo sumo $a^(d+1)$ peso total de hojas con valor entre $k_min$ y $k_max$, algunas estando en el nivel $d$ y otras en el nivel $d+1$.
  
  $
  sum_(j=0)^(d-1) a^j l_j^- + k_min a^d lt.eq T(n) lt.eq sum_(j=0)^(d-1) a^j dot l_j^+ + a^d dot f(n_0) + k_max dot a^(d+1)
  $

- Caso 1. $f in O(n^(c-epsilon))$ para algún $epsilon > 0$. Queremos probar que $T in Theta(n^c)$.
  
  Como $f in O(n^(c-epsilon))$, existen $alpha > 0$ y $n_1 in NN$ tales que $f(m) lt.eq alpha m^(c-epsilon)$ para todo $m gt.eq n_1$. Definimos $beta = max(alpha, max_(n_0 lt.eq m lt.eq n_1) f(m)/m^(c-epsilon))$. De esta forma conseguimos que $f(m) lt.eq beta m^(c-epsilon)$ para todo $m gt.eq n_0$.

  Como en el $j$-ésimo nivel, los argumentos son o bien $floor(n/b^j)$ o bien $ceil(n/b^j)$, llamemos $l_j = max(f(floor(n/b^j)), f(ceil(n/b^j)))$ al máximo valor de $f$ en el $j$-ésimo nivel. Por lo tanto, $f(floor(n/b^j)) lt.eq beta floor(n/b^j)^(c-epsilon)$ y $f(ceil(n/b^j)) lt.eq beta ceil(n/b^j)^(c-epsilon)$ para todo $j < d$.

  Primero probemos que $T in O(n^c)$. Tenemos $T(n) lt.eq sum_(j=0)^(d-1) a^j dot l_j^+ + a^d dot f(n_0) + k_max dot a^(d+1)$. Para la sumatoria, usamos $ceil(n/b^j) lt.eq 2n/b^j$ y $floor(n/b^j) lt.eq n/b^j$:
  $
  l_j^+ lt.eq beta dot (2n/b^j)^(c-epsilon) = beta dot 2^(c-epsilon) dot n^(c-epsilon)/b^(j(c-epsilon))
  $

  Entonces:
  $
  sum_(j=0)^(d-1) a^j dot l_j^+ lt.eq beta dot 2^(c-epsilon) dot n^(c-epsilon) sum_(j=0)^(d-1) a^j/b^(j(c-epsilon))
  $

  Como $a = b^c$, $a^j/b^(j(c-epsilon)) = b^(j c)/b^(j(c-epsilon)) = b^(j epsilon)$.
  Luego:
  $
  sum_(j=0)^(d-1) a^j dot l_j^+ lt.eq beta dot 2^(c-epsilon) dot n^(c-epsilon) sum_(j=0)^(d-1) b^(j epsilon)
  $

  La sumatoria es geométrica con razón $b^epsilon > 1$:
  $
  sum_(j=0)^(d-1) b^(j epsilon) = (b^(d epsilon) - 1)/(b^epsilon - 1) < b^(d epsilon)/(b^epsilon - 1)
  $

  Como $d = floor(log_b (n/n_0)) + 1 lt.eq log_b (n/n_0) + 1$:
  $
  b^(d epsilon) lt.eq b^(epsilon(log_b (n/n_0) + 1)) = b^epsilon dot (n/n_0)^epsilon
  $

  Por lo tanto:
  $
  sum_(j=0)^(d-1) a^j dot l_j^+ &lt.eq beta dot 2^(c-epsilon) dot n^(c-epsilon) dot (b^epsilon dot (n/n_0)^epsilon)/(b^epsilon - 1)\
    &= (beta dot 2^(c-epsilon) dot b^epsilon)/((b^epsilon - 1) dot n_0^epsilon) dot n^c
  $

  Esto está en $O(n^c)$.

  Para los términos restantes:
  - $a^d dot f(n_0)$: Como $d lt.eq log_b (n/n_0) + 1$, tenemos $a^d lt.eq a dot (n/n_0)^c in O(n^c)$.
  - $k_"max" dot a^(d+1) = a dot k_"max" dot a^d lt.eq a dot k_"max" dot (n/n_0)^c in O(n^c)$.

  Concluimos que $T in O(n^c)$. Ahora probemos la cota inferior, $T in Omega(n^c)$. Por nuestra descomposición:
  $
  T(n) gt.eq sum_(j=0)^(d-1) a^j dot l_j^- + k_"min" dot a^d gt.eq k_"min" dot a^d
  $

  ya que $f(x) gt.eq 0$ para todo $x in NN$.

  Como $d = floor(log_b (n/n_0)) + 1 > log_b (n/n_0)$:
  $
  a^d > a^(log_b (n/n_0)) = (n/n_0)^c = n^c/n_0^c
  $

  Por lo tanto $T(n) > k_"min" dot n^c / n_0^c$ para todo $n gt.eq n_0$, y luego $T in Omega(n^c)$. Concluimos que $T in Theta(n^c)$.


- Caso 2. Sabemos que $f in Theta(n^c log^k n)$ para algún $k in NN$. Queremos probar que $T in Theta(n^c log^(k+1) n)$.

  Como $f in Theta(n^c log^k n)$, existen $alpha, beta' > 0$ y $N_0 in NN$ tales que para todo $m gt.eq N_0$:
  $
  alpha m^c log^k m lt.eq f(m) lt.eq beta' m^c log^k m
  $

  Como en el caso anterior, definimos $beta = max(beta', max_(n_0 lt.eq m < max(N_0, n_0 + 1)) f(m) / (m^c log^k m))$, para saber que $f(m) lt.eq beta m^c log^k m$ para todo $m gt.eq n_0$. Definimos $N_1 = max(n_0, N_0, 4)$. Probaremos ambas cotas para $n gt.eq 4 N_1^2$.

  *Cota superior.* De la descomposición del árbol:
  $
  T(n) lt.eq sum_(j=0)^(d-1) a^j dot l_j^+ + a^d dot (a k_max + f(n_0))
  $

  Para $j < d$, tenemos $n / b^j gt.eq n_0 gt.eq 2$, así que $ceil(n / b^j) lt.eq n / b^j + 1 lt.eq 2n / b^j$. Como ambos argumentos a $f$ en $l_j^+$ son al menos $n_0$, y porque $beta$ es tal que para todo $m gt.eq n_0$ se tiene $f(m) lt.eq beta m^c log^k m$, tenemos:
  $
  l_j^+ lt.eq beta dot (2n / b^j)^c dot log^k (2n / b^j) = beta dot 2^c dot n^c / b^(j c) dot log^k (2n / b^j)
  $

  Usando $a^j = b^(j c)$:
  $
  a^j dot l_j^+ lt.eq beta dot 2^c dot n^c dot log^k (2n / b^j)
  $

  Para $n gt.eq 4$ y $j < d$, tenemos $2n / b^j lt.eq 2n$, así que $log (2n / b^j) lt.eq log (2n) lt.eq 2 log n$. Por lo tanto:
  $
  sum_(j=0)^(d-1) a^j dot l_j^+ lt.eq beta dot 2^c dot n^c dot d dot (2 log n)^k = beta dot 2^(c+k) dot n^c dot d dot log^k n
  $

  Como $d = floor(log_b (n / n_0)) + 1 lt.eq log_b n + 1 lt.eq (2 log n) / (log b)$ para $n gt.eq b$:
  $
  sum_(j=0)^(d-1) a^j dot l_j^+ lt.eq (2^(c+k+1) beta) / (log b) dot n^c log^(k+1) n
  $

  Para los valores de los últimos dos niveles, como $d lt.eq log_b (n / n_0) + 1$, tenemos $a^d lt.eq a dot (n / n_0)^c$. Sea $delta = a dot n_0^(-c) dot (a k_max + f(n_0))$. Entonces:
  $
  a^d dot (a k_max + f(n_0)) lt.eq delta dot n^c
  $
  Como $O(n^c) subset.eq O(n^c log^(k+1) n)$, estos términos también están en $O(n^c log^(k+1) n)$. Combinando ambas partes obtenemos $T in O(n^c log^(k+1) n)$.

  *Cota inferior.* De la descomposición:
  $
  T(n) gt.eq sum_(j=0)^(d-1) a^j dot l_j^-
  $

  #lemma[
  Para $j lt.eq (d-1) / 2$ y $n gt.eq 4 N_1^2$, se tiene
  $floor(n / b^j) gt.eq n / (2 b^j) gt.eq N_1$.
  ]
  #demo[
  Como $d - 1 lt.eq log_b (n / n_0)$, para $j lt.eq (d-1) / 2$ tenemos
  $b^j lt.eq b^((d-1)/2) lt.eq sqrt(n / n_0)$. Por lo tanto:
  $
    n / b^j gt.eq n / sqrt(n / n_0) = sqrt(n dot n_0).
  $

  Como $n_0 gt.eq 2$, se tiene $sqrt(n dot n_0) gt.eq sqrt(n)$.
  Y como $n gt.eq 4 N_1^2$, resulta $sqrt(n) gt.eq 2 N_1 gt.eq 8 gt.eq 2$.
  Luego $n / b^j gt.eq 2$, y por tanto:
  $
    floor(n / b^j) gt.eq n / b^j - 1 gt.eq n / (2 b^j).
  $

  Además:
  $
    n / (2 b^j) gt.eq sqrt(n dot n_0) / 2.
  $
  Como $n gt.eq 4 N_1^2$ y $n_0 gt.eq 2$, se cumple
  $n dot n_0 gt.eq 8 N_1^2 gt.eq 4 N_1^2$, y luego:
  $
    sqrt(n dot n_0) / 2 gt.eq sqrt(4 N_1^2) / 2 = N_1.
  $

  Por lo tanto, $floor(n / b^j) gt.eq n / (2 b^j) gt.eq N_1$.
  ]
  Para tales $j$, como $floor(n / b^j) gt.eq N_1 gt.eq N_0$:
  $
  l_j^- gt.eq alpha dot floor(n / b^j)^c dot log^k (floor(n / b^j)) gt.eq alpha dot (n / (2 b^j))^c dot log^k (n / (2 b^j))
  $

  Usando $a^j = b^(j c)$:
  $
  a^j dot l_j^- gt.eq alpha / 2^c dot n^c dot log^k (n / (2 b^j))
  $

  Ahora acotemos $log (n / (2 b^j))$ con el siguiente lemma.
  #lemma[
  Para $j lt.eq (d-1) / 2$ y $n gt.eq 4 N_1^2$, se tiene $log (n / (2 b^j)) gt.eq 1/4 log n$.
  ]
  #demo[
  Del lema anterior, $n / (2 b^j) gt.eq sqrt(n dot n_0) / 2 gt.eq sqrt(n) / 2$.
  $
  log (n / (2 b^j)) gt.eq log (sqrt(n) / 2) = 1/2 log n - log 2
  $
  Para que esto sea al menos $1/4 log n$, necesitamos $1/4 log n gt.eq log 2$, es decir, $n gt.eq 16$.

  Como $n gt.eq 4 N_1^2 gt.eq 4 dot 16 = 64 gt.eq 16$, la desigualdad se cumple.
  ]

  Por lo tanto, para $j lt.eq (d-1) / 2$:
  $
  a^j dot l_j^- gt.eq alpha / 2^c dot n^c dot (log n / 4)^k = alpha / (2^c dot 4^k) dot n^c log^k n
  $

  El número de tales términos es $floor((d-1) / 2) + 1 gt.eq d / 2$. Como $d > log_b (n / n_0) gt.eq (log n) / (2 log b)$ para $n gt.eq n_0^2$:
  $
  sum_(j=0)^(floor((d-1) / 2)) a^j dot l_j^- gt.eq d/2 dot alpha / (2^c dot 4^k) dot n^c log^k n gt.eq alpha / (2^(c + 2k + 2) log b) dot n^c log^(k+1) n
  $

  Así $T in Omega(n^c log^(k+1) n)$.

  Combinando ambas cotas: $T in Theta(n^c log^(k+1) n)$.

- Caso 3. Supongamos que $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$, y que además existen
  $n_1 in NN$ y $r < 1 in RR0$ tales que para todo $n gt.eq n_1$ se cumple $a_1 f(floor(n/b)) + a_2 f(ceil(n/b)) lt.eq r f(n)$.

  Por la hipótesis $f in Omega(n^(c + epsilon))$, existen $alpha > 0$ y $n_2 in NN$ tales que para todo $n gt.eq n_2$ se cumple $f(n) gt.eq alpha n^(c + epsilon) gt 0$. Definimos $N = max(n_0, n_1, n_2)$.

  Vamos a probar que $T in Theta(f)$. Primero, la cota inferior es inmediata: para todo $n gt.eq n_0$, $T(n) = a_1 T(floor(n/b)) + a_2 T(ceil(n/b)) + f(n) gt.eq f(n)$, luego $T in Omega(f)$.

  Para la cota superior, vamos a definir una constante explícita. Consideremos el conjunto finito $S = { n in NN : N lt.eq n lt.eq b N }$. Como $f(n) gt 0$ para todo $n in S$, definimos $C_0 = max_(n in S) (T(n) / f(n))$. Definimos finalmente $C = max(C_0, 1 / (1 - r))$.
  
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

  Por inducción, $T(n) lt.eq C f(n)$ para todo $n gt.eq N$, y luego $T in O(f)$.Concluimos que $T in Theta(f)$.
]

== Demostración del número de comparaciones de Mergesort

Esta demostración no es particularmente larga. La pongo en el apéndice porque quiero que vean el poder del teorema maestro en el capítulo donde se ve este algoritmo por primera vez.

Notemos cómo acá derivamos la función del peor caso explícitamente, no sólo asintóticamente.

#ej[
  Mergesort es un algoritmo de ordenamiento a base de comparaciones.

  ```py
  def merge(left: list[int], right: list[int]) -> list[int]:
    result = []
    i = 0
    j = 0
    while i < len(left) and j < len(right):
      if left[i] <= right[j]:
        result.append(left[i])
        i += 1
      else:
        result.append(right[j])
        j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

  def mergesort(arr: list[int]) -> list[int]:
    if len(arr) <= 1:
      return arr
    mid = len(arr) // 2
    left = mergesort(arr[:mid])
    right = mergesort(arr[mid:])
    return merge(left, right)
  ```

  Dada una lista de enteros $x$, sea $C(x)$ el número de comparaciones que hace `mergesort(x)`. Se define $T:NN arrow NN$ como $T(n) = max_x {C(x) | "len"(x) = n}$. Es decir, el máximo número de comparaciones que realiza ```py mergesort(x)```, entre todas las listas `x` tales que ```py len(x) = n```.

  Probar que $T(n) = n ceil(log_2 n) - 2^(ceil(log_2 n)) + 1$.
]
#demo[
  Llamemos $M(l, r)$ al número de comparaciones que hace `merge` al ser llamados con dos listas de longitud $l$ y $r$ respectivamente. Probemos algo sobre el comportamiento de `merge`.
  #lemma[
    $M(l, r) lt.eq l + r - 1$.
  ]
  #demo[
    En cada iteración del `while`, se hace una comparación entre `left[i]` y `right[j]`, y se incrementa exactamente uno de $i$ o $j$. Luego, después de $t$ iteraciones, $i + j = t$. El ciclo termina cuando $i = l$ o $j = r$. Si termina con $i = l$, entonces $j < r$ (pues la condición del `while` requiere ambas desigualdades estrictas para entrar al ciclo). Luego $t = l + j lt.eq l + r - 1$. El caso $j = r$ es análogo.
  ]

  En `mergesort`, recibimos una lista $x$ de longitud $n$. La dividimos en dos partes, de tamaño $l = floor(n/2)$ y $r = ceil(n/2)$ respectivamente. Podemos ver por inducción que la longitud de `mergesort(x)` es igual a `len(x)`. Por ende, `merge` recibe dos listas ordenadas de longitudes $l$ y $r$. Por el lema, `merge` hace a lo sumo $l + r - 1 = n - 1$ comparaciones, y por lo tanto $T(n) lt.eq T(l) + T(r) + n - 1$.

  Para ver que esta cota se alcanza, construimos inductivamente una entrada peor caso. Definimos la siguiente función, que recibe una lista ordenada y devuelve una permutación de ella:

  ```py
  def peor_caso(ordenada: list[int]) -> list[int]:
    if len(ordenada) <= 1:
      return ordenada
    izq = ordenada[1::2]  # posiciones impares: l elementos
    der = ordenada[0::2]  # posiciones pares: r elementos
    return peor_caso(izq) + peor_caso(der)
  ```

  Por ejemplo, `peor_caso([1,2,3,4,5,6,7,8])` devuelve `[4,8,2,6,3,7,1,5]`. Al ejecutar `mergesort` sobre esta lista, cada llamada a `merge` en cada nivel de la recursión recibe dos listas ordenadas cuyos elementos se intercalan, y por lo tanto hace exactamente $n - 1$ comparaciones. La idea es que en cada nivel, `peor_caso` distribuye los valores pares a la mitad izquierda y los impares a la derecha (con respecto a la lista ordenada de ese nivel), de modo que al ordenar cada mitad, los resultados se intercalan.

  Probemos por inducción que `mergesort(peor_caso([1,...,n]))` hace exactamente $T(l) + T(r) + n - 1$ comparaciones. Para $n = 1$, no hay comparaciones. Para $n > 1$: la mitad izquierda es `peor_caso(izq)` donde `izq` tiene $l$ elementos, y por hipótesis inductiva, ordenarla cuesta $T(l)$ comparaciones. Análogamente, la mitad derecha cuesta $T(r)$. Tras ordenar, las mitades producen `izq` $= [2, 4, dots]$ y `der` $= [1, 3, dots]$ (los elementos pares e impares de la lista original), que se intercalan. Luego, `merge` hace exactamente $n - 1$ comparaciones.

  Esto nos da $T(n) = T(floor(n/2)) + T(ceil(n/2)) + n - 1$, con $T(1) = 0$.

  Vamos a probar por inducción que $T(n) = n ceil(log_2 n) - 2^(ceil(log_2 n)) + 1$. Formalmente, sea $P(n): T(n) = n ceil(log_2 n) - 2^(ceil(log_2 n)) + 1$. Vamos a probar $P(n)$ para todo natural $n gt.eq 1$.

  - Para $n = 1$, $T(1) = 0$, y asimismo $1 ceil(log_2 1) - 2^(ceil(log_2 1)) + 1 = 1 ceil(0) - 2^0 + 1 = 0$, con lo cual vale $P(1)$.
  - Sea $n > 1$ un natural. Asumimos que $P(k)$ vale para todo $k < n$, queremos probar $P(n)$. Sea $k = ceil(log_2 n)$, con lo cual $2^(k-1) < n lt.eq 2^k$. Sea $l = floor(n/2)$, y $r = ceil(n/2)$, con $l + r = n$. Sabemos que $T(n) = T(l) + T(r) + n - 1$.

    Como $n lt.eq 2^k$, entonces $r lt.eq 2^(k-1)$. Como $n > 2^(k-1)$, entonces $r > 2^(k-2)$. Luego, $r$ está en el intervalo $(2^(k-2), 2^(k-1)]$, y por lo tanto, $ceil(log_2 r) = k - 1$. Usando la hipótesis inductiva, obtenemos $T(r) = r (k - 1) - 2^(k - 1) + 1$.

    Para encontrar $T(l)$, partimos en casos sobre $n$, ya que el valor de $ceil(log_2 l)$ depende de si $l$ es exactamente una potencia de $2$. Recordemos que $2^(k-1) + 1 lt.eq n lt.eq 2^k$.
    - Si $n = 2^(k-1) + 1$ exactamente, entonces $l = 2^(k-2)$, y $r = 2^(k-2) + 1$. Luego, $ceil(log_2 l) = k - 2$. Aplicando la hipótesis inductiva a $l$, tenemos $T(l) = l (k - 2) - 2^(k - 2) + 1$. Sumando lo que teníamos, sabemos que:

    $
      T(n) & = T(l) + T(r) + n - 1 \
           & = l (k - 2) - 2^(k - 2) + 1 + r (k - 1) - 2^(k - 1) + 1 + n - 1 \
           & "Usando que" 2^(k-2)=l ", y luego "2^(k-1) = 2l", obtenemos:" \
           & = l (k - 2) - l + 1 + r (k - 1) - 2l + 1 + (l + r) - 1 \
           & = k (l + r) - 2l - l + 1 - r - 2l + 1 + (l + r) - 1 \
           & = k (l + r) - 4l + 1 \
           & = k n - 4 times 2^(k-2) + 1 \
           & = k n - 2^k + 1
    $

    que es lo que queríamos demostrar.
    - Si $2^(k-1) + 1 < n lt.eq 2^k$, entonces $l > 2^(k-2)$. Luego, $ceil(log_2 l) = k - 1$. Aplicando la hipótesis inductiva a $l$, tenemos $T(l) = l (k - 1) - 2^(k - 1) + 1$. Sumando lo que teníamos, sabemos que:

    $
      T(n) & = T(l) + T(r) + n - 1 \
           & = l (k - 1) - 2^(k - 1) + 1 + r (k - 1) - 2^(k - 1) + 1 + n - 1 \
           & = (l + r) (k - 1) - 2^k + 2 + (l + r) - 1 \
           & = n k - 2^k + 1
    $

    que es lo que queríamos demostrar.

  Luego, hemos probado por inducción que para todo $n gt.eq 1$, $T(n) = n ceil(log_2 n) - 2^(ceil(log_2 n)) + 1$.
]

#load-bib()