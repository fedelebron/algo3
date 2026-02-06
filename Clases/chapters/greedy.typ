#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


== Greedy

Estos algoritmos son similares a los de backtracking, excepto que al tomar una decisión, nunca la deshacemos. Son entonces "más rápidos" que una solución de backtracking, dado que exploran menos del espacio de sub-soluciones. Sin embargo, demostrar que son correctos va a requerir demostrar que las elecciones que hacen nunca son incorrectas. Es decir, nunca nos llevan desde una sub-solución que puede completarse a una solución global, a una que no puede completarse de tal forma.

Para muchos problemas, una solución greedy es fácil de imaginar. Por ejemplo, en el problema de la mochila, podemos pensar en "siempre tomo el objeto más valioso", o "siempre tomo el objeto más liviano". Lo difícil está en probar su correctitud.

#let t = [Hay varias maneras de probar la correctitud de los algoritmos greedy. En general, van a tener mucha flexibilidad para probar este tipo de algoritmos correctos. Tres formas clásicas son:
  - Argumentos de intercambio, donde tomamos una solución óptima mejor a la nuestra lo más parecida posible a la nuestra, y hacemos un intercambio en esa solución que la hace o mejor que lo que era, o más parecida a la nuestra.
  - Argumentos de liderazgo ("greedy stays ahead"), donde definimos una métrica para sub-soluciones, y una noción de "longitud" para las mismas. Luego argumentamos que nuestra sub-solución siempre mejor, en esta métrica, a cualquier otra sub-solución de la misma "longitud".
  - Argumentos de completación, donde argumentamos que en todo momento nuestra sub-solución puede ser completada a una solución óptima.
]
#let img = image("/images/greedy.png", width: 100%)
#wrap-content(img, t, align: bottom + right)

Vamos a mostrarles algunos ejemplos de cada una.

#ej[
  Tomás quiere viajar de Buenos Aires a Mar del Plata en su flamante Renault 12. Como está preocupado por la autonomía de su vehículo, se tomó el tiempo de anotar las distintas estaciones de servicio que se encuentran en el camino. Modeló el mismo como un segmento de 0 a $M$, donde Buenos aires está en el kilómetro 0, Mar del Plata en el $M > 0$, y las distintas estaciones de servicio están ubicadas en los kilómetros $0 = x_1 lt.eq x_2 lt.eq dots x_n = M$.
  Razonablemente, Tomás quiere minimizar el número de paradas para cargar nafta. Él sabe que su auto es capaz de hacer hasta $C$ kilómetros con el tanque lleno, y que al comenzar el viaje este está vacío.

  + Diseñar un algoritmo greedy que le indique a Tomás en qué estaciones debe detenerse para cargar nafta, de forma tal que el número de paradas sea mínimo.

  + Demostrar su correctitud.

  + Mostrar la complejidad temporal y espacial del algoritmo. El mejor algoritmo posible tiene complejidad temporal y espacial $O(n)$.
]

#sol[
  Un posible algoritmo greedy para este problema es el siguiente:

  ```python
  def g(estaciones: list[int], C: int) -> list[int] | None:
    n = len(estaciones)
    i = 0
    cargas = []
    while i != n - 1:
      j = i
      while j < n - 1 and estaciones[j+1] - estaciones[i] <= C:
        j += 1
      if j == i: return None
      cargas.append(i + 1)
      i = j
    return cargas
  ```

  Vamos a dar tres demostraciones de la correctitud de este algoritmo. La primer demostración es un argumento del estilo greedy-stays-ahead.

  #demo[
    Definimos una solución como una sucesión estríctamente creciente de índices, $S = (s_1, dots, s_h) subset.eq {1, dots, n}$, tal que $s_1 = 1$ (se carga en el kilómetro cero, la primer estación), $s_h = n$ (se llega a Mar Del Plata desde la última estación), y tal que para todo $1 lt.eq j < h$, $|x_(s_(j+1)) - x_(s_j)| lt.eq C$ (se puede llegar de una estación a la otra con el tanque lleno). Notar que podemos simplificar la última condición a $x_(s_(j+1)) - x_(s_j) lt.eq C$, pues las estaciones están ordenadas crecientemente en $x$. En general, el auto se puede mover de la estación $x_i$ a la estación $x_j$ cuando $|x_i - x_j| lt.eq C$.

    Si el problema no tiene solución, es porque ni siquiera cargando en cada estación podemos llegar. Esto implica que existe al menos una estación $i$, tal que $x_(i+1) - x_i gt C$. En este caso, nuestro algoritmo devuelve ```python None``` al considerar ```python if j == i: return None```, y es la respuesta correcta. Por otra parte, si nuestro algoritmo devuelve ```python None``` es porque no puede llegar a la próxima estación desde la actual ($i$), y por lo tanto no existe ninguna solución, pues toda solución tiene que pasar por $x_i$, cargue o no cargue ahí, y llegar a $x_(i+1)$. Luego, en este caso nuestro algoritmo es correcto, pues devuelve ```python None``` si y sólo si no existe solución.

    Asumimos entonces que el problema tiene solución. Sea $G = {g_1, dots, g_k}$ una solución producida por nuestro algoritmo. Sea $O = {o_1, dots, o_h}$ cualquier solución óptima, con lo cual $h lt.eq k$. Vamos a demostrar la siguiente proposición por inducción, para todo $t in NN, t gt.eq 1$.


    $
      P(t): & "Si" t lt.eq h, "entonces" o_t lt.eq g_t.
    $

    + Caso base, $t = 1$. Como empezamos con el tanque vacío en $x_1 = 0$, y $M > 0$, el auto tiene que moverse y no tiene combustible al empezar. Luego toda solución debe cargar en la primer estación, y $g_1 = o_1 = 1$. Luego vale $P(1)$.
    + Paso inductivo. Sabemos que vale $P(t)$, queremos demostrar $P(t+1)$. Si $t = h$, entonces $P(t+1)$ es trivial, pues es una implicación con antecedente falso. Luego basta considerar $t < h$, y por lo tanto $t + 1 lt.eq h$. Sabemos por $P(t)$ que $o_t lt.eq g_t$. Sea $A_t = {j | j > g_t, x_j - x_(g_t) lt.eq C}$ el conjunto de estaciones alcanzables yendo hacia adelante desde $g_t$. Como el problema tiene solución, $A_t eq.not emptyset$, y podemos llegar al menos a la próxima estación. Sea entonces $j^* = max A_t$. Nuestro algoritmo elije $g_(t+1) = j^*$.

      Como $O$ es una solución válida, $|x_(o_(t+1)) - x_(o_t)| lt.eq C$, y como los valores de $O$ están ordenados de forma creciente, $x_(o_(t+1)) > x_(o_t)$, y por lo tanto $x_(o_(t+1)) - x_(o_t) lt.eq C$. Luego, como $o_t lt.eq g_t$, tenemos $x_(o_t) lt.eq x_(g_t)$, y luego $x_(o_(t+1)) - x_(g_t) lt.eq C$. Notemos que $o_(t+1)$ puede ser mayor o menor que $g_t$, y por lo tanto el lado izquierdo de esta suma puede ser negativo. Partimos en casos:

      - Si $o_(t+1) < g_t$, entonces $x_(g_(t+1)) gt.eq x_(g_t) gt.eq x_(o_(t+1))$. Como las estaciones están ordenadas crecientemente en $x$, concluímos $g_(t+1) gt.eq o_(t+1)$, y luego vale $P(t+1)$.
      - Si $o_(t+1) gt.eq g_t$, entonces $o_(t+1) in A_t$, y por lo tanto $o_(t+1) lt.eq j^* = g_(t+1)$. Luego vale $P(t+1)$.

    Luego vale $P(t)$ par todo $t in NN, t gt.eq 1$. En particular, vale $P(h)$, y vemos que $o_h lt.eq g_h$. Como $O$ es una solución, $o_h = n$. Como nuestro algoritmo sólo devuelve estaciones, $g_h lt.eq n$. Luego, $g_h = n$, y $G$ es una solución. Como $g_h = n - 1$, nuestro algoritmo agregó $g_h =$ `i + 1`, y por lo tanto `i == `$n - 1$. Nuestro algoritmo se detiene cuando ```python i == n - 1```, con lo cual $k = h$. Luego, como $|G| = k = h = |O|$, y $O$ es una solución óptima, $G$ también es una solución óptima.]

  La siguiente demostración usa un argumento de intercambio.
  #demo[
    En la demostración anterior vimos que si el problema no tiene solución, nuestro algoritmo devuelve ```python None```, y si devuelve ```python None```, el problema no tiene solución. Luego, en este caso el algoritmo es correcto. Asumimos entonces que el problema tiene solución.

    Sea $G = {g_1, dots, g_k}$ la solución que devuelve nuestro algoritmo. De todas las soluciones óptimas, consideremos la solución $O = {o_1, dots, o_h}$ que tenga un prefijo más largo en común con $G$. Sea $i$ la longitud de ese prefijo en común. Como $O$ es óptima, $h lt.eq k$. Como $i$ es la longitud de un prefijo de $O$, $i lt.eq h$, y a fortiori $i lt.eq k$.

    Si $i = h$, entonces $o_i$ es la estación final. Como $g_i = o_i$, nuestro algoritmo habría llegado a la estación final, y terminaría, con lo cual $i = k$, y tendríamos $G = O$, mostrando el algoritmo correcto.

    Si no, entonces $i < h$, y existe $o_(i+1)$. Como $i < h$ y $h lt.eq k$, entonces $i < k$, y también existe $g_(i+1)$. Como $i$ es la longitud del prefijo en común entre $G$ y $O$, entonces $g_(i+1) eq.not o_(i+1)$.

    Nuestro algoritmo eligió a $g_(i+1)$ como la estación más lejana a la que puede llegar, habiendo cargado en $g_i$. Por ende, como $O$ es una solución válida, y $g_i = o_i$, debemos tener $o_i = g_i lt.eq o_(i+1) < g_(i+1)$. Como $O$ está ordenada crecientemente, entonces $g_(i+1) in.not {o_1, dots, o_i}$. Consideremos entonces $X = {o_1, o_2, dots, o_i, g_(i+1)}$. Al tener $X_1 = o_1, dots, X_i = o_i$, y $O$ siendo una solución, el prefijo de longitud $i$ de $X$ es válido. Para ver que $X_(i+1) - X_i lt.eq C$, basta ver que $X_i = o_i = g_i$ y $X_(i+1) = g_(i+1)$, y sabíamos que $g_(i+1) - g_i lt.eq C$ pues nuestro algoritmo sólo hace saltos con distancia menor o igual a $C$. Por lo tanto, el salto de $X_i$ a $X_(i+1)$ es válido.

    Sea $t = min {t | t in [i+2, dots, h], o_t > g_(i+1)}$. Primero vemos que el conjunto no es vacío: De otra forma, $g_(i+1)$ sería la última estación (recordando que $x_n$ debe estar en $O$ para ser solución válida), y luego $i + 1 = k$ es donde termina el algoritmo. Como $h = |O| gt.eq i + 1 = k$, entonces $G$ sería una solución óptima. Basta entonces considerar el caso en que el conjunto no es vacío, y por lo tanto $t$ está bien definido.

    Consideremos entonces $Y = {o_t, o_(t+1), dots, o_h}$. Claramente los saltos son válidos pues es un sufijo de $O$. Finalmente, vamos a considerar $O^* = X union Y$. Lo único que tenemos que ver para ver que $O^*$ es una solución válida es que $Y_1 - X_(i+1) lt.eq C$. Esto es ver que $o_t - g_(i+1) lt.eq C$. Como $O$ es una solución, $o_t - o_(t-1) lt.eq C$. Por cómo definimos $t$, $o_(t-1) lt.eq g_(i+1)$. Por lo tanto, tenemos $o_t - g_(i+1) lt.eq o_t - o_(t-1) lt.eq C$, que es lo que queríamos demostrar.

    Luego, $O^*$ es una solución válida. Su longitud es $|X| + |Y|$, con $|X|$ = $i + 1$, y $|Y| = h - t + 1$. Como $t gt.eq i + 2$, tenemos que $|O^*| = i + 1 + h - t + 1 lt.eq i + 2 + h - (i + 2) = h$, con lo cual $O^*$ es una solución óptima.

    Vemos que $O^*$ es una solución óptima que tiene un prefijo de longitud $i + 1$ en común con $G$, pero esto no puede suceder, pues $O$ era una solución óptima con el más largo prefijo en común con $G$, y ese prefijo tenía longitud $i$. Luego tal $O$ no existe, y $G$ ya es óptima.
  ]

  Finalmente, veamos una demostración usando un argumento de completación.
  #demo[
    Al igual que antes, vamos a dar por demostrado (porque lo hicimos en la primer demostración) que el algoritmo es correcto cuando no hay solución. Luego vamos a asumir acá que hay solución.

    Vamos a usar el teorema del invariante para probar la correctitud de nuestro algoritmo. Entre iteraciones del ciclo exterior, nuestro algoritmo mantiene un array $"cargas" = [g_1, dots, g_t]$, donde $t$ es el número de iteraciones completadas. Como vamos a usar el teorema del invariante, necesitamos explicitar las siguientes proposiciones:

    - Guarda $B(i)$: $i eq.not n - 1$.
    - Función variante $V(i) = n - 1 - i in NN$.
    - Precondición $P$: $0 = x_1 lt.eq x_2 lt.eq dots lt.eq x_n = M$, $C gt.eq 0$, y el problema tiene solución.
    - Postcondición $Q$: $G$ es una solución óptima.
    - Invariante $I(i)$:
      + $0 lt.eq i < n$.
      + Si $t > 0$, entonces $x_(i+1) - x_(g_t) lt.eq C$. Es decir, podemos llegar desde la última estación donde cargamos ($x_(g_p) = "estaciones[cargas["t-1] - 1]$), hasta la estación actual ($x_(i+1) = "estaciones"[i]$). El $-1$ al indexar `estaciones` es porque $"cargas"$ contiene índices comenzando en $1$, mientras que en Python los índices de arrays comienzan en $0$.
      + Si $t > 0$ y $B(i)$, entonces para todo $r > i+1$, $x_r - x_(g_t) > C$. Es decir, mientras que podemos llegar a $x_(i+1)$, pero no podemos llegar a ninguna estación posterior.
      + $exists O = {o_1, dots, o_h} "solución óptima" | (o_1, dots, o_t) = (g_1, dots, g_t)$

    Y necesitamos demostrar las siguientes proposiciones:
    - La función variante decrece en cada iteración. Como siempre asignamos $i arrow.l j$, con $j > i$, vemos que $V(i) = n - 1 - i$ decrece en cada iteración.
    - Si la función variante se anula, la guarda es falsa. Si $V(i) = 0$, entonces $i = n - 1$, que es precisamente $not B(i)$.
    - La negación de la guarda, y el invariante, implican la postcondición. Si tenemos la negación de la guarda ($not B(i)$), tenemos $not (i eq.not n - 1) iff i = n - 1$, y como si también vale el invariante ($I(i)$) tenemos $I(n - 1)$. Luego existe una solución óptima $O$ tal que $(o_1, dots, o_t) = (g_1, dots, g_t)$, y como $i = n - 1$, y si $t > 0$, $"estaciones"[i] - "estaciones"["cargas"[t-1]-1] = "estaciones"[n - 1] - "estaciones"["cargas"[t-1]-1] = x_n - x_(g_t) lt.eq C$, entonces podemos llegar desde la última estación de `cargas` hasta la estación final, Mar del Plata. Como existe una solución óptima $O$ que es extensión de $G$, y $G$ ya puede llegar a Mar del Plata, entonces $O$ debe ser $G$. Luego, $G = {g_1, dots, g_t}$ es una solución válida. Como $O$ es una solución óptima, entonces $O$ no puede tener ninguna estación posterior a la $n$-ésima, y $O$ no sólo _extiende_ a $G$, sino que _es_ $G$. Luego $G$ es una solución óptima. Luego vale la postcondición.
    - El invariante vale inicialmente, $I(0)$. El estado inicial es $i = 0, "cargas"=[]$. La lista vacía es trivialmente extensible a cualquier solución óptima. Por la precondición, existe al menos una solución, y luego existe una solución óptima. Las otras condiciones de $I(0)$ son o simples (pues $0 lt.eq 0 < n$) o trivialmente ciertas (pues $not (t > 0)$). Luego, $I(0)$ vale.
    - Si el invariante vale antes de una iteración, y la guarda es verdadera, entonces el invariante vale después de la iteración. Asumimos que valen $I(i) and B(i)$. Vamos a probar $I(j)$. Notemos que $j$ es el valor que obtiene $i$ al terminar cada iteración. Tenemos un pequeño ciclo interior que calcula $j = max { l | i lt.eq l < n, x_(l+1) - x_(i + 1) lt.eq C}$ (recordemos que los índices de $x$ empiezan en $1$, mientras que en Python estamos indexando ```python estaciones``` a partir de ```python 0```, por eso los $+1$).
      + Por cómo definimos $j$, tenemos que $j gt.eq i$, y luego $j gt.eq i gt.eq 0$. Asimismo definimos $j$ como el máximo de un conjunto cuyo elementos más grandde es a lo sumo $n - 1$, luego $j lt.eq n - 1$, es decir $j < n$. Luego $0 lt.eq j < n$, que es la primer parte de $I(j)$.
      + Llamemos $p = i + 1$. Estamos agregando $p$ a $G$, obteniendo $G' = {g_1, dots, g_t, i + 1}$. Tenemos que ver que $x_(j+1) - x_p lt.eq C$. Esto es justamente cómo definimos $j$, como el mayor índice que cumple $x_(j+1) - x_p lt.eq C$. Esta es la segunda cláusula de $I(j)$, recordando que $g_t = i + 1$ pues lo acabamos de insertar.
      + Si $B(j)$, entonces $j eq.not n - 1$. Si ocurriese $x_n - x_(i + 1) lt.eq C$, entonces $j$ no sería el máximo índice que cumple $x_(j+1) - x_(i+1) lt.eq C$, pues $n - 1$ también lo cumpliría, y dijimos que $j eq.not n - 1$. Esto no puede suceder, entonces $x_n - x_(i + 1) > C$. Esta es la tercer cláusula de $I(j)$.
      + Sabemos por $I(i)$ que existe una solución óptima $O$ que extiende a $G$. Si $t = 0$, entonces al comenzar con el tanque vacío, vamos a agregar la primer parada, $x_1 = 1$. Como toda solución tiene que hacer esto, en particular cualquier solución óptima tiene que hacer esto, y tenemos que $G$ sigue siendo extensible a una solución óptima.
        Si $t > 0$, entonces como vale $B(i)$, por $I(i)$ tenemos que $x_n - x_(g_t) gt C$. Luego toda solución óptima, en particular $O$, necesita al menos una estación más, y luego existe $o_(t+1)$. Sea $s = o_(t+1) > g_t$. Sea $p = i + 1$.

        Por $I(i)$ y $B(i)$, sabemos que para todo $r > i + 1$, $x_r - x_(g_t) > C$. También sabemos que $g_t = o_t$, y $p = i + 1$. Luego, para todo $r > p$, tenemos $x_r - x_(o_t) > C$. Como $O$ es una solución válida, $O$ no puede entonces seguir a $o_t$ con $x_r$ para ningún $r > p$, y tenemos $s lt.eq p$.

        Si $s = p$, ya tenemos en $O$ un prefijo de longitud $i + 1$ en común con $G$, y $G$ sigue siendo extensible a una solución óptima. Luego debemos ver el caso $s < p$.

        Si $s < p$, entonces $O$ carga antes de $p$. Recordemos que $O$ tiene la forma $O = {o_1, dots, o_h} = {g_1, dots, g_t, s, o_(t+2), dots, o_h}$. Quisiéramos reemplazar a $s$ por $p$, pero no sabemos si $o_(t+2) gt.eq p$, y si esto no sucediera, no estaríamos formando una solución válida (recordando que los índices en una solución son crecientes). Consideremos el primer índice $j$ en $O$, tal que $j > t + 1$, y $o_j > p$.

        Si $j$ no existe, entonces $O$ está llegando a Mar del Plata desde $s$, y como $p > s$, también vamos a poder llegar a Mar del Plata desde $p$. El algoritmo encontrará entonces que `j == i`, y terminará, con lo cual tenemos una solución $G = {g_1, dots, g_t, p}$ con longitud $t + 1$, que es también la longitud de $O = {o_1, dots, o_t, s}$.

        Si por otro lado $j$ existe, consideremos $O' = {o_1, dots, o_t, p, o_j, o_(j+1), dots, o_h}$. Claramente $G' = {g_1, dots, g_t, p}$ es un prefijo de $O'$. El único salto que hay que justificar en $O'$ es entre $p$ y $o_j$. Como $j$ es el primer índice mayor que $t + 1$ tal que $o_j > p$, tenemos que $o_(j-1) lt.eq p$. Como $O$ es una solución válida, $x_(o_j) - x_(o_(j-1)) lt.eq C$. Luego, como $o_(j-1) lt.eq p$, tenemos $x_(o_j) - x_p lt.eq C$. Luego, todos los saltos de $O'$ son válidos. También por cómo definimos $j$, tenemos $o_j gt.eq p$, y luego $O'$ está ordenada crecientemente. Finalmente, $|O'| lt.eq |O|$ pues removimos los elementos ${o_(t+2), dots, o_(j-1)}$ (puede ser vacío este conjunto), y como $O$ es óptima, $O'$ también lo es.

        Luego, $O'$ es una solución óptima que extiende a $G'$, y tenemos la última cláusula de $I(j)$.

    Por el teorema del invariante, entonces, vale la postcondición al terminar el ciclo, y nuestro algoritmo es correcto.
  ]

]

#ej[
  Queremos devolver el vuelto a un cliente, y tenemos monedas de 1, 5, 10, y 25 centavos. Diseñar un algoritmo greedy que resuelva el problema. Demostrar su correctitud.]
#demo[
  Un algoritmo como el que nos piden es el siguiente, donde $n$ es el número de centavos que queremos devolver:

  #algorithm({
    import algorithmic: *
    Procedure(
      "GreedyChange",
      ($n in NN$),
      {
        Assign[$C$][$[1, 5, 10, 25]$]
        Assign[$v$][[]]
        While($n > 0$, {
          Assign[$c$][$max_(c in C) {c | c lt.eq n}$]
          Assign[$n$][$n - c$]
          Assign[$v$][$v + [c]$]
        })
        Return[$v$]
      },
    )
  })

  #let gc = smallcaps("GreedyChange")

  La semántica que le vamos a asignar a #gc es que #gc$(n)$ devuelve una lista de denominaciones de monedas, tal que la suma de las denominaciones es $n$, y el número de monedas es mínimo entre todas las formas de sumar $n$ con esas denominaciones.

  Primero, veamos que #gc termina. En cada iteración, $n$ decrece en como mínimo $1$, pues $1 lt.eq n$ si entramos al ciclo, puesto que la guarda es $n > 0$, es decir $n gt.eq 1$. $n$ nunca se hace negativo, porque siempre seleccionamos un $c$ tal que $c lt.eq n$, y luego $n - c gt.eq 0$. Luego, como en cada iteración decrece, vuelve al ciclo cada vez que $n$ es positio, y $n$ nunca se hace negativo, sabemos que al final del ciclo, $n = 0$. Como cada vez que restamos $c$ a $n$, agregamos $c$ a $v$, vemos que $sum_(c in v) c = n$, y luego $v$ es una forma de devolver el vuelto de $n$ centavos. Asimismo, vemos que como $n$ decrece en cada iteración, y $c$ siempre es la máxima denominación menor a $n$, entonces $c$ no puede crecer de una iteración a la otra, y luego $v$ es llenado en orden de mayor a menor denominación.

  Ahora veamos que #gc devuelve una lista $v$ de mínima longitud, tal que $v$ contiene sólo elementos de $C$, y $sum_(c in v) c = n$. Vamos a hacer esto mediante un *argumento de intercambio*. Supongamos que existe una forma $w$ de devolver el vuelto de $n$ centavos, con menos monedas que $v$. De todas las posibles $w$ de mínima longitud, tomemos cualquier que, al ser ordenada de forma no-creciente, tenga el máximo número de elementos en común con $v$. Es decir, $w$ maximiza $max {i | 0 lt.eq i lt.eq min(|w|, |v|), forall 0 lt.eq j < i, w_j = v_j}$, donde estamos ordenando $w$ de forma no-creciente, entre todas las soluciones óptimas.

  Sea $i$ ese número. Entonces sabemos que antes de $i$, $w$ y $v$ tienen los mismos elementos, mientras que $v_i eq.not w_i$. Como #gc produjo $v$ de forma no-creciente, al elegir $v_i$, teníamos que $v_i = max_(c in C) {c | c lt.eq n'}$, con $n' < n$ el cambio que hace falta hacer todavía. Entonces, $n' = n - sum_(j = 1)^(i - 1) v_j = sum_(j = 1)^(i - 1) w_j$, porque dijimos que para todos esos índices $j$, $v_j = w_j$. Luego, como $n = sum_(j = 1)^(|w|) w_j gt.eq sum_(j = 1)^i w_j = n - n' + w_i$, o vemos que $0 gt.eq -n' + w_i$, o también, $w_i lt.eq n'$. Cómo elegimos $v_i$ como el máximo $c in C$ tal que $c lt.eq n'$, y $w_i in C$, sabemos que $w_i < v_i$.

  Vamos a querer obtener, en cada caso, una forma de obtener una solución de menor largo que $w$, o de igual largo pero que tiene un prefijo más largo en común con $v$. Como $w$ era una forma óptima que tiene el prefijo más largo con común con $v$, esto es una contradicción. Por lo tanto $w$ no puede existir, y luego $v$ es una solución óptima. Recordemos que $|w| < |v|$, por cómo definimos $w$.

  #align(center)[
    #block(
      inset: 2em,
      stack(
        spacing: -0.75em,
        place(dx: 2em, dy: -2.1em, math.overbrace(h(9em), $sum_(j gt.eq i) v_j = n'$)),
        grid(
          columns: 7,
          rows: 3,
          gutter: 1pt,
          inset: 10pt,
          fill: (col, row) => if row == 0 { blue.lighten(80%) } else if row == 1 { white } else { green.lighten(80%) },
          stroke: 0.1pt + black,
          $v_1$, $v_2$, $dots$, $v_(i-1)$, $v_i$, $dots$, $v_(|v|)$,
          ..($=$, $=$, $dots$, $=$, $eq.not$, [], []).map(x => rotate(x, 90deg)),
          $w_1$, $w_2$, $dots$, $w_(i-1)$, $w_i$, $dots$, $w_(|w|)$,
        ),
        place(dx: 2em, math.underbrace(h(9em), $sum_(r gt.eq i) w_r = n'$)),
      ),
    )]

  Partimos en casos:
  + Si $v_i = 25$, entonces $n' gt.eq 25$, y $w_i < 25$. Como ordenamos $w$ de forma no-creciente, y el resto de $w$ tiene que sumar $n' gt.eq 25$, consideremos qué monedas está usando $w$, a partir de $w_i$. Llamemos a estas monedas $z = [w_j | |w| gt.eq j gt.eq i]$. $z$ va a ser de la forma $z = [#math.underbrace($10, dots, 10$, [$a$ dieces]), #math.underbrace($5, dots, 5$, [$b$ cincos]), #math.underbrace($1, dots, 1$, [$c$ unos])]$, con $10a + 5b + c = n'$.
    + Si $a gt.eq 3$, entonces podemos reemplazar tres $10$s por $[25, 5]$, obteniendo una solución más corta que $w$.
    + Si $a = 2$, $b gt.eq 1$, entonces podemos reemplazar dos $10$s y un $5$ por $[25]$. Si $b = 0$, podemos reemplazar dos $10$s y cinco $1$s por $[25]$.
    + Si $a = 1$, $b gt.eq 3$, podemos reemplazar un $10$ y tres $5$s por $[25]$. Si $b = 2$, podemos reemplazar un $10$, dos $5$s y cinco $1$s por $[25]$. Si $b = 1$, podemos reemplazar un $10$, un $5$ y diez $1$s por $[25]$. Si $b = 0$, podemos reemplazar un $10$ y quince $1$s por $[25]$.
    + Si $a = 0$, vemos que cualquier combinación no-creciente de $5$s y $1$s que sume $n' gt.eq 25$ va a tener un prefijo que sume $25$, y podemos ahí reemplazar ese prefijo monedas por $[25]$. En todos los casos, obteniendo una solución más corta que $w$.
  + Si $v_i = 10$, entonces $n' gt.eq 10$, y como $w_i < v_i$, entonces con la misma construcción que arriba, obtenemos $z = [#math.underbrace($5, dots, 5$, [$a$ cincos]), #math.underbrace($1, dots, 1$, [$b$ unos])]$, con $5a + b = n' gt.eq 10$.
    + Si $a gt.eq 2$, entonces podemos reemplazar dos $5$s por $[10]$.
    + Si $a = 1$, entonces podemos reemplazar un $5$ y cinco $1$s por $[10]$.
    + Si $a = 0$, entonces podemos reemplazar diez $1$s por $[10]$.
  + Si $v_i = 5$, entonces $n' gt.eq 5$, y como $w_i < v_i$, entonces con la misma construcción que arriba, obtenemos $z = [#math.underbrace($1, dots, 1$, [$a$ unos])]$, con $a = n' gt.eq 5$. Podemos entonces reemplazar cinco $1$s por $[5]$.
  + No podemos tener $v_i = 1$, porque no es posible tener $w_i in C, w_i < 1$.

  En todos los casos, obtenemos una solución más corta que $w$, lo cual contradice que $w$ era una solución óptima. Luego, no puede existir tal $w$, y por lo tanto $v$ es una solución óptima.]


/*
#ej[
Tenemos $n$ tareas para hacer. Cada tarea tiene una duración $d_i$, y una penalidad $p_i$. Como podemos hacer sólo una tarea a la vez, queremos encontrar un orden para realizar las tareas, tal que si $c_i$ es el momento en el que terminamos la tarea $i$, minimizamos el tiempo total pesado $T = sum_(i=1)^n p_i c_i$.

Por ejemplo, si tenemos tres tareas, con penalidades $p = [7, 1, 8]$, duraciones $d = [1, 2, 3]$, y las realizamos en orden $[3, 1, 2]$, entonces los tiempos de terminación son $c = [4, 6, 3]$, y el tiempo total pesado es $T = 7 times 4 + 1 times 6 + 8 times 3 = 58$.

Diseñar un algoritmo greedy para resolver este problema. Probar que es correcto y probar su complejidad temporal y espacial asintótica.
]
#demo[
/* Ordenar las tareas por $p_i / d_i$. */
// https://www.youtube.com/watch?v=WJpxJXzahIQ
// https://www.youtube.com/watch?v=qG0UfYTmN_Y
// https://rohitvaish.in/Teaching/2024-Fall/Slides/Lecture-15.pdf
]
*/

#ej[
  Tenemos un aula a nuestra disposición, y $n$ clases que se pueden dar en ese aula. La $i$-ésima clase empieza a la hora $s_i$, y termina a la hora $f_i$. Dos clases no se pueden dar al mismo tiempo en ese aula. Queremos saber cual es el máximo número de clases que se pueden dictar en ese aula.

  Diseñar un algoritmo greedy que resuelva este ejercicio. Probar que es correcto y probar su complejidad temporal y espacial asintótica.
]
#quote-box[
  Cuando encontramos un problema nuevo y queremos ver si existe una estrategia greedy para resolverlo, lo primero que tenemos que hacer es intentar definir una estructura de "subproblemas", y adivinar cuál va a ser una estrategia de selección local (es decir, que toma decisiones en cada subproblema, sin replantearlas si "sale mal").

  Sirve entonces plantearse ejemplos, y ver cómo nuestras ideas funcionan o no.

  #let h = 15pt
  #let w = 15pt
  #let padding = 3pt
  #let rng = gen-rng-f(0xBADFED)
  #let act(i, row, s, f, selected: false) = {
    let fill = if selected {
      blue.lighten(80%)
    } else {
      white
    }
    draw.rect(
      (s * w, row * (h + padding)),
      (f * w, row * (h + padding) + h),
      fill: fill,
      stroke: 0.4pt + black,
    )
  }

  #let nrows = 5
  #let ncols = 30
  #let activities = (
    for row in range(nrows) {
      let (x, s, f) = (0.0, 0.0, 0.0)
      while true {
        (rng, s) = uniform-f(rng, low: x, high: x + 2.5)
        (rng, f) = uniform-f(rng, low: s + 1, high: s + 8.5)
        if f > ncols { break }
        (row, s, f)
        x = f
      }
    }
  ).chunks(3)

  #let overlaps(act, acts) = {
    let (_, s, f) = act
    for (_, a_s, a_f) in acts {
      if s <= a_f and a_s <= f { return true }
    }
    return false
  }
  #let max_selected_set(i, x) = {
    if i == activities.len() { return x }
    let a = max_selected_set(i + 1, x)
    if overlaps(activities.at(i), x) {
      return a
    }
    let b = max_selected_set(i + 1, x + (activities.at(i),))
    if b.len() >= a.len() {
      return b
    } else {
      return a
    }
  }
  #let by_start = x => { return x.at(1) }
  #let by_finish = x => { return x.at(2) }
  #let by_size = x => { return x.at(2) - x.at(1) }
  #let selected_by_fn(fn) = {
    let selected = ()
    for act in activities.sorted(key: fn) {
      if not (overlaps(act, selected)) {
        selected = selected + (act,)
      }
    }
    selected
  }
  #assert(selected_by_fn(by_finish).len() > selected_by_fn(by_size).len(), message: "NOPE1")
  #assert(selected_by_fn(by_finish).len() > selected_by_fn(by_start).len(), message: "NOPE2")
  #assert(selected_by_fn(by_finish).len() == max_selected_set(0, ()).len(), message: "NOPE3")
  #canvas({
    let selecteds = ()
    for (i, (row, s, f)) in activities.enumerate() {
      act(i, row, s, f, selected: (row, s, f) in selecteds)
    }
  })

  Pensemos en un par de estrategias para este ejemplo.
  + Podemos ordenar las materias por hora de comienzo, y agarrar la materia que empieze lo antes posible, que no tenga conflictos con materias ya seleccionadas. Esto nos da un subconjunto de tamaño 4.
    #canvas({
      let selecteds = selected_by_fn(by_start)
      for (i, (row, s, f)) in activities.enumerate() {
        act(i, row, s, f, selected: (row, s, f) in selecteds)
      }
    })
  + Podemos ordenar las materias por duración, eligiendo las más cortas que no causen conflictos con materias ya seleccionadas. Esto nos da un subconjunto de tamaño 5.
    #canvas({
      let selecteds = selected_by_fn(by_size)
      for (i, (row, s, f)) in activities.enumerate() {
        act(i, row, s, f, selected: (row, s, f) in selecteds)
      }
    })
  + Podemos ordenar las materias por hora de finalización, y agarrar la materia que termine lo antes posible, que no tenga conflictos con materias ya seleccionadas. Esto nos da un subconjunto de tamaño 6.
    #canvas({
      let selecteds = selected_by_fn(by_finish)
      for (i, (row, s, f)) in activities.enumerate() {
        act(i, row, s, f, selected: (row, s, f) in selecteds)
      }
    })

  Si buscamos a fuerza bruta, una solución óptima para este ejemplo también tiene tamaño 6.
  #canvas({
    let selecteds = max_selected_set(0, ())
    for (i, (row, s, f)) in activities.enumerate() {
      act(i, row, s, f, selected: (row, s, f) in selecteds)
    }
  })

  Esto nos sugiere intentar probar que la estrategia de ordenar por momento de finalización, creciente, puede ser buena.
]
#sol[
  Proponemos el siguiente algoritmo.

  #algorithm({
    import algorithmic: *
    Procedure(
      "GreedyCourses",
      ($M = [(s_1, f_1), dots, (s_n, f_n)]: #smallcaps("List")\[NN times NN]$),
      {
        Assign[$A$][[]]
        Assign[$I$][sort($[1, dots, n]$, key: $lambda i. f_i$)]
        Assign[$c$][0]
        For($i in I$, {
          If($s_i >= c$, {
            Assign[$c$][$f_i$]
            Assign[$A$][$A + [i]$]
          })
        })
        Return[$A$]
      },
    )
  })

  #demo[
    Para esta demostración les vamos a mostrar un argumento de liderazgo ("greedy stays ahead"). Para esto tenemos que definir una estructura de "subproblemas" que nuestro algoritmo greedy resuelve en orden. Luego tenemos que dar una estructura de sub-solución a cualquier solución. Finalmente, vamos a dar una noción de "valor" para las sub-soluciones, y probamos que la $i$-ésima sub-solución de nuestro algoritmo tiene "mejor" valor que la $i$-ésima sub-solución de cualquier solución. "Mejor" puede lo vamos a definir a veces como "menor", y a veces como "mayor", dependiendo del problema.

    Sean $A = {i_1, dots, i_k}$ los índices de las materias que devuelve nuestro algoritmo, en el orden en que fueron agregados. Sea $O = {j_1, dots, j_m}$ los índices de las materias en una solución óptima, ordenados por momento de finalización. Sea $F(X) = max_(x in X) f_x$ el máximo tiempo de finalización entre todas las materias en un conjunto $X$. Notar que por cómo definimos $A$ y $O$, tenemos que $F({i_1, dots, i_r}) = F({i_r}) = f_(i_r)$ y $F({j_1, dots, j_r}) = F({j_r}) = f_(j_r)$, para todo $r$.

    Las sub-soluciones de nuestro algoritmo son ${i_1, dots, i_r}$, para cada $r$. Las sub-soluciones de una solución óptima son ${j_1, dots, j_r}$, para cada $r$. La noción de valor que vamos a usar es $F$, el máximo tiempo de finalización entre las materias en la sub-solución. Vamos a mostrar, entonces, que para todo $1 lt.eq r lt.eq k$, tenemos $P(r): F({i_1, dots, i_r}) lt.eq F({j_1, dots, j_r})$. Probemos $P$.

    + Caso base, $P(1)$. Como $A$ eligió inicialmente la materia que antes termina en $M$, sabemos que $f_(i_1) lt.eq f_r forall r$. En particular, vemos que $f_(i_1) lt.eq f_(j_1)$.
    + Paso inductivo. Sea $k gt.eq t gt.eq 2 in NN$, sabemos que $P(t - 1)$, queremos probar $P(t)$. $P(t-1)$ nos dice que $f_(i_(t-1)) lt.eq f_(j_(t-1))$. Todas las materias que pueden seguirle a $j_(t-1)$ en $O$ empiezan después de $f_(j_(t-1))$, luego como eso viene después que $f_(i_(t-1))$, también son candidatas para agregar a $A$. Luego, si $i_t$ es la siguiente materia que agrega $A$, entonces $f_(i_t) lt.eq f_(j_t)$, pues $A$ toma la que antes termine, de todas las candidatas. Esto muestra que $P(t)$ es cierto.

    Eso demuestra que vale $P(r)$ para todo $1 lt.eq r lt.eq k$. En particular, vale para $r = k$, y tenemos que $F(A) = F({i_1, dots, i_k}) lt.eq F({j_1, dots, j_k})$.

    Si $m > k$, entonces existe $j_(k+1)$, una materia que la solución óptima $O$ eligió, que no está en $A$. Como ordenamos $O$, debemos tener que $s_(j_(k+1)) gt.eq f_(j_k)$. Por $P(k)$, sabemos que $f_(j_k) gt.eq f_(i_k)$. Por lo tanto, $j_(k+1)$ es una materia que empieza después de que termine la última materia que agregó $A$. Es más, como $k$ fue la última materia que agregó $A$, $j_(k+1)$ empieza después que _todas_ las materias en $A$. Entonces, al iterar por $i = j_(k+1)$, $A$ la hubiera agregado, y no lo hizo. Esto no puede suceder, y por lo tanto $m lt.eq k$. Luego, $A$ es una solución óptima.
  ]]

#ej[
  Tenemos $n$ items, cada uno con valor $v_i$ y peso $p_i$. Tenemos una mochila que puede aguantar un peso máximo $P$. Para este problema, podemos tomar pedazos fraccionarios de cada objeto. Por ejemplo, si tenemos una manzana de 300 gramos y valor 6, podemos tomar un tercio de la manzana, de peso 100 gramos y valor 2.

  Queremos maximizar el valor de los objetos que llevamos en la mochila, sin exceder el peso máximo $P$. Podemos asumir que $v_i / p_i eq.not v_j / p_j forall i, j$, es decir, que no hay dos objetos con el mismo valor por unidad de peso.

  Diseñar un algoritmo greedy que resuelva este ejercicio. Probar que es correcto y probar su complejidad temporal y espacial asintótica.
]
#sol[
  Primero formalicemos un poco la consigna. Lo que queremos hacer es encontrar un vector $x = (x_1, dots, x_n)$, donde $0 lt.eq x_i lt.eq 1$ para cada $i$, que maximice la suma
  $
    sum_(i = 1)^n v_i x_i
  $

  sujetos a

  $
    sum_(i = 1)^n p_i x_i lt.eq P
  $

  Una estrategia greedy para resolver esto va a ser repetidamente elegir algún elemento, mientras que quepa en la mochila. Si sólo cabe una fracción del objeto, metemos sólo esa fracción en la mochila. Veamos un ejemplo, con peso máximo $P = 40$.

  #align(center)[
    #grid(
      columns: 9,
      rows: 2,
      gutter: 0pt,
      inset: 5pt,
      stroke: 0.5pt + black,
      [Pesos], $4$, $50$, $14$, $52$, $13$, $1$, $45$, $3$,
      [Valores], $2$, $42$, $4$, $24$, $2$, $3$, $42$, $10$,
    )]

  Algunas ideas para cómo elegir los objetos:

  + Podemos elegir el objeto con mayor valor, y meterlo en la mochila. Si no cabe entero, metemos la fracción que quepa. En este problema, elegiríamos ordenaríamos los objetos como $[2, 7, 4, 8, 3, 6, 1, 5]$. Luego intentaríamos meter el $2$do objeto, que tiene peso $50$ y valor $42$. Como no cabe entero puesto que su peso es mayor a $P = 40$, meteríamos $40/50$ de este objeto, que aporta un valor de $40/50 times 42 = 33.6$.
  + Podemos elegir el objeto con menor peso, y meterlo en la mochila. Si no cabe entero, metemos la fracción que quepa. En este problema, ordenaríamos los objeto como $[6, 8, 1, 5, 3, 7, 2, 4]$. Podemos meter los objetos 6, 8, 1, 5, y 3, enteros, obteniendo un valor de $3+10+2+2+4 = 21$. Para cuando vemos el 7mo objeto, nuestra mochila ya tiene un peso de $1 + 3 + 4 + 13 + 14 = 35$, luego sólo podemos meter $5/45$ de este objeto, que nos agrega un valor de $5/45 times 42 = 4.67$, obteniendo un valor final de $21 + 4.67 = 25.67$.
  + Podemos elegir el objeto con mayor valor por unidad de peso ($v_i / w_i$), y meterlo en la mochila. Si no cabe entero, metemos la fracción que quepa. En este caso, ordenaríamos los objetos como $[8, 6, 7, 2, 1, 4, 3, 5]$. Agregamos los objetos 8 y 6, obteniendo un valor de 13, y un peso de 4. Luego vemos el 7mo objeto, y como tenemos 36 de peso para llenar, y el objeto pesa 45, sólo podemos meter $36/45$ de este objeto, que nos agrega un valor de $36/45 times 42 = 33.6$, obteniendo un valor final de $13 + 33.6 = 46.6$.

  De estas tres ideas, la última fue la que mejor valor nos dio. Intentemos, entonces, ese algoritmo.

  #algorithm({
    import algorithmic: *
    Procedure(
      "FractionalKnapsack",
      ($P in NN$, $p: NN^n$, $v: NN^n$),
      {
        Assign[$A$][[]]
        Assign[$I$][sort($[1, dots, n]$, key: $lambda i. v_i / p_i$)]
        Assign[$c$][0]
        Assign[$v$][0]
        For($i in I$, {
          IfElseChain(
            $c + p_i <= P$,
            {
              Assign[$c$][$c + p_i$]
              Assign[$v$][$v + v_i$]
              Assign[$A$][$A + [(i, 1.0)]$]
            },
            {
              Assign[$x$][$P - c / p_i$]
              Assign[$v$][$v + x * v_i$]
              Assign[$A$][$A + [(i, x)]$]
              Break
            },
          )
        })
        Return[$(A, v)$]
      },
    )
  })

  #demo[
    Para este problema vamos a usar un argumento de intercambio. Vamos a considerar una solución óptima que es distinta y mejor a la nuestra, y vamos a ver que podemos mejorar esta solución óptima, lo cual nos diría que no puede existir.

    #note-box[
      Notemos que en general _no_ vamos a poder probar que nuestra solución es la _única_ solución óptima. Puede haber muchas, y nuestro algoritmo va a elegir una sola. No vamos a poder probar, entonces, que no existe una solución óptima distinta que la nuestra. Lo que vamos a poder probar es que no hay una solución _mejor_ que la nuestra.
    ]

    Ordenemos los objetos por su valor por unidad de peso, $v_i / p_i$, de forma no-creciente. Luego, tenemos que $v_i / p_i gt.eq v_j / p_j$ para todo $i lt.eq j$.

    Sea $A = [x_1, dots, x_n]$ las fracciones de cada elemento que eligió nuestro algoritmo, y sea $O = [y_1, dots, y_n]$ una solución óptima. Por cómo ordenamos los objetos en esta demostración, nuestro algoritmo eligió primero un valor para $x_1$, luego un valor para $x_2$, etcétera. Notemos que $0 lt.eq x_i lt.eq 1$ y $0 lt.eq y_i lt.eq 1$ para todo $i$, porque estamos eligiendo fracciones de los objetos, y no podemos elegir más de un objeto entero.

    Supongamos que $A$ no es óptima. Entonces $sum_(i = 1)^n v_i x_i < sum_(i = 1)^n v_i y_i$. Sea $i$ el primer índice donde $x_i eq.not y_i$. Luego, $sum_(j = 1)^(i - 1) x_j p_j = sum_(j = 1)^(i - 1) y_j p_j$. Al momento de elegir $x_i$, nuestro algoritmo podía usar un peso máximo de $P' = P - sum_(j = 1)^(i - 1) x_j p_j$. Nuestro algoritmo elije $x_i = P' / p_i$.

    Asimismo, como $O$ es una solución, tenemos que $sum_(j = 1)^n y_j p_j lt.eq P$. Restando $sum_(j = 1)^(i - 1) x_j p_j$ de cada lado, tenemos que $sum_(j = i)^n y_j p_j lt.eq P'$. Como todos los pesos son positivos, así como también los $y_j$, esto implica que $y_i p_i lt.eq P'$. Esto es lo mismo que decir $y_i lt.eq P'/p_i = x_i$. Como $y_i lt.eq x_i$ y $y_i eq.not x_i$, sabemos que $y_i < x_i$. Como $O$ es óptima, y tiene más peso disponible en la mochila, tiene que existir algún $j > i$ tal que $y_j > x_j$. Si no fuera así, entonces $O$ no es óptima, porque $A$ tiene más valor que $O$.

    Sea $epsilon = min(1 - y_i, y_j p_j / p_i)$. Vemos que, como $epsilon lt.eq 1 - y_i$, entonces $y_i + epsilon lt.eq 1$. También, como $epsilon lt.eq y_j p_j/p_i$, entonces $y_j - epsilon p_i/p_j gt.eq 0$. Por lo tanto, podemos definir una nueva solución $z$, cuyos valores están siempre entre $0$ y $1$, como:

    $
      z_r = cases(
        y_i + epsilon", si "r = i,
        y_j - epsilon p_i / p_j", si "r = j,
        y_r", si "r eq.not i and r eq.not j
      )
    $

    Veamos que el peso total de $z$ es el mismo que el de $O$.

    $
      sum_(r = 1)^n z_r p_r &= sum_(r = 1)^n y_r p_r - y_i p_i - y_j p_j + (y_i + epsilon) p_i + (y_j - epsilon p_i / p_j) p_j\
      &= sum_(r = 1)^n y_r p_r - y_i p_i - y_j p_j + y_i p_i + epsilon p_i + y_j p_j - epsilon p_i\
      &= sum_(r = 1)^n y_r p_r
    $

    Y luego $z$ es una solución válida. Sin embargo, veamos que el valor de $z$ es mayor al de $O$:
    $
      sum_(r = 1)^n z_r v_r &= sum_(r = 1)^n y_r v_r - y_i v_i - y_j v_j + (y_i + epsilon) v_i + (y_j - epsilon p_i / p_j) v_j\
      &= sum_(r = 1)^n y_r v_r - y_i v_i - y_j v_j + y_i v_i + epsilon v_i + y_j v_j - epsilon p_i / p_j v_j\
      &= sum_(r = 1)^n y_r v_r + epsilon (v_i - p_i / p_j v_j)
    $

    Ahora bien:

    $
      v_i - p_i/p_j v_j & gt.eq 0 \
              v_i / p_i & gt.eq v_j / p_j
    $

    Pues así ordenamos los objetos. El problema nos dice que no hay dos objetos con el mismo valor por unidad de peso, entonces ese $gt.eq$ es en realidad un $>$, pues $j > i$, y luego son objetos distintos.

    Por otro lado, sabemos que $y_i < x_i lt.eq 1$, y luego $y_i < 1$, y entonces $1 - y_i > 0$. Asimismo, como $y_j > x_j gt.eq 0$, entonces $y_j > 0$, y luego $y_j p_j / p_i > 0$. Luego, al ser $epsilon = min(1 - y_i, y_j p_j / p_i) > 0$, tenemos que $epsilon (v_i - p_i / p_j v_j) > 0$.


    Luego, $sum_(r = 1)^n z_r v_r > sum_(r = 1)^n y_r v_r$, lo cual contradice que $O$ es óptima. Luego, no puede existir una tal solución óptima, $O$, que es estríctamente mejor que la nuestra, $A$.
  ]
]

#ej[
  Tenemos dos conjuntos de personas y para cada persona sabemos su habilidad de baile. Queremos armar la máxima cantidad de parejas de baile, sabiendo que para cada pareja debemos elegir exactamente una persona de cada conjunto de modo que la diferencia de habilidad sea menor o igual a 1 (en modulo). Ademas, cada persona puede pertenecer a lo sumo a una pareja de baile. Por ejemplo, si tenemos un multiconjunto con habilidades ${1, 2, 4, 6}$ y otro con ${1, 5, 5, 7, 9}$, la maxima cantidad de parejas es 3. Si los multiconjuntos de habilidades son ${1, 1, 1, 1, 1}$ y ${1, 2, 3}$, la máxima cantidad es 2.

  Diseñar un algoritmo greedy que resuelva este ejercicio. Probar que es correcto y probar su complejidad temporal y espacial asintótica.
]
#demo[

  Veamos un algoritmo recursivo simple que resuelve el problema.

  ```python
  def F(G: [int], B: [int]) -> int:
      return f(sorted(G), sorted(B))

  def f(G: [int], B: [int]) -> int:
      if not G or not B:
          return 0
      g = G[0]
      b = B[0]
      if b < g - 1:
          return f(G, B[1:])
      if g < b - 1:
          return f(G[1:], B)
      return 1 + f(G[1:], B[1:])
  ```

  Queremos ver que `F(G, B)` devuelve el máximo número de parejas que se pueden armar con los multiconjuntos (en este programa, listas) de habilidades dados por `G` y `B`. Vamos a probar que `f(G', B')` devuelve la respuesta que `F(G, B)` tiene que dar, asumiendo que `G'` y `B'` tienen los mismos elementos que `G` y `B` respectivamente, sólo permutando su orden, lo cual no cambia la solución esperada, dado que estamos cambiando la representación del multiconjunto, pero no sus elementos.

  Lo vamos a hacer por inducción. Como en `f` estamos sacando siempre un elemento de `B` o de `G` (y a veces de ambos), vamos a definir:

  ```python
  tamaño(G, B) = len(G) + len(B)
  ```

  Esto nos va a ayudar porque nuestras llamadas recursivas siempre llaman a `f` con instancias de menor `tamaño` que la que recibe. Esto es lo que necesitamos para hacer inducción.

  Definimos entonces:
  $
    P(k): f(G, B) & "es correcta para todos los argumentos (G, B)" \
                  & "de tamaño(G, B) a lo sumo " k.
  $

  + Caso base

    El caso base es $P(0)$. Tenemos que probar que $f(G, B)$ es correcto para todos los argumentos de tamaño a lo sumo $k = 0$. Si `tamaño(G, B) = 0`, entonces `len(G) + len(B) = 0`, pero entonces como ambos `len(G)` y `len(B)` son enteros no-negativos, tenemos que `len(G) = len(B) = 0`. Luego, `G = B = []`. Entonces, no hay parejas posibles, porque una pareja tendría que tener un elemento de `G` y otro de `B`. Luego la respuesta correcta es `0`, y efectivamente nuestro programa devuelve `0`, en:

    ```python
      if not G or not B:
          return 0
    ```

  + Paso inductivo

    Ahora probemos el paso inductivo. Asumo $P(k)$, y quiero probar $P(k + 1)$.

    Me dan un par $(G, B)$ con $"tamaño"(G, B) = k + 1$. Si uno de los dos está vacío (no pueden ambos estar vacíos porque $"tamaño"(G, B) = k+1 gt.eq 1$), no hay parejas posibles, luego la respuesta correcta es `0`, y el programa efectivamente devuelve eso

    ```python
      if not G or not B:
          return 0
    ```

    Si ninguno está vacío, ambos tienen un primer elemento, llamémoslo $g_0 in G$ y $b_0 in B$. Como $G$ y $B$ están ordenados crecientes, $g_0 lt.eq g forall g in G$, y $b_0 lt.eq b forall b in B$.

    Consideremos ahora $b_0$ versus $g_0$.

    - Si $b_0 < g_0 - 1$, entonces $b_0$ no puede estar aparejado con $g_0$. Pero más aún, como $g_0 lt.eq g forall g in G$, todos los elementos de $G$ son al menos tan grandes como $g_0$, y luego $b_0$ no puede estar aparejado con nadie. Luego, toda solución a $(G, B)$ es lo mismo que una solución a $(G, B without {b_0})$. Como $"tamaño"(G, B without {b_0}) = k < k + 1$, sabemos por inducción que $f$ es correcta para ese caso, y luego nuestra $f$ es también correcta para este caso de $(G, B)$, porque devolvemos exactamente $f(G, B without {b_0})$:

      ```python
        if b < g - 1:
            return f(G, B[1:])
      ```

    - Con un argumento similar, si $g_0 < b_0 - 1$, $g_0$ no puede estar aparejado con $b_0$, y $b_0$ es menor o igual que todos los elementos en $B$, luego $g_0$ no puede estar aparejado con nadie en $B$, y luego toda solución a $(G, B)$ deja a $g_0$ sin usar, y luego es idéntica a una solución a $(G without {g_0}, B)$. Luego nuestra $f$ es correcta para este caso de $(G, B)$, porque devolvemos exactamente $f(G without {g_0}, B)$, y como $"tamaño"(G without {g_0}, B) = k < k + 1$, por hipótesis inductiva $f$ devuelve una solución óptima para ese caso:

      ```python
        if g < b - 1:
            return f(G[1:], B)
      ```

      Si ninguna de las dos condiciones vale, entonces $g_0 gt.eq b_0 - 1$, y $b_0 gt.eq g_0 - 1$. Esto es lo mismo que $b_0 - g_0 lt.eq 1$, y $g_0 - b_0 lt.eq 1$, o lo que es lo mismo, $|b_0 - g_0| lt.eq 1$, es decir, $b_0$ y $g_0$ son compatibles. Notemos que en nuestro programa esta es la última rama, donde devolvemos `1 + f(G[1:], B[1:])`. Vamos a probar dos lemas:

      + Si existe una solución óptima para $(G, B)$ donde $(g_0, b_0)$ están aparejados, entonces $f$ es correcta para $(G, B)$.
      + Existe una solución óptima para $(G, B)$ donde $(g_0, b_0)$ están aparejados.

      Está claro que si probamos ambos lemas, probamos que $f$ es correcta para $(G, B)$. Como $(G, B)$ era cualquier argumento de tamaño $k + 1$, esto prueba que $P(k) implies P(k+1)$, que es lo que queríamos demostrar.

      #lemma[
        Queremos probar que "Si existe una solución óptima para $(G, B)$ donde $(g_0, b_0)$ están aparejados, entonces $f$ es correcta para $(G, B)$."]
      #demo[
        Supongamos que existe una solución óptima para $(G, B)$ donde $(g_0, b_0$) están aparejados. Sea $S$ esa solución. Luego, $S' = S without {(g_0, b_0)}$ es una forma de aparejar a $G without {g_0}$ y $B without {b_0}$.

        Podemos decir algo más fuerte: $S'$ es _óptima_ para $(G without {g_0}, B without {b_0})$. Si no lo fuera, sea $S^*$ una solución a $(G without {g_0}, B without {b_0})$ que tiene más elementos que $S'$. Como $S^*$ no menciona a $g_0$ ni a $b_0$, podemos construir $S^* union {(g_0, b_0)}$, que tiene $|S^*| + 1 gt |S'| + 1 = |S|$ elementos, y es una solución a aparejar a $G$ y $B$. Esto no puede pasar, porque $S$ era óptima para $(G, B)$, no puedo tener a $S^* union {(g_0, b_0)}$ más grande que $S$.

        Luego, $S'$ es óptima para  $(G without {g_0}, B without {b_0})$. Por inducción, $f$ es correcta para  $(G without {g_0}, B without {b_0})$, porque $"tamaño"(G without {g_0}, B without {b_0}) = k - 1 < k + 1$. Luego $|S'| = |f(G without {g_0}, B without {b_0})|$, y luego $|S| = 1 + |S'| = 1 + |f(G without {g_0}, B without {b_0})|$. Luego $f$ es correcta para $(G, B)$, dado que devolvemos exactamente eso:

        ```python
        return 1 + f(G[1:], B[1:])
        ```
      ]
      #lemma[
        Queremos probar que "Existe una solución óptima para $(G, B)$ donde $(g_0, b_0)$ están aparejados." Sabemos que $g_0$ y $b_0$ son compatibles.]
      #demo[
        Sea $S$ cualquier solución óptima a $(G, B)$. Sean $S_G$ y $S_B$ los elementos de $G$ y $B$ que _no_ aparecen en $S$, respectivamente. Leér "single girls, single boys".

        Partimos en casos:

        - Si $g_0 in S_G$ y $b_0 in S_B$, podríamos considerar $S' = S union {(g_0, b_0)}$, que tiene un elemento más que $S$, y es solución a $(G, B)$. Como $S$ era solución óptima, esto no puede pasar.

        - Si $g_0 in S_G$ pero $b_0 in.not S_B$, sabemos que existe una pareja $(x, b_0) in S$. Luego, podemos considerar  $S' = (S without {(x, b_0)}) union {(g_0, b_0)}$. Esto deja sin aparejar a $x$, pero empareja a $g_0$ y $b_0$, y como tiene el mismo número de elementos que $S$, vemos que $S'$ es una solución óptima para $(G, B)$ donde $g_0$ y $b_0$ están aparejados.

        - Si $b_0 in S_B$ pero $g_0 in.not S_G$, sabemos que existe una pareja $(g_0, y) in S$. Luego, podemos considerar $S' = (S without {(g_0, y)}) union {(g_0, b_0)}$. Esto deja sin aparejar a $y$, pero empareja a $g_0$ y $b_0$, y como tiene el mismo número de elementos que $S$, vemos que $S'$ es una solución óptima para $(G, B)$ donde $g_0$ y $b_0$ están aparejados.

        - Si $g_0 in.not S_G$ y $b_0 in.not S_B$, entonces ambos están aparejados. Hay dos opciones:

          - Si están aparejados el uno al otro, es decir, $(g_0, b_0)$ está en $S$, ya está, conseguimos una solución óptima que contiene a $(g_0, b_0)$, y es $S$.

          - Si no, existen $(x, b_0) in S$ y $(g_0, y) in S$. Quisieramos aparejar a $b_0$ con $g_0$, y a $x$ con $y$, y para eso tenemos que probar que $x$ e $y$ son compatibles. Como $b_0$ era el elemento en $B$ más chico, tenemos que $y gt.eq b_0$. De la misma manera sabemos que $x gt.eq g_0$. Veamos qué puede pasar:

            - Si $b_0 = g_0$, es decir, tienen la misma altura, entonces $y gt.eq b_0 = g_0$, y como en $S$ están aparejados $y$ con $g_0$, $y$ sólo puede ser $g_0$ o $g_0 + 1$.  Por el mismo motivo, $x gt.eq g_0 = b_0$, y en $S$ están aparejados $x$ con $b_0$, y entonces $x$ sólo puede ser $b_0$ o $b_0 + 1$. Como $b_0$ y $g_0$ son el mismo número, ambos $x$ e $y$ sólo pueden ser $b_0$ o $b_0 + 1$, y luego $x$ e $y$ son compatibles.
            - Si $b_0 = g_0 + 1$, entonces $y gt.eq b_0 = g_0 + 1$, y como en $S$ están aparejados $y$ con $g_0$, tenemos que $y$ es _exáctamente_ $g_0 + 1$. Luego tenemos que $y = g_0 + 1 = b_0$. Como $x$ y $b_0$ son compatibles, y $b_0 = y$, vemos que $x$ e $y$ son compatibles.
            - Si $g_0 = b_0 + 1$, pasa lo mismo que en el caso anterior. Tenemos $x gt.eq g_0 = b_0 + 1$, y como $x$ y $b_0$ están aparejados en  $S$, tenemos que $x$ es _exáctamente_ $b_0 + 1$. Luego tenemos que $x = b_0 + 1 = g_0$. Como $y$ y $g_0$ son compatibles, y $g_0 = x$, vemos que $x$ e $y$ son compatibles.

            Como en todos los casos $x$ e $y$ son compatibles, podemos considerar $S' = (S without {(x, b_0), (g_0, y)}) union {(g_0, b_0), (x, y)}$. Esta es una solución a $(G, B)$ que apareja a $g_0$ y $b_0$, y que tiene el mismo número de elementos que $S$, y por lo tanto también es óptima para $(G, B)$.

            Vemos entonces que siempre existe una solución óptima para $(G, B)$ donde $g_0$ y $b_0$ están aparejados.
      ]
]

#ej[
  Resolver el ejercicio anterior dando un algoritmo iterativo, en vez de recursivo.
]
#demo[
  Veamos ahora una resolución iterativa del mismo ejercicio.

  Nota: Se asume acá que los multiconjuntos están representados por listas no-decrecientes.

  ```python
  def f(G: [int], B: [int]) -> int:
    n = len(G)
    m = len(G)
    i = 0
    j = 0
    res = 0
    while i < n and j < m:
      g = G[i]
      b = B[j]
      if b < g - 1:
          j += 1
      elif g < b - 1:
          i += 1
      else:
          i += 1
          j += 1
          res += 1
    return res
  ```

  Nuestro invariante va a ser que $0 lt.eq i lt.eq n, 0 lt.eq j lt.eq m$, y que existe un conjunto $S$, un conjunto $T$, y una solución óptima $S^*$, tal que:

  + $S subset.eq G[0 dots i) times B[0 dots j)$
  + $T subset.eq G[i dots n) times B[j dots m)$
  + $S^* = S union.sq T$, con $union.sq$ siendo la unión disjunta
  + `res` = $|S|$

  Esto se puede entender como que $S$ es "extensible" a una solución óptima $S^*$, usando sólo elementos que vienen no antes que $i$ en $G$ y $j$ en $B$. Llamemos a esta noción "$(i, j)$-extensible".

  *El invariante vale inicialmente*

  Claramente vale el invariante antes de entrar al ciclo, dado que `i = j = 0`, y `G[0 .. i) = G[0 .. 0) = [], B[0 .. j) = B[0 .. 0) = []`. Con ambos `G` y `B` vacíos, no se puede formar ninguna pareja, y luego definimos $S = emptyset$, cuyo tamaño es exactamente `res = 0`. Asimismo, vemos que _toda_ solución global $S^*$, es una extensión de $emptyset$, agregándole parejas en $G[i dots n) times B[j dots m) = G[0 dots n) times B[0 dots m) = G times B$. En particular, definimos $T = S^*$, y tenemos que $S^* = emptyset union.sq T$.

  Los despiertos habrán notado que ese párrafo asume que _existe_ una solución óptima. Un "para todo $x$ en $X$, vale $P(x)$" sólo implica "existe $x$ en $X$ tal que $P(x)$" cuando $X$ no es vacío. El conjunto de todos los emparejamientos posibles no es vacío (por ejemplo, podemos tomar el emparejamiento vacío), y es finito (está incluído en $cal(P)(G times B)$, el conjunto de partes de $G times B$). Luego tiene al menos un elemento de tamaño máximo, y luego _existe_ al menos una solución óptima.

  *El invariante es preservado por las iteraciones*

  Ahora veamos que si vale la guarda, y vale el invariante al entrar al cuerpo del ciclo, vale el invariante al finalizar el cuerpo del ciclo. Como vale la guarda, sabemos que $0 lt.eq i < n$, y $0 lt.eq j < m$. Vemos fácilmente que al final del cuerpo del loop sigue valiendo $0 lt.eq i lt.eq n, 0 lt.eq j lt.eq m$, porque sólo los aumentamos en uno en el cuerpo del loop, y antes eran $gt.eq 0$ y $< n$ y $< m$, respectivamente. Como los índices están en rango, tiene sentido referirse a $g = G[i]$, y $b = B[j]$. Partamos en los tres casos que parte el algoritmo:

  + Si $b < g - 1$, entonces $b$ no es compatible con $g$, puesto que $|g - b| = g - b > 1$.  Sabemos que $G$ está ordenado crecientemente, luego para todo $g' in G[i dots n)$, $g' gt.eq g$, y luego $|g' - b| = g' - b gt.eq g - b > 1$, y por lo tanto $b$ es también incompatible con todos los $g'$ que quedan. Luego, sea $S^*$ la extensión de $S$ que existe por el invariante. Sabemos que $S^*$ se descompone como $S^* = S union.sq T$, con $S subset.eq G[0dots i) times B[0 dots j)$, y $T subset.eq G[i dots n) times B[j dots m)$. Como $b = B[j]$, $b in.not B[0 dots j)$, y luego $b$ no aparece emparejado en $S$. Vimos arriba que $b$ no es compatible con nadie en $G[i dots n)$, y luego $b$ no puede estar en $T$, porque su pareja debería estar en $G[i dots n)$. Luego, tenemos que

    + $S subset.eq G[0 dots i) times B[0 dots j + 1)$, trivialmente, porque ya estaba incluído en $G[0 dots i) times B[0 dots j)$.
    + $T subset.eq G[i dots n) times B[j + 1dots m)$, porque sabíamos que estaba incluído en $G[i dots n) times B[j dots m)$, y probamos que $b$ no aparece emparejado con nadie en $T$, luego podemos restringir la segunda componente de $T$ a $B[j + 1 dots m)$.
    + $S^* = S union.sq T$, que ya valía antes.
      Luego, como nuestro código dice:

      ```python
      j += 1
      ```

    Estamos manteniendo el invariante, porque cambiamos de $j$ a $j + 1$.

  + Si $g < b - 1$, pasa algo exactamente análogo al caso anterior, y como decimos `i += 1`, mantenemos el invariante.

  + Si no, tenemos que $g gt.eq b - 1$, y $b gt.eq g - 1$. Esto implica que $|g - b| lt.eq 1$, y por lo tanto son compatibles. Definimos $S' = S union {(g, b)}$, con $S' subset.eq G[0dots i+1) times B[0dots j+1)$, porque $S subset.eq G[0 dots i) times B[0 dots j)$, y $S'$ usa $g = G[i]$ y $b = B[j]$. Queremos mostrar que $S'$ es $(i + 1, j + 1)$-extensible, para probar que se mantiene el invariante. Definamos $S^*_G$ como los elementos de $G$ que *no* menciona $S^*$, y $S^*_B$ análogamente para $B$. Leér "single girls, single boys". Partimos en casos.

    + Si $g in S^*_G and b in S^*_B$.  Esto no puede suceder, porque $(g, b)$ son compatibles, luego $S^* union {(g, b)}$ sería una solución con tamaño mayor a $S^*$, con $S^*$ siendo definida como de tamaño máximo.

    + Si $g in S^*_G$, pero $b in.not S^*_B$. Esto significa que existe un emparejamiento $(x, b) in S^*$, con $x eq.not g$, y que $g$ no aparece emparejada en $S^*$. Como $b$ no aparece emparejado en $S$, tiene que ser que $(x, b) in T$. Consideremos entonces $T' = T without {(x, b)}$. Definamos $S^{*'} = S' union.sq T'$. Tenemos que $|S^{*'}| = |S'| + |T'| = |S| + 1 + |T| - 1 = |S| + |T| = |S^*|$, y luego $S^{*'}$ también es óptima, porque tiene el mismo tamaño que $S^*$. Notamos que agregar $(g, b)$ es válido, porque $g$ no aparecía emparejada en $S^*$, y rompimos la pareja de $b$ cuando creamos $T'$. Notar también que $T' subset.eq G[i + 1 dots n) times G[j + 1 dots m)$, porque $g$ no aparece emparejado en $S^*$ (a fortiori en $T$, y en $T'$), y le sacamos a $T$ la mención de $b$. Por lo tanto, $S'$ es $(i + 1, j + 1)$-extensible.

    + Si $b in S^*_B$, pero $g in.not S^*_G$. Esto es totalmente análogo al caso anterior.

    + Si $b in.not S^*_B, g in.not S^*_G$. Pueden pasar dos cosas, que estén emparejados entre sí, o que cada uno esté emparejado con alguien más.

      + Si $(g, b) in S^*$. Ya sabíamos que $(g, b) in.not S$, y luego como $S^* = S union.sq T$, tenemos que $(g, b) in T$. Definiendo $T' = T without {(g, b)}$, vemos que $S^* = S' union.sq T'$, y $T'$ no usa ni $g = G[i]$ ni $b = B[j]$, y luego $T' subset.eq G[i + 1 dots n) times B[j + 1 dots m)$. Luego $S'$ es $(i + 1, j + 1)$-extensible.

      + Si no, entonces existen $(g, x)$ y $(y, b)$ en $S^*$. Como $g = G[i]$ y $b = B[j]$ no pueden estar en $S$ porque $S subset.eq G[0 dots i) times B[0 dots j)$, esas parejas tienen que estar en $T$. Notamos que $x gt.eq b$ y que $y gt.eq g$, porque $x$ e $y$ vienen después que $b$ y $g$ en $B$ y $G$ respectivamente, y $B$ y $G$ están ordenados de forma no-decreciente. Vamos a probar que $x$ e $y$ son compatibles.

        + Si $g = b$, entonces $y gt.eq g = b$. Como $(y, g) in T$, son compatibles, y luego $y = g$, o $y = g + 1$. Por el mismo motivo, $x gt.eq b = g$, y como $(g, x) in T$, son compatibles, luego $x = g$, o $x = g + 1$. Luego, ${x, y} subset.eq {g, g+1}$, luego están a distancia a lo sumo 1 del otro, y luego son compatibles.
        + Si $g > b$, entonces $g = b + 1$, porque $g$ y $b$ son compatibles. Tenemos $y gt.eq g > b$, y luego $y = b + 1$, porque $(y, b)$ son compatibles, estando emparejados en $T$. Como $x$ es compatible con $g = b + 1$, estando emparejados en $T$, tenemos que $x$ es compatible con $y$.
        + Si $b > g$, tenemos algo análogo al caso anterior.

        En todos los casos, $x$ e $y$ son compatibles. Luego, podemos considerar $T' = T union {(x, y)} without {(g, x), (y, b)}$, y definimos $S^{*'} = S' union.sq T'$, con $|S^{*'}| = |S'| + |T'| = |S| + 1 + |T| + 1 - 2 = |S| + |T| = |S^*|$, y luego $S^{*'}$ también es una solución óptima. Como $T$ sólo usa elementos que vienen _después_ de $(g, b) = (G[i], B[j])$, tenemos que $T' subset.eq G[i + 1 dots n) times B[j + 1 dots m)$, y luego $S'$ es $(i + 1, j + 1)$-extensible.

    En todos los casos, tenemos que existe $S'$, un conjunto $(i + 1, j + 1)$-extensible, con $|S'| = |S| + 1$. Recordemos que `res`, antes de entrar al cuerpo de la iteración, era igual a $|S|$, por el teorema del invariante. Luego, como nuestro código dice:

    ```python
    i += 1
    j += 1
    res += 1
    ```

    `res` es ahora $|S'|$, y el invariante es preservado.

  *El ciclo termina*

  El cuerpo del ciclo siempre aumenta o $i$ o $j$, empezando ambos en cero. Luego, si llegásemos a $n + m - 1$ iteraciones, tendríamos $i + j = n + m - 1$. Esto haría que la guarda no se cumpla y el ciclo termine - veamos por qué.
  + Si $i gt.eq n$, la guarda no se cumple.
  + Si $i < n$, y sabemos que $n + m - 1 = i + j$, entonces $n + m + 1 < n + j$, y restando $n$ de cada lado obtenemos $m + 1 < j$, o lo que es lo mismo, $j gt.eq m$, con lo cual la guarda no se cumple.

  *El invariante es suficiente para demostrar lo que queremos*

  Al final del ciclo, vale la negación de la guarda, y el invariante. La negación de la guarda es que o bien $i gt.eq n$, o bien $j gt.eq m$. Como vale el invariante, tenemos que $i lt.eq n$ y $j lt.eq m$. Luego, sabemos que o bien $i = n$, o bien $j = m$ (pueden pasar las dos juntas). Partimos en casos:

  + Si $i = n$, entonces $S$ es $(n, j)$-extensible para algún $j$. Esto significa que existe una solución óptima $S^*$, y un conjunto $T subset.eq G[n dots n) times B[j dots m)$, tal que $S^* = S union.sq T$. Pero $G[n dots n) = emptyset$, y luego $T = emptyset$, y luego $S = S^*$. Luego, $S$ es una solución óptima.
  + Si $j = m$, pasa algo análogo con $B[m dots m) = emptyset$.

  Luego, como sabemos que `res`$= |S|$, y devolvemos `res`:

  ```python
  return res
  ```

  Nuestro algoritmo devuelve el tamaño de una solución óptima, y luego es correcto.
]

#load-bib()