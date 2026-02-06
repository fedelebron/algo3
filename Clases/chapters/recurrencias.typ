#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Recurrencias

Muchas veces vamos a tener funciones que están definidas de forma recursiva, también llamadas recurrencias. Es decir, son funciones de la forma $f(n) = dots f(k) dots$, con $k < n$. Por ejemplo, los números de Fibonacci están definidos como:

$
f(n) = cases(1 & "si" n = 1, 1 & "si" n = 2, f(n - 1) + f(n - 2) & "si" n gt 2)
$

También vamos a encontrarnos con recurrencias definidas sólo hasta conjuntos asintóticos, como por ejemplo:
$
T(n) = cases(5 & "si" n = 1, T(n - 1) + O(n^2) & "si" n gt 1)
$

Vamos a querer hacer análisis asintótico de estas funciones, y frecuentemente esto comienza encontrando una forma cerrada para la recurrencia. En este capítulo veremos tres técnicas para hacer esto: expansión directa, árboles de recursión, y finalmente el teorema maestro.

=== Expansión

La técnica de *expansión* consiste en aplicar repetidamente la definición recursiva de una función $T$, sustituyendo $T(n-1)$, $T(n-2)$, etc., hasta llegar a un caso base. Esto nos permite ver el patrón resultante y conjeturar una forma cerrada.

El procedimiento es:
+ Expandir $T(n)$ usando la definición recursiva, hasta reconocer un patrón o llegar al caso base.
+ Expresar la suma o producto resultante en forma cerrada.
+ Verificar la solución por inducción.

Esta técnica funciona particularmente bien para *recurrencias lineales*, donde $T(n)$ depende de $T(n-1)$, $T(n-2)$, etc. Para recurrencias que dividen el argumento (como $T(n/2)$), la expansión se vuelve más complicada, y usaremos otras técnicas.

Comencemos con un ejemplo sencillo, una suma aritmética.

#ej[
Sea $T: NN arrow NN$ definida como:
$
  T(n) = cases(
    1 & "si" n = 1,
    T(n-1) + n & "si" n gt 1
  )
$
Encontrar su forma cerrada.
]
#sol[
*Paso 1: Expansión.* Expandimos $T(n)$ usando la definición recursiva:
$
  T(n) &= T(n-1) + n \
       &= T(n-2) + (n-1) + n \
       &= T(n-3) + (n-2) + (n-1) + n \
       &dots.v \
       &= T(1) + 2 + 3 + dots + n \
       &= 1 + sum_(i=2)^n i
$

*Paso 2: Forma cerrada.* Reconocemos el patrón como una suma aritmética. Conjeturamos que $T(n) = (n(n+1))/2$.

*Paso 3: Verificación por inducción.* Probamos que $T(n) = (n(n+1))/2$ para todo $n gt.eq 1$.
- _Caso base_: $T(1) = 1 = (1 dot 2)/2$. Cumple.
- _Paso inductivo_: Sea $n gt 1$. Asumimos $T(n-1) = ((n-1)n)/2$. Entonces:
$
  T(n) = T(n-1) + n = ((n-1)n)/2 + n = (n(n-1) + 2n)/2 = (n(n+1))/2
$

Luego $T(n) = (n(n+1))/2$, y por lo tanto $T in Theta(n^2)$.
]

Y un poco más complejo, una suma geométrica.

#ej[
Sea $T: NN arrow NN$ definida como:
$
  T(n) = cases(
    1 & "si" n = 0,
    2 T(n-1) + 1 & "si" n gt 0
  )
$
Encontrar su forma cerrada.
]
#sol[
*Paso 1: Expansión.* Expandimos $T(n)$ usando la definición recursiva:
$
  T(n) &= 2 T(n-1) + 1 \
       &= 2(2 T(n-2) + 1) + 1 = 4 T(n-2) + 2 + 1 \
       &= 4(2 T(n-3) + 1) + 2 + 1 = 8 T(n-3) + 4 + 2 + 1 \
       &dots.v \
       &= 2^n T(0) + 2^(n-1) + dots + 2 + 1 \
       &= 2^n + sum_(i=0)^(n-1) 2^i
$

*Paso 2: Forma cerrada.* Reconocemos el patrón como una suma geométrica. Conjeturamos que $T(n) = 2^(n+1) - 1$.

*Paso 3: Verificación por inducción.* Probamos que $T(n) = 2^(n+1) - 1$ para todo $n gt.eq 0$.
- _Caso base_: $T(0) = 1 = 2^1 - 1$. Cumple.
- _Paso inductivo_: Sea $n gt 0$. Asumimos $T(n-1) = 2^n - 1$. Entonces:
$
  T(n) = 2 T(n-1) + 1 = 2(2^n - 1) + 1 = 2^(n+1) - 2 + 1 = 2^(n+1) - 1
$

Luego $T(n) = 2^(n+1) - 1$, y por lo tanto $T in Theta(2^n)$.
]

Algunas recurrencias lineales tienen formas cerradas conocidas:

#align(center)[
#table(
  columns: 3,
  align: (left, left, left),
  table.header([*Recurrencia*], [*Forma cerrada*], [*Orden*]),
  [$T(n) = T(n-1) + c$], [suma aritmética], [$Theta(n)$],
  [$T(n) = T(n-1) + n$], [suma triangular], [$Theta(n^2)$],
  [$T(n) = T(n-1) + n^k$], [suma de potencias], [$Theta(n^(k+1))$],
  [$T(n) = a dot T(n-1) + c$], [suma geométrica], [$Theta(a^n)$],
)
]

Cuando la recurrencia usa notación asintótica, la expansión nos da una cota asintótica.

#ej[
Sea $T:NN arrow RR0$, definida como:

$
  T(n) = cases(
    5 & "si" n = 1,
    T(n - 1) + O(n^2) & "si" n gt 1
  )
$

Demostrar que $T in O(n^3)$.
]
#demo[
Por definición de la notación algebraica asintótica, existe una función $h in O(n^2)$ tal que para todo $n gt 1$, $T(n) = T(n-1) + h(n)$.

Expandiendo la recurrencia:
$
  T(n) &= T(n-1) + h(n) \
       &= T(n-2) + h(n-1) + h(n) \
       &= T(n-3) + h(n-2) + h(n-1) + h(n) \
       &dots.v \
       &= T(1) + sum_(i=2)^n h(i) \
       &= 5 + sum_(i=2)^n h(i)
$

Como $h in O(n^2)$, existe $alpha > 0$ y $n_0 in NN$ tales que para todo $i gt.eq n_0$, $h(i) lt.eq alpha i^2$. Definamos, entonces, $beta = max(alpha, max_(i=2)^(n_0) h(i)/i^2)$. Tenemos, entonces, que $h(i) lt.eq beta i^2$ para todo $i in NN, i gt.eq 2$. Luego:
$
  sum_(i=2)^n h(i) lt.eq sum_(i=2)^n beta i^2 = beta sum_(i=2)^n i^2 = beta ((n(n+1)(2n+1))/6 - 1) in O(n^3)
$

Por lo tanto, $T(n) = 5 + O(n^3)$, y luego $T in O(n^3)$.
]

No siempre va a ser fácil encontrar un patrón mediante expansiones. En particular, cuando la recurrencia divide el argumento (por ejemplo, $T(n) = 2T(n/2) + n$), la expansión directa se complica. Para esos casos, usaremos árboles de recursión. 

=== Árboles de recursión

En el contexto de ciencias de la computación, nos vamos a enfocar más en la forma de computar $Y$, dado $X$. Al ver una definición como esta para $f:NN arrow NN$:
$
  f(n) = cases(
    0 & "si" n = 0,
    1 & "si" n = 1,
    f(n - 1) + f(n - 2) & "si" n gt.eq 2
  )
$

vamos a querer considerar cómo computar valores de $f$. Una herramienta usual para funciones recursivas va a ser el *árbol de recursión*, que nos muestra qué llamadas de $f$ dependen de qué otras llamadas de $f$. Para $f$ definida como arriba, el árbol para $n=4$ se ve así:
#let draw_recursion_tree = (t, radius: 1.3em) => {
  canvas({
    tree.tree(
      direction: "down",
      spread: 1,
      grow: 0.75,

      draw-node: (node, ..) => {
        if node.children != () {
          draw.circle((), radius: radius, fill: blue.lighten(50%), stroke: none)
          draw.content((), node.content)
        } else {
          draw.rect((-0.25, -0.25), (0.25, 0.25))
          draw.content((0, 0), node.content)
        }
      },
      draw-edge: (from, to, ..) => {
        draw.line(from, to, mark: (end: ">"))
      },
      t,
    )
  })
}

#align(center)[
  #draw_recursion_tree(
    ([$f(4)$], ([$f(3)$], ([$f(2)$], [$1$], [$0$]), [$1$]), ([$f(2)$], [$1$], [$0$])),
  )
]

Esta herramienta nos va a ser útil para encontrar formas cerradas de funciones, o al menos darnos una idea de quién puede ser. Por ejemplo, consideremos la siguiente función, $f: NN_(>0) arrow NN$:
$
  f(n) = cases(
    0 & "si" n = 1,
    f(floor(n/2)) + f(ceil(n/2)) + n & "si" n > 1
  )
$

Veamos cómo usar árboles de recursión para entender esta función. Intentemos encontrar una forma cerrada para $f$, viendo el árbol de recursión para $n = 7$:

#align(center)[
  #draw_recursion_tree(
    (
      [$f(7) + 7$],
      ([$f(3) + 3$], [$0$], ([$f(2) + 2$], [$0$], [$0$])),
      ([$f(4) + 4$], ([$f(2) + 2$], [$0$], [$0$]), ([$f(2) + 2$], [$0$], [$0$])),
    ),
    radius: 2em,
  )
]

Esto es un árbol de 4 niveles. Podemos ver es que en cada nivel donde no hay hojas, la suma los términos en cada vértice es $7$. En el primer nivel, hay un sólo vértice, y suma $7$ al valor total ("$+ 7$"). En el segundo nivel, se suman $3$ y $4$, que otra vez suman $7$ al valor total, en conjunto. Esto es porque cada vez que caemos en el caso recursivo, $f(n)$ tiene un $+n$ al final.

En el tercer y cuarto nivel hay hojas, y todas cuestan 0. Para saber el costo total, podemos calcular el costo de cada nivel. Para los niveles que no tienen hojas, el costo es exactamente $n$. Para los niveles que tienen sólo hojas, el costo es $0$. Luego, queda saber cuántos niveles hay con hojas, y en esos niveles, cuántas hojas hay.




Queremos entender la estructura del árbol de recursión. Sea $k = floor(log_2(n))$. Vamos a probar formalmente que:
1. Los niveles $0, 1, dots, k - 1$ están completos (todos sus vértices son internos).
2. El nivel $k$ es el primer nivel que contiene hojas.
3. Si $n$ es potencia de $2$, el nivel $k$ contiene sólo hojas y el árbol tiene altura exactamente $k$.
4. Si $n$ no es potencia de $2$, el nivel $k$ contiene tanto hojas como vértices internos, y el nivel $k + 1$ contiene sólo hojas.

Para esto, primero caracterizamos los valores en cada nivel del árbol. Definimos el _valor_ de un vértice como el argumento de $f$ en ese vértice. Por ejemplo, en el árbol de $f(7)$, la raíz tiene valor $7$, sus hijos tienen valores $3$ y $4$, etc. Un vértice es una _hoja_ si su valor es $1$ (caso base de $f$), y es un _vértice interno_ si su valor es mayor a $1$ (caso recursivo).

#prop[
Sea $v$ el valor de un vértice en el nivel $i$ del árbol de recursión. Entonces:
$
  floor(n / 2^i) lt.eq v lt.eq ceil(n / 2^i)
$
]
#demo[
Por inducción en $i$.
- Caso base, $i = 0$. El único vértice en el nivel $0$ es la raíz, con valor $n$. Como $floor(n / 2^0) = n = ceil(n / 2^0)$, el predicado vale.
- Paso inductivo, $i > 0$. Sea $v$ un vértice en el nivel $i$. Su padre, en el nivel $i - 1$, tiene valor $p$ tal que por hipótesis inductiva, $floor(n / 2^(i-1)) lt.eq p lt.eq ceil(n / 2^(i-1))$. El valor de $v$ es $floor(p / 2)$ o $ceil(p / 2)$. Usando que $floor(floor(x) / m) = floor(x / m)$ y $ceil(ceil(x) / m) = ceil(x / m)$ para $m in NN_(>0)$:
$
  floor(v) gt.eq floor(floor(n / 2^(i-1)) / 2) = floor(n / 2^i)
$
$
  ceil(v) lt.eq ceil(ceil(n / 2^(i-1)) / 2) = ceil(n / 2^i)
$
Luego, $floor(n / 2^i) lt.eq v lt.eq ceil(n / 2^i)$.
]

Ahora podemos determinar qué niveles contienen hojas (vértices con valor $1$) y cuáles contienen sólo vértices internos (valor $gt.eq 2$).

Como $k = floor(log_2(n))$, tenemos que $2^k lt.eq n < 2^(k+1)$.

+ Niveles $i < k$ están completos: Para $i < k$, tenemos $2^i lt.eq 2^(k-1) < 2^k / 2 lt.eq n / 2$. Luego:
$
  floor(n / 2^i) gt.eq floor(n / 2^(k-1)) gt.eq floor(2^k / 2^(k-1)) = 2
$
Por la proposición anterior, todo vértice $v$ en el nivel $i$ tiene $v gt.eq 2$, así que es un vértice interno.

+ El nivel $k$ contiene hojas: Tenemos $2^k lt.eq n < 2^(k+1)$, lo que implica $1 lt.eq n / 2^k < 2$. Luego $floor(n / 2^k) = 1$. El vértice en la rama más a la izquierda (que siempre toma $floor(dot / 2)$) tiene valor exactamente $floor(n / 2^k) = 1$, que es una hoja.

+ Si $n$ es potencia de $2$, entonces $n = 2^k$. Luego, $n / 2^k = 1$, y $ceil(n / 2^k) = 1$. Por la proposición, todo vértice en el nivel $k$ tiene valor $v$ con $1 lt.eq v lt.eq 1$, así que $v = 1$. Todos son hojas, y el árbol tiene altura exactamente $k$.

+ Si $n$ no es potencia de $2$, entonces $n eq.not 2^k$. Como además $n gt.eq 2^k$, tenemos $n > 2^k$. Combinando con $n < 2^(k+1)$ y dividiendo por $2^k$, obtenemos $1 < n / 2^k < 2$. Luego, $ceil(n / 2^k) = 2$. El vértice más a la derecha tiene valor $ceil(n / 2^k) = 2$, que es un vértice interno. Luego el nivel $k$ tiene tanto hojas (valor $1$) como vértices internos (valor $2$). Para el nivel $k + 1$, como $n < 2^(k+1)$:
$
  ceil(n / 2^(k+1)) lt.eq ceil((2^(k+1) - 1) / 2^(k+1)) = 1
$
  Así, todo vértice en el nivel $k + 1$ tiene valor $1$, es decir, es hoja. El árbol tiene altura $k + 1$.

Resumiendo: el árbol tiene $k$ niveles completos ($0$ a $k - 1$), un nivel $k$ que es el primero con hojas, y posiblemente un nivel $k + 1$ con sólo hojas (si $n$ no es potencia de $2$).

Sabiendo esto, calculemos $f(n)$. Sean $L$ el número de hojas en el nivel $k$, y $m$ el número de vértices internos en el nivel $k$. Como los niveles $0, dots, k-1$ están completos, el nivel $k$ tiene exactamente $2^k$ vértices:
$
  m + L = 2^k
$
Cada vértice interno en el nivel $k$ tiene valor $2$ (sus dos hijos serán hojas con valor $1$). Cada hoja en el nivel $k$ tiene valor $1$. Como la suma de valores en cualquier nivel completo es $n$, y el nivel $k$ tiene hojas de valor $1$ y vértices internos de valor $2$:
$
  1 dot L + 2 dot m = n
$
Combinando ambas ecuaciones, obtenemos:
$
   m + L & = 2^k \
  2m + L & = n
$
Restando, $m = n - 2^k$, y luego $L = 2^(k+1) - n$.

Los niveles $0, dots, k - 1$ son completos y cada uno suma exactamente $n$, aportando $k dot n$ al total. El nivel $k$ tiene $m$ vértices internos de valor $2$, aportando $2m$. Las hojas aportan $0$. Entonces:
$
  f(n) = k dot n + 2m = k dot n + 2(n - 2^k) = n floor(log_2(n)) + 2n - 2^(floor(log_2(n))+1)
$

Notemos que, en particular, cuando $n$ es potencia de $2$, $f(n) = n log_2 n$.

/*
En una próxima sección vamos a ver cómo generalizar este argumento, usando el llamado "teorema maestro para recurrencias".

==== Conteo acotado

Eso fue un poco complicado, y dependió de la estructura precisa de $f$. Para otras funciones, no es obvio que vamos a poder hacer esto. En cambio, intentemos encontrar una cota superior ajustada para $f$. Intuitivamente, queremos sacarnos de encima el piso ($floor(dot)$) y techo ($ceil(dot)$). Podemos primero probar por inducción que nuestra cota vale para potencias de dos, donde desaparecen ambas $floor(dot)$ y $ceil(dot)$, y luego extender la cota al resto de los naturales.

Sea $n = 2^k$ con $k in NN$. Vamos a probar por inducción sobre $k$ el predicado $P(k): f(2^k) lt.eq k 2^k$.
#demo[
- Caso base: $k = 0$. Entonces $f(2^k) = f(1) = 0 lt.eq 0 times 1 = 0$.
- Paso inductivo: Sea $k in NN$. Asumimos $P(k)$. Queremos probar $P(k+1)$. Por $P(k)$ sabemos que que $f(2^k) lt.eq k 2^k$. Notemos que $2^(k+1) = 2 times 2^k$. Entonces: 
$
  f(2^(k+1)) & = f(2^k) + f(2^k) + 2^(k+1) \
             & lt.eq k 2^k + k 2^k + 2^(k+1) "por hipótesis inductiva" \
             & = 2k 2^k + 2^(k+1) \
             & = (k + 1) 2^(k+1) 
$
]
Por lo tanto, vale $P(k)$ para todo $k in NN$. Esto nos dice que para toda potencia de dos $n$, vale $f(n) lt.eq n log_2(n)$. Ahora queremos rellenar los huecos entre potencias de dos. Vamos a querer "ensandwichar" a $f(n)$, teniendo $f(a) lt.eq f(n) lt.eq f(b)$, con $a lt.eq n lt.eq b$, y ambas $a$ y $b$ potencias de dos. Para eso vamos a necesitar probar que $f$ es monótona no-decreciente

Probemos, entonces, que $f$ es monótona no-decreciente. Es decir, que para todo $n in NN$, vale $f(n) lt.eq f(n+1)$. Esto lo podemos probar por inducción sobre $n$.
#demo[
- Caso base: $n = 1$. Entonces, $f(1) = 0 lt.eq 1 = f(2)$.
- Paso inductivo: Sea $n in NN$, y asumamos que vale $f(k) lt.eq f(k+1)$ para todo $k lt.eq n$. Queremos probar que vale $f(n+1) lt.eq f(n+2)$. Notemos que:
$
  f(n+2) & = f(floor((n+2)/2)) + f(ceil((n+2)/2)) + n + 2 \
$

Ahora, comparemos los argumentos de $f$ en $f(n+1)$ y $f(n+2)$. Tenemos:
- $f(n+1) = f(floor((n+1)/2)) + f(ceil((n+1)/2)) + n + 1$
- $f(n+2) = f(floor((n+2)/2)) + f(ceil((n+2)/2)) + n + 2$

Observemos que $floor((n+2)/2) gt.eq floor((n+1)/2)$ y $ceil((n+2)/2) gt.eq ceil((n+1)/2)$.

De hecho, si $n+1$ es par, entonces $floor((n+1)/2) = ceil((n+1)/2) = (n+1)/2$, y $floor((n+2)/2) = (n+1)/2$, $ceil((n+2)/2) = (n+1)/2 + 1$. Luego, por la hipótesis inductiva aplicada a $(n+1)/2 - 1 lt.eq n$ y a $(n+1)/2 lt.eq n$:
$
  f(n+2) & = f((n+1)/2) + f((n+1)/2 + 1) + n + 2 \
         & gt.eq f((n+1)/2) + f((n+1)/2) + n + 2 ", por hipótesis inductiva" \
         & = f(n+1) + 1
$

Si $n+1$ es impar, entonces $floor((n+1)/2) = n/2$ y $ceil((n+1)/2) = (n+2)/2$. También, $floor((n+2)/2) = (n+1)/2$ y $ceil((n+2)/2) = (n+1)/2$. Por la hipótesis inductiva:
$
  f(n+2) & = f((n+1)/2) + f((n+1)/2) + n + 2 \
         & gt.eq f(n/2) + f((n+2)/2) + n + 1 ", ya que "f((n+1)/2) gt.eq f(n/2)" y "n + 2 gt.eq n + 1 \
         & = f(n+1)
$ 

En ambos casos, $f(n+1) lt.eq f(n+2)$.
]

Por lo tanto, $f$ es monótona no-decreciente. Este argumento parece bastante general, así que para poder usar el resultado para otras funciones, vamos a probar una generalización de esto.

#teo(title:[Monotonía Estructural])[
  Sea $T: NN_0 arrow RR$ definida por partes:
  $
    T(n) = cases(
      b_n & "si" 0 lt.eq n < n_0,
      sum_(i=1)^m T(h_i (n)) + f(n) & "si" n gt.eq n_0
    )
  $
  
  Donde $h_i (n) < n$ son las funciones de tamaño de subproblema (e.g., $floor(n/2)$).
  
  Si se cumplen las siguientes condiciones:
  
  1. La secuencia base no decrece ($b_0 lt.eq b_1 lt.eq ... lt.eq b_(n_0-1)$).
  2. El salto a la recursión respeta el orden ($b_(n_0-1) lt.eq T(n_0)$).
  3. Las funciones $h_i (n)$ son no-decrecientes ($n_1 lt.eq n_2 implies h_i (n_1) lt.eq h_i (n_2)$).
  4. $h_i (n) < n$ para todo $i$ y todo $n$.
  5. $f(n)$ es no-decreciente ($f(n) lt.eq f(n+1)$).
  
  Entonces $T(n)$ es *no-decreciente* ($T(n) lt.eq T(n+1)$) para todo $n in NN$.
]<teo:mono>
#demo[
  Usamos inducción fuerte sobre $n$.
  
  - Caso base ($n < n_0 - 1$): Por la condición 1, $T(n) lt.eq T(n+1)$.
  - Transición ($n = n_0 - 1$): Por la condición 2, $T(n_0 - 1) lt.eq T(n_0)$.
  
  - Caso recursivo ($n gt.eq n_0$):
    Queremos probar que $T(n) lt.eq T(n+1)$.
    Expandimos $T(n+1)$:
    $ T(n+1) = sum_(i=1)^m T(h_i (n+1)) + f(n+1) $
    
    Analizamos término a término:
    + Como $h_i$ es no-decreciente por la condición 3, tenemos $h_i (n) lt.eq h_i (n+1)$.
    + Como $h_i (n+1) < n+1$ por la condición 4, aplicamos la hipótesis inductiva (o la propiedad transitiva de la monotonía ya probada para valores menores): la función $T$ no decrece en estos argumentos.
       $ T(h_i (n)) lt.eq T(h_i (n+1)) $
    + Sumando sobre todo $i$:
       $ sum T(h_i (n)) lt.eq sum T(h_i (n+1)) $
    + Como $f$ es no-decreciente por la condición 5:
       $ f(n) lt.eq f(n+1) $
       
    Sumando las dos desigualdades del paso 3 y 4, obtenemos:
    $ T(n) lt.eq T(n+1) $
]

Volvamos ahora a nuestra $f$. Consideremos cualquier $n in NN$. Llamando $k = ceil(log_2(n))$, tenemos:

$
  n &lt.eq 2^k \
  f(n) &lt.eq f(2^k) "por ser "f" monótona no-decreciente" \
       &lt.eq k 2^k "por "P(k)
$

Ahora acotemos ambos factores, en términos de $n$. Sabemos que $2^k < 2n$, pues $k = ceil(log_2(n))$. Por el mismo motivo, $k < 1 + log_2(n) = log_2(2n)$. Luego, tenemos $f(n) lt.eq 2n log_2(2n)$, para todo $n in NN$.

Notemos cómo para no-potencias de $2$, tuvimos que ensanchar la cota superior, mediante la función techo. Esto es típico. Generalizemos esto.

#teo(title: [Extensión eventual de potencias])[
Sean $T, g: NN arrow RR0$ y $b, n_0 in NN$ que cumplen:

+ $b gt.eq 2$
+ $T(n) lt.eq T(n + 1)$ para todo $n lt.eq n_0$ (es decir, $T$ es no-decreciente a partir de $n_0$)
+ $g(n) lt.eq g(n+1)$ para todo $n gt.eq n_0$ (es decir, $g$ es no-decreciente a partir de $n_0$)
+ $T(b^k) lt.eq g(b^k)$ para todo $k in NN$ tal que $b^k gt.eq n_0$

Entonces $T(n) lt.eq g(b n)$ para todo $n gt.eq n_0$.
]<teo:extpot>
#demo[
Sea $n in NN$ tal que $n gt.eq n_0$. Como $b gt.eq 2$, podemos tomar $k = ceil(log_b(n))$, y tenemos que $b^k lt.eq n < b^(k+1)$. Como $n gt.eq n_0$ y $b^(k+1) > n$, entonces $b^(k+1) > n_0$. Como $T$ es no-decreciente desde $n_0$, entonces tenemos $T(n) lt.eq T(b^(k+1))$. Usando la cuarta condición, tenemos que $T(n) lt.eq T(b^(k+1)) lt.eq g(b^(k+1))$.

Por otro lado, como $b^k lt.eq n$, tenemos que $b^(k+1) lt.eq b n$. Como $b gt.eq 2$ y $n gt.eq n_0$, tenemos que $b^(k+1) gt.eq n_0$, y por lo tanto podemos usar la condición 3, obteniendo $g(b^(k+1)) lt.eq g(b n)$.

Juntando ambas desigualdades obtenemos $T(n) lt.eq g(b n)$.
]

==== Acotado de conjuntos asintóticos

Supongamos que tenemos un conjunto de funciones como $O(n)$, y sabemos que $f in O(n)$. En general *no* vamos a poder decir que $f(n) = alpha n$ para algún $alpha in RRg0$, pero sí vamos a poder decir que existe una función $g$ de la forma $g(n) = alpha n$ que domina asintóticamente a $f$. Es decir, que existe un $n_0 in NN$, tal que para todo $n in NN$, $(n gt.eq n_0 implies f(n) lt.eq g(n))$.

Tomando un caso más interesante, sea $T: NN arrow RR0$ que cumple:

$
T(n) = cases(1 &"si" n = 0,
             T(floor(n/2)) + O(n) &"si" n > 0
)
$

Recordemos qué significa esta notación. Esto nos dice que _existe_ una función $g: NN arrow RR0$, tal que $g in O(n)$, y el caso recursivo de $T$ es $T(n) = T(floor(n/2)) + g(n)$. Es decir, *no sabemos* quién exactamente es $T$, no podríamos decir $T(45) = dots$, pues no tenemos suficiente información. *Tampoco sabemos* que el caso recursivo de $T$ es de la forma $T(n) = T(floor(n/2)) + alpha n$ para algún $alpha in RRg0$. No vamos a poder calcular valores exactos de $T(n)$. Lo que sí vamos a poder hacer, es acotar a $T$.

Vamos a crear una función $W$, que tiene la misma forma que $T$ en el caso recursivo, pero que tiene una forma explícita en vez de $O(n)$. Como la $g$ que usa $T$, está en $O(n)$, sabemos que existe $alpha in RRg0$, y $n_0 in NN$, tal que para todo $n in NN, (n gt.eq n_0 implies g(n) lt.eq alpha n)$. Definimos, entonces, el caso recursivo de $W$ como $W(n) = W(floor(n/2)) + alpha n$. Esto nos da una función que sabemos domina a $T$, pero para la cual tenemos una forma explícita.

#warning-box[
Esto no es obvio! Si nuestra recursión fuera $T(n) = -T(floor(n/2)) + O(n)$, _no_ podríamos símplemente cambiar $T$ por $W$, dar una forma explícita para algo que acota al elemento de $O(n)$, y decir que $W$ domina a $T$, pues eso es falso. Esto requiere una demostración.
]

#teo(title:[Dominación recursiva (mayorante)])[Sea $T: NN_0 arrow RR$ una función definida por partes:
  $ T(n) = cases(
    b_n & "si" 0 lt.eq n < n_0,
    Phi({T(n_0), dots, T(n-1)}) + f(n) & "si" n gt.eq n_0
  )
  $
  para algunas funciones $Phi$ y $f$.

  Construimos una función acotante $W: NN arrow RR0$ que imita la estructura recursiva de $T$, pero "aplana" los casos base:
  $ W(n) = cases(
    K & "si" 0 lt.eq n < n_0,
    Phi({W(n_0), dots, W(n-1)}) + g(n) & "si" n gt.eq n_0
  ) $

  Si se cumplen tres condiciones:
  + $f(n) lt.eq g(n)$ para todo $n gt.eq n_0$.
  + El operador $Phi$ es no-decreciente (si la entrada crece, la salida no decrece).
  + La constante $K$ cumple que $K gt.eq max { b_0, b_1, dots, b_(n_0-1) }$.
  
  Entonces $T(n) lt.eq W(n)$ para todo $n in NN$.
]<teo:domrec>
#demo[
Usamos inducción.  
- Caso base: Sea $n in NN$, con $n < n_0$. Por definición, $W(n) = K$.
  Por la condición 3, $K gt.eq b_n$.
  Como $T(n) = b_n$, entonces $T(n) lt.eq W(n)$.
  
- Caso recursivo: Sea $n in NN$, con $n gt.eq n_0$. Por la hipótesis inductiva, asumimos $T(k) lt.eq W(k)$ para todo $k < n$. Sabemos que $T(n) = Phi({T(n_0), dots, T(n-1)}) + f(n)$. Aplicamos al hipótesis inductiva a cada argumento interno, y sabiendo que $Phi$ es monótona no-decreciente por la condición 2, obtenemos que $T(n) lt.eq Phi({W(n_0), dots, W(n-1)}) + f(n)$. Finalmente usamos la condición 1 para obtener que $T(n) lt.eq Phi({W(n_0), dots, W(n-1)}) + g(n) = W(n)$.
]

Tenemos entonces nuestra función acotante, $W$, definida como:

$
  W(n) = cases(
    1 &"si" n = 0,
    W(floor(n/2)) + alpha n &"si" n gt.eq 1
  )
$

donde $alpha$ es tal que para todo $n gt.eq n_0$, tenemos que $g(n) lt.eq alpha n$. Por el @teo:domrec, tenemos que $T(n) lt.eq W(n)$ para todo $n in NN_0$. Ahora podemos acotar $W$ como vimos antes.

/*Tenemos un teorema análogo para dominación por debajo.

#teo(title:[Dominación recursiva (minorante)])[
Sea $T: NN_0 arrow RR$ una función definida por partes:
  $ T(n) = cases(
    b_n & "si" 0 lt.eq n < n_0,
    Phi({T(n_0), dots, T(n-1)}) + f(n) & "si" n gt.eq n_0
  )
  $
  para algunas funciones $Phi$ y $f$.

  Construimos una función acotante $V: NN arrow RR0$ que imita la estructura recursiva de $T$, pero "aplana" los casos base:
  $ V(n) = cases(
    K & "si" 0 lt.eq n < n_0,
    Phi({V(n_0), dots, V(n-1)}) + g(n) & "si" n gt.eq n_0
  ) $

  Si se cumplen tres condiciones:
  + $f(n) gt.eq g(n)$ para todo $n gt.eq n_0$.
  + El operador $Phi$ es no-decreciente (si la entrada crece, la salida no decrece).
  + La constante $K$ se elige tal que $K lt.eq min { b_0, b_1, dots, b_(n_0-1) }$.

  Entonces $T(n) gt.eq V(n)$ para todo $n in NN$.
]<teo:domrecmin>
#demo[
Sea $n in NN$. Si $n < n_0$, entonces $K = V(n) lt.eq min { b_0, dots, b_(n_0-1) } lt.eq b_n = T(n)$. De otra forma, $V(k) lt.eq T(k)$ para todo $k < n$. Como esto vale para todos los argumentos de $Phi({V(n_0), dots, V(n-1)})$, y $Phi$ es no-decreciente, tenemos que $Phi({V(n_0), dots, V(n-1)}) lt.eq Phi({T(n_0), dots, T(n-1)})$. Finalmente, como $g(n) lt.eq f(n)$, tenemos que $V(n) = Phi({V(n_0), dots, V(n-1)}) + g(n) lt.eq Phi({T(n_0), dots, T(n-1)}) + f(n) = T(n)$.
]*/

=== Acotado asintótico
Finalmente, intentemos encontrar una cota para una función $T$ que cumple con una forma recursiva definida asintóticamente, juntando todo lo que vimos.

#prop[
Sea $T$ que cumple:

$
T(n) = cases(
  37 &"si" n = 0,
  42 &"si" n = 1,
  3 &"si" n = 2,
  T(floor(n/2)) + T(ceil(n/2)) + O(n) &"si" n > 2
)
$

Probar que $T$ está en $O(n log n)$.
]
#demo[
Recordemos que $T$ no está definida únicamente, por el $O(n)$ en su caso recursivo.

Para mostrar que $T in O(n log n)$, vamos a juntar lo que vimos hasta ahora:

+ Vamos a encontrar una cota superior $W$ para $T$, usando que sabemos qué forma tiene $T$.
+ Vamos a probar que $W$ in $O(n log n)$ si restringimos $O$ a potencias de $2$ (pues la recursión se divide en $2$ cada vez)
+ Vamos a probar que $W$ es monotónicamente creciente.

Con esto vamos a concluir que $W in O(n log n)$ en general, y como $T(n) lt.eq W(n)$ para todo $n in NN$, tendremos que $T in O(n log n)$.

+ Sea $T$ una tal función, donde en el caso recursivo está definido como $T(n) = T(floor(n/2)) + T(ceil(n/2)) + f(n)$ para algún $f in O(n)$. Como $f in O(n)$, existe un $alpha in RRg0, n_0 in NN$, tal que para todo $n in NN$, $n gt.eq n_0 implies f(n) lt.eq alpha n$.
+ Definimos $W$ como $
  W(n) = cases(
    50 &"si" n lt.eq 3,
    W(floor(n/2)) + W(ceil(n/2)) + alpha n &"si" n gt.eq 3
  )
  $
  que por @teo:domrec sabemos domina a $T$.
+ Si asumimos que $n$ es una potencia de $2$, entonces intentemos probar que $W(n) lt.eq beta n log_2 n + gamma$ para algún $beta in RRg0$ y $gamma in RR$. Para encontrar quién puede ser $beta$ y $gamma$, veamos que en los casos base, donde $W(n) = 50$, tenemos $W(n) lt.eq beta n log_2 n + gamma$:
    - $n = 0$: $50 lt.eq beta 0 log_2(0) + gamma = gamma$, con lo cual tenemos $50 lt.eq gamma$.
    - $n = 1$: $50 lt.eq beta log_2(1) + gamma = gamma$, con lo cual tenemos $50 lt.eq gamma$.
    - $n = 2$: $50 lt.eq 2 beta log_2(2) + gamma = 2beta + gamma$, con lo cual tenemos $50 lt.eq 2beta + gamma$.
    - $n = 3$: $50 lt.eq 3 beta log_2(3) + gamma = 3beta log_2(3) + gamma$.
  Con lo cual eligiendo $gamma = 50$, y $beta gt.eq 0$, satisfacemos la desigualdad para los casos base.


  Para encontrar $beta$, planteemos por inducción:
  $
    W(n) &= 2 W(n/2) + alpha n \
         &lt.eq 2 (beta (n/2) log_2 (n/2) + gamma) + alpha n \
         &lt.eq beta n (log_2(n) - 1) + 2gamma + alpha n \
         &= beta n log_2(n) - beta n + 2gamma + alpha n \

  $

  obteniendo $W(n) lt.eq (beta n log_2 n + gamma) + (gamma + (alpha - beta) n)$. Queremos que esto valga para todo $n in NN$, $n gt.eq 4$. Si tuvieramos $gamma + (alpha - beta) n lt.eq 0$, estaríamos, pues podríamos simplemente descartar ese término y conseguir $W(n) lt.eq beta n log_2 n + gamma$. Como $n gt.eq 4$, queremos $gamma + 4 (alpha - beta) lt.eq 0$.

  $
    gamma + 4 (alpha - beta) &lt.eq 0 \
    gamma &lt.eq 4 (beta - alpha) \
    gamma &lt.eq 4 beta - 4 alpha \
    beta &gt.eq (50 + 4alpha)/4 = 12.5 + alpha/4
  $

  Eligiendo entonces $beta = 12.5 + alpha/4$, tenemos que $W(n) lt.eq gamma n log_2 n + beta$ para todo $n$ potencia de $2$.

+ Queremos ver que $W$ es monotónica creciente. Para esto podemos usar el @teo:mono.
+ Podemos ahora extender $W$ a todos los $n in NN$ usando el @teo:extpot, y podemos acotar $W(n) lt.eq 2 n gamma log_2 (2n) + beta = 2 n gamma (1 + log_2 n) + beta = 2n gamma log_2 n + 2 n gamma + beta$.

Por lo tanto, al estar $T$ acotada por arriba por $W$, y $W$ estando en $O(n log n)$, tenemos que $T in O(n log n)$.
]

Esto fue bastante esfuerzo, y requirió adivinar una cota superior para $W$ en potencias de $2$ en el paso 3. Podemos intentar generalizar el trabajo que hicimos, para una clase más amplia de funciones.

*/
=== Teorema maestro

Acotar esa función nos costó bastante trabajo. Afortunadamente hay un teorema que nos ayuda bastante, pues lo podemos aplicar mecánicamente, y generaliza lo que hicimos.

La idea del teorema es mirar el árbol de recurrencia de nuestra función $T$. Cada vértice va a contribuir algo a la suma total. Hay aproximadamente $a^(log_b n) = n^(log_b a)$ hojas.

Pueden pasar tres cosas con el valor de $T$:
  - El valor de las hojas domina a $f$. Si $f$ crece menos rápido que $n^(log_b a)$, entonces la mayor contribución al valor de $T$ viene, asintóticamente, dada por las hojas. Luego $T in Theta(n^(log_b a))$.
  - El valor de las hojas está balanceado con el valor de $f$. Luego el costo de cada nivel es $f(n)$ o $n^(log_b a)$, cualquiera de las dos, y habiendo $log_b n$ niveles, tenemos que $T in Theta(n^(log_b a) log_b^(k+1) n)$.
  - El valor de $f$ domina a los valores de las hojas. Obtenemos $T in Theta(f)$.

#show_master_theorem_infographic()

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



La demostración está en la #xref(<demo:master>) del apéndice. Veamos cómo usar este teorema.

#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    1 &"si" n = 0,
    T(floor(n/2)) + 35 &"si" n gt.eq 1
  )
$

Demostrar que $T in Theta(log n)$.
]
#demo[
Veamos en qué caso del teorema caemos. Esta recurrencia es de la forma $a_1 = 1$, $a_2 = 0$, $b = 2$. Luego, $c = log_b a = log_2 1 = 0$. Tenemos $f(n) = 35$. Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? No, pues $n^c = n^0 = 1$, con lo cual $O(n^(c - epsilon)) = O(1/n^epsilon)$. Una constante (35 en este caso) no puede siempre ser menor que $1/n^epsilon$ para algún ningún $epsilon > 0$, pues eventualmente $1/n^epsilon$ decrece hasta ser arbitrariamente cercana a cero. Luego no caemos en el primer caso.

Es cierto que $f in Theta(n^c log^k n)$? Sí, con $k = 0$. Este conjunto es $Theta(n^c log^0 n) = Theta(n^0 (log n)^0) = Theta(1)$, y efectivamente $f in Theta(1)$. Luego, el teorema maestro nos dice que $T in Theta(n^0 log^1 n) = Theta(log n)$.
]

#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    1 &"si" n = 0,
    T(floor(n/2)) + 7 n^2 &"si" n gt.eq 1
  )
$

Demostrar que $T in Theta(n^2)$.
]

#demo[
Veamos en qué caso del teorema caemos. Esta recurrencia es de la forma $a_1 = 1$, $a_2 = 0$, $b = 2$. Luego, $c = log_b a = log_2 1 = 0$. Tenemos $f(n) = 7 n^2$. Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? No, pues $f in Omega(n^2)$, cuya intersección con $O(1/n^epsilon)$ es vacía.

Es cierto que $f in Theta(n^c log^k n)$ para algún $k in NN$? No, pues $n^c = n^0 = 1$, con lo cual $Theta(n^c log^k n) = Theta(log^k n)$. Luego no caemos en este caso, pues no hay ningún $k$ tal que $f in Theta(log^k n)$, al ser $f$ un polinomio de grado mayor a 0.

Es cierto que $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$? Sí, con $epsilon = 2$. Este conjunto es $Omega(n^(c + epsilon)) = Omega(n^2)$, y efectivamente $f in Omega(n^2)$ (y de hecho, $f in Theta(n^2)$). Ahora verifiquemos la condición de regularidad. Queremos encontrar $0 lt.eq r < 1$ tal que
$
  a_1 f(floor(n/b)) + a_2 f(ceil(n/b)) &= f(floor(n/2)) \
   &lt.eq r f(n)
$

Como $f$ es monotónicamente creciente, tenemos:

$
  f(floor(n/b)) lt.eq f(n/2) = (7/4) n^2 lt.eq (1/4) 7n^2 = 1/4 f(n)
$

Luego, tomando $r = 1/4$, tenemos que $f(floor(n/b)) lt.eq r f(n)$, para todo $n in NN$. Luego $T in Theta(n^2)$.
]

#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    3 &"si" n = 0,
    2 &"si" n = 1,
    34 &"si" n = 2,
    9 &"si" n = 3,
    3T(floor(n/4)) + T(ceil(n/4)) + 7n + 9 &"si" n gt.eq 4
  )
$

Demostrar que $T in Theta(n log n)$.
]
#demo[
Tenemos $a = a_1 + a_2 = 3 + 1 = 4$, y $b = 4$, con lo cual $c = log_b a = log_4 4 = 1$. Tenemos $f(n) = 7n + 9$. Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? No, pues $n^c = n^1 = n$, con lo cual $O(n^(c - epsilon)) = O(n^1/n^epsilon)$. Un término lineal (7n + 9 en este caso) no puede siempre ser menor que $n/n^epsilon$ para algún ningún $epsilon > 0$, pues eventualmente $n/n^epsilon$ crece hasta ser arbitrariamente grande. Luego no caemos en el primer caso.

Es cierto que $f in Theta(n^c log^k n)$? No, pues $n^c = n^1 = n$, con lo cual $Theta(n^c log^k n) = Theta(n log^k n)$. Con $k = 0$, tenemos precisamente que $f in Theta(n log^0 n) = Theta(n)$. Luego, el teorema maestro nos dice que $T in Theta(n log^1 n) = Theta(n log n)$.
]


#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    1 &"si" n = 0,
    1 &"si" n = 1,
    4T(floor(n/2)) + n &"si" n gt.eq 2
  )
$

Demostrar que $T in Theta(n^2)$.
]
#demo[
Tenemos $a = 4$, $b = 2$, con lo cual $c = log_b a = log_2 4 = 2$. Tenemos $f(n) = n$.

Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? Tomando $epsilon = 1$, tenemos $n^(c - epsilon) = n^(2-1) = n$. Efectivamente $f(n) = n in O(n)$. Luego caemos en el primer caso.

El teorema maestro nos dice que $T in Theta(n^c) = Theta(n^2)$.
]

#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    1 &"si" n lt.eq 2,
    8T(floor(n/3)) + n^2 &"si" n gt.eq 3
  )
$

Demostrar que $T in Theta(n^2)$.
]
#demo[
Tenemos $a = 8$, $b = 3$, con lo cual $c = log_b a = log_3 8 approx 1.89$. Tenemos $f(n) = n^2$.

Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? Tendríamos que $n^2 in O(n^(c - epsilon))$, lo cual requiere $2 lt.eq c - epsilon$, es decir $epsilon lt.eq c - 2 approx -0.11 < 0$. Como necesitamos $epsilon > 0$, no caemos en el primer caso.

Es cierto que $f in Theta(n^c log^k n)$ para algún $k in NN$? Tendríamos $n^2 in Theta(n^c log^k n)$ con $c approx 1.89 < 2$. Pero $n^2$ crece estrictamente más rápido que $n^c log^k n$ para cualquier $k$ fijo, pues $lim_(n arrow infinity) n^2 / (n^c log^k n) = lim_(n arrow infinity) n^(2-c) / log^k n = infinity$. Luego no caemos en el segundo caso.

Es cierto que $f in Omega(n^(c + epsilon))$ para algún $epsilon in RRg0$? Tomando $epsilon = 0.1$, tenemos $c + epsilon approx 1.99 < 2$, así que $n^2 in Omega(n^1.99)$. Esto es cierto.

Debemos verificar la condición de regularidad: que exista $k < 1$ tal que $a dot f(n/b) lt.eq k dot f(n)$. Tenemos:
$
  8 dot f(n/3) = 8 dot (n/3)^2 = 8n^2 / 9
$
Queremos $8n^2 / 9 lt.eq k dot n^2$, es decir $k gt.eq 8/9$. Tomando $k = 8/9 < 1$, la condición se cumple.

Luego caemos en el tercer caso, y el teorema maestro nos dice que $T in Theta(f(n)) = Theta(n^2)$.
]
#prop[
El número de multiplicaciones que realiza el algoritmo de Strassen para multiplicación de matrices, dadas dos matrices de $n times n$ donde $n$ es una potencia de $2$, tiene la recurrencia:
$
  T(n) = cases(
    1 &"si" n = 1,
    7T(n/2) + Theta(n^2) &"si" n gt 1
  )
$

Demostrar que $T in Theta(n^(log_2 7))$.
]
#demo[
Tenemos $a = 7$, $b = 2$, con lo cual $c = log_b a = log_2 7 approx 2.81$. Tenemos $f(n) in Theta(n^2)$.

Es cierto que $f in O(n^(c - epsilon))$ para algún $epsilon in RRg0$? Tomando $epsilon = 0.8$, tenemos $c - epsilon approx 2.01$. Debemos verificar que $n^2 in O(n^2.01)$, lo cual es cierto pues $2 < 2.01$. Luego caemos en el primer caso.

El teorema maestro nos dice que $T in Theta(n^c) = Theta(n^(log_2 7))$.  
]


#prop[
Sea $T: NN arrow RR0$, definida como:
$
  T(n) = cases(
    1 &"si" n = 0,
    2T(floor(n/2)) + n / (log n) &"si" n gt.eq 1
  )
$

Mostrar que el teorema maestro no aplica directamente a esta recurrencia.
]
#demo[
Tenemos $a = 2$, $b = 2$, con lo cual $c = log_b a = log_2 2 = 1$. Tenemos $f(n) = n / (log n)$.

Veamos que no caemos en ninguno de los tres casos.

- Caso 1. Requiere $f in O(n^(c - epsilon)) = O(n^(1-epsilon))$ para algún $epsilon > 0$. Pero $lim_(n arrow infinity) (n / (log n)) / n^(1-epsilon) = lim_(n arrow infinity) n^epsilon / (log n) = infinity$ para todo $epsilon > 0$. Luego $n / (log n) in.not O(n^(1-epsilon))$ para ningún $epsilon > 0$.

- Caso 2. Requiere $f in Theta(n^c log^k n) = Theta(n log^k n)$ para algún $k gt.eq 0$. Tenemos $f(n) = n / (log n) = n log^(-1) n$. Esto correspondería a $k = -1$, pero el teorema maestro requiere $k gt.eq 0$. Luego no caemos en el segundo caso.

- Caso 3. Requiere $f in Omega(n^(c + epsilon)) = Omega(n^(1+epsilon))$ para algún $epsilon > 0$. Pero $lim_(n arrow infinity) (n / (log n)) / n^(1+epsilon) = lim_(n arrow infinity) 1 / (n^epsilon log n) = 0$ para todo $epsilon > 0$. Luego $n / (log n) in.not Omega(n^(1+epsilon))$ para ningún $epsilon > 0$.

Como no caemos en ninguno de los tres casos, el teorema maestro no aplica a esta recurrencia. Habría que usar otros métodos (como el árbol de recursión o el método de sustitución) para determinar su comportamiento asintótico.
]

#prop[
  Sea la $T: NN arrow NN$ una función dada por $T(0) = 1$, y para todo $n in NN$ tal que $n > 0$, definimos $T(n) = 2 T(n/2) + Theta(n log n)$. Es decir, existe una función $h: NN arrow NN$ tal que $h in Theta(n log n)$, y $T(n) = 2 T(n/2) + h(n)$ para todo $n in NN, n > 0$.

  Probar que $T in Theta(n log^2 n)$.]
#demo[
  Podemos usar el teorema maestro, que nos dice que si tenemos una función $T$ de la forma $T(n) = a T(n/b) + f(n)$ para todo $n in NN, n > 0$, y $f in Theta(n^(log_b (a)) log^k n)$ para algún $k in NN$, entonces $T in Theta(n^(log_b (a)) log^(k+1)(n))$. Basta elegir $k = 1, a = 2, b = 2$, para ver que estamos dentro de las condiciones de este caso del teorema, y como $log_2(2) = 1$, tenemos que $T in Theta(n log^2 n)$.]

=== Ejercicios

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 4T(floor(n/3)) + O(n log n)$, y $T(0) = 0$. Probar que $T in Theta(n^(log_3 4))$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 2T (floor(n/2)) + n log n$, y $T(0) = 7$. Probar que $T in Theta(n log^2 n)$.
]

#ej[
  Sea $T: NN arrow NN$ tal que $T(n) = 2T(floor(n/4)) + sqrt(n)$, y $T(0) = 1$. 
  Probar que $T in Theta(sqrt(n) log n)$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 4$, $T (n) = 16T (floor(n/4)) + n!$, y $T(k) = k^2$ para $0 lt.eq k lt.eq 4$. Probar que $T in Theta(n!)$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 3T(floor(n/3)) + sqrt(n)$, y $T(0) = 0$. Probar que $T in Theta(n)$.
]

#load-bib()