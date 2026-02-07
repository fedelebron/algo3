#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Análisis asintótico

Muchas veces vamos a querer analizar el crecimiento de una función, cuando su entrada crece. Queremos por ejemplo tener una noción de que la función $g(n) = 100 log_2(n)$ es "más chica" que la función $f(n) = n^2$, a pesar de que $g(3) > f(3)$, por ejemplo. Lo que queremos captar es cómo estas funciones se comportan "en el límite", es decir, cuando $n$ es muy grande.

#note-box[
Nuestros algoritmos consumen recursos: tiempo, memoria, ancho de banda, energía.

Para analizar un algoritmo, modelamos el consumo de un recurso como una función $f : NN -> RR0$ del tamaño de la entrada.

Pero esta función depende de detalles que queremos ignorar. Si medimos tiempo de ejecución, una computadora más rápida multiplicará todos los valores por alguna constante $c < 1$. Si contamos operaciones, la elección de qué operaciones contar cambia la función por un factor constante. Si hay costos fijos de inicialización o terminación, la función se desplaza por una constante aditiva.

Queremos una noción de equivalencia entre funciones que sea invariante bajo estas transformaciones: que $f$ y $c dot f + d$ sean "esencialmente iguales" para cualquier $c > 0$ y $d in RR0$. La notación asintótica nos da exactamente esto.
]

Para esto vamos a definir ciertos conjuntos de funciones.

#def[
  Sea $f: NN arrow RR0$. Definimos los conjuntos:

  $
    O(f) &= {g: NN arrow RR0 | exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies g(n) lt.eq alpha f(n))} \
    Omega(f) &= {g: NN arrow RR0 | exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies g(n) gt.eq alpha f(n))} \
    Theta(f) &= O(f) inter Omega(f)
  $
]

Podemos leer la expresión $f in O(g)$ como "$f$ está asintóticamente dominada por $g$", y la expresión $f in Omega(g)$ como "$f$ asintóticamente domina a $g$", y la expresión $f in Theta(g)$ como "$f$ y $g$ son asintóticamente equivalentes".

#warning-box[
  Esta notación no significa "aproximadamente" en el sentido coloquial. Es una relación matemática precisa entre funciones, aplicable a cualquier recurso que podamos modelar como función del tamaño de entrada.

  Algo *muy* importante es que $O(f)$ y $Omega(f)$ y $Theta(f)$ son *conjuntos de funciones*. No son números, y no son funciones. Es increíblemente común que los alumnos se confundan con esto, especialmente cuando, como veremos más adelante, veamos notación como $5 n^2 + O(n)$.
]

Veamos qué están captando estas definiciones, usando el ejemplo de arriba. Si $f: NN arrow RR0$, entonces $O(f)$ es el conjunto de funciones de la forma $g: NN arrow RR0$, tales que existen constantes $alpha in RR, alpha > 0$, y $n_0 in NN$, tales que a partir de $n_0$, $g(n) lt.eq alpha f(n)$. Con $f(n) = n^2$ y $g(n) = 100 log_2(n)$, podemos tomar $alpha = 100$, y $n_0 = 1$, y plantear:

$
          g(n) & lt.eq alpha f(n) \
  100 log_2(n) & lt.eq 100 n^2 \
      log_2(n) & lt.eq n^2
$

Como sabemos que $log_2(n) lt.eq n$ para todo $n in NN, n gt.eq 1 = n_0$, y a su vez $n lt.eq n^2$ para todo $n in NN$, esto es cierto. Luego, tenemos que $g in O(f)$, $g$ está asintóticamente dominada por $f$.

Veamos ahora una propiedad que relaciona dos de estos conjuntos.

#prop[
  Sean $f, g: NN arrow RR0$ funciones. Entonces, $g in O(f)$ si y sólo si $f in Omega(g)$.
]
#demo[
  $
    g in O(f) & iff exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies g(n) lt.eq alpha f(n)) \
              & iff exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies 1/alpha g(n) lt.eq f(n)) \
              & iff exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies f(n) gt.eq 1/alpha g(n)) \
              & "Que exista "alpha > 0" es lo mismo que que exista "1/alpha > 0", luego" \
              & iff exists alpha > 0 in RR, exists n_0 in NN, forall n in NN, (n gt.eq n_0 implies f(n) gt.eq alpha g(n)) \
              & f in Omega(g)
  $
]

Vemos entonces que $O$ y $Omega$ son duales. Veamos un par de propiedades básicas sobre estos conjuntos.

#prop[
  Sea $f: NN arrow RR0$, y $k in RRg0$. Entonces $k f in Theta(f)$.
]<prop:asim_refl>
#demo[
  Debemos probar que $k f in O(f)$ y $k f in Omega(f)$.

  Para $k f in O(f)$, debemos encontrar $alpha > 0$ y $n_0 in NN$ tales que para todo $n gt.eq n_0$, $(k f)(n) lt.eq alpha f(n)$. Como $k > 0$, podemos tomar $alpha = k$ y $n_0 = 0$. Entonces, para todo $n gt.eq n_0$, tenemos que $(k f)(n) = k f(n) lt.eq k f(n) = alpha f(n)$.

  Para $k f in Omega(f)$, debemos encontrar $beta > 0$ y $n_1 in NN$ tales que para todo $n gt.eq n_1$, $(k f)(n) gt.eq beta f(n)$. Como $k > 0$, podemos tomar $beta = k$ y $n_1 = 0$. Entonces, para todo $n gt.eq n_1$, tenemos que $(k f)(n) = k f(n) gt.eq k f(n) = beta f(n)$.

  Por lo tanto, $k f in O(f) inter Omega(f) = Theta(f)$.
]
#corollary[
Sea $f: NN arrow RR0$. Entonces $f in O(f)$.
]<prop:asim_self>

#prop[
  Sean $f, g, h: NN arrow RR0$, tales que $f in O(g)$ y $g in O(h)$. Entonces $f in O(h)$.
]<prop:asim_trans>
#demo[
  Como $f in O(g)$ y $g in O(h)$, existen $alpha_1, alpha_2 > 0 in RR$, y $n_1, n_2 in NN$, tales que para todo $n gt.eq n_1$, tenemos que $f(n) lt.eq alpha_1 g(n)$, y para todo $n gt.eq n_2$, tenemos que $g(n) lt.eq alpha_2 h(n)$. Luego, para todo $n gt.eq max(n_1, n_2)$, tenemos que $f(n) lt.eq alpha_1 g(n) lt.eq alpha_1 alpha_2 h(n)$, lo que demuestra que $f in O(h)$.
]

#note-box[Esas dos propiedades nos dicen que tenemos un preorden entre funciones, definiendo $f lt.eq g iff f in O(g)$.]

Tenemos una herramienta útil para probar pertenencia a estos conjuntos asintóticos, que es usar límites#footnote[La restricción de que $L$ exista no es realmente necesaria. Las equivalencias valen si uno toma $limsup$ para $O$ y $liminf$ para $Omega$, que existen aún cuando el límite tradicional no existe. Como no quiero asumir que vieron límites superiores e inferiores, uso esta formulación más restringida, que es suficiente en la práctica.].

#prop[
  Sean $f, g: NN arrow RR0$, tal que $g$ es positiva a partir de algún número $n_0$. Sea $L = lim_(n arrow infinity) f(n)/g(n)$, con $L in RR union {infinity}$ (es decir, el límite existe). En el límite podemos asumir que $n gt.eq n_0$, para que la división tenga sentido. Entonces:

  - $L < infinity iff f in O(g)$
  - $L > 0 iff f in Omega(g)$
  - $0 < L < infinity iff f in Theta(g)$
]<prop:asim_lim>
#demo[
  - $L < infinity implies f in O(g)$: Por definición de límite, existe $n_1 in NN$ tal que para todo $n gt.eq n_1$, $abs(f(n)/g(n) - L) < 1$. Luego $f(n)/g(n) < L + 1$, y por lo tanto $f(n) < (L + 1) g(n)$ para todo $n gt.eq max(n_0, n_1)$. Tomando $alpha = L + 1$, tenemos $f in O(g)$.

  - $f in O(g) implies L < infinity$: Por definición de $O(g)$, existen $alpha > 0$ y $n_1 in NN$ tal que $f(n) lt.eq alpha g(n)$ para todo $n gt.eq n_1$. Luego $f(n)/g(n) lt.eq alpha$ para todo $n gt.eq max(n_0, n_1)$. Como el límite $L$ existe por hipótesis, y la sucesión $f(n)/g(n)$ está eventualmente acotada por $alpha$, tenemos $L lt.eq alpha < infinity$.

  - $L > 0 implies f in Omega(g)$: Por definición de límite, tomando $epsilon = L/2 > 0$, existe $n_1 in NN$ tal que para todo $n gt.eq n_1$, $abs(f(n)/g(n) - L) < L/2$. Luego $f(n)/g(n) > L - L/2 = L/2$, y por lo tanto $f(n) > (L/2) g(n)$ para todo $n gt.eq max(n_0, n_1)$. Tomando $alpha = L/2$, tenemos $f in Omega(g)$.

  - $f in Omega(g) implies L > 0$: Por definición de $Omega(g)$, existen $alpha > 0$ y $n_1 in NN$ tal que $f(n) gt.eq alpha g(n)$ para todo $n gt.eq n_1$. Luego $f(n)/g(n) gt.eq alpha$ para todo $n gt.eq max(n_0, n_1)$. Como el límite $L$ existe por hipótesis, y la sucesión $f(n)/g(n)$ está eventualmente acotada inferiormente por $alpha > 0$, tenemos $L gt.eq alpha > 0$.

  - $0 < L < infinity iff f in Theta(g)$: Se sigue de los dos puntos anteriores, pues $Theta(g) = O(g) inter Omega(g)$.
]

Veamos cómo usar esta propiedad de límites.
#ej[
  Sean $f(n) = 7 log_2(n)$, $g = sqrt(n) + 1$. Entonces $f in O(g)$.
]
#demo[
  Como $sqrt(n) + 1> 0$ para todo $n in NN$, entonces podemos tomar =

  $
    L & = lim_(n arrow infinity) (7 log_2(n))/(sqrt(n) + 1) \
      & = lim_(n arrow infinity) (7 (log n)/(log 2))/(sqrt(n) + 1) \
      & = lim_(n arrow infinity) (7/(log 2)) (log n)/(sqrt(n) + 1)
  $

  Usando la regla de L'Hôpital, obtenemos

  $
    L & = (7/(log 2)) lim_(n arrow infinity) (1/n) / (1/(2 sqrt(n))) \
      & = (7/(log 2)) lim_(n arrow infinity) (2 sqrt(n))/n \
      & = (7/(log 2)) lim_(n arrow infinity) 2/(sqrt(n)) \
      & = (7/(log 2)) 0 \
      & = 0
  $

  Por lo tanto, $f in O(g)$.
]

De hecho, tendremos las siguientes inclusiones.

#let draw-asymptotic-hierarchy(class, color, reversed:true) = {
  let levels = (
    $(1)$,
    $(log n)$,
    $(sqrt(n))$,
    $(n)$,
    $(n^2)$,
    $(2^n)$,
    $(3^n)$,
    $(n!)$,
  )
  return canvas({
    let n = levels.len()
    let x-scale = 0.75
    let y-scale = 0.55
    let shift = 0.6
    let c = color.lighten(10%)
    for (i, level) in levels.enumerate() {
      let depth = n - i
      let rx = depth * x-scale
      let ry = depth * y-scale
      let cx = depth * shift

      draw.circle(
        (cx, 0),
        radius: (rx, ry),
        stroke: 0.75pt + black,
        fill: c.lighten((i/n)*100%),
      )
    }

    if reversed {
      levels = levels.rev()
    }
    for (i, level) in levels.enumerate() {
      let depth = n - i
      let rx = depth * x-scale
      let cx = depth * shift
      let left-edge = cx - rx

      let inner-left-edge = if depth > 1 {
        let inner-depth = depth - 1
        inner-depth * shift - inner-depth * x-scale
      } else {
        cx
      }

      let label-x = cx + rx - 0.7

      draw.content(
        (label-x, 0),
        text(size: 9pt, class + level)
      )
    }
  })
}

#align(center, draw-asymptotic-hierarchy($O$, red))

Vemos, entonces, que estar en $O(n^2)$ implica estar en $O(n^6)$, y que estar en $O(3^n log n)$, implica estar en $O(4^n sqrt(n))$. Tendremos las inclusiones opuestas cuando usamos cotas inferiores, usando $Omega$:

#align(center, draw-asymptotic-hierarchy($Omega$, blue, reversed:false))

Todas las funciones están acotadas por debajo por alguna constante (por ejemplo, $0$), pero muy pocas están acotadas por debajo, eventualmente, por un múltiplo de $n!$.

En las sección de ejercicios van a tener que demostrar varias de esas inclusiones. La siguiente propiedad nos va a dejar sumar estos conjuntos.

#prop[
  Sean $f, g, h: NN arrow RR0$, con $f in O(h)$ y $g in O(h)$. Entonces $f + g in O(h)$.
]<prop:asim_sum>
#demo[
  Por hipótesis, $f in O(h)$ implica que existen $alpha > 0$ y $n_1 in NN$ tal que $f(n) lt.eq alpha h(n)$ para todo $n gt.eq n_1$. Similarmente, $g in O(h)$ implica que existen $beta > 0$ y $n_2 in NN$ tal que $g(n) lt.eq beta h(n)$ para todo $n gt.eq n_2$.

  Sea $n_0 = max(n_1, n_2)$ y sea $gamma = alpha + beta$. Entonces para todo $n gt.eq n_0$ tenemos que

  $
    f(n) + g(n) &lt.eq alpha h(n) + beta h(n) \
                &= (alpha + beta) h(n) \
                &= gamma h(n)
  $

  Luego, $f(n) + g(n) lt.eq gamma h(n)$ para todo $n gt.eq n_0$, lo que demuestra que $f + g in O(h)$.
]

La siguiente propiedad nos deja quedarnos con los términos que crecen más rápidamente, en una suma.

#prop[
Sean $f, g: NN arrow RR0$, con $f in O(g)$. Entonces $f + g in Theta(g)$.
]<prop:asim_dom>
#demo[
  Para probar que $f + g in Theta(g)$, debemos probar que $f + g in O(g)$ y $f + g in Omega(g)$.

  - $f + g in O(g)$: Por hipótesis, $f in O(g)$ implica que existen $alpha > 0$ y $n_0 in NN$ tal que $f(n) lt.eq alpha g(n)$ para todo $n gt.eq n_0$. Luego, para todo $n gt.eq n_0$:
  $
    f(n) + g(n) &lt.eq alpha g(n) + g(n) \
                &= (alpha + 1) g(n)
  $
  Por lo tanto, $f + g in O(g)$.

  - $f + g in Omega(g)$: Como $f(n) gt.eq 0$ para todo $n in NN$, tenemos que $f(n) + g(n) gt.eq g(n)$ para todo $n in NN$. Tomando $beta = 1$, tenemos que $f(n) + g(n) gt.eq beta g(n)$ para todo $n in NN$. Por lo tanto, $f + g in Omega(g)$.

  Como $f + g in O(g)$ y $f + g in Omega(g)$, concluimos que $f + g in Theta(g)$.
]

Luego, en una función como $h(n) = n^2 + 3n$, como $3n in O(n^2)$ pues $lim_(n arrow infinity) (3n)/n^2 = 0$, tenemos que $h in Theta(n^2)$. Las siguientes dos propiedades nos dicen cómo multiplicar dos de estos conjuntos, o multiplicarlos por un escalar.
#prop[
Sean $f, F, g, G: NN arrow RR0$. Si $f in O(F)$ y $g in O(G)$, entonces $f g in O(F G)$.
]
La demostración es el @ej:asim_prod.
#prop[
  Sean $f, g: NN arrow RR0$, y $alpha > 0 in RR$. Entonces $f in O(g)$ si y sólo si $alpha f in O(g)$.
]<prop:asim_mul>
La demostración es el @ej:asim_mul.

Veamos un ejemplo en la práctica.
#ej[
  Sea $f: NN arrow RR0$ la función dada por $f(n) = 3 n^2 + 2 n + 1$. Probar que $f in O(n^2)$.
]
#demo[
  Primero hagamos las cuentas "a mano". Tenemos que elegir un $alpha in RR, alpha > 0$, y un $n_0 in NN$, tal que para todo $n in NN, n gt.eq n_0$, se cumpla que $f(n) lt.eq alpha n^2$. Intuitivamente, $f$ crece parecido a $3n^2$. Luego, si elegimos $alpha = 4$, eventualmente $f(n) lt.eq alpha n^2$. Probemos esto formalmente.

  Elegimos $alpha = 4$. Queremos encontrar $n_0$ tal que si $n gt.eq n_0$, entonces $3 n^2 + 2 n + 1 lt.eq 4 n^2$.
  $
        & 3n^2 + 2n + 1 lt.eq 4 n^2 \
    iff & 2n + 1 lt.eq n^2 \
    iff & 0 lt.eq n^2 - 2n - 1 \
  $

  Ahora consideremos la función $h(n) = n^2 - 2n - 1$. Para ver dónde es no-negativa, podemos encontrar sus raíces:

  $
    n^2 - 2n - 1 & = 0 \
               n & = (2 plus.minus sqrt(4 + 4)) / 2 \
               n & = 1 plus.minus sqrt(2)
  $

  Luego, como $h$ es una parábola que crece en sus extremos, cuando $n gt.eq 1 + sqrt(2)$, $h(n) gt.eq 0$. Como $sqrt(2) < 2$, podemos elegir $n_0 = 3$, y garantizamos que si $n gt.eq n_0$, entonces $h(n) gt.eq 0$, que vimos es equivalente a que $f(n) lt.eq 4 n^2$. Luego, $f in O(n^2)$.
]
#demo[
  Ahora usemos las herramientas que aprendimos. $f(n) = g(n) + h(n)$, con $g(n) = 3n^2$, y $h(n) = 2n + 1$. Como $h in O(g)$ pues $lim_(n arrow infinity) (3n^2) / (2n + 1) = infinity > 0$, entonces por la @prop:asim_dom, $f in Theta(g)$. Por la @prop:asim_refl, sabemos que $g in Theta(n^2)$.
  
  Finalmente, por la @prop:asim_trans, tenemos que $f in Theta(n^2)$. En particular, $f in O(n^2)$.
]
#demo[
  Finalmente usemos sólo la propiedad de límites. Sea $L = lim_(n arrow infinity) (3n^2 + 2n + 1)/(n^2) = lim_(n arrow infinity) 3 + 2/n + 1/n^2 = 3$. Entonces por la @prop:asim_lim, tenemos que $3n^2 + 2n + 1 in Theta(n^2) subset.eq O(n^2)$.
]

Podemos generalizar este hecho.

#prop[
  Sea $n in NN$, y $f in NN[x]$ un polinomio de grado $n$ en la variable $x$, con coeficientes naturales. Entonces $f in Theta(x^n)$.
]

La demostración es el @ej:asim_poly.

/*La definición usando límites también nos permite aprender más sobre cómo se comportan los polinomios. Veamos como todo polinomio está dominado por cualquier exponencial con razón mayor a 1.
#prop[
Sea $n in NN$, y $r in RR$, con $r > 1$. Entonces $x^n in O(r^x)$.
]
#demo[
Sea $L = lim_(x arrow infinity) x^n/(r^x)$. Como $f$ es un polinomio de grado $n$, podemos aplicar la regla de L'Hôpital $n$ veces. El numerador se vuelve $n!$, recordando que $(d^k x^n)/(d x^k) = n(n-1)...(n-k+1)x^(n-k)$. El denominador se vuelve $r^x ln r$, recordando que $(d^k r^x)/(d x^k) = r^x (ln r)^k$. Entonces:

$
  L & = lim_(x arrow infinity) x^n/(r^x) \
    & = lim_(x arrow infinity) n!/(r^x (ln r)^n) \
    & = 0
$

Por lo tanto, $x^n in O(r^x)$.
]

#warning-box[
Notemos cómo hay un abuso de notación cuando escribimos cosas como $O(r^x)$. $O(dots)$ recibe una función, mientras que $r^x$ es una expresión. Podríamos estar quisiendo decir $O(f)$ con $f(x) = r^x$, o $O(g)$ con $g(r) = r^x$, notar cómo estas dos funciones son totalmente distintas, y por lo tanto los conjuntos son totalmente distintos. Tampoco sabemos el dominio que tiene esta función, implícita.

La expresión por sí sola no es suficiente para saber a qué función nos referimos, en general. Vamos a hacer abuso de esta notación sólo cuando sea claro cuál es la variable, y cuáles las constantes. Tener cuidado con esto se va a volver aún más importante cuando veamos la notación con varias variables, como ser $O(n + m)$, en algunos capítulos.
]

Asimismo podemos ver cómo se comportan las exponenciales.

#prop[
Sean $r, s in RR$, con $1 < s < r$. Entonces $r^x in O(s^x)$, pero $s^x in.not O(r^x)$.
]
#demo[
Sea $L = lim_(x arrow infinity) s^x/(r^x)$. Entonces:

$
  L & = lim_(x arrow infinity) s^x/(r^x) \
    & = lim_(x arrow infinity) (s/r)^x \
    & = 0
$

Por lo tanto, $r^x in O(s^x)$.

Por otro lado, sea $T = lim_(x arrow infinity) r^x/(s^x)$. Entonces:

$
  T & = lim_(x arrow infinity) r^x/(s^x) \
    & = lim_(x arrow infinity) (r/s)^x \
    & = infinity
$

Como $T in.not R$, tenemos que $s^x in.not O(r^x)$.  
]
*/
Una propiedad que vamos a usar mucho es que $Theta(log_a n) = Theta(log_b n)$ para todos $a, b in NN_(> 1)$. Esto nos va a dejar escribir $Theta(log n)$, sin especificar la base del logaritmo, pero sin perder precisión.

#prop[
Sean $a, b in NN_(> 1)$. Entonces $log_a x in Theta(log_b x)$.
]
#demo[
Sea $L = lim_(x arrow infinity) (log_a x) / (log_b x)$. Entonces:

$
  L & = lim_(x arrow infinity) (log_a x) / (log_b x) \
    & = lim_(x arrow infinity) ((ln x) / (ln a)) / ((ln x) / (ln b)) \
    &= lim_(x arrow infinity) (ln x) / (ln a) (ln b) / (ln x) \
    &= lim_(x arrow infinity) (ln b) / (ln a) \
    &= (ln b) / (ln a) in RR_(> 0)
$

Por lo tanto, $log_a x in Theta(log_b x)$.
]

=== Ejercicios

#ej[
  Sean $f, g: NN arrow RR0$, y $alpha > 0 in RR$. Entonces $f in O(g)$ si y sólo si $alpha f in O(g)$.
]<ej:asim_mul>

#ej[
Sean $f, F, g, G: NN arrow RR0$. Si $f in O(F)$ y $g in O(G)$, entonces $f g in O(F G)$.
]<ej:asim_prod>

#ej[
  Sea $n in NN$, y $f in NN[x]$ un polinomio de grado $n$ en la variable $x$, con coeficientes naturales. Entonces $f in Theta(x^n)$.
]<ej:asim_poly>

#ej[
Probar que si $f:NN arrow RR0$ es tal que $f(n) = 4^n$, entonces $f in.not O(2^n)$.
]

#ej[
Sean $f, g: NN arrow RR0$ funciones. Recordando que $f dot O(g) = {f dot h | h in O(g)}$, probar que $f dot O(g) = O(f dot g)$.
]<bigoprod>
#ej[
  Sean $f, g: NN arrow NN$ funciones. Probar que si $f in Theta(g)$, entonces $g in Theta(f)$.
]
#ej[
Sean $f, g: NN arrow RR0$ funciones, y $n_0 in NN$. Probar que si $f(n) lt.eq g(n)$ para todo $n gt.eq n_0$, entonces $f in O(g)$.

Mostrar que la vuelta no vale, exhibiendo un ejemplo explícito de $f$ y $g$, tal que $f in O(g)$, pero no exista ningún $n_0$ tal que para todo $n gt.eq n_0$ se tenga $f(n) lt.eq g(n)$.
]
#ej[
  Sea $n in NN$, y $f in ZZ[x]$ un polinomio de grado $n$. Probar que $f in O(x^n)$. Mostrar que no es cierto que $f in Omega(x^n)$, dando un ejemplo explícito de $n$ y $f$.

Este ejercicio es distinto a @ej:asim_poly, pues los coeficientes son enteros, no sólo naturales.
]

#ej[
Sean $f, g: NN arrow RR0$ tales que $f in Theta(g)$. Probar que $log_2 f in Theta(log g)$.

Probar que *no* es cierto, en general, que si $log_2 f in Theta(log g)$, entonces $f in Theta(g)$.
]

#ej[
Sean $f, g: NN arrow RR0$. Es cierto que o bien $f in O(g)$, o bien $g in O(f)$? De ser cierto, demostrarlo. De caso contrario, exhibir un contraejemplo, y demostrar que efectivamente es un contraejemplo.
]


== Álgebra asintótica

Vimos como notaciones como $O(dots)$ y $Omega(dots)$ se pueden usar para aproximar el crecimiento de funciones. Vamos a querer expresar que no sólo una función se comporta de esa manera, sino que "una parte" de una función se comporta de esa manera. Por ejemplo, al decir que $f: NN arrow RR0$, $f(n) = n^2 + O(n)$, queremos decir que existe una función $g in O(n)$ tal que $f(n) = n^2 + g(n)$ para todo $n in NN$. Esto nos dice algo más que sólo saber que $f in O(n^2)$, nos dice algo sobre la estructura de $f$. Al mismo tiempo, no nos dice exactamente _quién_ es $f$, lo cual es útil pues a veces vamos a querer obviar exactamente qué elemento de $O(n)$ es $g$.

#def[
Sean $f, g: NN arrow RR0$, y $k in RR0$. Definimos:
- $f + O(g) = {f + h | h in O(g)}$
- $f O(g) = {f h | h in O(g)}$
- $k O(f) = {k h | h in O(f)}$

Definiciones equivalentes valen para $Omega$ y $Theta$.
]

#warning-box[
Tengan cuidado, ¡decir que $f(n) = n^2 + O(n)$ *no* define $f$! Sólo nos dice que $f$ está en el conjunto ${n^2 + g | g in O(n)}$. Más propiamente escrito, esto sería $f in n^2 + O(n)$. Les presento esta notación porque es usual verla, pero deben tener cuidado, pues cosas "obvias" como dar vuelta esta "igualdad" dejan de funcionar. No tiene sentido decir que $n^2 + O(n) = f$, como tampoco va a tener sentido razonamientos del estilo "Como $f = n^2 + O(n)$ y $g = n^2 + O(n)$, entonces $f = g$."
.

Esta notación es tan poderosa como peligrosa. ¡Están advertidos!
]
#block({
  image("/images/dumbledore.png", width: 100%)
  place(center + horizon, dx: 4mm, dy: -33mm, block({text(size: 9pt)[¡Cuidado Harry, la magia negra asintótica ha traicionado a muchos estudiantes!]}, width: 30mm))
})

Veamos algunos ejemplos.

#ej[
Sea $f(n) = 2 n^2 + O(n)$, y $g(n) = 4 n + Theta(log n)$. Demostrar que $f g in O(n^3)$.
]
#demo[
Por definición, existen funciones $h_1 in O(n)$ y $h_2 in Theta(log n)$ tales que $f(n) = 2n^2 + h_1(n)$ y $g(n) = 4n + h_2(n)$.

Luego:
$
  f(n) g(n) &= (2n^2 + h_1(n))(4n + h_2(n)) \
            &= 8n^3 + 2n^2 h_2(n) + 4n h_1(n) + h_1(n) h_2(n)
$

Ahora debemos probar que cada término está en $O(n^3)$:
- $8n^3 in O(n^3)$ por la @prop:asim_mul.
- Como $h_1 in O(n)$, entonces $4n h_1 in O(n dot n) = O(n^2) subset.eq O(n^3)$ por el @ej:asim_prod.
- Como $h_2 in Theta(log n) subset.eq O(log n)$, entonces $2n^2 h_2 in O(n^2 log n) subset.eq O(n^3)$ por el @ej:asim_prod, pues $log n in O(n)$.
- Como $h_1 in O(n)$ y $h_2 in O(log n)$, entonces $h_1 h_2 in O(n log n) subset.eq O(n^2) subset.eq O(n^3)$ por el @ej:asim_prod.

Por lo tanto, $f g in O(n^3)$.
]

/*Vamos a querer hacer operaciones algebraicas con estos conjuntos de funciones, como sumarlos y multiplicarlos. Esto nos va a permitir combinarlos y decir cosas más poderosas.

#def[
Sean $A, B$ conjuntos de funciones $NN arrow RR0$, y $k in RR0$. Definimos:

- $A + B = {h: NN arrow RR0 | exists f in A, g in B, forall n in NN. h(n) = f(n) + g(n)}$
- $A B = {h: NN arrow RR0 | exists f in A, g in B, forall n in NN. h(n) = f(n) g(n)}$
- $k A = {h: NN arrow RR0 | exists f in A, forall n in NN. h(n) = k f(n)}$
]

Esto nos permite usar expresiones como $O(f) + 3 O(g)$. Veamos algunas formas simples de trabajar con estos conjuntos:

#prop[
Sean $f, g: NN arrow RR0$. Entonces $O(f) + O(g) = O(f + g)$.
]
#demo[
  - $subset.eq)$ Sea $h in O(f) + O(g)$. Por definición, existen $a in O(f)$ y $b in O(g)$, tal que para todo $n in NN$, $h(n) = a(n) + b(n)$. Como $a in O(f)$ y $b in O(g)$, entonces existen $alpha in RRg0, beta in RRg0, n_0 in NN, m_0 in NN$ tales que para todo $n in NN, (n gt.eq n_0 implies a(n) lt.eq alpha f(n))$, y para todo $m in NN$, $(m gt.eq m_0 implies b(m) lt.eq beta g(m))$. Sea entonces $p_0 = max(n_0, m_0) in NN$, y $gamma = alpha + beta$. Entonces, para todo $p in NN, p gt.eq p_0$, tenemos que
  
    $
  h(n) &= a(n) + b(n)\
       &lt.eq alpha f(n) + beta g(n)\
       &lt.eq (alpha + beta) (f(n) + g(n)) \
       &= gamma (f(n) + g(n)) \
       &= gamma (f + g) (n)
    $
    y por lo tanto $h in O(f + g)$.
  - $supset.eq)$ Sea $h in O(f + g)$. Entonces, existen $alpha in RRg0, n_0 in NN$ tales que para todo $n in NN, (n gt.eq n_0 implies h(n) lt.eq alpha (f + g)(n))$. Vamos a definir las siguientes funciones:
  
    $
      a(n) &= cases(
        (h(n) f(n))/(f(n) + g(n)) & "si" f(n) + g(n) eq.not 0,
        0 & "si" f(n) + g(n) = 0)\
      b(n) &= cases(
        (h(n) g(n))/(f(n) + g(n)) & "si" f(n) + g(n) eq.not 0,
        0 & "si" f(n) + g(n) = 0)
    $
  
    Notemos que para todo $n in NN$, $h(n) = a(n) + b(n)$. Ahora, veamos que $a in O(f)$ y $b in O(g)$. Sea $n gt.eq n_0$. Si $f(n) + g(n) eq.not 0$, entonces:
  
    $
      a(n) & = (h(n) f(n))/(f(n) + g(n)) h(n) \
           & lt.eq (alpha (f + g)(n) f(n))/(f(n) + g(n)) \
           & = alpha f(n)
    $
  
    Si $f(n) + g(n) = 0$, entonces $f(n) = 0$, y luego $a(n) = 0 lt.eq alpha f(n)$. Luego, en ambos casos, $a lt.eq alpha f(n)$ para todo $n gt.eq n_0$, y por lo tanto $a in O(f)$.
  
    De forma análoga, podemos ver que $b in O(g)$.
  
    Luego, como $h(n) = a(n) + b(n)$ para todo $n in NN$, con $a in O(f)$ y $b in O(g)$, tenemos que $h in O(f) + O(g)$.
]

Esto nos da un corolario que vamos a usar mucho:
#corollary[
Sean $f: NN arrow RR0$, y $g in O(f)$. Entonces $O(f) + O(g) = O(f)$.
]

#example[$O(n^2) + O(n) = O(n^2)$]
#example[$O(2^n) + O(n^3) + O(log n) = O(2^n)$.]

#prop[
Sean $f, g: NN arrow RR0$. Entonces $O(f) O(g) = O(f g)$.
]
#demo[
- $subset.eq)$ Sean $a in O(f)$, y $b in O(g)$. Por definición, existen $alpha in RRg0, beta in RRg0, n_0 in NN, m_0 in NN$ tales que para todo $n in NN, (n gt.eq n_0 implies a(n) lt.eq alpha f(n))$, y para todo $m in NN$, $(m gt.eq m_0 implies b(m) lt.eq beta g(m))$. Sea entonces $p_0 = max(n_0, m_0) in NN$, y $gamma = alpha beta$. Entonces, para todo $p in NN, p gt.eq p_0$, tenemos que

  $
    (a b)(n) & = a(n) b(n) \
             & lt.eq (alpha f(n)) (beta g(n)) \
             & = gamma (f(n) g(n)) \
             & = gamma (f g)(n)
  $

  y por lo tanto $a b in O(f g)$. Como $O(f)O(g)$ es precisamente el conjunto de funciones de la forma $a b$ con $a in O(f)$ y $b in O(g)$, tenemos que $O(f) O(g) subset.eq O(f g)$.
- $supset.eq)$ Sea $h in O(f g)$. Luego, existen $alpha in RR, alpha >0$, y $n_0 in NN$, tal que para todo $n in NN$, $(n gt.eq n_0 implies h(n) lt.eq alpha (f g)(n) = alpha f(n)g(n)$. Sean $a = f$, y $b: NN arrow RR0$, definida como:
  $
    b(n) = cases(
      h(n)/f(n) & "si" f(n) eq.not 0,
      0 & "si" f(n) = 0
    )
  $

  Vemos que $h(n) = a(n) b(n)$ para todo $n in NN$. Ahora, veamos que $a in O(f)$ y $b in O(g)$. Claramente, $a = f in O(f)$. Sea $n in NN$, con $n gt.eq n_0$. Si $f(n) = 0$, entonces $b(n) = 0 lt.eq g(n)$. Si $f(n) eq.not 0$, entonces:

  $
    b(n) & = h(n)/f(n) \
         & lt.eq (alpha (f g)(n))/f(n) \
         & = alpha g(n) 
  $

  Luego $b in O(g)$. Como $h(n) = a(n) b(n)$ para todo $n in NN$, con $a in O(f)$ y $b in O(g)$, tenemos que $h in O(f) O(g)$.
]

#prop[
Sean $f: NN arrow RR0$, y $k in RR0$. Entonces $k O(f) = O(k f)$.
]
#demo[
- $subset.eq)$ Sea $h in k O(f)$. Entonces, existe $a in O(f)$, tal que para todo $n in NN$, $h(n) = k a(n)$. Como $a in O(f)$, existen $alpha in RRg0$, y $n_0 in NN$, tales que para todo $n in NN, (n gt.eq n_0 implies a(n) lt.eq alpha f(n))$. Entonces, para todo $n gt.eq n_0$, tenemos que 

  $
    h(n) & = k a(n) \
         & lt.eq k (alpha f(n)) \
         & = (k alpha) f(n) \
         & = (alpha (k f))(n)
  $

  Luego, $h in O(k f)$.
- $supset.eq)$ Sea $h in O(k f)$. Entonces, existen $alpha in RRg0$, y $n_0 in NN$, tales que para todo $n in NN, (n gt.eq n_0 implies h(n) lt.eq alpha (k f)(n) = alpha k f(n))$. Definamos la función $a: NN arrow RR0$, como $a(n) = h(n)/k$ (si $k eq.not 0$), o $a(n) = 0$ (si $k = 0$). Entonces, para todo $n in NN$, tenemos que $h(n) = k a(n)$. Ahora, veamos que $a in O(f)$. Sea $n gt.eq n_0$. Si $k = 0$, entonces $a(n) = 0 lt.eq alpha f(n)$. Si $k eq.not 0$, entonces:

  $
    a(n) & = h(n)/k \
         & lt.eq (alpha k f(n))/k \
         & = alpha f(n)
  $

  Luego, en ambos casos, $a in O(f)$. Como $h(n) = k a(n)$ para todo $n in NN$, con $a in O(f)$, tenemos que $h in k O(f)$.
]

#prop[
Demostraciones prácticamente idénticas nos dan las siguientes propiedades:
- $Omega(f) + Omega(g) = Omega(f + g)$
- $Omega(f) Omega(g) = Omega(f g)$
- $k Omega(f) = Omega(k f)$
- $Theta(f) + Theta(g) = Theta(f + g)$
- $Theta(f) Theta(g) = Theta(f g)$
- $k Theta(f) = Theta(k f)$
]

Finalmente, vamos a extender nuestra notación para poder operar con funciones y conjuntos en la misma expresión.

#def[
Sean $f, g: NN arrow RR0$. Definimos:
- $f + O(g) = {f + h | h in O(g)}$
- $f O(g) = {f h | h in O(g)}$
]

#prop[
Sean $f, g: NN arrow RR0$. Entonces:
- $f + O(g) subset.eq O(f + g)$
- $f O(g) = O(f g)$
]
#demo[
- $f + O(g) subset.eq O(f + g)$: Sea $h in f + O(g)$. Entonces, existe $a in O(g)$, tal que para todo $n in NN$, $h(n) = f(n) + a(n)$. Como $a in O(g)$, existen $alpha in RRg0$, y $n_0 in NN$, tales que para todo $n in NN, (n gt.eq n_0 implies a(n) lt.eq alpha g(n))$. Entonces, para todo $n gt.eq n_0$, tenemos que

  $
    h(n) & = f(n) + a(n) \
         & lt.eq f(n) + alpha g(n) \
         & lt.eq (1 + alpha) f(n) + (1 + alpha) g(n) \
         & "pues "alpha > 0", y luego "1 + alpha > 1 \
         & lt.eq (1 + alpha) (f(n) + g(n)) \
         & = (1 + alpha) (f + g)(n)
  $

  y por lo tanto $h in O(f + g)$.
- $f O(g) = O(f g)$: Esta demostración es el ejercicio @bigoprod.
]


#warning-box[
Notemos que en general no vale la igualdad $f + O(g) = O(f + g)$. Por ejemplo, si $f(n) = n^2$, y $g(n) = n$, entonces el lado derecho, $O(f + g) = O(f) + O(g) = O(n^2) + O(n) = O(n^2)$, pero el lado izquierdo, $f + O(g)$ contiene sólo funciones de la forma $n^2 + j(n)$, con $j in O(n)$. Una función como $h(n) = 2n^2$ está en $O(n^2)$, pero no está en $f + O(g)$, pues no es posible encontrar una tal función $j$.
]

Tenemos entonces las siguientes propiedades:

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    inset: 5pt,
    align: center + horizon,
    stroke: 0.5pt + gray,
    
    table.header(
      [*Operación*], 
      [*$O$ (Cota superior)*], 
      [*$Omega$ (Cota inferior)*], 
      [*$Theta$ (Orden exacto)*]
    ),

    [*Suma*],
    $ O(f) + O(g) \ = O(f + g) \ = O(max(f, g)) $,
    $ Omega(f) + Omega(g) \ = Omega(f + g) \ = Omega(max(f, g)) $,
    $ Theta(f) + Theta(g) \ = Theta(f + g) \ = Theta(max(f, g)) $,

    [*Producto*],
    $ O(f) dot O(g) \ = O(f dot g) $,
    $ Omega(f) dot Omega(g) \ = Omega(f dot g) $,
    $ Theta(f) dot Theta(g) \ = Theta(f dot g) $,

    [*Escalar* \ (para $k > 0$)],
    $ k dot O(f) = O(f) $,
    $ k dot Omega(f) = Omega(f) $,
    $ k dot Theta(f) = Theta(f) $,
  ),
  caption: [Resumen de propiedades algebraicas asintóticas.]
) <tabla-algebra-asintotica>
*/
=== Errores frecuentes

Es muy común que se confundan con esta notación. A continuación les voy a dar algunas demostraciones incorrectas. Presten mucha atención, intenten ver dónde exactamente les estoy mintiendo.

#propf[
Sea $g: NN arrow RR0$, con $g(n) = 2^n$. Entonces $g in O(1).$
]
#demof[
Es fácil ver que $O(1) dot O(1) = O(1)$. Luego, por inducción, tendremos $product_(i=1)^n O(1) = O(1)$.

Sea $f: NN arrow NN, f(m) = 2$ para todo $m in NN$. Claramente $f in O(1)$. Luego, $(product_(i=1)^n f) in product_(i=1)^n O(1) = O(1)$. Asimismo, si llamamos $g(n) = product_(i=1)^n f(n)$, tendremos que $g(n) = product_(i=1)^n 2 = 2^n$. Por lo tanto, $2^n in O(1)$.
]
Esto es obviamente incorrecto. Es cierto que $O(1) dot O(1) = O(1)$. Y también es cierto que para todo $k in NN$ _fijo_, tenemos que $product_(i=1)^k O(1) = O(1)$. Recordemos qué significa que $h in O(1)$: Existen constantes $alpha in RRg0, n_0 in NN$, tal que $h(n) lt.eq alpha$ para todo $n gt.eq n_0$. Para cada $k in NN$, vamos a tener dos tales constantes. Lo que _no_ vamos a tener, son dos constantes que valgan para _todo_ $k$ al mismo tiempo.

Lo que la inducción nos da es, para cada $k in NN$, una constante $alpha_k$ tal que el producto de $k$ funciones acotadas por $2$, está acotado por $alpha_k 2^k$. Si $k$ es una constante, esto es realmente una inclusión en el conjunto $O(1)$. Pero si tomamos a $n$ como variable, el que exista una constante $alpha$ tal que podemos acotar al producto de las $n$ funciones por $alpha 2^n$ _no_ implica que este producto está en $O(1)$, pues la cota resultante _es una función de $n$_, no una constante. Veamos otra demostración que tiene el mismo error, y esta parecería ser "obvia".

#prop[
Sea $T(n) = sum_(i=1)^n (i + O(1))$. Entonces $T in O(n^2)$.
]
#demof[
Por definición, para cada $i$ en $[1, dots, n]$, existe una función $h_i in O(1)$ tal que el $i$-ésimo término de la suma es $i + h_i (n)$.

Luego:
$
  T(n) &= sum_(i=1)^n i + h_i (n) \
       &= sum_(i=1)^n i + sum_(i=1)^n h_i (n)
$

Para el primer término, sabemos que $sum_(i=1)^n i = (n(n+1))/2 = (n^2 + n)/2 in Theta(n^2) subset.eq O(n^2)$.

Para el segundo término, como cada $h_i in O(1)$, existen $alpha_i > 0$ y $n_i in NN$ tales que para todo $i$, para todo $n gt.eq n_i$, $h_i (n) lt.eq alpha_i$. Sea $alpha = max{alpha_1, alpha_2, ..., alpha_n}$ y $m_0 = max{n_1, n_2, ..., n_n}$. Entonces, para todo $n gt.eq m_0$:
$
  sum_(i=1)^n h_i (n) lt.eq sum_(i=1)^n alpha = n alpha in O(n) subset.eq O(n^2)
$

Por lo tanto, $T in O(n^2)$.
]

Este razonamiento es incorrecto. Para verlo, basta tomar $h_i (n) = i^3$ para cada $i in [1, dots, n]$, una función constante (no depende de su argumento), y por lo tanto $h_i in O(1)$. Entonces $T(n) = sum_(i=1)^n i + sum_(i=1)^n h_i (n) = n(n+1)/2 + sum_(i=1)^n i^3 = n(n+1)/2 + (n(n+1)/2)^2 in Omega(n^4)$, que tiene intersección nula con $O(n^2)$. El error en la demostración es que $m_0$ y $alpha$ _dependen de n_ (son un máximo de $n$ cosas). La definición de $O(dots)$ requiere que sean _constantes_.

Esto nos muestra una sutileza sobre la notación asintótica. Al usar la expresión "$O(dots)$" en un contexto como el de esa sumatoria, donde hay dos variables libres ($i$ y $n$) en vez de sólo una, no está claro con respecto a cuál variable estamos diciendo que varía nuestra función. A priori, en un término así podemos usar ambas, teniendo una función de varias variables. Más adelante veremos notación asintótica con múltiples variables. Por ahora, para probar lo que queremos que valga, vamos a pedir que para todo $n$, y vamos a querer que $O(1)$ en esa sumatoria signifique una función $g: NN times NN arrow RR0$, donde la sumatoria es de la forma $T(n) = sum_(i=1)^n i + g(i, n)$, y existe una constante $alpha in RR$ tal que para todo $n in NN$, y para todo $1 lt.eq i lt.eq n$, $g(i, n) lt.eq alpha$. Esto nos va a permitir la siguiente demostración.

#demo[
Sea $g: NN times NN arrow RR0$, tal que existe $alpha in RR$ tales que para todo $n in NN$ y para todo $1 lt.eq i lt.eq n$, $g(i, n) lt.eq alpha$. Luego:

$
  T(n) &= sum_(i=1)^n i + g(i, n) \
       &= sum_(i=1)^n i + sum_(i=1)^n g(i, n) \
       &lt.eq sum_(i=1)^n i + sum_(i=1)^n alpha \
       &= (n(n+1))/2 + alpha n
$

Por lo tanto, $T in O(n^2)$.
]



#propf[
Sea $T: NN arrow RR0$, definida por:
$
  T(n) = cases(
    0 &"si" n = 0,
    T(n - 1) + 1 &"si" n > 0
  )
$

Entonces $T in O(1)$.
]
#demof[
Probemos esto por inducción en $n$.
- Caso base. $T(0)$ es una constante, luego está en $O(1)$.
- Paso inductivo, $n > 0$. Asumimos que $T(k) in O(1)$ para todo $k < n$, queremos ver que $T(n) in O(1)$. Como $n > 0$, $T(n) = T(n - 1) + 1$. Como $n - 1 < n$, por hipótesis inductiva $T(n - 1) in O(1)$. Luego, como $O(1) + 1 = O(1)$, tenemos que $T(n) in O(1).$

Asimismo, vemos que $T(n) = n$, y por lo tanto, $n in O(1)$.
]


#let t = [Esto es un sinsentido. Empezamos diciendo sinsentidos al decir "$T(0)$ es una constante, luego está en O(1)". Recordemos, *$O(1)$ es un conjunto de funciones*. Mientras tanto, $T(0)$ es un número, es cero. De ninguna manera vamos a tener que $T(0)$ está en $O(1)$, es como decir que un elefante está en un conjunto de jirafas: no tipa.]
#let img = image("/images/jirafas.png", width: 100%)
#wrap-content(img, t, align: bottom + right)

Luego seguimos con la confusión al decir $T(k) in O(1)$. Nada de esto tiene sentido, y no tiene sentido hablar de "$T(n) in O(1)$". He visto alumnos que se confunden entre $f$, una función, y $f(x)$, el resultado de evaluar una función en un punto, $x$. Hasta algunos libros fomentan esa confusión. En este caso, esa confusión nos dejó decir sinsentidos.

Veamos cómo podríamos demostrar algo sobre esta función.

#prop[
Sea $T: NN arrow RR0$, definida por:
$
  T(n) = cases(
    0 &"si" n = 0,
    T(n - 1) + 1 &"si" n > 0
  )
$

Entonces $T in O(n)$.
]
#demo[
Vamos a mostrar que existen constantes $alpha in RRg0, n_0 in NN$, tal que para todo $n in NN$, $(n gt.eq n_0) implies T(n) lt.eq alpha n$. En particular, vamos a probar por inducción que $n_0 = 0, alpha = 1$ funcionan.

Formalmente, sea $P(k): (k gt.eq n_0) implies T(k) lt.eq k$.

- Caso base, $P(0)$. Tenemos que probar que $(0 gt.eq n_0) implies T(0) lt.eq 0$. Esto es cierto porque la conclusión es cierta, $0 = T(0) lt.eq 0 = 0$.
- Paso inductivo. Tenemos $k in NN$. Asumimos $P(k)$, queremos probar $P(k + 1)$. Luego, queremos probar que $(k+1 gt.eq n_0) implies T(k+1) lt.eq (k + 1)$. Para probar una implicación, podemos asumir la premisa, y luego $k + 1 gt.eq n_0$. Como $k + 1 gt.eq n_0$, con más razón $k gt.eq n_0$. Ahora expandimos $T(k+1) = T(k) + 1$. Por hipótesis inductiva, como $k gt.eq n_0$, tenemos que $T(k) lt.eq k$. Juntando, tenemos que $T(k+1) lt.eq k + 1$, que es lo que queríamos demostrar.

Luego, $T(k) lt.eq k$ para todo $k in NN$. Esto es precisamente la definición de que $T in O(n)$, usando $n_0 = 0, alpha = 1$.
]

#propf[
Sea $f: NN arrow RR0$ una función. Entonces $f in O(1)$.
]
#demof[
Sea $g: NN arrow RR0$, $g(n) = f(n) + n$. Como $f(n) gt.eq 0$ para todo $n in NN$, tenemos que $g(n) gt.eq n$ para todo $n in NN$. Por lo tanto, $g in Omega(n)$, con lo cual $n in O(g)$. Ahora bien, $f(n) = g(n) - n$, y luego $f in O(g) - O(g) = O(g - g) = O(0) subset.eq O(1)$. Por lo tanto, $f in O(1)$.
]

La resta de conjuntos asintóticos no funciona así. El que algo esté en $O(g)$ no significa que _sea_ $g$. El que $n in O(g)$ no significa que al restar $f - n$ estamos restando $f - g$, y poner $O(dots)$ al rededor no lo hace cierto. Notemos acá cómo usamos $n in O(g)$ para querer decir que si $h(n) = n$, entonces $h in O(g)$. Recordemos que $O(dots)$ es un conjunto de funciones, no de números, ni variables.

Por útlimo, veamos una propiedad que a veces quieren que valga.

#propf[
Sean $f, g, h: NN arrow RR0$. Si $f in Theta(g)$, entonces $h compose f in Theta(h compose g)$.
]
Esto no es cierto, y basta tomar $f(n) = 2n$, $g(n) = n$, y $h(n) = 2^n$. $f$ y $g$ son asintóticamente equivalentes. Sin embargo $(h compose f)(n) = 2^(2n) = (2^n)^2$ no es asintóticamente equivalente a $(h compose g)(n) = 2^n$.

=== Ejercicios

#ej[
Sea $k in NN$ una constante fija. Probar que si $f_1, f_2, dots, f_k in O(1)$, entonces $product_(i=1)^k f_i in O(1)$.

Explicar por qué este resultado *no* implica que $2^n in O(1)$.
]

#ej[
Sea $T: NN arrow RR0$ definida por $T(n) = sum_(i=1)^n i^2$. Probar que $T in Theta(n^3)$.
]

#ej[
Sea $f: NN arrow RR0$ tal que $f(n) = n + (-1)^n n$. Determinar si $f in O(n)$, $f in Omega(n)$, y/o $f in Theta(n)$. Demostrar las tres cosas.
]

#ej[
Sean $f, g: NN arrow RR0$ tales que $f in Theta(g)$. Probar que $2^f in.not Theta(2^g)$ en general, dando un contraejemplo explícito.
]

#ej[
Sean $f, g, h: NN arrow RR0$ con $g(n) gt.eq 1$ para todo $n$. Probar que si $f in O(g)$ y $h in O(g)$, entonces $f - h in O(g)$.

Mostrar que *no* es cierto que $f - h in O(g - g) = O(0)$.
]

#ej[
Sea $f: NN arrow RR0$ definida por $f(n) = floor(log_2(n+1))$. Probar que $f in Theta(log n)$.
]

#ej[
Sea $f: NN arrow RR0$ tal que $f(n) = 3n^2 + O(n)$. Probar que $f^2 in 9n^4 + O(n^3)$.
]

#load-bib()