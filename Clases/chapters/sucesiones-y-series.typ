
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Sucesiones y series

Esta sección contiene varios ejercicios resueltos sobre sumatorias. Asumo que han visto sumatorias antes, y por ende no voy a explicar qué son o qué significa la notación $sum$. Para alumnos interesados en aprender más, recomiendo @concrete.
#ej[
  Sea $n in NN$. Demostrar que $sum_(i = 0)^n (2i + 1) = (n + 1)^2$.
]
#demo[
  Vamos a probar esto por inducción, $P(n): sum_(i = 0)^n (2i + 1) = (n + 1)^2$.
  - $P(0)$. El lado izquierdo de la ecuación es $sum_(i=0)^0 (2i + 1) = 2 times 0 + 1 = 1$. El lado derecho es $(0 + 1)^2 = 1$. Luego, vale $P(0)$.
  - Sea $n in NN$. Queremos ver que $P(n) implies P(n+1)$. Luego, vamos a asumir $P(n)$, y vamos a ver $P(n+1)$. Ver $P(n+1)$ es que $sum_(i = 0)^(n+1) (2i + 1) = (n + 2)^2$. Razonemos entonces:
    $
      sum_(i = 0)^(n+1) (2i + 1) & = 2(n+1)+1 + sum_(i = 0)^n (2i + 1) \
                                 & = 2(n+1)+1 + (n+1)^2", usando "P(n) \
                                 & = 2n + 2 + 1 + (n+1)^2 \
                                 & = 1^2 + 2 times (n+1) times 1 + (n+1)^2 \
                                 & = ((n+1) + 1)^2 \
                                 & = (n+2)^2
    $

    que es lo que queríamos demostrar.
  Luego, vale $P(n)$ para todo $n in NN$.
]

#ej[
  Demostrar que para todo $n in NN, n gt.eq 5$, tenemos $2^n > n^2$.
]
#demo[
  Vamos a demostrar la propiedad $P(n): n gt.eq 5 implies 2^n > n^2$, por inducción. Para $n < 5$, la demostración es trivial, puesto que no hay nada que probar ("falso implica todo"). Luego vamos a empezar nuestra inducción con $n = 5$ como caso base.
  - $P(5)$: Vemos que $2^5 = 32$, mientras que $5^2 = 25$, con lo cual efectivamente $2^5 > 5^2$, que es $P(5)$.
  - Sea $n in NN$. $P(n) implies P(n+1)$: Si $n lt.eq 4$, vimos que $P(n+1)$, sea porque la premisa de $P(n+1)$ es falsa cuando $n < 3$, o porque $P(5)$ es cierto porque lo probamos arriba, cuando $n = 4$. Luego asumimos $n gt.eq 5$. Por un lado, tenemos $2^(n+1) = 2 (2^n) > 2 n^2$, donde usamos $P(n)$ y $n gt.eq 5$ para obtener la desigualdad, mediante la conclusión de $P(n)$. Por el otro, $(n+1)^2 = n^2 + 2n + 1$. Si probamos que $2n^2 > n^2 + 2n + 1$, tendremos que $2^(n+1) > (n+1)^2$.

    $
              2n^2 & > n^2 + 2n + 1 \
      n^2 - 2n - 1 & > 0
    $

    Consideremos ahora el polinomio $f(x) = x^2 - 2x - 1$. Lo podemos factorizar como $f(x) = (x - (1 + sqrt(2)) (x - (1 - sqrt(2))$, es decir que sus raíces son $a = 1 - sqrt(2)$, y $b = 1 + sqrt(2)$. Como el coeficiente principal de $f(x)$ es 1, $f$ es positiva en $(-infinity, a)$, es negative en $(a, b)$, y es positiva en $(b, infinity)$.

    #align(center)[
      #canvas({
        plot.plot(
          axis-style: "school-book",
          y-label: "",
          x-label: $x$,
          y-tick-step: none,
          size: (8, 4),
          legend-anchor: "east",
          axis-layer: 2,
          {
            plot.add(x => x * x - 2 * x - 1, domain: (-5, 5), label: $f(x) = x^2 - 2x - 1$)
            plot.annotate({
              //draw.rect((-5, 0), (1-calc.sqrt(2), 35), fill: rgb(50,50,200,50), stroke: none)
              //draw.rect((1+calc.sqrt(2), 0), (5, 35), fill: rgb(50,50,200,50), stroke: none)
            })
          },
        )
      })]

    Como $n gt.eq 5 > b = 1 + sqrt(5)$, tendremos que $f(n) > 0$, y luego $n^2 - 2n - 1 > 0$, es decir, $2n^2 > n^2 + 2n + 1$. Como dijimos, esto implica que $2^(n+1) > (n+1)^2$, lo cual prueba $P(n+1)$.
]

#ej[
  Sea $(a_n)_(n in NN)$ la sucesión dada por $a_0 = 1$, y para todo $n in NN$, $n > 0$, $a_n = 2 (n-1) a_(n-1) + 2^n (n-1)!$.

  Demostrar que para todo $n in NN$, $n > 0$, $a_n = 2^n n!$.
]
#demo[
  Como toda sucesión definida recursivamente, tenemos una estructura inductiva. Luego, intentemos probar esto por inducción. La proposición que vamos a probar es $P(n): a_n = 2^n n!$.

  + $P(0)$: Si $n = 0$, entonces queremos ver $P(0)$, es decir que $a_0 = 2^0 1! = 1$. Esto es cierto, porque por definición $a_0 = 1$.

  + $P(n) implies P(n+1)$. Queremos probar que $a_(n+1) = 2^(n+1) (n+1)!$. Sabemos que $a_(n+1) = 2 n a_n + 2^(n+1) n!$. Como vale $P(n)$, podemos reemplazar $a_n$ por $2^n n!$. Luego, sabemos que $a_(n+1) = 2 n (2^n n!) + 2^(n+1) n! = 2^(n+1)(n n! + n!) = 2^(n+1)n!(n+1) = 2^(n+1) (n+1)!$, que es lo que queríamos demostrar.
]

#ej(title: "Series geométricas")[
  Sean $n in NN$, y $a in CC, a eq.not 1$. Probar que

  $
    sum_(i = 0)^n a^i = (a^(n+1) - 1)/(a-1)
  $
]
#demo[
  Vamos a probar esto mediante una serie de manipulaciones a esa ecuación, teniendo cuidado de que cada una sea un si-y-sólo-si.

  $
                                              sum_(i=0)^n a^i & = (a^(n+1) - 1)/(a-1) \
                                      (a - 1) sum_(i=0)^n a^i & = a^(n+1) - 1 \
                        a (sum_(i=0)^n a^i) - sum_(i=0)^n a^i & = a^(n+1) - 1 \
                    1 + sum_(i=1)^(n+1) a^i - sum_(i=0)^n a^i & = a^(n+1) \
      sum_(i=0)^0 a^i + sum_(i=1)^(n+1) a^i - sum_(i=0)^n a^i & = a^(n+1) \
                        sum_(i=0)^(n+1) a^i - sum_(i=0)^n a^i & = a^(n+1) \
    sum_(i=n+1)^(n+1) a^i + sum_(i=0)^n a^i - sum_(i=0)^n a^i & = a^(n+1) \
                                                      a^(n+1) & = a^(n+1)
  $

  Como llegamos a algo cierto a través de manipulaciones reversibles, cada paso puede ser revertido para empezar con $a^(n+1) = a^(n+1)$ y concluir con $sum_(i=0)^n a^i &= (a^(n+1) - 1)/(a-1)$.

  Notar que para revertir la multiplicación por $a - 1$ que hacemos para ir de la primer ecuación a la segunda, estamos usando que $a eq.not 1$.
]


#ej[
  Sea la sucesión $(a_n)_(n in NN)$ definida como $a_0 = 1$, y para todo $n in NN, n > 0$, $a_n = 4 a_(n-1) - 2 ((2n-2)!)/(n! (n-1)!)$. Probar que para todo $n in NN$, $a_n = binom(2n, n)$.
]
#demo[
  Nuevamente, vamos a usar inducción, porque $(a_n)$ tiene una estructura inductiva (es decir, está definida recursivamente).

  Vamos a probar la proposición $P(n): a_n = binom(2n, n)$, para todo $n in NN$. Recordemos que $binom(a, b) = a!/(b! (a - b)!)$, para todo $a, b in NN$.

  Sea $n in NN$.
  + Si $n = 0$, entonces queremos ver $P(0)$, que es $a_0 = binom(0, 0) = 0! / (0! 0!) = 1 / 1 = 1$, y esto es cierto pues definimos $a_0 = 1$.
  + Si $n > 0$, entonces podemos usar la hipótesis inductiva en $n - 1$, y sabemos $P(n-1)$. Esto nos dice que $a_(n-1) = binom(2(n-1), n - 1)$. Queremos ver $P(n+1)$, es decir, que $a_n = binom(2n, n)$. Como sabemos por definición que $a_n = 4 a_(n-1) - 2 ((2n-2)!)/(n! (n-1)!)$, podemos reemplazar lo que sabemos es $a_(n-1)$ acá, y sabemos luego que $a_n = 4 binom(2(n-1), n-1) - 2 ((2n-2)!)/(n! (n-1)!)$.

  $
    a_n & = 4 binom(2n - 2, n - 1) - 2 (2n - 2)!/(n! (n-1)!) \
        & = 4 (2n - 2)! / ((n-1)! (n - 1)!) - (2n - 2)! / (n! (n -1)!) \
        & = (2n - 2)!/(n-1)! (4/(n-1)! - 2 /n!) \
        & = (2n - 2)!/(n-1)! ((4n!)/(n!(n-1)!) - (2(n-1)!)/(n!(n-1)!)) \
        & = (2n - 2)!/(n-1)! (4n (n-1)! - 2(n-1)!)/(n!(n-1)!) \
        & = (2n - 2)!/(n-1)! (4n - 2)/(n!) \
        & = 2 (2n - 2)!/(n-1)! (2n - 1)/(n!) \
        & = 2 (2n - 1)!/(n!(n-1)!) \
        & = 2 binom(2n - 1, n) \
        & = binom(2n - 1, n) + binom(2n - 1, n) \
        & = binom(2n - 1, n) + binom(2n - 1, 2n - 1 - n) ", pues "binom(a, b) = binom(a, a-b) \
        & = binom(2n - 1, n) + binom(2n - 1, n - 1) \
        & = binom(2n, n) ", pues" binom(a, b) + binom(a, b - 1) = binom(a + 1, b)
  $
  que es lo que queríamos demostrar.
]

/*
FIXME: Esto va a ir a una sección de análisis estocástico, junto con algoritmos estocásticos. Por ahora lo saco para que no tengan miedo.

#ej[
  Estamos pensando en una estrategia de inversión. Tenemos un fondo que crece, en valor esperado, $alpha - 1$ cada mes. Por ejemplo, si $alpha = 1.1$, nuestro fondo crece en valor esperado un 10% por mes. Asumiendo que empezamos con $c$ pesos en nuestra cuenta, y cada mes compramos $b$ pesos más de este fondo, ¿cuál es el valor de los fondos que esperamos tener luego de $k$ meses? ¿Qué necesitan asumir para encontrar este valor?
]
El objetivo de este ejercicio no es que hagan cuentas, sino que entiendan cómo descubrir qué están asumiendo cuando hacen cuentas.
#demo[Sea $a_i$ el retorno del $i$-ésimo mes. Sabemos que $EE[a_i] = alpha$.
  Podemos definir la siguiente sucesión:
  $
    T(0) & = c \
    T(n) & = b + a_n T(n - 1)
  $

  Queremos encontrar $EE[T(n)]$. Veamos cómo se comporta esta función. $EE[T(1)] = EE[b + a_1 c] = b + alpha c$, usando linearidad de esperanza, y que $b$ y $c$ son constantes. Para su segundo valor, $EE[T(2)] = EE[b + a_2 T(1)] = b + EE[a_2 T(1)]$. Nos gustaría decir que esto es $b + EE[a_2] EE[T(1)]$, pero acá debemos asumir que $a_2$ y $T(1)$ son independientes. *Para esto tenemos que asumir que los retornos ${a_i}$ son independientes de a pares*. Es decir, $EE[a_i a_j] = EE[a_i] EE[a_j] = alpha^2$ para todo $i, j$. Luego, tenemos
  $
    EE[T(2)] & = b + EE[a_2 (b + a_1 c)] \
             & = b + EE[a_2 b + a_2 a_1 c] \
             & = b + b EE[a_2] + c EE[a_2 a_1] \
             & = b + b alpha + c alpha^2
  $
  Veamos qué pasa para $n = 3$.
  $
    EE[T(3)] & = EE[b + a_3 T(2)] \
             & = b + EE[a_3 T(2)]
  $
  Acá no podemos decir que $EE[a_3 T(2)] = EE[a_3] E[T(2)]$ porque no sabemos si $a_3$ y $T(2)$ están correlacionados. Veamos qué pasa si expandimos $T(2)$ por definición:

  $
    EE[T(3)] & = b + EE[a_3 T(2)] \
             & = b + EE[a_3 (b + a_2 T(1))] \
             & = b + EE[a_3 b + a_3 a_2 T(1)] \
             & = b + b alpha + EE[a_3 a_2 T(1)] \
             & = b + b alpha + EE[a_3 a_2 (b + a_1 c)] \
             & = b + b alpha + EE[a_3 a_3 b + a_3 a_2 a_1 c] \
             & = b + b alpha + b alpha^2 + c EE[a_3 a_2 a_1] \
  $

  El saber que los $a_i$ no están correlacionados de a pares no nos deja decir que no estén correlacionados de a triplas. Luego, para seguir acá vamos a necesitar asumir *que los ${a_i}$ son independientes de a triplas*, así como también lo que habíamos asumido antes, que son independientes de a pares.

  Si asumimos eso, concluímos $EE[T(3)] = b + b alpha + b alpha^2 + c alpha^3$.

  Conjeturamos, entonces, que $EE[T(n)] = alpha^n c + sum_(i=0)^(n-1) alpha^i b$, si asumimos que *los ${a_i}$ son independientes tomados de a conjuntos de tamaño menor o igual a $n$*.

  Tenemos que tener cuidado al hacer inducción, entonces. Si quisieramos probar la proposición $Q(n): EE[T(n)] = alpha^n c + sum_(i=0)^(n-1) alpha^i b$, en algún momento vamos a tener $EE[a_n T(n)]$, y no vamos a poder llegar a mucho si sólo tenemos eso, porque no sabemos que $a_n$ y $T(n)$ son independientes. Entonces, vamos a tener que ser precisos, y reescribir $T$ de manera que podamos usar la independencia de los ${a_i}$.

  Expresemos, entonces, $T(n)$, de una manera que nos deje usar esta independencia. Vimos que $T(3) = b + b a_3 + b a_3 a_2 + c a_3 a_2 a_1$. Luego, definamos $S_(i, n) = product_(i lt j lt.eq n) a_j$. Vemos que $T(3) = b S_(3, 3) + b S_(2, 3) + b S_(1, 3) + c S_(0, 3)$.

  Probemos, entonces, $P(n): T(n) = c S_(0, n) + sum_(i = 1)^n b S_(i, n)$.

  + $P(0)$. $T(0) = c$ por definición. $S_(0, 0) = product_(0 lt j lt.eq 0) a_j = 1$, por definición de una productoria vacía. Asimismo, $sum_(i = 1)^0 S_i b = 0$, por definición de sumatoria vacía. Luego, $T(0) = 1 c + 0 = c$, que prueba $P(0)$.
  + $P(n) implies P(n+1)$.
  $
    T(n+1) & = b + a_n T(n) \
           & = b + a_n (c S_(0, n) + sum_(i = 1)^n b S_(i, n)), "por hipótesis inductiva" \
           & = b S_(n+1, n+1) + c a_n S_(0, n) + a_n sum_(i = 1)^n b S_(i, n) \
           & = b S_(n+1, n+1) + c S_(0, n+1) + sum_(i = 1)^n b S_(i, n+1) \
           & = c S_(0, n+1) + sum_(i = 1)^(n+1) b S_(i, n+1)
  $

  Luego vale $P(n)$ para todo $n in NN$. Veamos ahora qué nos dice esto sobre $EE[T(n)]$. Como los ${a_i}$ son independientes en cualquier subconjunto de tamaño a lo sumo $n$, tenemos que $EE[S_(i, n)] = EE[product_(i < j lt.eq n) a_j] = product_(i < j lt.eq n) EE[a_j] = product_(i < j lt.eq n) alpha = alpha^(n - i)$.

  Luego:

  $
    EE[T(n)] & = EE[c S_(0, n) + sum_(i = 1)^n b S_(i, n)], "porque vale" P(n) \
             & = c EE[S_(0, n)] + sum_(i = 1)^n b EE[S_(i, n)] \
             & = c alpha^n + sum_(i = 1)^n b alpha^(n-i) \
             & = b (alpha^n - 1)/(alpha - 1) + c alpha^n
  $

  Para esto tuvimos que asumir que los ${a_i}$ son independientes tomados de cualquier subconjunto de tamaño a lo sumo $n$.

  Vemos con cuánto cuidado hay que deducir cosas, si no queremos cometer errores.
]
*/

=== Ejercicios

#ej[
  Probar que para todo $n in NN$, $sum_(i = 1)^n i = 1 + 2 + 3 + dots + n = n(n + 1)/2$.
]

#ej[
  Probar que para todo $n in NN$, $1^3 + 2^3 + 3^3 + dots + n^3$ es un cuadrado perfecto.
]

#ej[
  Probar que para todo $n in NN$, $sum_(i=1)^n 1/((2i-1)(2i+1)) = n/(2n + 1)$.
]

#load-bib()