#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Combinatoria

La combinatoria estudia cómo contar y enumerar objetos, y es una herramienta fundamental en ciencias de la computación. La usaremos para analizar la cantidad de operaciones que realiza un algoritmo, para contar configuraciones posibles en un problema, y para razonar sobre estructuras discretas como grafos y árboles. En esta sección les presento algunos ejemplos resueltos y ejercicios para practicar. El material debería ser de repaso, y los ejercicios sirven como calentamiento para el tipo de matemática que usaremos en el resto del libro.

#ej[
  ¿Cuantos números naturales hay menores o iguales que $1000$ que no son ni múltiplos de $3$ ni múltiplos de $5$?
]
#demo[
  Para esto vamos a usar el principio de inclusión-exclusión. Simbólicamente, este nos dice que para todo par de conjuntos $A, B$:

  $
    |A union B| = |A| + |B| - |A inter B|
  $

  Para resolver este ejercicio, usamos $A = {n in NN | n lt.eq 1000 and n equiv.not 0 (mod 3)}$, y $B = {n in NN | n lt.eq 1000 and n equiv.not 0 (mod 5)}$. Lo que nos pide el enunciado es $|A inter B|$. Luego, esto es $|A| + |B| - |A union B|$.

  Por definición, $|A union B| = {n in NN | n lt.eq 1000 and (n equiv.not 0 (mod 3) or n equiv.not 0 (mod 5))}$. Pero si prestamos atención, el que algo sea o no múltiplo de tres o no múltiplo de cinco, es lo mismo que no ser múltiplo de quince. Podemos razonarlo o podemos hacer una tabla:

  #align(center)[
    #table(
      columns: (auto, auto, auto, auto),
      $n$, $n (mod 3)$, $n (mod 5)$, $n (mod 15)$,
      ..for i in range(15) {
        ($#i$, $#calc.rem(i, 3)$, $#calc.rem(i, 5)$, $#calc.rem(i, 15)$)
      },
    )
  ]

  Luego, $A union B = {n in NN | n lt.eq 1000 and n equiv.not 0 (mod 15)}$. Esto, a su vez, es $A union B = {n in NN | n lt.eq 1000} without {n in NN | n lt.eq 1000 and n equiv 0 (mod 15)}$. Es decir, sacarle los múltiplos de 15, al conjunto de todos los números menores o iguales a 1000. ¿Cuántos tales múltiplos hay? Uno de cada 15 números va a ser múltiplo de 15, luego hay $floor(1000/15)$ tales números, y $|A union B| = 1000 - floor(1000/15) = 1000 - 66 = 934$.

  Encontrar $|A|$ y $|B|$ es similar. $|A| = 1000 - floor(1000/3) = 667$, y $|B| = 1000 - floor(1000/5) = 800$.

  Luego, lo que nos piden es $|A inter B| = 667 + 800 - 934 = 533$.
]

#ej[
  ¿Cuántos palíndromes distintos de longitud $n$ se pueden armar usando un conjunto de $k$ símbolos?
]
#demo[
  Si algo es un palíndrome, entonces se lee igual hacia adelante que hacia atrás. Sea $S = {x_1, x_2, dots, x_(n-1), x_n}$ un tal palíndrome. Entonces $x_n = x_1$, y $x_(n - 1) = x_2$, etcétera. Tenemos que tener cuidado, entonces, con qué pasa en el medio, cuando no hay una igualdad extra. Por ejemplo, si $n = 3$, entonces hay sólo una igualdad, $x_1 = x_3$. La igualdad $x_2 = x_2$ no dice nada, entonces no restringe nuestras posibilidades.


  Entonces, partamos en dos casos, dependiendo de si $n$ es par o impar.
  - Si $n equiv 0 (mod 2)$, entonces $n = 2t$ para algún $t in NN$. Los primeros $t$ símbolos son totalmente arbitrarios, entonces tenemos $k^t$ posibles cadenas. Como los siguientes $t$ símbolos están totalmente determinados por los primeros, no hay posibilidades restantes, y el número de palíndromos de longitud $n = 2t$ usando un conjunto de $k$ símbolos es $k^(n/2)$.
    #table(
      columns: (1fr, 1fr, 1fr, 1fr, 5fr, 5fr, 1fr, 2fr),
      $x_1$,
      $x_2$,
      $dots$,
      $x_t$,
      $x_(t+1) = x_(n - (t + 1)) = x_(t - 1)$,
      $x_(t + 2) = x_(n - (t+2)) = x_(t - 2)$,
      $dots$,
      $x_n = x_1$,
    )
  - Si $n equiv 1 (mod 2)$, entonces $n = 2t + 1$, para algún $t in NN$. Los primeros $t + 1$ símbolos son arbitrarios, y tenemos $k^(t+1)$ cadenas. Los últimos $t$ símbolos están totalmente determinados por los primeros $t$, entonces no hay más posibilidades, y tenemos $k^(t+1)$ palíndromos posibles.
    #table(
      columns: (1fr, 1fr, 1fr, 1fr, 2fr, 6fr, 1fr, 3fr),
      $x_1$, $x_2$, $dots$, $x_t$, $x_(t+1)$, $x_(t + 2) = x_(n - (t + 1)) = x_t$, $dots$, $x_n = x_1$,
    )

  Vemos entonces que la fórmula general para el número de palíndromos de longitud $n$ usando un conjunto de $k$ símbolos es $k^(ceil(n/2))$.
]

#ej[
  Sin calcular los valores explícitamente ni expandir a factoriales, probar que
  $
    binom(10, 4) = binom(9, 3) + binom(9, 4)
  $
]
#demo[
  Esto es un caso particular de la fórmula $binom(n, k) = binom(n - 1, k) + binom(n - 1, k - 1)$, con $n = 10, k = 4$.

  Queremos dar una demostración de este hecho, sin expandir los coeficientes binomiales a sus factoriales. ¿Qué otra cosa sabemos sobre estos coeficientes? Que $binom(n, k)$ es el número de subconjuntos de tamaño $k$, de un conjunto de tamaño $n$.

  Vamos a usar la técnica de "contar lo mismo de dos formas distintas". Supongamos que tenemos un conjunto $X$ de tamaño $n$. Sea $Y$ el conjunto de subconjuntos de $X$ de tamaño $k$.

  - Por un lado, $|Y| = binom(n, k)$, porque esa es precisamente la semántica de $binom(n, k)$.
  - Por otro lado, sea $x in X$. Los elementos de $Y$ se dividen en los que contienen a $x$, y los que no contienen a $x$. ¿Cuántos hay que no tienen a $x$? Eso es lo mismo que elegir subconjuntos de tamaño $k$ de $X without {0}$, que tiene tamaño $n - 1$. Luego, hay $binom(n - 1, k)$ de esos. ¿Cuántos hay que _sí_ tienen a $x$? Si esos ya tienen a $x$, el número de cosas que pueden elegir es $k - 1$ cosas más, pero no pueden volver a elegir a $x$, entonces tienen $n - 1$ elementos de $X$ para elegir. Luego, hay $binom(n - 1, k - 1)$ de esos. Entonces, en total, $|Y| = binom(n - 1, k) + binom(n - 1, k - 1)$.

  Luego, $binom(n, k) = binom(n - 1, k) + binom(n - 1, k - 1)$ para todo $n, k in NN$, con $k lt.eq n$, en particular vale para $n = 10, k = 4$.
]

#ej(title: [Teorema binomial])[
  Probar que para todo $x, y in RR$, y para todo $n in NN$, tenemos que
  $
    (x + y)^n = sum_(k = 0)^n binom(n, k) x^k y^(n - k)
  $
]
Para esta demostración les voy a mostrar el proceso de deducción e ideas que hago antes de formalizarla.
#quote-box[
  Tengo una suma hasta $n$, quizás puedo descomponer la suma hasta $n$ en una suma hasta $n - 1$? A ver....

  Es más, tengo algo "a la" $n$, entonces puedo descomponer eso como $(x + y) (x + y)^(n - 1)$. Si ahí uso la hipótesis inductiva, veamos qué queda...

  $
    (x + y)^(n+1) & = (x + y) (x + y)^n \
                  & = (x + y) sum_(k = 0)^n binom(n, k) x^k y^(n - k) \
                  & = sum_(k = 0)^n binom(n, k) x^(k+1) y^(n - k) + sum_(k = 0)^n binom(n, k) x^k y^(n - k + 1)
  $

  Quiero ver si puedo combinar estas dos ecuaciones, quizás emparejando coeficientes, porque así se sumarían los coeficientes binomiales. Pensando en cosas que valgan para sumas de coeficientes binomiales, recuerdo que $binom(n, k) = binom(n - 1, k) + binom(n - 1, k - 1)$, puede ser que emparejando los coeficientes que tengan el mismo $x^i y^j$, me queden así los coeficientes? A ver...

  Tengo $i, j in NN$, quiero ver qué coeficiente binomial multiplica a $x^i y^j$ en la primer sumatoria, y luego en la segunda. En la primera, $i = k + 1, j = n - k$. Entonces el coeficiente es $binom(n = j + (i - 1), k = i - 1)$. En la segunda, tenemos $i = k, j = n - k + 1$, entonces el coeficiente es $binom(j + i - 1, i)$.

  Juntando estos dos, tenemos que la sumatoria es $sum_(i, j) x^i y^j (binom(j + i - 1, i - 1) + binom(j + i - 1, i))$, donde estoy sumando $i, j$ sobre algún conjunto que no quiero pensar por ahora. Pero esto es bueno, los términos son precisamente de la forma que pensaba que eran, si los sumo me queda $binom(j + i, i)$.

  Ahora tengo que pensar sobre dónde sumo los $i, j$. Todos los términos en las sumatorias tienen el mismo grado, son todos de grado $n + 1$. Los términos que estoy sumando ahora tienen grado $i + j$, entonces $i + j = n + 1$. Como quiero que me quede una sumatoria de sólo un índice, elijo $i$, y me queda $j = n + 1 - i$. ¿Cuáles son los bordes del índice $i$? Hay un término de la sumatoria de la derecha donde tengo $x^0$, y acá estoy diciendo $x^i$, así que seguro tengo que tener un término con $i = 0$. Por otro lado, de la sumatoria izquierda tengo un término $x^(n + 1)$, y nuevamente acá digo $x^i$, así que $i$ tiene que llegar hasta $n + 1$.

  Entonces, usando que $j = n + 1 - i$ y el coeficiente del término $x^i y^j$ es $binom(j + i, i)$, la suma de las sumatorias me queda $sum_(i = 0)^(n + 1) binom(n + 1 - i + i, i) x^i y^(n + 1 - i)$, y esto es igual a $sum_(i = 0)^(n + 1) binom(n + 1, i) x^i y^(n + 1 - i)$, que es precisamente lo que quiero probar.

  OK, perfecto. ¡A formalizarlo! Voy a tener que pensar un rato para hacer menos grotesco el reindexado de las sumas.
]
#demo[
  Vamos a usar inducción. Sea $P(n): forall x, y in RR. (x + y)^n = sum_(k = 0)^n binom(n, k) x^k y^(n - k)$.

  - Caso base, $P(0)$. $P(0): forall x, y in RR. (x + y)^0 = sum_(i = 0)^0 binom(0, k) x^k y^(0 - k) = binom(0, 0) x^0 y^0 = 1$. Como $(x + y)^0 = 1$ para todo $x, y$ (sí, $0^0 = 1$)), esto es cierto.
  - Paso inductivo. Sea $n in NN$. Asumo $P(n)$, quiero ver $P(n + 1)$. Sean $x, y in RR$.

    $
      (x + y)^(n + 1) =& (x + y) (x + y)^n \
      =& (x + y) (sum_(k = 0)^n binom(n, k) x^k y^(n - k))," por hipótesis inductiva" \
      =& x (sum_(k = 0)^n binom(n, k) x^k y^(n - k)) + y (sum_(k = 0)^n binom(n, k) x^k y^(n - k)) \
      =& sum_(k = 0)^n binom(n, k) x^(k+1) y^(n - k) + sum_(k = 0)^n binom(n, k) x^k y^(n - k + 1) \
      =& sum_(i = 1)^(n + 1) binom(n, i - 1) x^i y^(n - (i - 1)) + sum_(k = 0)^n binom(n, k) x^k y^(n - k + 1), "llamando "i = k + 1, \
      =& sum_(j = 1)^(n + 1) binom(n, j - 1) x^j y^(n + 1 - j) + sum_(j = 0)^n binom(n, j) x^j y^(n + 1 - j), "llamando a ambos índices "j
    $
    Acá hay que tener cuidado. Lo que queremos hacer es que los índices sean iguales, que es sacarle el último término ($j = n + 1$) a la primer sumatoria, y el primer término $(j = 0)$ a la segunda. Lo único que sé es que $n in NN$, entonces tengo al menos un término en cada sumatoria, porque $n + 1 gt.eq 1$ (para la primera) y $n gt.eq 0$ (para la segunda). No podría, si quisiera, sacar dos términos de cada una, porque no sé si _hay_ dos términos en cada una.


    $
      = & binom(n, n) x^(n + 1) y^(n + 1 - (n + 1)) + sum_(j = 1)^n binom(n, j - 1) x^j y^(n + 1 - j) \
        & + sum_(j = 1)^n binom(n, j) x^j y^(n + 1 - j) + binom(n, 0) x^0 y^(n+1-0) \
      = & binom(n, n) x^(n + 1) y^0 + binom(n, 0) x^0 y^(n+1) + sum_(j=1)^n (binom(n, j - 1) + binom(n, j)) x^j y^(n + 1 - j) \
      = & binom(n + 1, n + 1) x^(n + 1) y^0 + binom(n + 1, 0) x^0 y^(n+1) + sum_(j=1)^n binom(n+1, j) x^j y^(n+1-j) \
      = & sum_(j=0)^(n+1) binom(n+1, j) x^j y^(n+1-j)
    $

    que es lo que queríamos demostrar.
]


#ej[
  Sean $f, g: NN arrow NN$. Se define la convolución de $f$ y $g$ como la función $(f * g)(n) = sum_(i = 0)^n f(i) g(n - i)$.

  Probar que la convolución es asociativa. Es decir, que para cuales quiera $f, g, h: NN arrow NN$, tenemos $f * (g * h) = (f * g) * h$.
]

Para este ejercicio también voy a escribirles en qué pienso a medida que lo hago.
#quote-box[
  Primero voy a expandir uno de los lados, a ver qué queda. La igualdad de funciones es igualdad en cada valor de entrada, así que sea $n in NN$.
  $
    (f * (g * h))(n) = & sum_(i = 0)^n f(i) (g * h)(n - i) \
                     = & sum_(i = 0)^n f(i) (sum_(j = 0)^(n - i) g(j) h(n - i - j)) \
  $

  Puedo que los índices tengan una relación simple, puedo en vez de ir desde $j = 0$ hasta $n - i$, ir desde $i$ hasta $n$, y lo único que estoy haciendo es sumándole $i$ a $j$. Luego cuando en el término digo $g(j)$, se convierte en $g(j - i)$, y cuando digo $h(n - i - j)$, se convierte en $h(n - i - (j - i)) = h(n - j)$.
  $
    = & sum_(i = 0)^n f(i) (sum_(j = i)^n g(j - i) h(n - j)) \
    = & sum_(0 lt.eq i lt.eq j lt.eq n) f(i) g(j - i) h(n-j) \
  $

  Lo de $f(i) g(j - i)$ se parece bastante a una convolución, específicamente $(f * g)(j)$. Tengo entonces que hacer que la suma de $i$ esté afuera de la suma de $j$. Pero eso me quedaría $sum_(j = i)^m f(i) g(j - i)$ adentro, que no es lo que quiero tener, porque no es una convolución. Más aún, no podría sacar el $h(n - j)$ afuera de esa convolución, porque es distinto para cada ($j$) término. OK, entonces la sumatoria interna tiene que ser sobre $i$.
  $
    = & sum_(j = 0)^n sum_(i = 0)^j f(i) g(j - i) h(n - j) \
    = & sum_(j = 0)^n (f * g)(j) h(n - j) \
    = & ((f * g) * h)(n)
  $

  OK, pasémoslo en limpio.
]
#demo[
  Sea $n in NN$, y $f, g, h: NN arrow NN$.

  Entonces:
  $
    (f * (g * h))(n) = & sum_(i = 0)^n f(i) (g * h)(n - i) \
                     = & sum_(i = 0)^n f(i) (sum_(j = 0)^(n - i) g(j) h(n - i - j)) \
                     = & sum_(i = 0)^n f(i) (sum_(j = i)^n g(j - i) h(n - j)) \
                     = & sum_(0 lt.eq i lt.eq j lt.eq n) f(i) g(j - i) h(n-j) \
                     = & sum_(j = 0)^n sum_(i = 0)^j f(i) g(j - i) h(n - j) \
                     = & sum_(j = 0)^n (f * g)(j) h(n - j) \
                     = & ((f * g) * h)(n)
  $
]

=== Ejercicios

#ej[
  ¿Cuántas cadenas binarias de longitud $n$ tienen exactamente $k$ unos?
]

#ej[
  Sea $n in NN$. Demostrar que $sum_(k = 0)^n binom(n, k) = 2^n$.
]

#ej[
  Sea $n in NN$. Demostrar que $sum_(k = 0)^n (-1)^k binom(n, k) = 0$.
]

#ej[
  Sean $m, n, r in NN$ con $r lt.eq m + n$. Demostrar la identidad de Vandermonde:
  $
    binom(m + n, r) = sum_(k = 0)^r binom(m, k) binom(n, r - k)
  $
  Sugerencia: contar de dos formas la cantidad de subconjuntos de tamaño $r$ de un conjunto formado por dos grupos disjuntos, uno de tamaño $m$ y otro de tamaño $n$.
]

#ej[
  ¿De cuántas formas se pueden sentar $n$ personas en una mesa circular, si consideramos iguales a dos disposiciones que difieren sólo por una rotación?
]

#ej[
  Demostrar el principio de inclusión-exclusión para tres conjuntos: sean $A, B, C$ conjuntos finitos. Entonces:
  $
    |A union B union C| = |A| + |B| + |C| - |A inter B| - |A inter C| - |B inter C| + |A inter B inter C|
  $
]

#ej[
  Sea $n in NN$, $n gt.eq 1$. Demostrar que $sum_(k = 1)^n k binom(n, k) = n 2^(n - 1)$.
]

/* FIXME: Esto va a ir en la sección sobre teoría de grafos, cuando exista.

#ej[
  Sea $G$ un grafo con $n > 1$ vértices. Probar que existen en $G$ dos vértices del mismo grado.
]
#demo[
  Sea $G = (V, E)$ un grafo. El grado de un vértice es el número de aristas que inciden en él. Notemos por $d(v)$ al grado de cada vértice $v in V$. Como un vértice puede estar conectado como mínimo con cero otros vértices, y como máximo con todos los otros $n - 1$ vértices, tenemos que $0 lt.eq d(v) lt.eq n - 1$ para todo $v in V$.

  Si existe un vértice $v$ tal que $d(v) = n - 1$, entonces no puede existir un vértice distinto $w$ con grado $d(w) = 0$ (no conectado con nadie), pues sabemos que ${v, w} in E$. Como $n eq.not 1$, tampoco podemos tener $v = w$, pues $d(v) = n - 1 eq.not 0 = d(w)$. Luego, si existe un vértice con grado $n - 1$, no puede existir ningún vértice con grado $0$, y luego los grados posibles son $1, 2, dots, n - 1$, es decir, $n - 1$ posibles grados.

  De otra manera, si no existe ningún vértice con grado $n - 1$, entonces los grados posibles son $0, 1, 2, dots, n - 2$, que también son $n - 1$ posibles grados.

  Entonces tenemos $n$ vértices, y sólo $n - 1$ posibles grados. Por el principio del palomar, existen al menos dos vértices con el mismo grado.
]
*/

#load-bib()