#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble
== Backtracking

A veces nuestra solución a un problema va a ser una exploración de un espacio de sub-soluciones, donde vamos construyendo la solución mediante una serie de elecciones a cada paso. Un algoritmo de backtracking es uno en el cual, ante una elección con varias opciones, probamos tomar una de las posibles opciones, nos fijamos si es posible extender esta opción a una solución final, y si no lo es, deshacemos esta elección y probamos con otra de las opciones.

Un ejemplo clásico es el de colocar $n$ reinas en un tablero de ajedrez con $n$ filas y $n$ columnas, sin que se ninguna pueda atacar a otra en un movimiento. La idea de la solución es colocar una reina en una posición $(i, j)$ del tablero, y resolver recursivamente el problema de colocar las $n - 1$ reinas restantes en el tablero resultante. Si no es posible hacer esto, sacamos a la reina, y la colocamos en otra posición. Si no existe una posición que podemos recursivamente completar, entonces decimos que no se puede continuar con el tablero que nos dan. El código queda así:

#algorithm({
  import algorithmic: *
  Procedure(
    "N-Queens",
    ($n in NN$),
    {
      Comment[$c[i]$ contiene la columna donde pusimos una reina en la $i$-ésima fila, o $0$ si no pusimos una reina en esa fila todavía.]
      Assign[$c[1 dots n]$][0]
      Comment[$f[i]$ indica si hay una reina en la fila $i$.]
      Assign[$f[1 dots n]$][#smallcaps("false")]
      Comment[$v[i]$ indica si hay una reina en la $i$-ésima diagonal "decreciente".]
      Assign[$v[1 dots (2n)]$][#smallcaps("false")]
      Comment[$w[i]$ indica si hay una reina en la $i$-ésima diagonal "creciente".]
      Assign[$w[1 dots (2n)]$][#smallcaps("false")]

      Return(FnInline[Backtrack][$1, n, c, f, v, w$])
    },
  )
  Procedure(
    "Backtrack",
    ($r in NN$, $n in NN$, $c[1 dots n]$, $f[1 dots n]$, $v[1 dots (2n)]$, $w[1 dots (2n)]$),
    {
      Comment[Caso base: Ya pusimos $n$ reinas.]
      If($r gt n$, {
        Return[$c$]
      })

      Comment[Intentamos poner una reina en la fila $r$, en cada columna $j$.]
      For([$j = 1$ to $n$], {
        Assign($d_1$, $r - j + n$)
        Assign($d_2$, $r + j$)
        Comment[Si no hay reinas que atacarían a una reina en $(r, j)$ ya puestas.]
        If([$not f[j]$ and $not v[d_1]$ and $not w[d_2]$], {
          Comment[Ponemos una reina en $(r, j)$.]
          Assign[$c[r]$][$j$]
          Assign[$f[j]$][#smallcaps("true")]
          Assign[$v[d_1]$][#smallcaps("true")]
          Assign[$w[d_2]$][#smallcaps("true")]

          Comment[Resolvemos recursivamente el tablero que queda.]
          Assign($z$, FnInline[Backtrack][$r + 1, n, c, f, v, w$])
          Comment[Si encontramos una solución recursivamente, la devolvemos.]
          If($z eq.not #smallcaps("null")$, {
            Return[$z$]
          })
          Comment[Si no, deshacemos la elección que hicimos para la fila $r$.]
          Assign[$f[j]$][#smallcaps("false")]
          Assign[$v[d_1]$][#smallcaps("false")]
          Assign[$w[d_2]$][#smallcaps("false")]
        })
      })

      Comment[Si no devolvimos durante el ciclo, no hay forma de poner una reina en la fila $r$. El tablero que nos pasaron no es resoluble, y devolvemos #smallcaps("null").]
      Return[#smallcaps("null")]
    },
  )
})

Vemos ahí las características clásicas de un algoritmo de backtracking:
- Construímos una solución global paso a paso, eligiendo opciones en cada paso, agregándolos a una sub-solución que tenemos.
- Al hacer una elección, nos fijamos recursivamente si podemos completar nuestra sub-solución actual con esta decisión, a una solución global.
- Si no pudimos hacer esto, deshacemos nuestra elección e intentamos con otra.
- Si ninguna opción funciona, el sub-problema que estamos resolviendo no es resoluble, y lo informamos al que nos llamó.

Demostrar la correctitud de estos algoritmos es un caso particular de correctitud de algoritmos recursivos.#footnote[Por su estructura inductiva, donde la solución al problema global se crea tomando pasos en una sub-solución de un sub-problema similar, prácticamente siempre los algoritmos de backtracking están escritos de forma recursiva. No es _necesario_, pero sí lo más común.] Veamos cómo demostrar la correctitud de nuestro algoritmo.

#prop[
  Dado un $n in NN$:
  - Si es posible colocar $n$ reinas en un tablero de ajedrez de $n times n$, de tal forma que ninguna pueda atacar a otra en un movimiento, #smallcaps("n-queens")$(n)$ devuelve una representación de algún tal tablero. El algoritmo devuelve una lista $c$ de longitud $n$, tal que $1 lt.eq c[i] lt.eq n$ es la columna donde hay una reina en la fila $i$.
  - Si no es posible, el algoritmo devuelve #smallcaps("null").
]
Como lo único que hace #smallcaps("n-queens") es llamar a #smallcaps("backtrack"), vamos a demostrar una proposición sobre #smallcaps("backtrack").

Sea $n in NN$, y $r in NN$ tal que $1 lt.eq r lt.eq n + 1$. Definimos $P(r)$ como:

#defi[$P(r)$: Sea $(c, f, v, w)$ una representación de un tablero de ajedrez de $n times n$, con $r - 1$ reinas ya colocadas, y asumiendo que ningún par de las reinas ya colocadas se pueden atacar entre sí en un movimiento. Si es posible completar el tablero agregando $n - r + 1$ reinas de tal forma que ningún par de ellas se ataque en un movimiento, entonces #smallcaps("backtrack")$(r, n, c, f, v, w)$ devuelve una lista $c'$ que representa un tal tablero. En particular, para cada $1 lt.eq i lt.eq n$, $c'[i]$ es la columna donde hay una reina en la fila $i$. Si no es posible completar el tablero, #smallcaps("backtrack") devuelve #smallcaps("null").]

Lo primero que vemos es que #smallcaps("n-queens") llama a #smallcaps("backtrack") con $r = 1$, y una representación de un tablero vacío. $P(1)$ nos dice que #smallcaps("backtrack") nos dice si es posible agregar $n-r+1=n-1+1=n$ a un tablero vacío (que es lo mismo que colocar $n$ reinas), de tal forma que ningún par se ataque. Luego, si probamos $P(1)$, sabremos que #smallcaps("n-queens") es correcto.

#demo[
  Vamos a probar $P(k)$ para todo $1 lt.eq k lt.eq n + 1$ por inducción. Nuestro caso base va a ser $k = n + 1$, y vamos a usar $P(k+1)$ para probar $P(k)$. Si los incomoda el hecho de hacer inducción "hacia atrás", pretendan que estamos probando $Q(k): 1 lt.eq k lt.eq n implies P(n - k + 1)$, pero realmente no hay ningún problema. Estamos construyendo una cadena de implicaciones, fundada en un caso base, como en toda inducción.

  + Caso base, $P(n + 1)$. Si $r = n + 1$, entonces ya hemos colocado $r - 1 = n$ reinas en el tablero que nos pasan, y sabemos que ningún par se atacan. Luego, existe un tal tablero que es solución al problema entero. Podemos devolver $c$, que indica en qué columna está la reina de cada fila, y es la representación de tal tablero. Vemos que #smallcaps("backtrack")$(n + 1, n, c, f, v, w)$ devuelve precisamente $c$, y luego vale $P(n + 1)$.
  + Paso inductivo. Tenemos $r in NN$, $1 lt.eq r lt.eq n$. Asumimos $P(r+1)$, y queremos probar $P(r)$. Sea $T$ el tablero que nos pasan, el representado por la 4-tupla $(c, f, v, w)$. Hay dos opciones, o bien $T$ se puede completar a un tablero con $n$ reinas, o no se puede.
    - Si se puede completar, entre todos los tableros solución que son completaciones de este, sea $T'$ cualquier tablero donde la reina que hay en la $r$-ésima fila está en la menor columna, y sea $j$ tal columna. Vemos que el ciclo que hace #smallcaps("backtrack") prueba las columnas posibles donde poner la $r$-ésima reina en orden creciente, y luego como ningún tablero se puede completar poniendo una reina en $c[r] = j'$ con $j' < j$, todas esas iteraciones van a terminar sin devolver nada. Luego, llegaremos a la $j$-ésima iteración. En esa iteración, vamos a poner una reina en $c[r] arrow.l j$, y escribimos $f$, $v$, y $w$ correspondientemente. Como $T'$ existe, y el tablero que acabamos de armar es un sub-tablero de $T'$ y también una completación parcial de $T$, estamos llamando a #smallcaps("backtrack")$(r + 1, dots)$ con un tablero que es completable a una solución global $T'$. Como asumimos $P(r+1)$ por inducción, sabemos que esta llamada a #smallcaps("backtrack") va a devolver un tablero solución (no necesariamente $T'$!). Es decir, $z eq.not #smallcaps("null")$. Luego, al devolver $z$, #smallcaps("backtrack") está devolviendo un tablero solución que completa $T$, que es el comportamiento esperado, y prueba $P(r)$.
    - En el caso contrario, no existe ninguna manera de completar $T$ para obtener un tablero con $n$ reinas. Si el ciclo devolviera en algún momento, tendríamos por $P(r+1)$ un tablero $z$ que extiende a $T$ a $n$ reinas, pero no existe. Luego, en ningún momento del ciclo podemos devolver, y el ciclo recorre todas sus iteraciones y termina. #smallcaps("backtrack") entonces devuelve #smallcaps("null"), que es la respuesta correcta en este caso. Esto entonces prueba $P(r)$.

    En ambos casos probamos $P(r)$, partiendo de $P(r+1)$. Por inducción, probamos $P(1)$, y esto completa la demostración.
]

Analizar el comportamiento asintótico de este algoritmo es también simple. Notemos cómo, al haber retornos dentro del ciclo, no vamos a poder saber exactamente cuántas iteraciones va a hacer en cada llamada. Vamos a definir $X(n)$ como el número de operaciones que realiza #smallcaps("n-queens")$(n)$. Vamos a encontrar una función $T$ tal que $X in O(T)$.

#prop[
  $T(n) = (n+1)!$ es tal que $X in O(T)$.
]
#demo[
  Sea $n in NN$. Veamos cuántas operaciones realiza #smallcaps("backtrack")$(r, n, dots)$, sabiendo que tenemos $r lt.eq n + 1$ durante todo el algoritmo. Llamemos $B(k)$ a una cota superior al número de operaciones que realiza, cuando $k = n - r + 1$. Vamos a definirla por inducción.
  - Si $k = 0$, entonces $r = n + 1$. En este caso, #smallcaps("backtrack") retorna inmediatamente, realizando un número constante de operaciones. Luego $B(0) = q$ para algún número de operaciones fijo $q$.
  - Si $k > 0$, entonces $r < n + 1$, y #smallcaps("backtrack") va a hacer algunas iteraciones, y en algunas va a llamarse recursivamente. Podríamos acotar este número de llamadas recursivas por $n$ trivialmente, pues el ciclo es de $1$ a $n$, pero si tenemos más cuidado, vemos que ya hay $r-1$ reinas en el tablero que nos dan. Por lo tanto, al verificar si $not f[j]$, va a haber $r - 1$ valores para los cuales $f[j] = #smallcaps("true")$, y por lo tanto no haremos llamadas recursivas. Entonces, hay a lo sumo $n - (r - 1) = n - r + 1 = k$ llamadas recursivas, no $n$. Por hipótesis inductiva, cada llamada recursiva de la forma #smallcaps("backtrack")$(r + 1, n, dots)$, realiza a lo sumo $B(k - 1)$ operaciones (pues aumentar $r$ es disminuir $k$). Luego, como también tenemos un costo de iterar $n$ veces y escribir/leer arrays (que cuestan $O(1)$ operaciones), realizaremos a lo sumo $B(k) = k B(k-1) + O(n)$ operaciones.

  Luego, podemos acotar por arriba el número de operaciones que realiza #smallcaps("backtrack")$(r, n, dots)$ por $B(n - r + 1)$, donde $B$ es la siguiente función:

  $
    B(k) = cases(
      q wide & "si" k = 0,
      k B(k - 1) + O(n) & "si" k > 0
    )
  $

  Para ser claros, lo que estamos diciendo explícitamente es que existe una función $g:NN arrow NN$, con $g in O(n)$, tal que

  $
    B(k) = cases(
      q wide & "si" k = 0,
      k B(k - 1) + g(n) & "si" k > 0
    )
  $

  Intentemos encontrar una forma cerrada para $B$. Si $g(n) = 0$, es fácil ver que $B(k) = k! q$. Veamos entonces qué pasa comparando $B(k)$ con $k!$. Definimos $C(k) = B(k)/k!$. Cuando $k > 0$, tenemos

  $
    C(k) & = B(k)/k! \
         & = B(k-1)/(k-1)! + g(n)/k! \
         & = C(k-1) + g(n)/k!
  $

  Entonces tenemos $C(k) = q + sum_(i=1)^k g(n)/i!$. Luego, $B(k) = k! C(k) = k! (q + sum_(i=1)^k g(n)/i!) = k! (q + g(n) sum_(i=1)^k 1/i!)$. Recordando que $sum_(i=0)^infinity 1/i! = e$, tenemos que $B(k) lt.eq k! (q + g(n) (e - 1)) lt.eq k! (q + 2g(n))$. Finalmente, vemos que $B in O(n! (q + 2 g(n))) subset.eq O(g(n) n!) subset.eq O(n n!) subset.eq O((n+1)!)$.

  Recordando que #smallcaps("n-queens")$(n)$ llama a #smallcaps("backtrack")$(r = 1, n, dots)$, y este hace a lo sumo $B(n - r + 1) = B(n - 1 + 1) = B(n)$ operaciones, tenemos que $X(n) lt.eq B(n)$, con $B in O((n+1)!)$, y luego $X in O((n+1)!)$. Luego, existe una función $T(n) = (n+1)!$, tal que $X in O(T)$.]

== Backtracking

A veces nuestra solución a un problema va a ser una exploración de un espacio de sub-soluciones, donde vamos construyendo la solución mediante una serie de elecciones a cada paso. Un algoritmo de backtracking es uno en el cual, ante una elección con varias opciones, probamos tomar una de las posibles opciones, nos fijamos si es posible extender esta opción a una solución final, y si no lo es, deshacemos esta elección y probamos con otra de las opciones.

Un ejemplo clásico es el de colocar $n$ reinas en un tablero de ajedrez con $n$ filas y $n$ columnas, sin que se ninguna pueda atacar a otra en un movimiento. La idea de la solución es colocar una reina en una posición $(i, j)$ del tablero, y resolver recursivamente el problema de colocar las $n - 1$ reinas restantes en el tablero resultante. Si no es posible hacer esto, sacamos a la reina, y la colocamos en otra posición. Si no existe una posición que podemos recursivamente completar, entonces decimos que no se puede continuar con el tablero que nos dan. El código queda así:

#algorithm({
  import algorithmic: *
  Procedure(
    "N-Queens",
    ($n in NN$),
    {
      Comment[$c[i]$ contiene la columna donde pusimos una reina en la $i$-ésima fila, o $0$ si no pusimos una reina en esa fila todavía.]
      Assign[$c[1 dots n]$][0]
      Comment[$f[i]$ indica si hay una reina en la fila $i$.]
      Assign[$f[1 dots n]$][#smallcaps("false")]
      Comment[$v[i]$ indica si hay una reina en la $i$-ésima diagonal "decreciente".]
      Assign[$v[1 dots (2n)]$][#smallcaps("false")]
      Comment[$w[i]$ indica si hay una reina en la $i$-ésima diagonal "creciente".]
      Assign[$w[1 dots (2n)]$][#smallcaps("false")]

      Return(FnInline[Backtrack][$1, n, c, f, v, w$])
    },
  )
  Procedure(
    "Backtrack",
    ($r in NN$, $n in NN$, $c[1 dots n]$, $f[1 dots n]$, $v[1 dots (2n)]$, $w[1 dots (2n)]$),
    {
      Comment[Caso base: Ya pusimos $n$ reinas.]
      If($r gt n$, {
        Return[$c$]
      })

      Comment[Intentamos poner una reina en la fila $r$, en cada columna $j$.]
      For([$j = 1$ to $n$], {
        Assign($d_1$, $r - j + n$)
        Assign($d_2$, $r + j$)
        Comment[Si no hay reinas que atacarían a una reina en $(r, j)$ ya puestas.]
        If([$not f[j]$ and $not v[d_1]$ and $not w[d_2]$], {
          Comment[Ponemos una reina en $(r, j)$.]
          Assign[$c[r]$][$j$]
          Assign[$f[j]$][#smallcaps("true")]
          Assign[$v[d_1]$][#smallcaps("true")]
          Assign[$w[d_2]$][#smallcaps("true")]

          Comment[Resolvemos recursivamente el tablero que queda.]
          Assign($z$, FnInline[Backtrack][$r + 1, n, c, f, v, w$])
          Comment[Si encontramos una solución recursivamente, la devolvemos.]
          If($z eq.not #smallcaps("null")$, {
            Return[$z$]
          })
          Comment[Si no, deshacemos la elección que hicimos para la fila $r$.]
          Assign[$f[j]$][#smallcaps("false")]
          Assign[$v[d_1]$][#smallcaps("false")]
          Assign[$w[d_2]$][#smallcaps("false")]
        })
      })

      Comment[Si no devolvimos durante el ciclo, no hay forma de poner una reina en la fila $r$. El tablero que nos pasaron no es resoluble, y devolvemos #smallcaps("null").]
      Return[#smallcaps("null")]
    },
  )
})

Vemos ahí las características clásicas de un algoritmo de backtracking:
- Construímos una solución global paso a paso, eligiendo opciones en cada paso, agregándolos a una sub-solución que tenemos.
- Al hacer una elección, nos fijamos recursivamente si podemos completar nuestra sub-solución actual con esta decisión, a una solución global.
- Si no pudimos hacer esto, deshacemos nuestra elección e intentamos con otra.
- Si ninguna opción funciona, el sub-problema que estamos resolviendo no es resoluble, y lo informamos al que nos llamó.

Demostrar la correctitud de estos algoritmos es un caso particular de correctitud de algoritmos recursivos.#footnote[Por su estructura inductiva, donde la solución al problema global se crea tomando pasos en una sub-solución de un sub-problema similar, prácticamente siempre los algoritmos de backtracking están escritos de forma recursiva. No es _necesario_, pero sí lo más común.] Veamos cómo demostrar la correctitud de nuestro algoritmo.

#prop[
  Dado un $n in NN$:
  - Si es posible colocar $n$ reinas en un tablero de ajedrez de $n times n$, de tal forma que ninguna pueda atacar a otra en un movimiento, #smallcaps("n-queens")$(n)$ devuelve una representación de algún tal tablero. El algoritmo devuelve una lista $c$ de longitud $n$, tal que $1 lt.eq c[i] lt.eq n$ es la columna donde hay una reina en la fila $i$.
  - Si no es posible, el algoritmo devuelve #smallcaps("null").
]
Como lo único que hace #smallcaps("n-queens") es llamar a #smallcaps("backtrack"), vamos a demostrar una proposición sobre #smallcaps("backtrack").

Sea $n in NN$, y $r in NN$ tal que $1 lt.eq r lt.eq n + 1$. Definimos $P(r)$ como:

#defi[$P(r)$: Sea $(c, f, v, w)$ una representación de un tablero de ajedrez de $n times n$, con $r - 1$ reinas ya colocadas, y asumiendo que ningún par de las reinas ya colocadas se pueden atacar entre sí en un movimiento. Si es posible completar el tablero agregando $n - r + 1$ reinas de tal forma que ningún par de ellas se ataque en un movimiento, entonces #smallcaps("backtrack")$(r, n, c, f, v, w)$ devuelve una lista $c'$ que representa un tal tablero. En particular, para cada $1 lt.eq i lt.eq n$, $c'[i]$ es la columna donde hay una reina en la fila $i$. Si no es posible completar el tablero, #smallcaps("backtrack") devuelve #smallcaps("null").]

Lo primero que vemos es que #smallcaps("n-queens") llama a #smallcaps("backtrack") con $r = 1$, y una representación de un tablero vacío. $P(1)$ nos dice que #smallcaps("backtrack") nos dice si es posible agregar $n-r+1=n-1+1=n$ a un tablero vacío (que es lo mismo que colocar $n$ reinas), de tal forma que ningún par se ataque. Luego, si probamos $P(1)$, sabremos que #smallcaps("n-queens") es correcto.

#demo[
  Vamos a probar $P(k)$ para todo $1 lt.eq k lt.eq n + 1$ por inducción. Nuestro caso base va a ser $k = n + 1$, y vamos a usar $P(k+1)$ para probar $P(k)$. Si los incomoda el hecho de hacer inducción "hacia atrás", pretendan que estamos probando $Q(k): 1 lt.eq k lt.eq n implies P(n - k + 1)$, pero realmente no hay ningún problema. Estamos construyendo una cadena de implicaciones, fundada en un caso base, como en toda inducción.

  + Caso base, $P(n + 1)$. Si $r = n + 1$, entonces ya hemos colocado $r - 1 = n$ reinas en el tablero que nos pasan, y sabemos que ningún par se atacan. Luego, existe un tal tablero que es solución al problema entero. Podemos devolver $c$, que indica en qué columna está la reina de cada fila, y es la representación de tal tablero. Vemos que #smallcaps("backtrack")$(n + 1, n, c, f, v, w)$ devuelve precisamente $c$, y luego vale $P(n + 1)$.
  + Paso inductivo. Tenemos $r in NN$, $1 lt.eq r lt.eq n$. Asumimos $P(r+1)$, y queremos probar $P(r)$. Sea $T$ el tablero que nos pasan, el representado por la 4-tupla $(c, f, v, w)$. Hay dos opciones, o bien $T$ se puede completar a un tablero con $n$ reinas, o no se puede.
    - Si se puede completar, entre todos los tableros solución que son completaciones de este, sea $T'$ cualquier tablero donde la reina que hay en la $r$-ésima fila está en la menor columna, y sea $j$ tal columna. Vemos que el ciclo que hace #smallcaps("backtrack") prueba las columnas posibles donde poner la $r$-ésima reina en orden creciente, y luego como ningún tablero se puede completar poniendo una reina en $c[r] = j'$ con $j' < j$, todas esas iteraciones van a terminar sin devolver nada. Luego, llegaremos a la $j$-ésima iteración. En esa iteración, vamos a poner una reina en $c[r] arrow.l j$, y escribimos $f$, $v$, y $w$ correspondientemente. Como $T'$ existe, y el tablero que acabamos de armar es un sub-tablero de $T'$ y también una completación parcial de $T$, estamos llamando a #smallcaps("backtrack")$(r + 1, dots)$ con un tablero que es completable a una solución global $T'$. Como asumimos $P(r+1)$ por inducción, sabemos que esta llamada a #smallcaps("backtrack") va a devolver un tablero solución (no necesariamente $T'$!). Es decir, $z eq.not #smallcaps("null")$. Luego, al devolver $z$, #smallcaps("backtrack") está devolviendo un tablero solución que completa $T$, que es el comportamiento esperado, y prueba $P(r)$.
    - En el caso contrario, no existe ninguna manera de completar $T$ para obtener un tablero con $n$ reinas. Si el ciclo devolviera en algún momento, tendríamos por $P(r+1)$ un tablero $z$ que extiende a $T$ a $n$ reinas, pero no existe. Luego, en ningún momento del ciclo podemos devolver, y el ciclo recorre todas sus iteraciones y termina. #smallcaps("backtrack") entonces devuelve #smallcaps("null"), que es la respuesta correcta en este caso. Esto entonces prueba $P(r)$.

    En ambos casos probamos $P(r)$, partiendo de $P(r+1)$. Por inducción, probamos $P(1)$, y esto completa la demostración.
]

Analizar el comportamiento asintótico de este algoritmo es también simple. Notemos cómo, al haber retornos dentro del ciclo, no vamos a poder saber exactamente cuántas iteraciones va a hacer en cada llamada. Vamos a definir $X(n)$ como el número de operaciones que realiza #smallcaps("n-queens")$(n)$. Vamos a encontrar una función $T$ tal que $X in O(T)$.

#prop[
  $T(n) = (n+1)!$ es tal que $X in O(T)$.
]
#demo[
  Sea $n in NN$. Veamos cuántas operaciones realiza #smallcaps("backtrack")$(r, n, dots)$, sabiendo que tenemos $r lt.eq n + 1$ durante todo el algoritmo. Llamemos $B(k)$ a una cota superior al número de operaciones que realiza, cuando $k = n - r + 1$. Vamos a definirla por inducción.
  - Si $k = 0$, entonces $r = n + 1$. En este caso, #smallcaps("backtrack") retorna inmediatamente, realizando un número constante de operaciones. Luego $B(0) = q$ para algún número de operaciones fijo $q$.
  - Si $k > 0$, entonces $r < n + 1$, y #smallcaps("backtrack") va a hacer algunas iteraciones, y en algunas va a llamarse recursivamente. Podríamos acotar este número de llamadas recursivas por $n$ trivialmente, pues el ciclo es de $1$ a $n$, pero si tenemos más cuidado, vemos que ya hay $r-1$ reinas en el tablero que nos dan. Por lo tanto, al verificar si $not f[j]$, va a haber $r - 1$ valores para los cuales $f[j] = #smallcaps("true")$, y por lo tanto no haremos llamadas recursivas. Entonces, hay a lo sumo $n - (r - 1) = n - r + 1 = k$ llamadas recursivas, no $n$. Por hipótesis inductiva, cada llamada recursiva de la forma #smallcaps("backtrack")$(r + 1, n, dots)$, realiza a lo sumo $B(k - 1)$ operaciones (pues aumentar $r$ es disminuir $k$). Luego, como también tenemos un costo de iterar $n$ veces y escribir/leer arrays (que cuestan $O(1)$ operaciones), realizaremos a lo sumo $B(k) = k B(k-1) + O(n)$ operaciones.

  Luego, podemos acotar por arriba el número de operaciones que realiza #smallcaps("backtrack")$(r, n, dots)$ por $B(n - r + 1)$, donde $B$ es la siguiente función:

  $
    B(k) = cases(
      q wide & "si" k = 0,
      k B(k - 1) + O(n) & "si" k > 0
    )
  $

  Para ser claros, lo que estamos diciendo explícitamente es que existe una función $g:NN arrow NN$, con $g in O(n)$, tal que

  $
    B(k) = cases(
      q wide & "si" k = 0,
      k B(k - 1) + g(n) & "si" k > 0
    )
  $

  Intentemos encontrar una forma cerrada para $B$. Si $g(n) = 0$, es fácil ver que $B(k) = k! q$. Veamos entonces qué pasa comparando $B(k)$ con $k!$. Definimos $C(k) = B(k)/k!$. Cuando $k > 0$, tenemos

  $
    C(k) & = B(k)/k! \
         & = B(k-1)/(k-1)! + g(n)/k! \
         & = C(k-1) + g(n)/k!
  $

  Entonces tenemos $C(k) = q + sum_(i=1)^k g(n)/i!$. Luego, $B(k) = k! C(k) = k! (q + sum_(i=1)^k g(n)/i!) = k! (q + g(n) sum_(i=1)^k 1/i!)$. Recordando que $sum_(i=0)^infinity 1/i! = e$, tenemos que $B(k) lt.eq k! (q + g(n) (e - 1)) lt.eq k! (q + 2g(n))$. Finalmente, vemos que $B in O(n! (q + 2 g(n))) subset.eq O(g(n) n!) subset.eq O(n n!) subset.eq O((n+1)!)$.

  Recordando que #smallcaps("n-queens")$(n)$ llama a #smallcaps("backtrack")$(r = 1, n, dots)$, y este hace a lo sumo $B(n - r + 1) = B(n - 1 + 1) = B(n)$ operaciones, tenemos que $X(n) lt.eq B(n)$, con $B in O((n+1)!)$, y luego $X in O((n+1)!)$. Luego, existe una función $T(n) = (n+1)!$, tal que $X in O(T)$.]

#load-bib()