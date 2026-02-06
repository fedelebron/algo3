
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble
== Divide and conquer y programación dinámica

#let t = [La computación está llena de algoritmos que se basan en dividir un problema en subproblemas más pequeños, resolver esos, y luego combinar los resultados. Estos en general van a tener demostraciones por inducción, donde hacemos inducción en el tamaño de los subproblemas que estamos resolviendo. Nuestra tarea es darle semántica al resultado del algoritmo, definir la noción de tamaño, y probar por inducción en el tamaño de una sub-solución, que el algoritmo es correcto con respecto a su semántica, para todos los subproblemas.]
#let img = image("/images/cake.png", width: 100%)
#wrap-content(img, t, align: bottom + right)


#ej[
  Se tiene un array $A$ de $n$ enteros, ordenado de manera estríctamente creciente. Dar un algoritmo basado en divide and conquer que determine si existe una posición $i$ tal que $A[i] = i$. Probar su correctitud, y determinar su complejidad asintótica temporal y espacial en el peor caso.]
#sol[
  #let aa = (-5, -3, -2, 3, 7, 8, 10)
  #let n = aa.len()
  #let bb = aa.zip(range(n)).map(((a, i)) => a - i)
  Podemos considerar la lista $B[i] = A[i] - i$, y vemos que $A[i] = i$ exactamente cuando $B[i] = 0$. Por ejemplo, para $A =$#aa, tenemos $B =$#bb, que se ve así:

  #canvas({
    plot.plot(
      size: (14, 5),
      x-label: $i$,
      x-tick-step: 1,
      y-label: none,
      y-tick-step: 4,
      legend-style: (
        default-position: "north-east",
        spacing: -1.8,
      ),
      {
        plot.add(range(n).zip(range(n)), line: "linear", label: $i$)
        plot.add(range(n).zip(aa), line: "linear", label: $A[i]$)
        plot.add(range(n).zip(bb), line: "linear", label: $B[i]$)
        plot.add-hline(0, style: (stroke: (dash: "dotted", paint: gray)))
      },
    )
  })
  Como $A$ es una lista creciente de enteros, entonces si $i in NN, i < n$, $A[i + 1] gt.eq A[i] + 1$. Restando $i$ a ambos lados, obtenemos $A[i + 1] - i gt.eq A[i] + 1 - i$, o equivalentemente, $A[i + 1] - (i + 1) gt.eq A[i] - i$, que es $B[i + 1] gt.eq B[i]$, luego $B$ es creciente.

  Luego, nuestro algoritmo tiene que encontrar un $i$ tal que $B[i] = 0$, con $B$ creciente. Podemos usar búsqueda binaria para esto. Notemos que no hace falta _crear_ $B$, dado que preguntar si $B[i] > 0$ es lo mismo que preguntar si $A[i] - i > 0 iff A[i] > i$.

  ```py
  def f(A: list[int], i: int, j: int) -> bool:
    if j <= i: return False
    k = i + (j - i) // 2
    if A[k] > k:
      return f(A, i, k)
    elif A[k] < k:
      return f(A, k + 1, j)
    return True
  ```

  La función se llama con ```python f(A, 0, len(A))```. El invariante, como en todas las búsquedas binarias, es que tenemos una propiedad $P(i, j):$ Si existe un $k$ tal que $A[k] = k$, entonces $i lt.eq k < j$.
  #demo[
    La semántica que le vamos a dar a ```python f(A, i, j)``` es que es `True` si y sólo si existe un $k$ en $[i, j)$ tal que $A[k] = k$.
    El algoritmo devuelve ```python f(A, 0, len(A))```. Si logramos probar que `f` es correcta, como todos los tales índices $k$ están en $[0, |A|)$, el algoritmo va a ser correcto.

    Definimos el tamaño de un argumento $(A, i, j)$ como $t(A, i, j) = j - i$, y definimos $P(n):$ Nuestro programa es correcto para todas las entradas de tamaño menor o igual a $n$. Vamos a probar $P$ por inducción.

    + Caso base, $P(0)$. Si $t(A, i, j) = 0$, entonces $i = j$, y el algoritmo devuelve `False`. La semántica que queríamos que `f` cumpliera es que devuelve `True` si y sólo si existe un $k$ en $[i, j)$ tal que $A[k] = k$, pero claramente no puede haber ningún tal $k$ si $i = j$, pues $[i, j) = []$. Luego nuestra función es correcta para entradas con tamaño $T(a, i, j) = 0$.

    + Paso inductivo. Asumo que vale $P(n)$, pruebo $P(n + 1)$. Si $t(A, i, j) = n + 1 > 0$, entonces $j > i$. Definimos $k$ como el promedio entre $i$ y $j$, $k = i + (j - i) / 2 = 2i/2 + (j - i) / 2 = (j + i) / 2$. Como vimos arriba, $B$ es creciente, estricta. Luego:
      + Si $B[k] > 0$, si existe un $k'$ tal que $B[k'] = 0$, tenemos que tener $k' < k$. Como tenemos que devolver `True` exactamente si existe un tal $k'$ en $[i, j)$, y sabemos que si tal $k'$ existe está antes que $k$, entonces el $k'$ no va a estar en $[k, j)$, y tiene que estar, si existe, en $[i, k)$. Por ende, nuestro algoritmo es correcto al devolver $f(A, i, k)$, que por hipótesis inductiva es `True` exactamente cuando hay un $k'$ en $[i, k)$ tal que $B[k'] = 0$.
      + Si $B[k] < 0$, si existe un $k'$ tal que $B[k'] = 0$, tiene que estar después de $k$. Como tenemos que devolver `True` exactamente si existe un $k'$ en $[i, j)$ tal que $B[k'] = 0$, y de existir tal $k'$, tiene que ser mayor a $k$, sabemos que debe estar en $(k, j) = [k + 1, j)$. Luego, nuestro algoritmo es correcto al devolver $f(A, k+1, j)$, que por hipótesis inductiva es `True` exactamente cuando hay un $k'$ en $[k + 1, j)$ tal que $B[k'] = 0$.

    Luego, nuestro algoritmo es correcto para todas las entradas.

    Si denotamos por $T(n)$ al número de operaciones que hace nuestro algoritmo al recibir una entrada de tamaño $t(A, i, j) = n$, vemos que $T(0) = c$ para alguna constante $c$ (no podría ser de otra forma, $T(0)$ no puede depender de nada). Mientras tanto, que si $n > 0$, $T(n)$ llama a uno de dos problemas cuyo tamaño es $k - i$, y $j - (k + 1)$ respectivamente, con $k = floor(i + (j - i) / 2)$. Por definición de la función $floor(thin)$, sabemos que $i + (j - i) / 2 - 1 lt k lt.eq i + (j - i) /2$.

    El primer problema, entonces, tiene tamaño $k - i lt.eq i + (j - i) / 2 - i = (j - i) / 2 = n / 2$. El segundo problema tiene tamaño $j - (k + 1) lt.eq j - (i + (j - i) / 2 - 1 + 1) = 2(j - i)/2 - (j - i) / 2 = (j - i)/2 = n / 2$. Además de las llamadas recursivas, hacemos algún número constante de operaciones.

    Lo que suelen hacer en la materia es decir que esto es $T(n) = T(n/2) + O(1)$, pero como vemos acá esto no es obviamente correcto (¿qué es $T(5/2)$, si dijimos que $T:NN arrow NN$?). Nuestro algoritmo a veces va a llamar a un problema de tamaño $floor(n/2)$, y otras veces $n - floor(n/2) - 1$. Como nos piden hacer un anális de peor caso, esto es $floor(n/2) gt.eq n - floor(n/2) - 1$, luego en el peor caso siempre caemos en la rama $floor(n/2)$, y para hacer esto lo más grande posible#footnote[Esto asume que $T$ es creciente, lo cual es cierto en este algoritmo, pero no es cierto para todas las funciones.], queremos que $floor(n/2) = n/2$, con lo cual para caer siempre en esta rama, $n$ tiene que ser una potencia de $2$. Esto nos dice que nuestro peor caso son entradas de tamaño potencia de $2$. Usando esto, podemos concluir que la recurrencia que determina el número de operaciones necesarias _en el peor caso_ es $T(n) = T(n/2) + O(1)$, pues en el peor caso, $n$ es una potencia de $2$.

    Para un tratamiento formal sobre cómo resolver recurrencias que tengan $floor(thin)$ y $ceil(thin)$, pueden ver @floorrecurrence. Noten el cuidado que hay que tener al argumentar, y cómo tuvimos que valernos de que estamos buscando el comportamiento asintótico _en el peor caso_ para definir $T$. No existe una función $T$ que nos da el número de pasos necesarios para _toda_ entrada de un dado tamaño, porque el número de tales pasos va a variar. Si queremos definir el comportamiento asintótico en el peor caso, tenemos que primero encontrar una tal familia de casos, argumentar por qué son "el peor caso", y recién ahí podemos valernos de que nuestra entrada tiene alguna forma particular (en este caso, tener longitud potencia de $2$).

    Luego, usando el teorema maestro vemos que $T in O(log n)$. La complejidad asintótica espacial es también $O(log n)$, porque usamos memoria para cada llamada recursiva, en particular para guardar $k$. Como hay a lo sumo $ceil(log_2 n)$ llamadas recursivas, y usamos $O(1)$ espacio en cada una, usamos $O(log n)$ espacio adicional a la entrada en total.
  ]]

#ej[
  Demostrar que el algoritmo "Mergesort" es correcto.
  ```python
  def merge(xs: [int], ys: [int]) -> [int]:
    i, j, n, m = 0, 0, len(xs), len(ys)
    ans = []
    while i < n or j < m:
      if i < n and (j >= m or xs[i] <= ys[j]):
        ans.append(xs[i])
        i += 1
      else:
        ans.append(ys[j])
        j += 1
    return ans

  def mergesort(xs: [int]) -> [int]:
    n = len(xs)
    if n <= 1: return xs
    lefts = mergesort(xs[:n//2])
    rights = mergesort(xs[n//2:])
    return merge(lefts, rights)
  ```
]
#sol[
  Este algoritmo consiste de dos sub-algoritmos, `merge` y `mergesort`. Vamos a especificar cada uno, y demostrar que cumplen la especificación.

  + `merge` recibe dos listas de enteros, `xs` e `ys`, ambas ordenadas de forma no-decreciente. Devuelve una lista de enteros `ans`, donde `ans` contiene los mismos elementos que `xs + ys`, y `ans` está ordenada de forma no-decreciente.
  + `mergesort` recibe una lista de enteros `xs`, y devuelve una lista de enteros `zs`, donde `zs` contiene los mismos elementos que `xs`, y `zs` está ordenada de forma no-decreciente.

  #lemma[
    `merge` es correcto.
  ]
  #demo[
    Ya vieron cómo demostrar usando el teorema del invariante. También vieron que los algoritmos con estados son, en general, más difíciles de analizar que los que no mutan estado. En esta demostración quiero mostrarles cómo usar las herramientas que tienen para algoritmos recursivos, para algoritmos con estado.

    Todo ciclo se puede transformar a un algoritmo con el mismo comportamiento, pero que usa recursión.

    #algorithm({
      import algorithmic: *
      Assign[Estado][EstadoInicial]
      While(CallInline([Condición], [Estado]), {
        Assign[Estado][Modificar(Estado)]
      })
      Return(CallInline([Postprocesamiento], [Estado]))
    })

    Esto es equivalente al siguiente algoritmo recursivo:

    #algorithm({
      import algorithmic: *
      Procedure(
        [Rec],
        [Estado],
        {
          If(CallInline([$not$Condición], [Estado]), Return(CallInline[Postprocesamiento][Estado]))
          Return(CallInline([Rec], CallInline[Modificar][Estado]))
        },
      )
      Call[Rec][EstadoInicial]
    })

    Estos algoritmos tienen la misma semántica, y costo computacional#footnote[Para justificar que tienen el mismo costo computacional, hay que definir un modelo computacional. Por ejemplo, hay que definir si una llamada recursiva de este estilo usa espacio para el "stack". Es razonable asumir que las funciones de esta forma no requieren más espacio en memoria que el código iterativo. Alumnos interesados pueden leer sobre el concepto de "tail-call recursion" para entender por qué es razonable asumir esto. También los invito a leer cómo su lenguaje favorito implementa esta optimización.]. Para la función `merge`, la versión iterativa queda así:

    ```python
    def merge(xs: [int], ys: [int]) -> [int]:
      n, m = len(xs), len(ys)
      def g(i, j, ans):
        if not (i < n or j < m): return ans
        if i < n and (j >= m or xs[i] <= ys[j]):
          return g(i + 1, j, ans + [xs[i]])
        return g(i, j + 1, ans + [ys[j]])
      return g(0, 0, [])
    ```

    La semántica que le vamos a dar a $g$ es:
    $
      & g: [0, dots, n] times [0, dots, m] times #smallcaps("List[int]") arrow #smallcaps("List[int]") \
      & g(i, j, a) = a + t", donde "t" está ordenada de forma no-decreciente," \
      & "y tiene exactamente los elementos de "x[i, dots, n - 1] + y[j, dots, m - 1]
    $

    Queremos ver en qué vamos a hacer inducción para probar que $g$ es correcta. Vemos que en cada llamada recursiva, aumenta $i$ o aumenta $j$, y el otro queda igual. Entonces, lo que decrece es $n - i$, o $m - j$. Si decrece al menos uno, y el otro queda igual, dos opciones para algo en lo que hacer inducción son la suma, $n - i + m - j$, y el producto, $(n - i) (m - j)$. Si elegimos la suma, entonces vamos a tener problemas para probar el caso base, porque $n - i + m - j$ no nos dice que $i = n, m = j$, que es lo usa $g$ para no-hacer recursión. Luego miremos el producto, $(n - i)(m - j)$, que sí nos deja concluir eso. El problema acá va a ser que cuando $i = n$ o $j = m$, las llamadas recursivas no bajan el valor de este producto (sigue siendo cero). Luego queremos modificar esto a $(n - i + 1)(m - j + 1)$, que no tiene ese problema. Entonces definimos la proposición

    #defi[
      $P(k): g(i, j, a)$ es correcta para todo $i, j in NN, 0 lt.eq i lt.eq n, 0 lt.eq j lt.eq m$ tal que $(n - i + 1)(m - j + 1) = k$.
    ]

    Vamos a definir por comodidad la notación $a lt.tilde b$ como que $a lt.eq t" "forall" "t in b$. Por ejemplo, $5 lt.tilde [6, 5, 9]$, pero $5 lt.tilde.not [8, 3, 10]$.

    Para ver que `merge` es correcta, tenemos que probar que vale $g(0, 0, [])$ es correcta. Si probamos que $P((n+1) (m+1))$, entonces como $(n - 0 + 1)(m - 0 + 1) = (n + 1)(m + 1)$, vemos que $g(0, 0, [])$ es correcta, y luego que `merge` devuelve una lista que contiene los mismos elementos que `xs[0 : n] + ys[0 : m] = xs + ys`, pero ordenada de forma no-decreciente, que es precisamente la semántica que queríamos darle a `merge`.

    #set enum(numbering: "1.a.i.")
    + Caso base, $P(1)$. Tenemos que probar que para todo $i, j in NN, 0 lt.eq i lt.eq n, 0 lt.eq j lt.eq m$ tal que $(n - i + 1)(m - j + 1) = 1$, $g$ es correcta. Como $i lt.eq n$ y $j lt.eq m$, entonces ambos factores de este producto son números naturales. Si tenemos un producto de naturales que es $1$, entonces ambos naturales son $1$. Luego, $n - i + 1 = 1$, y $m - j + 1 = 1$. Esto nos dice que $i = n$, y $j = m$. En este caso, tenemos que `not (i < n or j < m)`, y entonces $g(n, m, a)$ devuelve $a$. Ahora bién, $a$ es lo mismo que $a + []$ y $[]$ es precisamente la unión de todos los elementos de $x[i, dots, n - 1] + y[j, dots, m - 1] = x[n, dots, n - 1] + y[m, dots m - 1] = [] + [] = []$. Luego, $g$ es correcta para este caso.
    + Paso inductivo. Sabemos que vale $P(r)$ para todo $r < k$, queremos ver que vale $P(k)$. Sean entonces $i, j in NN, 0 lt.eq i lt.eq n, 0 lt.eq j lt.eq m$, tal que $(n - i + 1)(m - j + 1) = k$. Partimos en casos, si $i = n$, si $j = m$, o si ninguna es cierta.
      + Si $i = n$ y $j eq.not m$, entonces $k = m - j + 1$. Como $j lt.eq m$, entonces $j < m$, no salimos en la primer condición (`return ans`). Como $i < n$ es falso, $g(i, j, a)$ evalúa a $g(i, j + 1, a + [y[j]])$. Como $m - (j + 1) + 1 < m - j + 1 = k$, podemos usar la hipótesis inductiva $P(m - (j + 1) + 1)$, para concluir que si llamamos $X = g(i, j + 1, a + [y[j]]) = a + [y[j]] + b$, entonces $b$ es una lista que contiene los elementos de $x[i, dots, n - 1] + y[j + 1, dots, m - 1]$, ordenados de forma no-decreciented. Como $i = n$, entonces $x[i, dots, n - 1] + y[j+1, dots, m - 1] = y[j+1, dots, m - 1]$. Como $y$ está ordenada de forma no-decreciente, entonces $y[j] lt.tilde b$. Luego $t = [y[j]] + b$ está ordenada de forma no-decreciente, y tiene los mismos elementos que $y[j, dots, m - 1] = x[i, dots, n - 1] + y[j, dots, m - 1]$. Luego, $X = a + t$, con $t$ teniendo los mismos elementos que $x[i, dots, n - 1] + y[j, dots, m - 1]$, ordenados de forma no-decreciente, que es lo que queríamos demostrar para $P(k)$.
      + Pasa algo análogo si $j = m$ y $i < n$.
      + Si $i < n$ y $j < m$, entonces partimos en dos casos, dependiendo de si $x[i] lt.eq y[j]$ o no.
        + Si $x[i] lt.eq y[j]$, $g$ devuelve $g(i + 1, j, a + [x[i]])$. Como $n - (i + 1) + 1 < n - i + 1$, entonces $(n - (i + 1) + 1)(m - j + 1) < (n - i + 1)(m - j + 1) = k$, y podemos usar la hipótesis inductiva $P((n - (i + 1) + 1)(m - j + 1))$ para ver que $g(i + 1, j, a + [x[i]]) = a + [x[i]] + b$, con $b$ una permutación no-decreciente de $x[i + 1, dots, n - 1] + y[j, dots, m - 1]$. Como $x$ e $y$ son no-decrecientes, $x[i] lt.tilde x[i + 1, dots, n - 1]$, y $x[i] lt.eq y[j] lt.tilde y[j, dots, m - 1]$. Luego, $x[i] lt.tilde b$, y luego llamando $t = [x[i]] + b$, vemos que $g(i, j, a)$ está devolviendo $a + t$, con $t$ una lista no-decreciente, que contiene los mismos elementos que $x[i, dots, n - 1] + y[j, dots m - 1]$. Esto es precisamente lo que hay que probar para $P(k)$.
        + Si $x[i] > y[j]$, pasa algo análogo con $g(i, j + 1, a + [y[j]])$.

    Luego, demostramos $P(k)$ para todo $k gt.eq 1$.
  ]

  Habiendo probado que `merge` es correcta para toda entrada, probamos ahora fácilmente que `mergesort` es correcta.

  #lemma[
    `mergesort` es correcta.
  ]
  #demo[
    Al ser `mergesort` una función recursiva, la primer herramienta que vamos a intentar es usar inducción.

    Veamos primero, ¿qué es lo que decrece en cada llamada recursiva? Nos dan una lista, $x$, y la dividimos en dos partes, aproximadamente de la mitad del tamaño cada vez (lo de aproximado es porque no todas las entradas tienen un número par de elementos). Luego, lo que está decreciendo cada vez es el tamaño de la lista que nos pasan.

    #defi[
      $P(k)$: merge$(x)$ tiene los mismos elementos que $x$, pero ordenados de forma no-decreciente, para toda lista $x$ con a lo sumo $k$ elementos.
    ]

    + Caso base, $P(0)$. Si $x$ tiene $0$ elementos, entonces $x = []$, y merge$([]) = []$ por su primer `if`, que es la respuesta correcta. Luego vale $P(0)$.
    + Caso base, $P(1)$. Si $x$ tiene $1$ elemento, entonces $x = [alpha]$ para algún $alpha$, y merge$([alpha]) = [alpha]$ por su primer `if`, que es la respuesta correcta. Luego vale $P(1)$.
    + Paso inductivo. Sea $k in NN, k > 1$. Asumo que vale $P(r)$ para todo $r < k$, quiero ver que vale $P(k)$. Sea $a = floor(k / 2)$. Como $k > 1$, entonces $a > 0$. Sea $b = k - a$. Luego $a < k$, y $b < k$. Luego podemos usar las hipótesis inductivas $P(a)$ y $P(b)$, para ver que `lefts` tiene los mismos elementos que $x[0, dots, a - 1]$, y `rights` tiene los mismos elementos que $x[a, dots, n - 1]$. Luego, su concatenación `lefts + rights` tiene los mismos elementos que $x$. Vemos entonces que llamando a `merge(lefts, rights)`, tendremos una lista ordenada de forma no-decreciente, que tiene los mismos elementos que `lefts + rights`, que a su vez son los mismos elementos que $x$. Esto es precisamente la semántica que queríamos para `mergesort`, y luego vale $P(k)$.
  ]
]


#ej[
  Se tienen $n$ objetos de pesos $p_1, dots, p_n$ no-negativos, y valores $v_1, dots, v_n$ no-negativos, y una mochila en la que caben varios objetos, pero aguanta como máximo un peso $P$.

  + Diseñar un algoritmo basado en programación dinámica que encuentre el máximo valor alcanzable poniendo objetos en la mochila.
  + Demostrar que el algoritmo es correcto.
  + Demostrar su complejidad temporal y espacial, en el peor caso. El mejor algoritmo que conocemos tiene complejidad espacial $O(P)$ y complejidad temporal $O(n p)$.
]

Primero una explicación de cómo podemos pensar esto, y luego una solución como la que se espera que escriban en un parcial.
#quote-box[
  En principio, el espacio de búsqueda que tenemos es el conjunto de subconjuntos de los $n$ objetos. Por ejemplo, si $n = 3$, y los objetos son $X = {a, b, c}$, el espacio de búsqueda que tenemos es $cal(P)(X) = {{}, {a}, {b}, {b}, {a, b}, {a, c}, {b, c}, {a, b, c}}$. Una estrategia simple que usa esta estructura sería _backtracking_.

  Si queremos ver si un problema puede ser resuelto con programación dinámica, tenemos que ver si podemos parametrizar al conjunto de subproblemas de tal manera que tengan un orden, y se cumplan las dos propiedades clásicas de subestructura óptima y subproblemas compartidos.

  En este caso, podemos definir los subproblemas como pares $G = {(i, x) | 0 lt.eq i lt.eq n, 0 lt.eq x lt.eq P}$, donde un subproblema $(i, x)$ significa "El mayor valor que podemos obtener usando peso a lo sumo $x$, y usando sólo los primeros $i$ objetos." Llamemos $v^*: G arrow RR$ la función que nos da tal valor. Vemos entonces que la respuesta al problema entero es la respuesta al subproblema $(n, P)$. Más aún, vemos que se cumplen las dos condiciones:
  + $v^*(i, x)$ es o bien $v^*(i - 1, x)$, si una solución al subproblema $(i, x)$ no usa el $i$-ésimo objeto, o $v^*(i - 1, x - p_i) + v_i$, si una solución al subproblema $(i, x)$ usa el $i$-ésimo objeto. En el primer caso, tenemos el mismo peso disponible ($x$) para usarlo de la mejor forma posible usando sólo los primeros $i - 1$ objetos, y nuestro valor es el valor que nos den los objetos que elegimos de esos primeros $i - 1$. En el segundo caso, si usamos el $i$-ésimo objeto, tenemos $x - p_i$ peso restante para los otros objetos que vamos a elegir dentro de los primeros $i - 1$, y el valor de esta solución es el valor de la solución a $(i - 1, x - p_i)$, más el valor que obtenemos por haber tomado el $i$-ésimo objeto, $v_i$.
  + La función $v^*$ tiene dominio $[0 dots n] times [0 dots P]$, luego hay sólo $n P$ valores posibles. Sin embargo, en una implementación recursiva tradicional, en el peor caso vamos a tener un número exponencial de llamadas. Esto es fácil de ver si tomamos como familia de casos donde $p_i = 0 forall i$, vemos que $v^*(i, x) = max(v^*(i - 1, x), v^*(i - 1, x) + v_i)$, y luego una implementación recursiva tradicional tendría $T(i) = 2T(i - 1)$ llamadas, lo cual termina siendo $2^n$ llamadas.

  Como tenemos ambos subestructura óptima, y subproblemas compartidos, podemos usar programación dinámica y esperar mejoras en el tiempo de cómputo.

  Más aún, vemos que $v^*(i, x)$ sólo depende de cosas en $v^*(i - 1, dots)$, luego si usamos programación dinámica bottom-up, sólo necesitamos quedarnos con dos "filas" de la matriz de programación dinámica, porque al llenar una fila, sólo necesitamos ver la fila inmediatamente anterior, para responder el problema sólo necesitamos una entrada en la última fila.
]
#sol[
  Primero planteamos la función recursiva, junto con su semántica.
  $
          f: & [0 dots n] times [0 .. P] \
    f(i, x): & "El máximo valor que puedo obtener usando los primeros" i "objetos" \
             & " y un peso de a lo sumo "x"." \
  $

  La respuesta al enunciado es $f(n, P)$. Las ecuaciones recursivas para $f$ son:

  $
    f(i, x) = cases(
      0 ", si" i = 0,
      f(i - 1, x) ", si" p_i > x,
      max(f(i - 1, x), f(i - 1, x - p_i) + v_i) ", si no"
    )
  $
  #demo[
    Vamos a probar que $f$ es correcta usando inducción. Para poder razonar formalmente, vamos a definir algunos conceptos.
    - Definimos $v(S) = sum_(j in S) v_j$, la suma de los valores de los elementos de un subconjunto $S subset.eq {1, dots, n}$. Asimismo $p(S) = sum_(j in S) p_j$, la suma de los pesos de los elementos de $S$.
    - Definimos $F(i, x) = {S subset.eq {1, dots, i} | p(S) lt.eq x}$. Estos son los conjuntos de objetos, de entre los primeros $i$, que podemos meter en la mochila, con suma de peso a lo sumo $x$. Algunos elementos de $F(i, x)$ van a tener valor más alto que otros. Vemos que $F(i, x) subset.eq F(i + 1, x)$ para todo $1 lt.eq i < n$.
    - Definimos $v^*(i, x) = max_(S in F(i, x)) { v(S) }$, el máximo valor que podemos obtener, usando los primeros $i$ objetos, con peso total a lo sumo $x$.

    Sea $P(i): i lt.eq n implies f(i, x) = v^*(i, x)$. Vamos a probar $P(i) forall i in NN$ por inducción.

    + Caso base, $P(0)$. Tenemos que probar que $f(0, x) = v^*(0, x)$. Por definición, $v^*(0, x) = max_(S in F(0, x)) { v(S) }$, pero $F(0, x) = {S subset.eq {1, dots, 0} | p(S) lt.eq x} = {emptyset}$, pues el único subconjunto de los primeros $0$ objetos es $emptyset$. Luego, $v^*(0, x) = v(emptyset) = sum_(j in emptyset) v_j = 0$. Nuestra función $f$ efectivamente devuelve $0$, en su primer rama, donde $i = 0$. Luego $f(0, x) = 0 = v^*(0, x)$, lo cual demuestra $P(0)$.
    + Paso inductivo. Sabemos que vale $P(t)$, queremos ver que vale $P(t + 1)$. Es decir, queremos probar que $v^*(t + 1, x) = f(t + 1, x)$. Llamemos $i = t + 1$. Si $i > n$, no hay nada que probar, pues "falso implica todo", y estamos probando una implicación ($P(i)$) con antecedente falso. Luego, asumimos que $i lt.eq n$.

      Por definición, $v^*(i, x) = max_(S in F(i, x)) { v(S) }$.
      + Si $p_i > x$, sea $S in F(i, x)$. Como $S in F(i, x)$, sabemos que $p(S) lt.eq x$. Si $i$ estuviera en $S$, tendríamos que $p(S) = sum_(j in S) p_j gt.eq p_i > x$, lo cual no sucede. Luego $i in.not S$. Como esto sucede para cualquier $S in F(i, x)$, ningún $S in F(i, x)$ contiene a $i$, y entonces $S subset.eq {1, dots, i} without {i} = {1, dots, i - 1}$. Luego, $F(i, x) subset.eq F(i - 1, x)$, y como sabíamos que $F(i - 1, x) subset.eq F(i, x)$, tenemos que $F(i, x) = F(i - 1, x)$. Luego, $v^*(i, x) = max_(S in F(i, x)) {v(S)} = max_(S in F(i - 1, x)) { v(S) } = v^*(i - 1, x)$. Como sabemos $P(t)$, es decir $P(i - 1)$, sabemos que $f(i - 1, x) = v^*(i - 1, x)$. Como $f(i, x)$ devuelve $f(i - 1, x) = v^*(i - 1, x)$ cuando $p_i > x$, y en ese caso $v^*(i - 1, x) = v^*(i, x)$, tenemos $f(i, x) = v^*(i, x)$, es decir $P(i)$.
      + Si $p_i lt.eq w$, podemos particionar $F(i, x)$ en dos subconjuntos, $A$ y $B$, con $A = {S in F(i, x) | i in.not S}$, y $B = {S in F(i, x) | i in S}$. Como $A$ y $B$ particionan $F(i, x)$, entonces $max_(F(i, x)) {v(S)} = max(max_(S in A) {v(S)}, max_(S in B) {v(S)})$.

        - Tomemos un $S in A$. Vemos que $A = {S in F(i, x) | i in.not S} = {S subset.eq {1, dots, i} | p(S) lt.eq x and i in.not S} = {S subset.eq {1, dots, i - 1} | p(S) lt.eq w} = F(i - 1, x)$. Luego, $max_(S in A) {v(S)} = max_(S in F(i - 1, x)) {v(S)} = v^*(i - 1, x)$.
        - Tomemos ahora un $S in B$. Como $S in B$, entonces $i in S$. Llamemos $S = S' union {i}$, con $S' subset.eq {1, dots, i - 1}$. Luego, $p(S) = p_i + p(S')$. Como $S in B subset.eq F(i, x)$, $p(S) lt.eq x$, y luego $p_i + p(S') lt.eq x$. Por ende, $p(S') lt.eq x - p_i$. Luego, $S' in F(i - 1, x - p_i)$. Luego, cada $S in B$ se corresponde con un único $S' in F(i - 1, x - p_i)$, y la biyección es simplemente $phi(X) = X union {i}$. Para transformar los valores luego de esta biyección, vemos que $v(S) = v_i + v(S')$. Luego, $max_(S in B) {v(S)} = max_(S' in F(i - 1, x - p_i)) { v(S') + v_i } = max_(S' in F(i - 1, x - p_i)) { v(S') } + v_i = v^*(i - 1, x - p_i) + v_i$.

        Juntando ambas ramas, vemos que $v^*(i, x) = max_(F(i, x)) {v(S)} = max(v^*(i - 1, x), v^*(i - 1, x - p_i) + v_i)$. Por $P(t)$, que es $P(i - 1)$, sabemos que $f(i - 1, x) = v^*(i - 1, x)$, y $f(i - 1, x - p_i) = v^*(i - 1, x - p_i)$. Por lo tanto, como nuestra función devuelve $max(f(i - 1, x), f(i - 1, x - p_i))$, está devolviendo $v^*(i, x)$, que prueba $P(i)$.

    Esto prueba $P(i)$ para todo $i in NN$. En particular, para todo $i in NN, 0 lt.eq i lt.eq n$, y para todo $x in NN, 0 lt.eq x lt.eq P$, tenemos que $f(i, x) = v^*(i, x)$, y luego $f(n, P) = v^*(n, P)$, que muestra que nuestro algoritmo es correcto.
  ]

  Veamos el código ahora en Python:

  ```py
  def f(i, x):
    if i == 0: return 0
    if p[i] > x: return f(i - 1, x)
    return max(f(i - 1, x), f(i - 1, x - p[i]) + v[i])
  ```

  Si queremos hacer esto un algoritmo de programación dinámica top-down, lo único que hay que hacer es mecánicamente agregar un cache.

  ```py
  def f(i, x, cache = {}):
    if (i, x) not in cache:
      if i == 0: r = 0
      elif p[i] > x: r = f(i - 1, x, cache)
      else: r = max(f(i - 1, x, cache), f(i - 1, x - p[i], cache) + v[i])
      cache[(i, x)] = r
    return cache[(i, x)]
  ```

  El número asintótico de operaciones en este algoritmo es más difícil de analizar, porque está mutando el estado (`cache`) a medida que hacemos llamadas recursivas. También va a depender del costo que tenga insertar y buscar en la estructura que usamos para el cache.

  Para hacer este algoritmo bottom-up, tenemos que pensar en qué orden se llena la tabla, y llenarla nosotros mismos. Vemos que necesitamos leer un valor de $f(i, x)$ sólo cuando estamos escribiendo el valor de $f(i + 1, x')$ para algún $x'$. Luego, si llenamos la tabla en orden creciente de $i$, cada vez que querramos leer un valor, ya lo vamos a tener en la tabla.

  ```py
  def f(n, P):
    dp = [[0 for _ in range(P + 1)] for _ in range(n + 1)]
    for i in range(1, n + 1):
      for x in range(P + 1):
        if x < p[i]:
          dp[i][x] = dp[i - 1][x]
        else:
          dp[i][x] = max(dp[i - 1][x], dp[i - 1][x - p[i]] + v[i])
    return dp[n][P]
  ```

  El comportamiento asintótico de este algoritmo es mucho más fácil de analizar, el número de operaciones está en $Theta(n P)$ en todos los casos, y el costo espacial es también $Theta(n P)$, pues la tabla `dp` tiene $n times P$ entradas.

  Por último, vemos que no hace falta mantener en memoria toda la tabla, si sólo queremos devolver `dp[n][P]`. Para llenar una fila, `dp[i]`, sólo hace falta la fila anterior, `dp[i - 1]`. Luego podemos mantener sólo dos filas a la vez, `dp1` y `dp2`, donde `dp2 = dp[i]`, y `dp1 = dp[i - 1]`:

  ```py
  def f(n, P):
    dp1 = [0 for _ in range(P + 1)]
    dp2 = [0 for _ in range(P + 1)]
    for i in range(1, n + 1):
      for x in range(P + 1):
        if x < p[i]:
          dp2[x] = dp1[x]
        else:
          dp2[x] = max(dp1[x], dp1[x - p[i]] + v[i])
      dp1, dp2 = dp2, dp1
    return dp1[P]
  ```

  El costo temporal es idéntico, pero bajamos el costo espacial a sólo $Theta(P)$ en todos los casos.]

#ej[
  Sea $X = [x_1, x_2, dots, x_n]$ una secuencia de $n$ booleanos ($1$ o $0$) y sea $k in NN$ un número entre $1$ y $n$. Supongamos que se pueden eliminar $k$ ceros, queremos saber la longitud máximo que puede tener una cadena de $1$s. Por ejemplo si $k = 2$ y $X = 11001010001$ la respuesta es $3$, mientras que si $k = 3$ la respuespuesta es $4$.
  + Diseñar un algoritmo basado en programación dinámica que indique la longitud más larga de una subsecuencia de unos sacando a lo sumo $k$ ceros de $S$. Debe tener complejidad a lo sumo $O(n k)$.
  + Demostrar que el algoritmo es correcto.
  + Demostrar su complejidad temporal y espacial en el peor caso.
]
Primero les voy a mostrar en qué pienso al resolver el ejercicio, y luego una resolución.
#quote-box[
  Hay una estructura de orden ahí, porque si hablo de "puedo eliminar $k$ ceros", al eliminar un cero, caigo a un estado en el que "puedo eliminar $k - 1$ ceros". Ese probablemente va a ser uno de los parámetros de mi función.

  Si veo un 1, puedo armar una cadena de unos que termina en ese 1. Pero al hacer una llamada recursiva, no puedo preguntar algo como "la secuencia de 1s más larga borrando $k$ ceros que termina antes de esta posición", porque esa cadena puede terminar mucho más atrás que la posición que estoy viendo, y entonces no podría tomar ese número y sumarle uno, extendiéndo esa solución con el 1 que estoy mirando. Luego, tengo que restringir que la cadena de 1s termine exactamente donde estoy parado. Luego haré un pasada por la lista, diciendo que la cadena más larga de 1s borrando $k$ ceros, es la cadena más larga de 1s borrando $k$ ceros que termina exactamente en $i = 0$, o la que termina exactamente en $i = 1$, etc.

  Veamos si puedo plantear esto.
  - Si veo un 1 en $x_i$, entonces puedo tomar $f(i - 1, k) + 1$ como la respuesta para esta posición.
  - Si veo un 0 en $x_i$, entonces puedo tomar $f(i - 1, k - 1) + 1$ si $k > 0$, o $0$ si no. También puedo tomar una cadena de longitud $0$ que terminar en este $0$, si no quiero tomar la solución recursiva (que puede no existir, si por ejemplo estoy en un prefijo de más de $k$ ceros).

  $
    f(i, k) = cases(
      -infinity "si" k < 0,
      0 "si" i < 0,
      f(i - 1, k) "si" x_i = 1,
      max(0, f(i - 1, k - 1)) "si" x_i = 0 and k > 0,
      0 "si no"
    )
  $

  algo como:

  ```py
  def F(x, k):
    def f(i, kk):
      if k < 0: return -99999
      if i < 0: return 0
      if x[i] == 1: return f(i - 1, kk) + 1
      if x[i] == 0 and kk > 0: return f(i - 1, kk - 1)
      return 0
    return max(f(i, k) for i in range(len(x)))
  ```

  Probablemente ni necesito lo de $-infinity$. OK, a escribir.]
#sol[
  Definimos primero una función y su semántica.
  $
         f: & [-1, dots, n] times [0, dots, k] \
    f(i, r) & = cases(
                f(i - 1, r) + 1 & "si" i gt.eq 0 and x_i = 1,
                f(i - 1, r - 1) & "si" i gt.eq 0 and x_i = 0 and r > 0,
                0 & "si no"
              )
  $

  La semántica de $f(i, r)$ es "La longitud de la cadena de unos más larga que termina en la posición $i$, borrando a lo sumo $r$ ceros."

  El algoritmo devuelve
  $
    max_(0 lt.eq i lt.eq n) f(i, k)
  $

  #demo[
    Está claro que toda cadena de unos borrando a lo sumo $k$ ceros termina en alguna posición. Luego, si probamos que $f$ es correcta (es decir, que cumple su semántica), estamos probando que nuestro algoritmo es correcto, pues estamos tomando el máximo sobre todas las posibles posiciones donde terminaría tal secuencia.

    Vamos a probar que $f$ es correcta usando inducción. Definimos $v^*(i, t)$ como la longitud de cadena de unos más larga, borrando a lo sumo $t$ ceros, que termina exactamente en $i$, 0 cero si no existen tales cadenas. Definimos $P(i): i lt.eq n implies (f(i, t) = v^*(i, t) forall t in NN)$. Por comodidad, vamos a definir $theta(i, t)$ como el conjunto de cadenas de unos que termina en la posición $i$, y borra a lo sumo $t$ ceros, y $theta^*(i, t)$ como el subconjunto de $theta(i, t)$ que tiene número máximo de unos, para cada $i, t$.

    #set enum(numbering: "1.a)i)")
    + Caso base, $P(0)$. La longitud de una cadena de unos más larga que termina en la $(i = 0)$-ésima posición es o bien 1 o 0, dependiendo de si $x_0 = 1$ o $x_0 = 0$. Luego, si $v^*(0, t) = x_0$. Si $x_0 = 1$, nuestra función $f(0, t)$ devuelve $f(-1, t) + 1$, que evalúa a $1$ inmediatamente. Si $x_0 = 0 and t > 0$, $f(i, t)$ devuelve $f(-1, t - 1)$, que evalúa a $0$ inmediatamente. Finalmente, si $x_0 and t = 0$, entonces $f(0, 0) = 0$. Luego en todos los casos tenemos $f(0, t) = v^(0, t)$, lo que prueba $P(0)$.

    + Paso inductivo. Sabemos $P(i)$, queremos probar $P(i + 1)$. Sea $t in NN$. Sea $T in theta^*(i + 1, t)$, y por ende $|T| = v^*(i + 1, t)$. Partimos en casos, dependiendo de quién es $x_i$:
      + Si $x_(i+1) = 1$. Como $T$ termina en $i + 1$, $i + 1 in T$, puesto que sólo podemos borrar ceros. Sea $T' = T without {i + 1}$. Como $T'$ borra a lo sumo $t$ ceros, y termina en $i$, está en $theta(i, t)$. Si no estuviera en $theta^*(i, t)$, podríamos tomar cualquier $S in theta^*(i, t)$, y por lo tanto $|S| > |T'|$, con lo cual $|S + {i + 1}| > |T|$, pero esto no puede pasar, porque $T$ está en $theta^*(i + 1, t)$, luego tiene el número máximo de unos. Luego, $T' in theta^*(i, t)$, y luego $|T'| = v^*(i, t)$. Como sabemos $P(i)$, esto es $|T'| = f(i, t)$, y por ende, $|T| = f(i, t) + 1$, que es precisamente lo que devuelve $f(i + 1, t)$, y por ende vale $P(i + 1)$.
      + Si $x_(i+1) = 0 and t > 0$. Entonces $i+1 in.not T$. Entonces, como $t > 0$, y $T$ termina en $i + 1$, vemos que $T in theta(i, t - 1)$, y luego $v^*(i + 1, t) = |T| lt.eq v^*(i, t-1)$. Tomemos ahora cualquier $S in theta^*(i, t-1)$. Podemos expandir $S$ a terminar en $i + 1$, borrando el elemento $i + 1$, con lo cual $S$ también está en $theta(i+1, t)$. Luego $v^*(i, t - 1) = |S| lt.eq v^*(i+1, t)$. Luego $v^*(i, t - 1) = v^*(i + 1, t)$. Por $P(i)$, $f(i, t - 1) = v^*(i, t - 1)$, y entonces como $f(i + 1, t)$ devuelve $f(i, t - 1)$, devuelve $v^*(i, t - 1) = v^*(i + 1, t)$, que muestra $P(i + 1)$.
      + Si $x_(i+1) = 0 and t = 0$, entonces $T$ es una secuencia de unos que termina en un $i + 1$, pero no puede borrar ningún cero pues $t = 0$. Luego $T$ no existe, y por definición, $v^*(i+1, 0) = 0$ en este caso, que es precisamente lo que devuelve nuestra función.

    Luego tenemos $P(i) forall i in NN$.]

  El código en Python para la función recursiva es:

  ```py
  def F(x, k):
    def f(i, t):
      if i < 0: return 0
      if x[i] == 1: return f(i - 1, t) + 1
      if x[i] == 0 and t > 0: return f(i - 1, t - 1)
      return 0
    return max(f(i, k) for i in range(len(x)))
  ```

  La manera que formulamos el problema como un conjunto de subproblemas y un orden entre ellos cumple dos propiedades:
  + Subestructura óptima. Para resolver un problema $(i, t)$, necesitamos resolver algún número de subproblemas más pequeños ($(i - 1, t)$ o $(i - 1, t - 1)$). Esto es esencialmente lo que nos deja usar recursión.
  + Subproblemas compartidos. Podemos ver que el peor caso sucede cuando $k$ es muy grande o $x$ está lleno de unos (y nunca nos quedamos "sin presupuesto" de ceros para borrar). En esos casos, llamar a $f(i, t)$ resulta en $i$ llamadas recursivas. Como luego tomamos un $max$ para cada $i$ entre $1$ y $n$, vamos a computar $n(n-1)/2$ problemas en el peor caso, muchos de los cuales son idénticos.

  Como siempre, para hacer esto un algoritmo de programación dinámica top-down, mecánicamente agregamos un cache:

  ```python
  def F(x, k):
    def f(i, t, cache = {}):
      if (i, t) not in cache:
        if i < 0: r = 0
        elif x[i] == 1: r = f(i - 1, t, cache) + 1
        elif x[i] == 0 and t > 0: r = f(i - 1, t - 1, cache)
        else: r = 0
        cache[(i, t)] = r
      return cache[(i, t)]
    return max(f(i, k) for i in range(len(x)))
  ```

  Esto evita computar subproblemas dos veces, pero hace difícil el análisis de complejidad temporal, dado que estamos mutando estado (`cache`), y el tiempo que va a tomar una llamada va a depender del estado cuando es llamada. Asimismo, agregamos ahora el costo adicional de leer y escribir la estructura `cache`.

  Para hacer más claro el análisi algoritmo, y bajar su complejidad en la práctica cuando vamos a llenar `cache` enteramente de todos modos, podemos usar programación dinámica bottom-up. Esto implica ver en qué orden se llena `cache` en la versión top-down, y llenarlo nosotros mismos en ese orden. En este caso, vemos que llenamos una entrada `cache[(i, t)]` sólo luego de llamar a `f(i - 1, ...)`, que va a escribiri `cache[(i - 1, ...)]`. Luego, si llenamos `cache` en orden creciente de `i`, vamos a estar llenando la estructura en un orden que garantiza siempre tener escritos los valores que queremos leer, al momento de querer leerlos.

  ```python
  def F(x, k):
    n = len(x)
    dp = [[0 for _ in range(k + 1)] for _ in range(n)]
    for i in range(n):
      for t in range(k + 1):
        if x[i] == 1:
          if i == 0: dp[i][t] = 1
          else: dp[i][t] = dp[i-1][t] + 1
        else:
          if t > 0:
            if i == 0: dp[i][t] = 0
            else: dp[i][t] = dp[i - 1][t - 1]
          else:
            dp[i][t] = 0
    return max(dp[i][k] for i in range(n))
  ```

  Esa es una traducción totalmente literal, donde quedaron varios condicionales porque no podemos leer `dp[-1]`. Podemos limpiar el código un poco:

  ```py
  def H(x, k):
    n = len(x)
    dp = [[0 for _ in range(k + 1)] for _ in range(n)]
    for t in range(k + 1): dp[0][t] = x[0]
    for i in range(1, n):
      for t in range(k + 1):
        if x[i] == 1: dp[i][t] = dp[i - 1][t] + 1
        elif x[i] == 0 and t > 0: dp[i][t] = dp[i - 1][t - 1]
        else: dp[i][t] = 0
    return max(dp[i][k] for i in range(n))
  ```

  Vemos que el número de operaciones que hacemos en todos los casos es $Theta(n k)$, pues eso cuesta construir el array `dp`. Los dos ciclos anidados hacen $Theta(n k)$ operaciones, y el ciclo de inicialización de `dp[0]` hace $Theta(k)$ operaciones. El ciclo final, que computa `max`, hace $Theta(n)$ operaciones.

  El costo espacial del algoritmo es, en todos los casos, $Theta(n k)$.]

#ej[
  Sea $v = (v_0, v_2, dots, v_(n-1))$ un vector de números enteros. Diseñar un algoritmo que indique la mínima cantidad de números que hay que eliminar del vector para que cada número que permanezca sea múltiplo del anterior (excepto el primero). Por ejemplo, para los vectores $(-5, 5, 0), (0, 5, -5), y (0, 5, -5, 2, 15, 15)$, los resultados deberían ser respectivamente $0$, $1$, y $2$. El algoritmo debe tener complejidad temporal $O(n^2)$ y estar basado en programación dinámica.
  + Demostrar que el algoritmo es correcto.
  + Demostrar su complejidad temporal y espacial.

]
#sol[
  Definimos una función recursiva y su semántica.
  $
        f: & [0, dots, n) arrow N] \
    f(i) = & "La longitud de la subsecuencia de "v" más larga," \
           & "donde cada elemento es múltiplo del anterior," \
           & "y que termina exactamente en "v_i"."
  $

  La respuesta que devuelve el algoritmo es
  $
    A = n - max_(0 lt.eq i < n) { f(i) }
  $

  Y ahora las ecuaciones que definen $f$.

  $
    f(i) = cases(
      1 "si" i = 0,
      1 + max_0 {f(j) | j in [0, i), v_j | v_i} "si no"
    )
  $

  donde definimos $max_0$ como $max$, excepto que en el conjunto vacío devuelve $0$. Tenemos que probar dos cosas:
  + La función $f$ cumple la semántica que le dimos.
  + Si la función $f$ cumple la semántica que le dimos, entonces $A$ es la respuesta correcta al enunciado.

  Probemos ambas, entonces.

  #demo[
    + Vamos a probar que $f$ cumple la semántica que le dimos por (repitan conmigo) inducción. Definimos entonces $S(i)$ como el conjunto de subsucesiones de $v$ que terminan en $v_i$ y cada elemento es múltiplo del anterior, y definimos $g(i) = max {|s| | s in S(i)}$. Queremos probar la proposición $P(i): i < n implies f(i) = g(i)$, para todo $i in NN$.

      + Caso base, $P(0)$. Queremos ver que $f(0) = g(0)$. Por definición, $f(0) = 1$. $g(0)$ es la longitud de la subsecuencia de $v$ más larga, donde cada elemento es múltiplo del anterior, y que termina en exactamente en $v_0$. Pero $v_0$ es el primer elemento, luego hay una sola tal subsucesión, y es $[v_0]$, que tiene longitud $1$. Por lo tanto, $g(0) = 1$, y tenemos $f(0) = g(0)$, probando $P(0)$.
      + Paso inductivo. Sabemos $P(j)$ para todo $j < i$, queremos ver $P(i)$. Si $i gt.eq n$, entonces vale $P(i)$ trivialmente, pues $P(i)$ es una implicación con antecedente $i < n$, y falso implica todo. Luego, sabemos que $i < n$, y tiene sentido hablar de $v_k$, con $0 lt.eq k lt.eq i$. Sea $s in S(i)$. Como $s in S(i)$, sabemos que $s$ termina con $v_i$. Sea $s'$ el prefijo de $s$, es decir, $s = s' + [v_i]$, y por ende $|s| = |s'| + 1$. Entonces $s'$ es una subsucesión de $v$, donde cada elemento es múltiplo del anterior. No sabemos si $s' = []$, pero si no lo es, termina en algún $v_j$, con $j < i$, $v_j | v_i$. Luego, si $s' eq.not []$, entonces $s'$ pertenece a la unión disjunta de $S(j)$, para algún $0 lt.eq j < i$. Si $s' = []$, entonces $|s| = |s'| + 1 = 0 + 1 = 1$. Ahora razonamos:

        $
          g(i) =& max {|s| | s in S(i)}\
          =& max {{1 + |s'| | s' in S(j), 0 lt.eq j < i, v_j | v_i} union {1 + |s'| | s' in {[]}}}\
          =& 1 + max {{|s'| | s' in S(j), 0 lt.eq j < i, v_j | v_i} union {|s'| | s' in {[]}}}\
          =& 1 + max {{|s'| | s' in S(j), 0 lt.eq j < i, v_j | v_i} union {0}}\
          =& 1 + max { {max {|s'| | s' in S(j)} | 0 lt.eq j < i, v_j | v_i} union {0} }", pues" S(j) eq.not emptyset forall j\
          =& 1 + max { {g(j) | 0 lt.eq j < i, v_j | v_i} union {0} }\
          =& 1 + max { {f(j) | 0 lt.eq j < i, v_j | v_i} union {0} }", usando" P(j)", pues" j < i\
          =& 1 + inline(max_0) { {f(j) | 0 lt.eq j < i, v_j | v_i}}\
          =& f(i)
        $

        Luego vale $P(i)$.

      + Probemos ahora que, sabiendo que $f$ tiene la semántica que dijimos, $A$ es la respuesta al enunciado. Toda forma de borrar $k$ elementos, dejando una subsecuencia de $n - k$ elementos sin borrar, tal que cada uno es múltiplo del anterior, es lo mismo que encontrar esa subsecuencia de $n - k$ elementos, y dejar sólo esos. Luego, la manera que borre _menos_ elementos (que minimice $k$), es la manera que encuentre la subsecuencia _más_ larga (maximice $n - k$).

      Luego, podemos enfocarnos en encontrar la subsecuencia más larga donde cada elemento es múltiplo del anterior. El problema nos pide devolver cuántos elementos borramos, y eso es $n - k$, con $k$ la longitud de tal secuencia.

      Toda tal subsecuencia termina en alguna posición $i$. Luego, si tomamos $display(k = max_(0 lt.eq i < n) f(i))$, sabiendo la semántica de $f$, habremos encontrado esa secuencia. Finalmente, al devolver $A = n - k$, estamos correctamente respondiendo el enunciado.
  ]
  El código, en Python:

  ```python
  def F(v):
    n = len(v)
    def f(i):
      return 1 + max((f(j) for j in range(i)
                           if v[j] != 0 and v[i] % v[j] == 0),
                     default=0)
    return n - max(f(i) for i in range(n))
  ```

  Este algoritmo va a computar muchas veces cada valor de $f$. En el peor caso, donde tenemos $v = (1, 1, dots, 1)$, cada vez que llamemos a $f(i)$ vamos a llamar a $f(j)$ para todo $0 lt.eq j < i$. Si $T$ es el número de operaciones que hace, entonces $T(i) = O(n) + sum_(j = 0)^(i - 1) T(j)$. Esto termina siendo $T in Theta(2^n)$.

  Vemos que se cumplen las dos condiciones para usar programación dinámica:
  + Subestructura óptima. Para resolver $f(i)$, basta con resolver los problemas más pequeños que $i$, en particular, con calcular $f(j)$ para todo $0 lt.eq j < i$.
  + Subproblemas compartidos. A pesar de que hay sólo $n$ posibles valores de $f$, la solución recursiva simple mira $2^n$ subproblemas en el peor caso (donde $v$ es todos unos, esto sale de resolver la recurrencia $T(0) = 1; T(n) = 1 + sum_(i = 0)^(n - 1) T(i)$). Luego hay muchos subproblemas compartidos, y programación dinámica probablemente haga más rápido nuestro algoritmo.

  La manera mecánica de usar programación top-down es agregar un cache. Esto se convierte en:

  ```python
  def F(v):
    n = len(v)
    def f(i, cache={}):
      if i not in cache:
        cache[i] = 1 + max((f(j) for j in range(i)
                                 if v[j] != 0 and v[i] % v[j] == 0),
                           default=0)
      return cache[i]
    return n - max(f(i) for i in range(n))
  ```

  Es difícil analizar la complejidad temporal de este algoritmo, por estar mutando estado (`cache`), y depender su complejidad temporal del estado de `cache` en cada llamada. Podemos, entonces, usar programación dinámica bottom-up, llenando el cache en el mismo orden que se llenaría normalmente, pero a mano.

  ```python
  def F(v):
    n = len(v)
    dp = [1 for _ in range(n)]
    for i in range(1, n):
      dp[i] = 1 + max((dp[j] for j in range(i)
                             if v[j] != 0 and v[i] % v[j] == 0),
                      default=0)
    return n - max(dp[i] for i in range(n))
  ```

  Esto nos deja entender el comportamiento asintótico muy fácilmente. El primer ciclo hace $Theta(n^2)$ operaciones en todos los casos, y el segundo $Theta(n)$ operaciones. Luego el algoritmo entero hace $Theta(n^2)$ operaciones en el peor caso. Finalmente, la complejidad temporal del algoritmo es $Theta(n)$, que es el costo de guardar la tabla `dp`, más variables auxiliares, que cuestan $O(1)$ cada una.
]

=== Ejercicios

#ej[Se tienen dos arrays de $n$ naturales, $A$ y $B$. $A$ está ordenado de manera creciente, y $B$ de manera decreciente. Ningún valor aparece más de una vez en el mismo array. Para cada posición $i$, consideramos la diferencia absoluta entre los valores de los arrays, $|A[i] - B[i]|$. Se desea buscar el mínimo valor posible de dicha cuenta. Por ejemplo, si los arrays son $A = [1,2,3,4]$, y $B = [6, 4, 2, 1]$, los valores de las diferencias son $[5, 2, 1, 3]$, y el resultado es $1$.

  + Diseñar un algoritmo basado en divide-and-conquer que resuelva este problema.
  + Demostrar que es correcto.
  + Dar una cota superior ajustada de su complejidad temporal asintótica.
]

#ej[
  Probar que el siguiente algoritmo multiplica dos enteros $x, y$ dados, para cualquier valor entero de $c gt.eq 2$.

  #algorithm({
    import algorithmic: *
    Procedure(
      "F",
      ($x in ZZ$, $y in NN$),
      {
        If($y = 0$, {
          Return[$0$]
        })
        Assign($t$, FnInline[F][$c times x, floor(y / c)$])
        Return[$t + x times (y mod c)$]
      },
    )
  })
]

#ej[
  Diseñar un algoritmo que, dada una lista de longitud $n$ con los primeros $n$ números naturales, en orden, excepto un elemento faltante, encuentre tal elemento faltante. Por ejemplo, para la lista $[0, 1, 3, 4, 5]$, debe devolver $2$, y para la lista $[1, 2, 3]$, debe devolver $0$.

  Probar formalmente que es correcto, y dar una cota superior ajustada de su complejidad temporal asintótica. Dicha cota debe estar en $O(log n)$.
]

#ej[
  Un array se dice monotónico si está compuesto por un prefijo de enteros creciente, y luego un sufijo de enteros decreciente. Por ejemplo, $[5, 8, 9, 3, 1]$ es unimodal.

  Diseñar un algoritmo que, dado un array unimodal de longitud $n$, encuentre su valor máximo en tiempo $O(log n)$. Demostrar formalmente que es correcto, y dar una cota superior ajustada de su complejidad temporal asintótica en el peor caso.
]

#ej[
  Se tiene una escalera de $n$ escalones. En cada momento, podemos subir de a un escalón, o de a tres escalones. Por ejemplo, si $n = 9$, desde el cuarto escalón podemos ir o bien al quinto, o al séptimo. Si estamos en el séptimo u octavo escalón, sólo podemos subir de a un escalón, y si estamos en el noveno escalón hemos terminado.

  - Diseñar un algoritmo basado en programación dinámica que calcule de cuántas maneras distintas se puede subir la escalera entera.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n)$ operaciones en todo caso, y $O(1)$ memoria.
]

#ej[
  Se tiene una grilla de $n times m$ casillas. Empezamos en la casilla superior izquierda. En cada casilla nos podemos mover a la casilla de abajo, o a la casilla de la derecha. Por ejemplo, si estamos en la casilla $(2, 3)$, podemos ir a la casilla $(3, 3)$ o a la casilla $(2, 4)$. Si estamos en la última fila, sólo podemos movernos a la derecha, y si estamos en la última columna, sólo podemos movernos hacia abajo. Si llegamos a la casilla inferior derecha hemos terminado.

  - Diseñar un algoritmo basado en programación dinámica que, dados dos enteros positivos $n$ y $m$, calcule de cuántas maneras distintas se puede llegar a la casilla inferior derecha.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(min(n, m))$ memoria.
]

#ej[
  Similar al ejercicio anterior, pero ahora en cada casilla tenemos un entero, el entero en la celda $(i, j)$ está en $A[i][j]$. Si el entero es positivo o cero, indica la ganancia que obtenemos al pasar por esa casilla. Si el entero es negativo, indica que no podemos pasar por esa casilla.

  - Diseñar un algoritmo basado en programación dinámica que, dada una matriz $A$ de $n times m$ enteros, calcule la máxima ganancia posible al llegar a la casilla inferior derecha, partiendo desde la superior izquierda, y nuevamente yendo siempre o hacia abajo, o hacia la derecha.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(min(n, m))$ memoria.
]

#ej[
  Se tiene un array $A$A de $l$ cadenas de ceros y unos, por ejemplo $A = ["10", "0001", "111", "100101", "111001", "1", "0"]$, con $l = 7$. Dados enteros positivos $n$ y $m$, encontrar el máximo número de cadenas de $A$ con a lo sumo $n$ unos y $m$ ceros.

  Sea $k$ la suma de las longitudes de las cadenas en $A$, es decir, $k = sum_(i=1)^l |A_i|$.

  - Diseñar un algoritmo basado en programación dinámica que resuelva este problema.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(l n m + k)$ operaciones en todo caso, y $O(n m)$ espacio.
]

#ej[
  Dada una matriz $A$ de $n times m$ de enteros, encontrar la longitud del camino creciente más largo en $A$. El camino va desde una celda hacia arriba, abajo, a la derecha, o a la izquierda, pero no en diagonal.

  Por ejemplo, en la siguiente matriz:

  #table(
    columns: 3,
    rows: 3,
    [9], [9], [4],
    [6], [6], [8],
    [2], [1], [1],
  )

  El camino creciente más largo es `[1, 2, 6, 9]`, de longitud 4.

  - Diseñar un algoritmo basado en programación dinámica que resuelva este problema.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(n m)$ espacio.
]

#ej[
  Tenemos un árbol arraigado, con $n$ vértices. Podemos instalar cámaras en algunos vértices. Cada cámara puede monitorear al vértice donde está instalada, y a sus vecinos inmediatos, es decir su padre (si existe) y todos sus hijos inmediatos (si existen).
  Queremos saber cuántas cámaras como mínimo necesitamos para monitorear todos los vértices del árbol.

  La entrada consiste de dos líneas. La primera línea contiene $n$, el número de vértices del árbol. La segunda línea contiene $n$ enteros. El $i$-ésimo entero es el índice del vértice padre del vértice $i$, o $-1$ si se trata de la raíz del árbol.

  Por ejemplo,

  ```
  4
  -1 0 1 1
  ```

  Esto representa el siguiente árbol:
  ```
       0
      /
     1
   /   \
  2     3
  ```

  Y la respuesta correcta es $1$, pues podemos instalar una cámara en el vértice $1$ y monitorear todos los vértices.

  La entrada

  ```
  8
  -1 0 1 2 3 3 3 1
  ```

  representa el siguiente árbol:
  ```
            0
           /
          1
         / \
        2   7
       /
      3
    / | \
   4  5  6
  ```

  Y la respuesta correcta es $2$, pues podemos instalar cámaras en los vértices $1$ y $3$.

  - Diseñar un algoritmo basado en programación dinámica que calcule el número mínimo de cámaras necesarias para monitorear todos los vértices del árbol.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n)$ operaciones en todo caso, y $O(n)$ espacio.
]


#ej[
  Se nos dan precios de acciones en días consecutivos en un array $A$, donde $A[i]$ es el precio de una acción el día $i$. También se nos da un entero $k$.

  Queremos maximizar la ganancia total haciendo a lo sumo $k$ transacciones. Una transacción es comprar una acción en un día, y venderla en un día posterior. No podemos tener más de una acción a la vez, es decir, debemos vender la acción antes de comprar otra.

  Por ejemplo, si $A = [3,2,6,5,0,3]$ y $k = 2$, podemos comprar en el día 2 (precio 2) y vender en el día 3 (precio 6), ganando 4, y luego comprar en el día 5 (precio 0) y vender en el día 6 (precio 3), ganando 3, para un total de 7.

  - Diseñar un algoritmo basado en programación dinámica que calcule la máxima ganancia posible haciendo a lo sumo $k$ transacciones.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n k)$ operaciones en todo caso, y $O(k)$ espacio.
]

#ej[
  Se tiene una grilla de $m$ filas y $n$ columnas, con $m < n$. Cada celda debe ser pintada de color blanco o negro. Dos celdas son consideradas vecinas si comparten un borde y tienen el mismo color. Dos celdas $A$ y $B$ se consideran en la misma componente si son vecinas, o si hay un vecino de $A$ en la misma componente que $B$.

  Llamamos a una forma de pintar la grilla "linda" si tiene exactamente $k$ componentes.

  - Diseñar un algoritmo que, dados $n$ y $m$, determine el número de formas lindas de pintar la grilla.
  - Demostrar que el algoritmo es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n^2 4^m)$ operaciones en todo caso.

  Sugerencia: Resolver para $m = 1$ y $m = 2$ antes de intentar el caso general.
]

#load-bib()