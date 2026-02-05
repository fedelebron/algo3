// Chapter 4: ¿Cómo demostramos?
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= ¿Cómo demostramos?

Ahora miremos cómo se construye una demostración, proceduralmente.

== Formalizar la consigna
En su vida profesional muy rara vez les van a dar un problema pre-formalizado, en términos de secuencias de enteros, permutaciones, o teoría de grafos. En cambio, van a tener que transformar el problema que tienen, a uno donde puedan usar las herramientas que conocen. Esto se llama formalizar. Esta parte es *crucial*: Si formalizan incorrectamente, todo lo que hagan después es totalmente irrelevante. Parte de esto es lectura y comprensión de lo que les piden, y la otra parte es poder usar lenguaje formal.

#ej[
  Tenemos una máquina vendedora, y queremos devolver cambio. Necesitamos saber si usando sólo monedas de 3 y 5 centavos, podemos devolver cualquier cambio mayor o igual a 8 centavos.
]

La oración habla sobre monedas, no de algo que veamos diréctamente en la carrera. Para usar las herramientas que tenemos, lo traducimos a alguna estructura que nos sirva. En la carrera vemos varias, como ser números reales, listas, registros, números enteros, árboles, grafos, lenguajes formales, matrices, redes, autómatas, interrupciones del procesador, etc. De todas esas, tenemos que fijarnos cuál es la que probablemente nos sirva para este problema. Como el enunciado habla sobre armar combinaciones de monedas, queremos algo que modele combinaciones lineales. Podríamos formalizarlo de esta manera:

#ej[
  Sea $n in NN$, $n gt.eq 8$. Probar que existen $a, b in ZZ$ tales que $3a + 5b = n$.
]

Acá podríamos usar lo que sabemos sobre combinaciones lineales de enteros, es decir, que esto sucede si y sólo si $gcd(3, 5) | n$. Como $gcd(3, 5) = 1$, y $1 | n$ para todo $n in NN$, la proposición es cierta. Sin embargo, *esto está mal formalizado*, y la demostración usando $gcd$ es irrelevante. El problema es que no podemos devolver números negativos de monedas. Por ejemplo, si queremos mostrar que podemos devolver 13 centavos de cambio, es irrelevante decir que $13 = 3 times 6 + 5 times (-1)$, porque no podemos devolver "-1" monedas de 5 centavos.

Luego, tenemos que restringir $a, b$ a ser números naturales, no enteros.

#ej[
  Sea $n in NN$, $n gt.eq 8$. Probar que existen $a, b in NN$ tales que $3a + 5b = n$.
]

Demostrar esto se hace de forma totalmente diferente. Una forma es usar inducción.

#demo[
  Sea $P(n)$ el predicado "existen $a, b in NN$ tales que $3a + 5b = n$". Queremos probar que para todo $n in NN$ tal que $n > 7$, vale $P(n)$.

  Probamos por separado $P(8)$, $P(9)$, y $P(10)$.
  - $P(8)$: Tomamos $a = 1$, $b = 1$, pues $3 times 1 + 5 times 1 = 8$.
  - $P(9)$: Tomamos $a = 3$, $b = 0$, pues $3 times 3 + 5 times 0 = 9$.
  - $P(10)$: Tomamos $a = 0$, $b = 2$, pues $3 times 0 + 5 times 2 = 10$.
  Ahora para $n in NN$, con $n > 10$, podemos asumir que vale $P(k)$ para todo $8 < k < n$. Como $n > 10$, entonces $7 < n - 3 < n$. Luego, tomamos $k = n - 3$, y por hipótesis inductiva ($P(k)$), existen $a', b' in NN$ tales que $3a' + 5b' = k$. Entonces, tomando $a = a' + 1 in NN$, $b = b' in NN$, tenemos que $3a + 5b = 3(a' + 1) + 5b' = 3a' + 5b' + 3 = k + 3 = n$. Luego, vale $P(n)$.
]

/*
#ej[
Probar que en todo grupo de amigos, si cada par de amigos tiene sólo un amigo en común, entonces existe una persona que es amigo de todos.
]

La oración habla sobre grupos de amigos, no de algo que veamos diréctamente en la carrera. Para usar las herramientas que tenemos, lo traducimos a alguna estructura que nos sirva. En la carrera vemos varias, como ser números reales, listas, registros, números enteros, árboles, grafos, lenguajes formales, matrices, redes, autómatas, interrupciones del procesador, etc. De todas esas, tenemos que fijarnos cuál es la que probablemente nos sirva para este problema. Como el enunciado habla sobre la relación "tener amigos", queremos algo que modele una relación de amistad. El enunciado no aclara que la amistad es simétrica (si $X$ es amigo/a de $Y$, entonces $Y$ es amigo/a de $X$) y antireflexiva (nadie es amigo/a de sí mismo/a), así que es algo que deberíamos preguntar, o darnos cuenta que lo estamos asumiendo. Más adelante en el libro vamos a ver qué es un grafo, pero parecería que un buen modelo es un grafo $G = (V, E)$, $V$ es un conjunto de personas, y $E$ es un subconjunto de pares sin orden de $V$. Podemos traducir el enunciado de la siguiente manera - no se preocupen si todavía no vieron nada sobre grafos, es sólo un ejemplo:

#ej(title: "Teorema de la amistad (Erdős et. al., 1966)")[
  Sea $G = (V, E)$ un grafo. Dado $v in V$, definimos $N(v) = {w | {v, w} in E}$. Probar que si para todo $u, v in V$ tenemos que $|N(v) inter N(w)| = 1$, entonces existe un $w in V$ tal que $|N(w)| = |V| - 1$.
]

Ahora podemos usar las herramientas que nos da la carrera para atacar el problema. Notar cómo esta segunda versión nombra los objetos de los que habla ($G$, $V$, $E$, $v$, $N$, etc), explicita relaciones formalmente sobre los mismos ($G = (V, E)$, $v in V$, $N(v) = dots$, $|N(w)| = |V| - 1$, etc), cuantifica las variables usadas ("sea" / "para todo", "existe"), y usa conectores lógicos ("si", "entonces"). Contrastar esto con algo como:

#ej[
  Cada vez que dos personas siempre tienen un amigo en común, alguien es amigo de todos.
]

No sólo es difícil de leer, sino que distintas personas lo van a interpretar de distintas maneras, y eso aumenta el riesgo de no comprender la consigna correctamente. No se usan variables para referirse a la misma cosa, las relaciones entre los elementos no están explícitas, los cuantificadores son o inexistentes o imprecisos, y los conectores lógicos implícitos.
*/

Vemos cuán importante es leer detenidamente, y tener cuidado a la hora de formalizar el enunciado. Cuando modelamos algo del mundo real (como monedas) con un concepto matemático (como números naturales), tenemos que pensar si el modelo tiene sentido, y si estamos modelando exactamente los objetos que queremos modelar. Si nuestro modelo es demasiado amplio, como ocurrió con nuestro primer intento de formalización del problema de las monedas, las soluciones que encontramos no van a tener contraparte en el mundo real. Si, por otra parte, nuestro modelo es demasiado restrictivo, puede que no podamos encontrar soluciones que sí existen en el mundo real.

== Comprender qué se nos pide <conversacionn>

Una herramienta útil para entender qué hay que probar es pensarlo como una conversación entre dos personas. A nosotros nos van a pedir que demostremos algo, y nosotros tenemos que convencer al interlocutor. Luego, una proposición como la siguiente:

#ej(title: [Continuidad de $f(x) = e^x$ en $x_0$])[
  Para todo $epsilon > 0 in RR$, existe un $delta > 0 in RR$, tal que para todo $x in RR$, si $|x - x_0| < delta$, entonces $|e^x - e^(x_0)| < epsilon$.
]

Probar un "para todo" es equivalente a la siguiente conversación, entre el que está probando algo (Alicia) y el que está pidiendo que le demuestren algo (Beto):

#let A = text(weight: "bold")[Alicia]
#let B = text(weight: "bold")[Beto]
#log[
  #block(spacing: 3mm)[#B: No te creo que es cierto, a ver, para $epsilon = 0.2$, quién es $delta$?]
  #block(spacing: 3mm)[#A: Para $epsilon = 0.2$, te doy $delta = 0.4$.]
  #block(
    spacing: 3mm,
  )[#B: OK, ponele que $epsilon = 0.2$, y $delta = 0.4$.  Te doy un $x$ tal que $|x - x_0| < delta$, por ejemplo $x = x_0 - 0.3$. Por qué vale que $|e^(x_0 - 0.3) - e^(x_0)| < 0.2$?]
  #block(spacing: 3mm)[#A: [Demostración de que con ese $epsilon$ y $x$, tenemos que $|e^x - e^(x_0)| < epsilon$.]]
]

#let image_forall = block({
  image("../speech_forall.png", width: 90%)
  place(center + horizon, dx: -18mm, dy: -17mm, text(size: 20pt)[$forall$])
  place(center + horizon, dx: 17mm, dy: -17mm, text(size: 20pt)[$exists$])
})
#let body_forall = [Nosotros vamos a tomar el rol de Alicia. Nos van a dar un $epsilon$, y tenemos que decir quién es $delta$. Como nos están dando un $epsilon$, nuesto $delta$ puede (y en general va a) depender de $epsilon$. Por ejemplo, a veces vamos a concluir que $delta = epsilon / 8$. Este es el baile del "para todo / existe". El término "para todo" resulta en "se nos va a dar un". El término "existe" resulta en "tenemos que devolver".

  Por el contrario, si tuvieramos probar "existe un $x$ tal que para todo $y gt.eq x, x = y$", entonces tenemos que dar un $x$ explícito#footnote[Hay maneras de probar la existencia de algo sin darlo explícitamente, y es común en matemática. Inicialmente, sugiero que consideren que demostrar existencia se hace dando un objeto explícito.], y mostrar que sin importar cuál $y$ elija Beto, podemos probar que $x = y$.]
#wrap-content(image_forall, body_forall)

Luego de que devolvemos ese $delta$, le sigue otro "para todo", "para todo $x in RR$". Entonces, nos van a dar otro $x$. A ese "para todo", le sigue un "si", "si $|x - x_0| < delta$". Un "si" nos deja asumir algo - para probar que "si $X$, entonces $Y$" (que se escribe $X implies Y$), podemos _asumir_ $X$, puesto que de otra manera no hay nada que probar ("falso implica todo"). Entonces, esto se traduce en "nos van a dar un $x$, y podemos asumir que $|x - x_0| < delta$". El "entonces" de un "si" es lo que tenemos que probar. Luego, tenemos que probar que para ese $x$ que nos dieron, vale $|e^x - e^(x_0)| < epsilon$.

Noten cómo al igual que ocurre en la conversación, tuvimos que decir quién es $delta$ sin saber quién es $x$. Entonces, no puede ser que $delta$ dependa de $x$! En la conversación, las únicas variables que vinieron antes de $delta$ fueron $epsilon$ y $x_0$. Entonces, sólo de esas dos puede depender $delta$.


#let t = [Noten también cómo usé cuantificadores en Español, no usando símbolos. No sugiero enfocarse en escribir usando el mayor número de símbolos posibles. Comparen "$forall x in X. exists y in Y. x > y implies (exists z in Z. z = x + y or z = x - y)$", con "Sea $x in X$. Entonces existe un $y in Y$, tal que si $x > y$, entonces $x + y in Z$, o $x - y in Z$." Al saber leer lenguaje natural, nos es más fácil entender qué significa la segunda oración. ¡Esto es a pesar de ser más larga! Cuando escribimos cuidadosamente, usando lenguaje estándar, podemos tener ambas precisión, y comprensión del lector.]
#let img = block({
  image("../soviet.png", width: 100%)
  place(center + horizon, dx: 9.5mm, dy: -16mm, text(size: 8pt)[$forall x. forall y. x = y$])
})
#wrap-content(img, t, align: bottom + right)

== Considerar ejemplos

En general, las cosas que probamos van a ser de la forma $A implies B$, con $A$ algo que podemos asumir, y $B$ algo que queremos demostrar. Para demostrar esto, es frecuentemente útil considerar ejemplos de cosas que cumplen $A$, y ver "por qué" se tiene que cumplir $B$ para ellas. Podemos empezar con ejemplos pequeños, si nuestra estructura tiene alguna noción de "tamaño" (la longitud de una lista, el valor absoluto de un número real, el número de vértices mas aristas de un grafo, el numero de líneas de un programa, el número de reglas de una gramática, etc).

Por ejemplo, veamos el siguiente enunciado formal:

#ej[
  Dar una fórmula cerrada para la suma de los primeros $n$ números naturales impares, $sum_(i=1)^n (2i - 1)$.
]
Primero les voy a mostrar la serie de pensamientos que sigo al intentar resolver este ejercicio. No es una demostración formal, sólo una serie de ideas.

#quote-box[

  Podemos considerar ejemplos pequeños:
  #align(center)[
    #table(
      columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
      $n$, $1$, $n$, $3$, $4$, $5$,
      $sum_(i=1)^n (2i - 1)$, $1$, $1 + 3 = 4$, $1 + 3 + 5 = 9$, $1 + 3 + 5 + 7 = 16$, $1 + 3 + 5 + 7 + 9 = 25$,
    )]

  Vemos cómo los resultados son los cuadrados consecutivos, $1$, $4$, $9$, $16$, $25$. Podemos pensar, entonces, en cómo los cuadrados se relacionan con la suma. Si dibujamos estos cuadrados a medida que aumenta $n$, podemos ver un patrón. Acá el bloque rojo es la suma de los anteriores números impares, y los cuadrados azul, verde, y amarillo, es el nuevo número impar que estamos sumando.

  #let draw_blocks(n, bloque: red, columna: blue, fila: yellow, esquina: green, label: true) = {
    let nn = n + 1
    stack(
      dir: ttb,
      spacing: 2mm,
      if label { $n = #nn$ } else { none },
      grid(
        columns: n + 1,
        rows: n + 1,
        stroke: 0.7pt,
        inset: (2mm, 2mm),
        fill: (x, y) => {
          if (x < n and y < n) {
            return bloque
          } else if (x == n and y < n) {
            return columna
          } else if (x < n and y == n) {
            return fila
          } else if (x == n and y == n) {
            return esquina
          } else {
            return none
          }
        },
      ),
    )
  }

  #align(center)[
    #stack(
      dir: ltr,
      spacing: 6mm,
      ..range(6).map(i => draw_blocks(i)),
    )
  ]

  Vemos que cada vez empezamos con el cuadrado anterior, y luego le sumamos una fila amarilla de longitud $n$, una columna azul de longitud $n$, y tenemos que restar 1, el cuadrado verde, pues si no lo estaríamos contando dos veces, pues pertenece a ambas la columna y la fila. Esto es lo mismo que tener un rectángulo (rosa) de $n times (n + 1)$, y agregarle una fila (naranja) de longitud $n + 1$:

  #align(center)[
    #stack(dir: ltr, spacing: 5mm, draw_blocks(6, label: false), align(horizon)[$=$], draw_blocks(
      6,
      bloque: fuchsia,
      columna: fuchsia,
      fila: orange,
      esquina: orange,
      label: false,
    ))]

  Es decir, $n^2 + 2n - 1 = n times (n + 1) + (n + 1) = (n + 1)^2$. Esto no es una demostración, es sólo una intuición que nos va a guiar hacia cómo demostrarlo. Para ver cómo podemos demostrar esto, podemos usar inducción, pues estamos asumiendo la forma que tiene la suma de los primeros $n$ números impares, y calculando lo mismo para $n + 1$.
]

Ahora dadas esas ideas, podemos hacer una demostración formal.

#demo[
  Sea $S_n = sum_(i=1)^n (2i - 1)$ la suma de los primeros $n$ números impares. Sea el predicado $P(n): S_n = n^2$. Queremos probar que para todo $n in NN$ tal que $n gt.eq 1$, vale $P(n)$.
  - Probamos el caso base, $P(1)$. Tenemos que $S_1$ es la suma del primer $1$ número impar, que es símplemente $1$, y luego $S_1 = 1$. Por otro lado, $1 = 1^2$, luego vale $P(1)$.
  - Para el paso inductivo, podemos asumir que vale $P(k)$ para todo $1 lt.eq k < n$, y queremos probar $P(n)$. Por definición de $S_n$, tenemos que $S_n = S_(n-1) + (2n - 1)$. Como vale $P(n-1)$ por hipótesis inductiva, dado que $1 lt.eq n - 1 < n$, tenemos que $S_(n-1) = (n - 1)^2$. Luego, $S_n = (n - 1)^2 + (2n - 1) = (n - 1)^2 + (n - 1) + n = (n - 1) times n + n = n^2$, que es lo que queríamos demostrar.
]


#let draw_circle_graph(nodes, edges, directed: false) = {
  for (i, (n, c)) in nodes.enumerate() {
    let θ = 90deg - i * 360deg / nodes.len()
    node((θ, 10mm), n, stroke: 1pt + c, name: str(i))
  }
  for (from, to) in edges {
    let bend = if (to, from) in edges { 10deg } else { 0deg }
    edge(label(str(from)), label(str(to)), if directed { "-|>" } else { "-" }, bend: bend)
  }
}

/*
#ej(title: "Fórmula de suma de grados")[
Sea $G = (V, E)$ un grafo, $m = |E|$, y $d_G:V arrow NN$ el grado de cada vértice. Entonces:

$
sum_(v in V) d_G (v) = 2m
$
]

Para ver "por qué" se tiene que cumplir esa ecuación, podemos comenzar viendo grafos pequeños.


#align(center)[
#grid(
  columns: (1fr, 1fr, 1fr),
  rows: (35mm, 35mm),
  stroke: 1pt,
  gutter: 2mm,
  inset: 2mm,
block({
place(left, dx: -20mm, text(size: 13pt)[$G_1$])
diagram({
  let nodes = (($v_1$, red),)
  let edges = ()
  draw_circle_graph(nodes, edges)
})
}),
block({
place(left, dx: -20mm, text(size: 13pt)[$G_2$])
diagram({
  let nodes = (($v_1$, red), ($v_2$, green))
  let edges = ()
  draw_circle_graph(nodes, edges)
})
}),
block({
place(left, dx: -20mm, text(size: 13pt)[$G_3$])
diagram({
  let nodes = (($v_1$, red), ($v_2$, green))
  let edges = ((0, 1),)
  draw_circle_graph(nodes, edges)
})
}),
block({
place(left, dx: -11mm, text(size: 13pt)[$G_4$])
diagram({
  let nodes = (($v_1$, red), ($v_2$, green), ($v_3$, blue))
  let edges = ((0, 1),)
  draw_circle_graph(nodes, edges)
})}),
block({
place(left, dx: -11mm, text(size: 13pt)[$G_5$])
diagram({
  let nodes = (($v_1$, red), ($v_2$, green), ($v_3$, blue))
  let edges = ((0, 1), (1, 2))
  draw_circle_graph(nodes, edges)
})}),
block({
place(left, dx: -11mm, text(size: 13pt)[$G_6$])
diagram({
  let nodes = (($v_1$, red), ($v_2$, green), ($v_3$, blue))
  let edges = ((0, 1), (1, 2), (2, 0))
  draw_circle_graph(nodes, edges)
})})
)
]

Mirando qué pasa con $G_1$ y $G_2$, vemos que en ambos casos, ambos lados de la ecuación son cero. El lado izquierdo es porque todos los vértices tienen grado cero, y el lado derecho porque no hay aristas. Mirando qué pasa en $G_3$ y $G_4$, vemos que ambos lados de la ecuacion son $2$. El lado izquierdo vale $2$ porque cuando sumamos el grado de $v_1$ eso agrega $1$, y cuando sumamos el grado de $v_2$ eso agrega otro $1$, quedando de resultado $2$. El lado derecho vale porque hay una arista, luego $m = 1$, y luego $2m = 2$. En $G_5$, en la sumatoria sumamos $1$ en $v_1$ y $v_3$ (porque hay una arista incidente a cada uno), y $2$ en $v_2$ (porque tiene dos aristas incidentes). Finalmente, en $G_6$, cada vértice es incidente a dos otros, y luego al sumar los grados estoy sumando $2$ cada vez, obteniendo $2 times 3 = 6$. Como hay dos tres aristas, el lado derecho es también $2 times 3 = 6$.

Lo que está pasando, entonces, es que cada arista le suma $1$ al grado de cada vértice que toca. Al sumar el grado de cada vértice, vamos a estar sumando $2$ por cada arista, y luego obtendremos $2m$ como total de la suma.

Quisieramos escribir algo así, entonces.

#demo[
Cada arista en $E$ aumenta en $1$ el grado de sus dos vértices incidentes. En total, las aristas suman $2m$ a los grados de todos los vértices. Es decir, $sum_(v in V) d_G (v) = 2m$.
]

Esa demostración es vaga, porque está haciendo referencia a un "procedimiento" (que implícitamente comienza todos los grados en cero). Si queremos hacerla formal, un "procedimiento" se traduce a una inducción. Si este procedimiento está modificando un grafo, en la inducción vamos a tener un grafo cada paso, y el grafo en un paso se construye a partir de grafos anteriores, en los que podemos usar la hipótesis inductiva.

#demo[
Sea $G = (V, E)$ un grafo, y sean ${e_1, dots, e_m} = E$ sus aristas. Sea $G_0 = (V, emptyset)$ el grafo con los mismos vértices que $G$, pero sin aristas, y definimos para todo $1 lt.eq i lt.eq m$, $G_i = (V, {e_1, dots, e_i})$. Vemos que $G_m = G$.

Sea la proposición $P(i): "Si "i lt.eq m," entonces " sum_(v in V) d_(G_i)(v) = 2i$. Vamos a probar $P$ por inducción.

Caso base: $P(0)$. Como $i lt.eq m$, pues $m gt.eq 0$ es un natural, el antecedente vale. Todos los vértices de $G_0$ tienen grado cero puesto que no hay aristas, y luego $sum_(v in V) d_(G_0)(v) = 0 = 2 times 0$, que es lo que queríamos demostrar.

Paso inductivo. Asumimos $P(i)$, queremos probar $P(i + 1)$. Vemos que $P(i+1)$ es una implicación. Para probar una implicación, podemos asumir el antecedente. Luego, tenemos que $i + 1 lt.eq m$. Como vale eso, a fortiori vale $i lt.eq m$, que es el antecedente de $P(i)$, y luego podemos usar el consecuente de $P(i)$. Esto nos dice que $sum_(v in V) d_(G_i)(v) = 2i$. Sean ${v_j, v_k} = e_(i+1)$ los dos vértices incidentes a $e_(i+1)$. Para todo _otro_ $v in V$ que no es ni $v_j$ ni $v_k$, tenemos $d_(G_(i+1))(v) = d_G_i (v)$. Para esos dos, tenemos que $d_(G_(i+1))(v_j) = d_G_i (v_j) + 1$, y $d_(G_(i+1))(v_k) = d_G_i (v_k) + 1$. Luego, $sum_(v in V) d_(G_(i+1))(v) = 2i + 2 = 2(i + 1)$, y queda probada la conclusión de $P(i+1)$.

Como vale $P(i)$ para todo $i in NN$, en particular sabemos $P(m)$, y como $m lt.eq m$, sabemos que $sum_(v in V) d_(G_m)(v) = 2m$. Luego, como $G_m = G$, tenemos que $sum_(v in V) d_G (v) = 2m$, que es lo que queríamos demostrar.
]

Otra forma de demostrar es darse cuenta que lo que queremos hacer es "contar lo mismo dos veces", hacer esto explícito creando un grafo con dos subconjuntos de vértices, y contando algo en cada "lado" del grafo:

#demo[
Consideremos el grafo bipartito $G' = (V', E')$, donde $V' = V union.sq E$, la unión disjunta de $V$ y $E$, y $E' = {{e, v} | e in E, v in e}$. Cada arista en $E$ está unida en $G'$ con sus dos vértices incidentes, en $V'$.

Para el grafo $G_5$ que dibujamos arriba, esto se ve así:

#align(center)[
#diagram({
  node((0, -0.6), $e_1$, name: "e1", stroke: 1pt + rgb("ffff00").darken(30%), width: 20mm, corner-radius: 2mm)
  node((0, 0.6), $e_2$, name: "e2", stroke: 1pt + rgb("00ffff").darken(30%), width: 20mm, corner-radius: 2mm)
  node((3, -1), $v_1$, name: "v1", stroke: 1pt + red)
  node((3, 0), $v_2$, name: "v2", stroke: 1pt + green)
  node((3, 1), $v_3$, name: "v3", stroke: 1pt + blue)
  let edges = (("e1", "v1"), ("e1", "v2"), ("e2", "v2"), ("e2", "v3"))
  for (u, v) in edges {
    edge(label(u), label(v))
  }
})]

Como $|e| = 2$ para todo $e in E$, tenemos que $|E'| = 2|E| = 2m$. También, como sabemos que $d_G (v)$ es el número de veces que $v$ aparece en una arista, tenemos que $sum_(v in V) d_G (v) = sum_(v in V) |{e in E | v in e}| = |{{v, e} | e in E, v in e}| = |E'|$. Luego, tenemos que $sum_(v in V) d_G (v) = 2m$.]
Vemos cómo el considerar ejemplos nos guió primero a una demostración informal, y luego la formalizamos. El hacer cálculos manuales también nos mostró otra estrategia posible para demostrar (contar lo mismo de dos formas distintas, una estrategia combinatórica clásica).

*/

Veamos otro ejemplo de cómo jugar con ejemplos pequeños nos revela cómo lidiar con casos generales.
#ej[
  Demostrar que para todo $n in NN$, $sum_(i = 0)^n i^2 = (n(n+1)(2n+1))/6$.
]
#quote-box[
  Veamos qué pasa con $n = 1, 2, 3$.

  + Hay un sólo término, y es $1^2$. Esto es $(1 times 2 times 3) / 6$, pero no me es claro "por qué" todavía.
  + $1^2 + 2^2 = 5 = (2 times 3 times 5) / 6$. Mmm todavía nada. No creo que el patrón de $2 times 3 times X / 6$ continúe.
  + $1^2 + 2^2 + 3^2$. ¿Puedo hacer algo con esto más que sumar cada cuadrado? Esto es $1 + 2 times 2 + 3 times 3$, o quizás, $1 + 2 + 2 + 3 + 3 + 3$. Me queda algo sospechoso, $(1 + 2 + 3) + (2 + 3) + 3$. Como sumas de no-cuadrados, hasta $n$, que se van haciendo más cortas. Esto es $n(n-1)/2 + (n(n-1)/2 - 1) + (n(n-1)/2 - 3)$. El patrón queda algo como $sum_(i = 0)^(n - 1) N - i(i+1)/2$, con $N = n(n+1)/2$.

  A ver, pensémoslo con cuidado. Con $n = 4$, tenemos
  $
    sum_(i = 0)^n i^2 & = 0^2 + 1^2 + 2^2 + 3^2 + 4^2 \
                      & = 0 + 1 times 1 + 2 times 2 + 3 times 3 + 4 times 4 \
                      & = 1 + 2 + 2 + 3 + 3 + 3 + 4 + 4 + 4 + 4 \
                      & = (1 + 2 + 3 + 4) + (2 + 3 + 4) + (3 + 4) + (4) \
                      & = N + (N - 1) + (N - (1 + 2)) + (N - (1 + 2 + 3)) \
                      & = N + (N - 1 times 2 / 2) + (N - 2 times 3 / 2) + (N - 3 times 4 / 2)
  $

  OK, esto es entonces $sum_(i = 1)^n N - ((i - 1)i)/2 = N n - sum_(i = 1)^n ((i-1)i)/2$. Ese $((i-1)i)/2$ se va a convertir en $(i^2 - i)/2$, y si separo eso, ¡me va a quedar otra vez la suma de cuadrados!

  Juguemos, entonces. Llamemos $X = sum_(i = 0)^n i^2 = sum_(i = 1)^n i^2$.

  $
    X & = N n - sum_(i = 1)^n ((i-1)i)/2 \
      & = (n^2(n+1))/2 - (1/2)(sum_(i = 1)^n i^2 - i) \
      & = (n^2(n+1))/2 - (1/2)(sum_(i = 1)^n i^2) + (1/2) sum_(i = 1)^n i \
      & = (n^2(n+1))/2 - X/2 + n(n+1)/4
  $

  Multiplicamos todo por $4$, y pasamos todos los $X$ a la izquierda.

  $
    6X & = 2n^2(n+1) + n(n+1) \
       & = n(n+1)(2n + 1)
  $

  Con lo cual $X = (n(n+1)(2n+1))/6$, que ¡es lo que quería!
]
Habiendo jugado con ejemplos pequeños, ahora sabemos "por qué" la proposición es cierta. Resta hacer un argumento convincente de que el patrón que encontramos se va a repetir para todo $n in NN$. Usamos la herramienta formal de inducción, para hacer riguroso el argumento.
#demo[
  Vamos a probar la proposición $P(n): sum_(i=0)^n i^2 = sum_(i=1)^n (n(n+1) - (i-1)i)/2$, para todo $n in NN$.
  - $P(0)$. $sum_(i=0)^1 i^2 = 0^2 = 0$, mientras que $sum_(i=1)^0 "(lo que sea)" = 0$, porque hay cero términos en la suma. Luego vale $P(0)$.
  - $P(n) implies P(n+1)$. Entonces:
    $
      sum_(i = 0)^(n + 1) i^2 &= (sum_(i = 0)^n i^2) + (n + 1)^2 \
      &= (sum_(i=1)^n (n(n+1) - (i-1)i)/2) + (n+1) (n + 1) \
      &= (sum_(i=1)^(n+1) (n(n+1) - (i-1)i)/2) + (n+1) (n+1)", pues el último término es 0" \
      &= sum_(i=1)^(n+1) ((n(n+1) - (i-1)i)/2 + n + 1), "sumo" n+1 "a cada uno de los" n + 1 "términos" \
      &= sum_(i=1)^(n+1) (2n + 2 + n(n+1) - (i-1)i)/2\
      &= sum_(i=1)^(n+1) ((n+1)(n + 2) - (i-1)i)/2 \
    $

    que es lo que queríamos demostrar.
  Habiendo probado $P(n)$ para todo $n in NN$, veamos cómo probar que $sum_(i = 0)^n i^2 = (n(n+1)(2n+1))/6$ para todo $n in NN$. Sea $n in NN$, y llamemos $X = sum_(i = 0)^n i^2$.
  $
      X = sum_(i = 0)^n i^2 & = sum_(i=1)^n (n(n+1) - (i-1)i)/2 \
                            & = n^2 (n + 1)/2 - sum_(i=1)^n i(i-1)/2 \
                            & = n^2 (n + 1)/2 - (1/2)sum_(i=1)^n i^2 + (1/2)sum_(i=1)^n i \
                            & = n^2 (n + 1)/2 - (1/2)X + n(n+1)/4 \
    "Multiplicando por 4 y" & " pasando las "X" a la izquierda"dots \
                         6X & = 2n^2(n+1)+n(n+1) \
                            & =n(n+1)(2n+1)
  $
  Y por lo tanto $sum_(i = 0)^n i^2 = X = (n(n+1)(2n+1))/6$, que es lo que queríamos demostrar.
]

Nuestro cerebro es muy eficiente para ser perezoso, y frecuentemente al hacer cuentas repetitivas, vamos a encontrar patrones que nos ahorren esfuerzo, y al mismo tiempo revelen propiedades sobre los objetos que estamos mencionando. Jamás se me hubiera ocurrido distribuir un $n + 1$ a cada uno de los $n + 1$ términos de la sumatoria, si no fuera porque fue exactamente lo que hice para $n = 3$ y $n = 4$, notando ese patrón en un caso chico.

== Estrategias de demostración
Una vez que entendemos qué es lo que se no pide probar y tenemos una idea intuitiva de por qué funciona, podemos planear estructuras que va a tener nuestra demostración.
En general vamos a usar varias de ellas en la misma demostración.

=== Inducción
Si los objetos con los que estamos trabajando tienen una estructura recursiva, como los números naturales, los árboles, los grafos, o las cadenas de texto, entonces podemos considerar inducción como técnica de demostración.

Vamos a plantear un predicado sobre los naturales, $P$. Vamos a probar que $P$ vale para los primeros $k$ números naturales (es posible que $k = 0$, o $k = 1$, o $k > 1$). Luego vamos a probar que dado un $n gt.eq k$, si vale $P(j)$ para todo $j < n$, entonces vale $P(n)$. Esto nos permite concluir que vale $P(n)$ para todo $n in NN$.

Veamos un caso simple, con $k = 1$.

#prop[
  Para todo $n in NN$, $sum_(i=1)^n i = (n(n+1))/2$.
]
#demo[
  Sea el predicado $P(n): sum_(i=1)^n i = (n(n+1))/2$. Vamos a probar que vale $P(n)$ para todo $n in NN$.
  - Caso base, $P(0)$. Tenemos que $sum_(i=1)^1 i = 1$, y $(1(1+1))/2 = 1$, luego vale $P(1)$.
  - Paso inductivo, $P(n)$ con $n gt.eq 1$. Asumimos $P(j)$ para todo $j < n$, queremos probar $P(n)$.
    Tenemos:
    $
      sum_(i=1)^n i & = (sum_(i=1)^(n-1) i) + n \
                    & = ((n-1)n)/2 + n, "por hipótesis inductiva" P(n-1) \
                    & = (n^2 - n + 2n)/2 \
                    & = (n(n+1))/2,
    $
    que es lo que queríamos demostrar.
]

Veamos un caso con $k = 0$. Quizás les resulte extraño que no sean necesarios casos base. Esto sucede cuando la demostración de $P(n)$ no siempre usa $P(n-r)$ para algún $r$, sino que la estructura inductiva es otra. En el siguiente caso, la estructura es multiplicativa, no aditiva. Los "casos base" son los números primos, si uno quisiera llamarlos así.

#prop[
  Sea $n in NN$, $n > 0$. Entonces $n$ se puede escribir como un producto de números primos.
]
#demo[
  Sea el predicado $P(n):$ "Si $n > 0$, entonces $n$ se puede escribir como un producto de números primos". Vamos a probar que vale $P(n)$ para todo $n in NN$ con $n > 0$.

  Sea $n in NN$, $n > 0$. Asumimos que vale $P(j)$ para todo $j < n$. Como $n > 0$, o bien $n$ es primo, o no lo es.
  - Si $n$ es primo, entonces $n$ se puede escribir como un producto de números primos, símplemente $n$.
  - Si $n$ no es primo, entonces existen $a, b in NN$, con $1 lt.eq a, b < n$, tales que $n = a times b$. Como $a < n$ y $b < n$, sabemos que valen $P(a)$ y $P(b)$. Como $a > 0$ y $b > 0$, $P(a)$ y $P(b)$ nos dan formas de escribir a $a$ y $b$ como productos de números primos, $a = q_1 times dots times q_s$ y $b = r_1 times dots times r_t$. Luego vemos que $n = q_1 times dots times q_s times r_1 times dots times r_t$ es una forma de escribir $n$ como producto de números primos, que es lo que queríamos demostrar.
]
#note-box[
  Noten en la anterior demostración que $P(a)$ y $P(b)$ son implicaciones. No nos dicen que existe una factorización de $a$ y $b$ como producto de primos, nos dicen que *si* $a > 0$, *entonces* existe una factorización de $a$ como producto de primos. Lo mismo para $b$. Por eso es importante que tomamos $a$ y $b$ mayores que cero, pues de otra forma no sirve la hipótesis inductiva.
]

Una generalización de la inducción es la inducción en conjuntos bien-fundados, también conocida como inducción Noetheriana#footnote[El nombre es en honor a la matemática Emmy Noether (1882 - 1935), que fue la primera en usar una técnica similar para probar propiedades sobre ciertos anillos, hoy llamados anillos Noetherianos.] o inducción estructural. No es necesario para los temas de este libro, pero es útil para entender una forma de inducción sobre tipos de datos algebraicos.

#def(title: [Inducción estructural])[
  Sea $A$ un conjunto, y $prec.eq$ un orden parcial sobre $A$. Escribimos $a prec b$ para significar que $a prec.eq b$ y $a eq.not b$. Dado un subconjunto $M$ de $A$, llamamos a un elemento $m in M$ *$prec.eq$-minimal* cuando no existe ningún $m' in M$ tal que $m' prec m$.

  Decimos que $(A, prec.eq)$ es un *orden bien fundado* si para todo subconjunto no vacío $M$ de $A$, $M$ tiene un elemento $prec.eq$-minimal.

  Sea $P$ un predicado sobre $A$, con $(A, prec.eq)$ un orden bien fundado. Para probar que vale $P(a)$ para todo $a in A$, alcanza con probar dos cosas:
  - $P(a)$ vale para todo elemento $prec.eq$-minimal de $A$.
  - Para todo $a in A$ no $prec.eq$-minimal, si vale $P(a')$ para todo $a' prec a$, entonces vale $P(a)$.
]

Por ejemplo, veamos cómo usar inducción estructural para probar una propiedad sobre árboles.

#ej[
  Definimos el tipo de datos algebraico `Tree` como:

  ```haskell
  data Tree = Nil | Node Int Tree Tree
  ```

  Es decir, un `Tree` es o bien `Nil`, o bien es un nodo que contiene un entero y dos `Tree`s, cada uno posiblemente `Nil`. Luego definimos:

  ```haskell
  espejar :: Tree -> Tree
  espejar Nil = Nil
  espejar (Node x l r) = Node x (espejar r) (espejar l)
  ```

  Demostrar que para todo ```haskell t :: Tree```, vale que ```haskell espejar (espejar t) = t```.
]
#demo[
  Sea $T$ el conjunto de todos los ```haskell Tree```. Definimos un orden parcial $prec.eq$ sobre $T$ como: para todo $t_1, t_2 in T$, tenemos $t_1 prec.eq t_2$ cuando $t_1$ es un sub-árbol de $t_2$. Es decir, si $t_1 prec.eq t_2$, entonces o bien $t_1 = t_2$, o bien $t_2 =$ ```hs Node x l r```, y $t_1 prec.eq l$ o $t_1 prec.eq r$.

  El único elemento minimal es ```hs Nil```, pues para todo $t =$ `Node x l r`, tenemos que $l prec.eq t$, y $r prec.eq t$, con $l eq.not t$ y $r eq.not t$, y luego $l prec t$ y $r prec t$, con lo cual $t$ no es minimal.

  Probemos la propiedad $P(t):$ "```haskell espejar (espejar t) = t```", para todo $t in T$, usando inducción estructural sobre $(T, prec.eq)$.
  - Caso base, $t =$ ```hs Nil```. Probemos $P($```hs Nil```$)$. Tenemos que ```haskell espejar (espejar Nil) = espejar Nil = Nil```, luego vale $P($```hs Nil```$)$.
  - Paso inductivo, $t =$ ```hs Node x l r```. Como $l prec t$ y $r prec t$, podemos asumir que vale $P(l)$ y $P(r)$, queremos probar $P(t)$. Tenemos:
    ```haskell
    espejar (espejar (Node x l r))
      = espejar (Node x (espejar r) (espejar l))
      = Node x (espejar (espejar l)) (espejar (espejar r))
      = Node x l r -- por hipótesis inductiva P(l) y P(r)
    ```
    que es lo que queríamos demostrar.
]

Para estructuras finitas, la inducción estructural es equivalente a la inducción matemática "clásica" sobre $NN$, pues podemos asignar a cada elemento de la estructura un número natural que mide su "tamaño", que induce un órden parcial, y hacer inducción sobre ese número. Veamos un ejemplo.

#ej[
  Definimos el tipo de datos algebraico `List` como:

  ```haskell
  data List = Nil | Cons Int List
  ```

  Es decir, una `List` es o bien `Nil`, o bien es un par formado por un entero y otra `List`. Luego definimos:

  ```haskell
  length :: List -> Int
  length Nil = 0
  length (Cons _ xs) = 1 + length xs

  concat :: List -> List -> List
  concat Nil ys = ys
  concat (Cons x xs) ys = Cons x (concat xs ys)
  ```

  Demostrar que para todas dos ```haskell xs :: List``` y ```haskell ys :: List```, vale que ```haskell length (concat xs ys) = length xs + length ys```.
]
#demo[
  Vamos a probar el predicado sobre los números naturales $P(n):$ "Para toda ```haskell xs :: List``` tal que ```haskell length xs = n```, y para toda ```haskell ys :: List```, vale que ```haskell length (concat xs ys) = n + length ys```".

  - Caso base, $P(0)$. Sea ```haskell xs :: List``` tal que ```haskell length xs = 0```. Entonces, usando la definición de ```haskell length```, ```haskell xs = Nil```. Sea ```haskell ys :: List``` cualquiera. Entonces:
    ```haskell
    length (concat xs ys)
      = length (concat Nil ys)
      = length ys
      = 0 + length ys
    ```
    que es lo que queríamos demostrar.
  - Paso inductivo. Tenemos $n > 0 in NN$, sabemos que vale $P(j)$ para todo $0 < j < n$, y queremos probar $P(n)$. Sea ```haskell xs :: List``` tal que ```haskell length xs = n```. Como $n > 0$, tenemos que ```haskell xs = Cons x xs'```, para algún ```haskell x :: Int```, y ```haskell xs' :: List```. Además, como ```haskell length xs = n```, tenemos que ```haskell length xs' = n - 1```. Sea ```haskell ys :: List``` cualquiera. Entonces:
    ```haskell
    length (concat xs ys)
      = length (concat (Cons x xs') ys)
      = length (Cons x (concat xs' ys))
      = 1 + length (concat xs' ys)
      = 1 + (n - 1) + length ys -- por hipótesis inductiva P(n-1)
      = n + length ys
    ```
    que es lo que queríamos demostrar.

    Notar que usamos $P(n-1)$ para saber que ```haskell length (concat xs' ys) = (n - 1) + length ys```, pues ```haskell length xs' = n - 1```.
]


#warning-box[Sugiero ser formal cuando hacen inducción. Es muy común que se confundan cuando son informales. El siguiente es un ejemplo de una demostración incorrecta de una proposición falsa, por ser informal y no definir explícitamente una proposición sobre los números naturales, con cuantificadores.

  #text(red)[
    #prop[
      Sea $P(n):$ Para todo conjunto $S$ de enteros de tamaño $n$, si $1 in S$, entonces $max(S) = |S|$.
    ]
    #demo[
      + Caso base. Sea $S$ un conjunto de tamaño $1$, con $1 in S$. Entonces $S = {1}$, y luego $max(S) = 1 = |S|$.
      + Paso inductivo. Asumimos $P(n)$, vamos a probar $P(n+1)$. Sea $S$ un conjunto de tamaño $n$, tal que $1 in S$. Por $P(n)$ sabemos que $max(S) = |S|$. Construimos $S' = S union {k}$, con $k = |S| + 1 = n + 1$. Como $max(S) = |S| = n$, en particular $n + 1 in.not S$, y luego $|S'| = n + 1$. Además, $1 in S'$, porque $1 in S$, y $S subset.eq S'$. Entonces, $max(S') = k = n + 1 = |S'|$, que es lo que queríamos demostrar.
    ]
  ]

  Esto es claramente incorrecto, puesto que existe $S = {1, 100}$, con $1 in S$, pero $max(S) = 100 eq.not |S| = 2$. El problema es que la demostración es demasiado informal, y termina siendo insuficientemente rigurosa. No usa $P(n)$, sólo lo menciona. Para probar $P(n+1)$, tendríamos que probar que _cualquier_ conjunto $S'$ de tamaño $n + 1$ que contiene al $1$, cumple que $max(S') = |S'|$. Pero en la demostración, sólo se prueba para un conjunto particular, el que se construye agregando un elemento específico al conjunto $S$. El problema es que no todo conjunto de tamaño $n + 1$ que contiene al $1$, se puede construir de esa forma a partir de un conjunto de tamaño $n$ que contiene al $1$.
]

/*
#prop[
Sea $G$ un grafo. Si todos los vértices de $G$ tienen grado mayor o igual a $1$, entonces $G$ es conexo.
]
#text(red)[
#demo[
  + Caso base. Si $G$ tiene un sólo vértice, entonces no vale el antecedente, y luego la implicación es cierta (recordar que "falso implica todo").
  + Paso inductivo. Sea $G = (V, E)$ un grafo con todos los grados mayores o iguales a 1. Construímos $G'$ tomando $G$ y agregándole un vértice nuevo $v$, conectado con algún número positivo de vértices en $G$. Sea $V' = V + {v}$ el conjunto de vértices de $G'$. Sea $w$ alguno de los vértices en $V$ a los que conectamos a $v$. Entonces ${w, v}$ es una arista en $G'$.

    Sea $z in V$. Por hipótesis inductiva, $G$ es conexo, entonces existe un camino $z arrow.squiggly w$ en $G$, y luego también en $G'$. Como ${w, v}$ es una arista en $G'$, tenemos un camino $z arrow.squiggly v$ en $G'$.

    Veamos que $G'$ es conexo. Sean $a, b in V'$ cualquier par de vértices distintos en $G'$. Si $a eq.not v$ y $b eq.not v$, entonces ya había un camino entre $a$ y $b$ en $G$ por ser $a, b in V(G)$, y $G$ conexo. Como $G$ es subgrafo de $G'$, este camino sigue existiendo en $G'$. Si alguno de los dos es $v$, vimos arriba que hay un camino desde cualquier vértice de $V$ hasta $v$ en $G'$.

    Luego hay un camino entre todo par de vértices en $G'$, y luego $G'$ es conexo, que es lo que queríamos demostrar.
]]

Esto es falso, y tenemos este contraejemplo:

  #align(center)[
  #block({
  place(left, dx: -23mm, text(size: 13pt)[$G = K_2 union K_2$:])
  diagram({
    let nodes = (("", black), ("", black), ("", black), ("", black))
    let edges = ((0, 1), (2, 3))
    draw_circle_graph(nodes, edges)
  })})]

Todos los vértices de este grafo tienen grado mayor o igual a 1, y sin embargo no es conexo.

#let t = [Esa demostración está mal, fundamentalmente, porque está siendo informal (y luego erronea) en cómo funciona la inducción. La inducción es sobre naturales. No es sobre grafos.

Lo que sí está probando es que si empezamos con un grafo conexo, y varias veces agregamos vértices conectados con al menos un vértice preexistente, seguimos teniendo un grafo conexo. Esto es cierto, pero no es lo que se nos pidió probar.

La diferencia está en que no todo grafo cuyos vértices tienen grados mayores o iguales a 1, viene de hacer ese procedimiento iterativo. Luego, la recomendación es que sean formales, que escriban cuál exactamente es la propiedad sobre números naturales que quieren demostrar.]
#let im = image("../jenga.png", width: 50mm)
#wrap-content(im, t)
*/


/*

  #prop[
    Sea $G = (V, E)$ un grafo, tal que $|V| gt.eq 3$, y $d_G (v) gt.eq 2$ para todo $v in V$. Entonces $G$ contiene un ciclo de longitud $3$.
  ]
  #text(red)[
  #demo[
    Sea la proposición $A(G) = |V(G)| >= 3 and d_G (v) >= 2" "forall v in V(G)$, y $B(G) = G" tiene un ciclo de longitud "3$. Vamos a demostrar la proposición $P(G): A(G) implies B(G)$, para todo grafo $G$.

    Caso base, $G$ tiene exactamente $3$ vértices, con todos de grado $2$ como mínimo. Sólo hay un tal grafo de $3$ vértices, y es $K_3$, que no sólo contiene, sino que _es_ un ciclo de longitud $3$.

    Paso inductivo. Sea $G'$ tal que $A(G')$, con $n$ vértices. Le agrego a $G'$ un vértice $v$ con algún número $k gt.eq 2$ de aristas hacia otros vértices en $G'$, obteniendo $G$ con $n + 1$ vértices. Como $G'$ tiene un ciclo de longitud $3$, pues $A(G')$ y luego $B(G')$, y $G'$ es subgrafo de $G$, entonces $G$ tiene también un ciclo de longitud $3$.
  ]]
  Esto es mentira, porque por ejemplo el siguiente grafo, $C_4$, tiene al menos tres vértices, todos de grado al menos $2$, y no tiene ningún ciclo de longitud $3$.

  #align(center)[
  #block({
  place(left, dx: -11mm, text(size: 13pt)[$C_4:$])
  diagram({
    let nodes = (("", black), ("", black), ("", black), ("", black))
    let edges = ((0, 1), (1, 2), (2, 3), (3, 0))
    draw_circle_graph(nodes, edges)
  })})]

  Esa demostración está mal, fundamentalmente, porque está siendo informal (y luego erronea) en cómo funciona la inducción. La inducción es sobre naturales. No es sobre grafos. Formalmente, lo que está sucediendo es que estoy asumiendo que la clase de grafos que cumplen $A$ está cerrada por sacar vértices, y eso no es cierto. No todo grafo $G$ que cumple $A$ viene de tomar un subgrafo $G'$ *que cumple $A$* y agregarle un vértice con algunas aristas (por ejemplo, ver $G = C_4$ arriba).

  Esto sería más claramente erroneo si hubieramos comenzado con $G$ y removido un vértice. Tendríamos que en algún momento decir "Vale $A(G')$ porque..." y no sabríamos cómo seguir, porque no es cierto. Si usamos el formalismo de inducción, definiendo propiedades sobre los naturales (como $P(n): "Para todo grafo" G = (V, E)" con "|V| = n gt.eq 3" y "d_G (v) gt.eq 2" " forall v in V," "G" contiene un ciclo de longitud "3$), nos va a ayudar a no mandarnos estas macanas.
*/
#warning-box[Si nuestra demostración de $P(n)$ requiere que $P(n - 1), P(n - 2), dots, P(n - k)$ sea cierto para algún $k gt.eq 1$ fijo, entonces vamos a necesitar $k$ casos base. Esto es porque nuesta demostración no va a tener sentido cuando $n < k$, porque estaríamos diciendo que $P(n - k)$ vale, con $n - k < 0$, que no tiene sentido pues $P$ es una proposición sobre los naturales.]

Veamos primero una demostración correcta que toma esto en cuenta, y luego tres que son incorrectas por no hacerlo.

#ej(title: "Fórmula cerrada para la sucesión de Fibonacci")[
  Sea $a_0 = 0, a_1 = 1$, y para todo $n > 1$, definamos $a_n = a_(n-1) + a_(n-2)$. Entonces para todo $n in NN$, tenemos $a_n = (phi^n - psi^n)/sqrt(5)$, con $phi = (1 + sqrt(5))/2$, y $psi = (1 - sqrt(5))/2$.
]
#demo[
  La propiedad que vamos a probar por inducción es $P(n): a_n = (phi^n - psi^n)/sqrt(5)$. Como $a_n$ está definida en términos de $a_(n-1)$ y $a_(n-2)$, vamos a querer decir algo sobre $a_(n-1)$ y $a_(n-2)$, lo cual significa que vamos a  usar $P(n-1)$ y $P(n-2)$. Luego, tenemos dos casos base.

  - Caso base $n = 0$. Si $n = 0$, entonces $a_n = a_0 = 0$, por definición. $phi^n = phi^0 = 1$, y también $psi^n = psi^0 = 1$. Luego $phi^n - psi^n = 0$, y por lo tanto $a_n = a_0 = 0 = (phi^0 - psi^0)/sqrt(5) = (phi^n - psi^n)/sqrt(5)$, que es lo que queríamos demostrar.
  - Caso base $n = 1$. Si $n = 1$, entonces $a_n = a_1 = 1$, por definición. $phi^1 = (1 + sqrt(5))/2$, y $psi^1 = (1 - sqrt(5))/2$, luego $phi^n - psi^n = phi^1 - psi^1 = (1 + sqrt(5))/2 - (1 - sqrt(5))/2 = 2sqrt(5)/2 = sqrt(5)$, y luego $(phi^n - psi^n)/sqrt(5) = 1 = a_0 = a_n$, que es lo que queríamos demostrar.
  - Paso inductivo. Podemos asumir $P(n - 1)$ y $P(n - 2)$, y queremos probar $P(n)$. Vemos que $phi^(-1) = (sqrt(5)-1)/2$, y de ahí vemos que $1 + phi^(-1) = phi$, y que $1 - phi = -1/phi$. Realmente ambos hechos son consecuencia de que $phi$ es una de las raíces de $phi + 1 = phi^2$. Notemos que $psi = 1 - phi = -1/phi$. Entonces:
  $
    a_n & = a_(n-1) + a_(n-2) \
        & = (phi^(n-1) - psi^(n-1))/sqrt(5) + (phi^(n-2) - psi^(n-2))/sqrt(5) \
        & = (1/sqrt(5))[phi^(n-1) - (-1/phi)^(n-1)] + (1/sqrt(5))[phi^(n-2) - (-1/phi)^(n-2)] \
        & = (1/sqrt(5))[phi^(n-1) - (-1/phi)^(n-1)] + (1/sqrt(5))[phi^(n-1) 1/phi - (-1/phi)^(n-1) (-phi)] \
        & = (1/sqrt(5))[phi^(n-1) - (-1/phi)^(n-1) + phi^(n-1) 1/phi - (-1/phi)^(n-1) (-phi)] \
        & = (1/sqrt(5))[phi^(n-1) (1 + 1/phi) - (-1/phi)^(n-1) (1 - phi)] \
        & = (1/sqrt(5))[phi^(n-1) phi - (-1/phi)^(n-1) (-1/phi)] \
        & = (1/sqrt(5))[phi^n - (-1/phi)^n] \
        & = (phi^n - psi^n)/sqrt(5) \
  $
]

Ahora veamos qué pasa si no somos cuidadosos al usar la hipótesis inductiva.
#let txt = text(red)[
  #prop[En cualquier conjunto de caballos, todos los caballos son del mismo color.]
  #demo[
    Sea $S$ un conjunto de caballos de $n$ elementos. Si $n = 1$, $S$ tiene un único caballo, y obviamente es del mismo color que todos los caballos de $S$. Si $n > 1$, entonces sea $x$ cualquier caballo en $S$. Si sacamos a $x$ de $S$, obtenemos un conjunto $S' = S without {x}$ de $n - 1$ caballos. Por hipótesis inductiva, todos los caballos en $S'$ son del mismo color. Ahora sea $y$ otro caballo, distinto de $x$. Por hipótesis inductiva, en $T = S without {y}$, todos los caballos son del mismo color. Como $x$ e $y$ tienen el mismo color que todos los otros caballos, entonces $x$ e $y$ también son del mismo color entre sí, y luego todos los caballos en $S$ son del mismo color.

    Por inducción, en cualquier conjunto de caballos, todos los caballos son del mismo color.
  ]
]

#let im = image("../horses.png", width: auto)
#wrap-content(im, txt, align: left)


Sin embargo, han visto dos caballos de colores distintos. ¿Cómo puede ser? El error está en ser informal, pues al decir "$x$ e $y$ tienen el mismo color que todos los otros caballos", e intentar argumentar algo con eso, uno tiene que asegurarse de que el conjunto "todos los otros caballos" no es vacío, pues en ese caso no podemos inferir nada. Luego, esta demostración se cae en el caso $n = 2$. Al ser informal y razonar vagamente, miente.

Otra demostración erronea más. ¿Pueden encontrar el error?
#prop[
  Para todo $n in NN$, $2^n = 1$.
]
#text(red)[
  #demo[
    Vamos a probar que vale $P(n)$ para todo $n in NN$, con $P(n): 2^n = 1$.

    + Caso base, $P(0)$. Es cierto que $2^0 = 1$, y luego $P(0)$ es cierta.
    + Paso inductivo. Asumimos que vale $P(j)$ para todo $j < n + 1$, y probemos $P(n + 1)$.

    Manipulamos algebraicamente:
    $
      2^(n+1) & = 2^(2n - (n - 1)) \
              & = 2^(2n) / 2^(n - 1) \
              & = (2^n 2^n) / 2^(n - 1) \
              & = 1 times 1 / 1 "por hipótesis inductiva, tres veces" \
              & = 1
    $

    que es lo que queríamos demostrar.
  ]]

El error vino de usar $P(n - 1)$. Esto no tiene sentido cuando estamos probando $P(1)$, porque entonces $1 = n + 1$ y entonces $n = 0$, y no tiene sentido decir $n - 1$. No fuimos cuidadosos al asumir que $n > 1$, lo cual nos hubiera marcado que debemos probar $P(1)$ por separado, no sólo $P(0)$.

¿Pueden detectar dónde está el error en la siguiente demostración?
#prop[
  Probar que para todo $n in NN$, $5n = 0$.
]
#text(red)[
  #demo[
    Sea la proposición $P(n): 5n = 0$. Vamos a probar $P(n) forall n in NN$ por inducción.
    - $P(0)$. Queremos probar $P(0)$, que significa $5 times 0 = 0$, y esto es cierto. Luego vale $P(0)$.
    - $n > 0 implies P(n)$. Sean $i, j in NN$, con $i < n, j < n$, tales que $i + j = n$. Entonces por hipótesis inductiva vale $P(i)$ y $P(j)$, entonces $5i = 0$ y $5j = 0$. Entonces, $5n = 5(i + j) = 5i + 5j = 0 + 0 = 0$, lo cual prueba $P(n)$.
  ]]

El error está en asumir que existen naturales $i < n, j < n,$ con $i + j = n$. Esto sólo es cierto si $n gt.eq 2$, y entonces nuestra demostración falla para $n = 1$, y se cae la inducción. No fuimos cuidadosos, y nos faltó el caso base $n = 1$.

=== Correctitud de ciclos en algoritmos <fastexp>

Frecuentemente vamos a probar propiedades sobre algoritmos que usan ciclos. La herramienta principal que tenemos para esto es el teorema del invariante. Esto no es nada más que inducción en el número de iteraciones, con un formalismo al rededor para evitar que cometan errores (como, por ejemplo, olvidarse de probar que el ciclo efectivamente termina).

Para usar el teorema del invariante, necesitamos definir cinco cosas:

+ Una precondición $P$. Esto es algo que asumimos que vale antes de comenzar el ciclo.
+ Una postcondición $Q$. Esto es algo que queremos probar que vale al terminar el ciclo.
+ Un invariante $I$. Esto es algo que es válido antes de cada iteración, y después de cada iteración (pero no necesariamente _durante_ una iteración).
+ Una guarda $B$, que nos dice si ejecutaremos la próxima iteración del ciclo, o no.
+ Una función variante $v$, que nos obliga a terminar el ciclo cuando llega a cero.

Y tenemos que demostrar las siguientes seis proposiciones:

#let t = [
  + La precondición vale antes de comenzar el ciclo.
  + La precondición implica el invariante.
  + La función variante decrece con cada iteración.
  + Si la función variante es cero, la guarda es falsa.
  + El invariante y la negación de la guarda implican la postcondición.
  + La guarda y el invariante al comenzar la iteración implican el invariante al terminar la iteración.
]
#let im = image("../proof_bricks.png", width: 70mm)
#wrap-content(im, t, align: bottom + right)

En Algoritmos 1, aprenden a especificar estas proposiciones, y a demostrar estas proposiciones. En la sección de ejemplos muestro varios, pero para mostrarles uno acá, vamos a probar la correctitud del algoritmo de exponenciación en tiempo logarítmico.

#algorithm({
  import algorithmic: *
  Procedure(
    "Exp",
    ($a in NN$, $n in NN$),
    {
      If($n = 0$, {
        Return[$1$]
      })
      Assign[$k$][$n$]
      Assign[$y$][$1$]
      While($k > 1$, {
        If($k mod 2 = 1$, {
          Assign[$y$][$x times y$]
          Assign[$k$][$k - 1$]
        })
        Assign[$x$][$x^2$]
        Assign[$k$][$k \/ 2$]
      })

      Return[$x times y$]
    },
  )
})

#demo[
  Llamemos $x_0$ al valor de $x$ al comenzar el algoritmo. Queremos probar que el programa devuelve $x_0^n$.

  + La precondición del algoritmo es $n > 0, k = n, y = 1, x = x_0$.
  + La postcondición del ciclo es $x times y = x_0^n$.
  + El invariante es $1 lt.eq k lt.eq n and x^k y = x_0^n$.
  + La guarda es $k > 1$.
  + La función variante es $k - 1$.

  Probemos el teorema del invariante para este ciclo.

  + Estamos asignando $k arrow.l n$, $y arrow.l 1$, luego valen $k = n$, $y = 1$. Lo primero que hace nuestro programa es salir si $n = 0$, en cuyo caso devuelve la respuesta correcta y no ejecuta nada más. Luego, al comenzar el ciclo, sabemos que $n in NN, n eq.not 0$, y luego $n > 0$. Finalmente, antes de comenzar el ciclo no modificamos $x$, con lo cual sigue valiendo $x = x_0$.
  + Como vale la precondición, entonces $k = n$, y por ende $k lt.eq n$. Asimismo, la precondición nos dice que $n > 0$, y por ende $k > 0$, o lo que es equivalente, $k gt.eq 1$. Juntando las dos oraciones anteriores, tenemos que $1 lt.eq k lt.eq n$. Finalmente, como la precondición nos dice que $y = 1$ y $x_0 = x$, tenemos $x^k y = x^n y = x^n = x_0^n$, que prueba el invariante.
  + En cada iteración, estamos dividiendo a $k$ por $2$, y quizás restándole $1$, con lo cual siempre va a decrecer, porque $k > 1$ (sólo podría no-decrecer si $k = 0$, porque entonces $k\/2 = k$). Luego, como $k$ decrece, también $k - 1$, la función variante, decrece.
  + Si la función variante es cero, entonces $k - 1 = 0$, y luego $k = 1$. Como la guarda es $k > 1$, el que la función variante sea cero obliga a que la guarda no se cumpla.
  + La negación de la guarda nos dice que $k lt.eq 1$. El invariante nos dice que $1 lt.eq k$. Luego, sabemos que $k = 1$. El invariante también nos dice que $x^k times y = x_0^n$, entonces sabemos que $x^1 times y = x times y = x_0^n$, que es la postcondición.
  + Sabemos que $k > 1$ porque vale la guarda. Partimos en casos, dependiendo de si $k mod 2 = 0$ o $k mod 2 = 1$.
    - Si $k = 2k'$, entonces no entramos al condicional. Lo que hacemos es cuadrar $x$ obteniendo $x'$, y dividir $k$ por dos, obteniendo $k'$. Como vale la guarda, sabemos que $k > 1$, y como $k in NN$, tenemos $k gt.eq 2$. Como $k = 2k'$, vemos que $k' gt.eq 1$, que es la primer parte del invariante. Empezamos la iteración con $x^k y = x_0^n$, es decir $x^(2k') y = x_0^n$. Usando el álgebra de exponenciación, vemos que $x^(2k') = (x^2)^k'$, y $k' = k\/2$. Luego, vemos que vale $(x^2)^k' y = x_0^n$, o $x'^k' y = x_0^n$, que es el invariante al terminar la iteración.
    - Si $k = 2k' + 1$, entonces entramos al condicional. El efecto de la iteración en este caso es transformar $k$ en $k'$, $x$ en $x' = x^2$, y $y' = x times y$. Como $k > 1$, y $k in NN$, sabemos que $k gt.eq 2$, pero como $k$ es impar, $k gt.eq 3$. Como $k = 2k' + 1$, entonces, tenemos $2k' gt.eq 2$, y luego $k' gt.eq 1$, que es la primer parte del invariante. Como vale el invariante al comenzar la iteración, sabemos que $x^(2k' + 1) y = x_0^n$. Nuevamente usando álgebra de exponenciación, obtenemos $x_0^n = x^(2k' + 1) y = x^(2k') x y = (x^2)^k' x y = (x^2)^k' y' = x'^k' y'$, y por tanto vale el invariante al terminar la iteración.

  Concluímos la postcondición, que junto con la salida temprana en el caso de $n = 0$ nos deja concluír que el valor de retorno de nuestro programa es efectivamente $x_0^n$, con lo cual es un algoritmo de exponenciación correcto.
]
#note-box[
  Noten cómo los algoritmos con estado son más engorrosos de demostrar correctos, pues necesitamos más formalidad sobre las transiciones de estado para evitar cometer errores. Un argumento poco riguroso sería decir "En cada iteración, $x^k y = x_0^n$.", pero esto abre la puerta a errores (¿en qué momento de la iteración? ¿por qué es cierto eso?). El teorema del invariante es una herramienta formal para obtener rigor.]

=== Correctitud de algoritmos recursivos

Si nuestro algoritmo es recursivo, en general vamos a usar inducción para probar su correctitud. Veamos una versión recursiva del algoritmo `Exp`.

#algorithm({
  import algorithmic: *
  Procedure(
    "Exp",
    ($a in NN$, $n in NN$),
    {
      If($n = 0$, {
        Return[$1$]
      })
      Assign($b$, FnInline[Exp][$a, floor(n / 2)$])
      Assign[$c$][$b^2$]
      If($n mod 2 = 1$, {
        Assign[$c$][$c times a$]
      })
      Return[$c$]
    },
  )
})

Para probar su correctitud, vamos a definir una noción de "tamaño" de entrada, y probar la correctitud de nuestro algoritmo para todas las entradas de tamaño menor o igual a $n$, para todo $n in NN$.

#prop[
  El algoritmo recursivo devuelve $a^n$.
]
#demo[
  Definamos una propiedad $P(n)$: Para todo $a in NN$, `Exp(`$a, n$`)`$= a^n$.

  - $P(0)$. Queremos ver que `Exp(a, 0)`$= a^0 = 1$ para todo $a in NN$. Si $n = 0$, entonces entramos en el `if` de la línea $2$, y devolvemos $1$, que es la respuesta correcta.
  - $forall n in NN. (n > 0 and (forall k in NN. k < n implies P(k))) implies P(n)$. Vamos a usar inducción global. Si $n > 0$, entonces no entramos en el `if` de la línea 2. Llamamos a `Exp(a, `$floor(n/2)$`)`. Como $floor(n/2) < n$, podemos usar la hipótesis inductiva para ver que $b = a^(floor(n/2))$. Ahora partimos en casos:
    - Si $n equiv 0 mod 2$, entonces $floor(n/2) = n/2$. Luego, $a^n = (a^(n/2))^2$. Como asignamos $b arrow.l a^(n/2)$, y luego $c arrow.l b^2$, vemos que $c = a^n$. Como $n equiv mod 2$, no entramos en el `if` de la línea 7. Luego, cuando devolvemos $c$ en la línea 10, estamos devolviendo $a^n$, que es la respuesta correcta.
    - Si $n equiv 1 mod 2$, entonces $floor(n/2) = (n-1)/2$. Luego, $a^n = a^(2(n-1)/2 + 1) = a^(2(n-1)/2) times a = a^(floor(n/2))^2 times a$. Como asignamos $b arrow.l a^(floor(n/2))$, y luego $c arrow.l b^2$, vemos que $c = a^(2(n-1)/2)$. Como $n equiv 1 (mod 2)$, entonces entramos al `if` de la línea 7, y multiplicamos a $c$ por $a$, obteniendo $c = a^(2(n-1)/2) times a = a^(2(n-1)/2 + 1) = a^(n - 1 + 1) = a^n$. Luego, cuando devolvemos $c$ en la línea 10, estamos devolviendo $a^n$, que es la respuesta correcta.
]

Vemos como es más fácil demostrar esto que un algoritmo iterativo, que cambia estados. Esto es cierto en general, y es parte del motivo por el cual la gente usa algoritmos y lenguajes de programación funcionales.

=== Definiciones equivalentes
Si tenemos definiciones equivalentes para nuestro objeto, podemos hacer uso de cualquiera de ellas. Por ejemplo:

#ej[
  Recordemos que una función $f: RR arrow RR$ es continua en un punto $x_0 in RR$ si cumple cualquiera de las siguientes definiciones equivalentes:
  - Para todo $epsilon gt.eq 0$, existe $delta gt.eq 0$ tal que para todo $x in RR$, si $|x - x_0| < delta$, entonces $|f(x) - f(x_0)| < epsilon$.
  - Para toda sucesión $(x_n)_{n in NN}$ en $RR$ que converge a $x_0$, la sucesión $(f(x_n))_{n in NN}$ converge a $f(x_0)$.

  Sea $f$ la función definida por:
  $
      f: & RR arrow RR \
    f(x) & = cases(
             1 "si" x in QQ,
             0 "si" x in.not QQ
           )
  $

  Demostrar que $f$ no es continua en ningún punto.
]
#demo[
  La primer noción de continuidad parece difícil de usar acá, pues para cualquier $delta gt.eq 0$, podemos encontrar un número racional y un número irracional dentro del intervalo $(x_0 - delta, x_0 + delta)$, y luego no podemos encontrar un único $delta$ que funcione para todos los $x$ en ese intervalo. La segunda definición parece más manejable.

  Vamos a encontrar dos secuencias que convergen a $x_0$, una $(q_n)$ de números racionales y otra $(i_n)$ de números irracionales. Por ejemplo, podemos tomar la sucesión $q_n = floor(10^n x_0)/10^n$, que es truncar $x_0$ a $n$ decimales, y la sucesión $i_n = q_n + sqrt(2) / 10^n$. Como $q_n$ es racional para todo $n in NN$, $i_n$ es irracional, y la secuencia $(i_n)$ también converge a $x_0$. Entonces, tenemos que $f(q_n) = 1$ para todo $n in NN$, y $f(i_n) = 0$ para todo $n in NN$.

  Si asumimos que $f$ es continua en $x_0$, ambas sucesiones $(f(q_n))$ y $(f(i_n))$ convergen a $f(x_0)$. Sin embargo, la primer sucesión es constantemente $1$, y luego converge a $1$, y la segunda sucesión es constantemente $0$, y luego converge a $0$. Luego, $f(x_0) = 1$ y $f(x_0) = 0$, lo cual es una contradicción. Luego, $f$ no es continua en ningún punto $x_0 in RR$.
]



/*
Por ejemplo, si tenemos que probar que agregarle una arista a cualquier árbol crea un ciclo en el grafo resultante, podemos usar cualquiera de las definiciones equivalentes de árbol:

A un grafo $G = (V, E)$ con $n$ vértices y $m$ aristas se le dice árbol cuando cumple cualquiera de las siguientes condiciones equivalentes:
- $G$ es conexo y acíclico.
- $G$ es conexo y $m lt.eq n - 1$.
- $G$ es acíclico y $m gt.eq n - 1$.
- $G$ es conexo y sacarle cualquier arista lo desconecta.
- $G$ es acíclico y agregarle cualquier arista produce un ciclo.
- Cualquier par de vértices en $G$ está conectado por un único camino en $G$.

En este caso, probablemente nos sea útil que un árbol es un grafo $G = (V, E)$ tal que para todo $v, w$ en $V$, existe en $G$ un único camino entre $v$ y $w$. Al agregar una arista $e = (v, w)$, y sabiendo que ya había un camino entre $v$ y $w$, vamos a poder crear un ciclo. Para esto es importante saber _todas_ las definiciones equivalentes de los objetos que usamos.

  #align(center)[
    #box(stroke: 0.5pt, inset: 2mm)[
    #diagram({
      node((2, 0), "", stroke: 1pt, name: "v0")
      node((4, 1.25), "", stroke: 1pt, name: "v1")
      node((1, 0.5), "", stroke: 1pt, name: "v2")
      node((3, 2), $u$, stroke: 1pt, name: "v3")
      node((7, 0), "", stroke: 1pt, name: "v4")
      node((6, 1.5), $v$, stroke: 1pt, name: "v5")
      node((5, 0), "", stroke: 1pt, name: "v6")

      let edges = (("v1", "v2"), ("v1", "v5"), ("v1", "v0"), ("v3", "v2"), ("v1", "v6"), ("v6", "v4"))
      for (u, v) in edges {
        edge(label(str(u)), label(str(v)), stroke: 1pt + black)
      }

      edge(label("v3"), label("v5"), stroke: 1pt + red)
    })]
  ]
*/

Si tenemos que probar condiciones equivalentes, frecuentemente nos va a ser útil ordenarlas de manera que cada una implique la próxima, y la última implique la primera, estableciendo así la equivalencia entre todas, usando sólo implicaciones.

#ej[
  Sea $X$ un conjunto, y $tilde$ una relación de equivalencia en $X$. Sean $a, b in X$. Entonces son equivalentes:

  + $a tilde b$
  + $[a] inter [b] eq.not emptyset$
  + $[a] = [b]$
]
#demo[

  - 1 $implies$ 2: Como $a tilde b$, entonces $b$ es un elemento de $[a]$. También $b$ es un elemento de $[b]$. Entonces $b in [a] inter [b]$, y luego $[a] inter [b] eq.not emptyset$.
  - 2 $implies$ 3: Sea $y in [a] inter [b]$. Luego $y tilde a$ como también $y tilde b$. Entonces para todo $x in [a]$, tenemos por transitividad que $x tilde y tilde b$, y luego $x in [b]$, y luego $[a] subset.eq [b]$. De la misma manera, si $x in [b]$, tenemos que $x tilde b tilde y tilde a$, y luego $x in [b]$, y $[b] subset.eq [a]$. Entonces $[a] = [b]$.
  - 3 $implies$ 1: Como $[a] = [b]$ y $a in [a]$, entonces $a in [b]$, y luego $a ~ b$.
]

=== Contrarecíproco y contradicción

Si tenemos que probar una implicación, es decir una proposición de la forma $P implies Q$, podemos probar algo equivalente, que es el contrarecíproco de esa implicación. El contrarecíproco de $P implies Q$ es $(not Q) implies (not P)$. Hacemos esto cuando nos es más cómodo tener de antecedente $not Q$, por ejemplo porque ya probamos $not Q$ y queremos usar esto en un _modus ponens_ para probar $not P$.

Esto también se puede usar para probar proposiciones en general, aún cuando no sean inmediatamente implicaciones. Si tenemos la proposición $P$, esta es equivalente a la proposición $top implies P$. Luego, es equivalente a su contrarecíproco, que es $(not P) implies bot$. Esto se llama probar $P$ por contradicción, o a veces, "por absurdo".

Aún siendo equivalentes, a veces una va a ser más fácil de probar que la otra. Por ejemplo, si $P$ es de la forma $P: not(exists y. Q(y))$, parece difícil probarla, porque es difícil probar la no-existencia de algo, uno parece carecer de herramientas. Al negarla obtenemos $exists y. Q(y)$. Eso nos da otro objeto ($y$), otro sustantivo del cual hablar, y con el cual razonar. Cambiamos nuestra misión a ver si podemos obtener algo internamente contradictorio sobre $y$, y queremos llegar a $bot$. Lo mismo sucede si tenemos una proposición de la forma $P: forall x. Q(x)$. Probar esto por contradicción es probar $(not (forall x. Q(x))) implies bot$, que es lo mismo que decir $(exists x. not Q(x)) implies bot$. Eso otra vez nos da un objeto, $x$, del cual hablar.

Por ejemplo, el siguiente teorema era probablemente sabido por Aristóteles, y aparece en "Elementos" de Euclides:

#teo[
  $sqrt(2) in.not QQ$.
]
#demo[
  Asumamos $sqrt(2) in QQ$. Luego, existen $a, b in ZZ$ tal que $sqrt(2) = a/b$, con $b eq.not 0$. Podemos elegir a $a, b$ coprimos, dado que si no lo fueran, tomamos $a / b = (a / d) / (b / d)$, con $d = gcd(a, b)$, y ahora teniendo el numerador y denominador coprimos.

  Como $sqrt(2) = a/b$, tenemos que $a^2/b^2 = 2$, y luego $a^2 = 2b^2$. Luego $a$ es par, pues $a^2$ lo es, y el cuadrado de un número impar sería impar.

  Entonces existe $k in ZZ$, tal que $a = 2k$. Usando esto obtenemos que $2b^2 = (2k)^2 = 4k^2$, y luego $b^2 = 2k^2$. Luego, $b$ también es par, porque su cuadrado es par.

  Luego ambos $a$ y $b$ son pares. Esto no puede suceder, porque dijimos que eran coprimos. Luego, lo que asumimos es falso, y no es cierto que $sqrt(2) in QQ$. Esto prueba que $sqrt(2) in.not QQ$, que es lo que queríamos demostrar.
]

El motivo por el que la demostración es por contradicción es porque el que $x$ no esté en $QQ$ nos dice poco, sólo que $x in RR without QQ$, pero no es cómodo hablar sobre los irracionales. El demostrar por contradicción nos deja "imaginar" que $x in QQ$, y el objetivo es llegar a $bot$, algo falso. Usando esta hipótesis concluímos cosas útiles sobre $x$, como que $x = n/m$ con $n, m in ZZ, m eq.not 0$.

#warning-box[Frecuentemente vemos alumnos empezar usando esta estrategia automáticamente, sin pensar en por qué se lo está haciendo. Imaginamos que es porque les da algo que escribir, y "se parece a progreso". Pero realmente no sugerimos hacer esto sin tener una razón específica, muchas veces se confunden con la cantidad (y paridad) de negaciones, ya que cada vez que hacen esto agregan una negación más. Eventualmente cometen algún error, llegan a un absurdo, y dicen "¡Listo, terminé!", pero el absurdo vino de hacer otra cosa mal en el medio.

  Las demostraciones por contradicción son una fuente clásica de errores de alumnos.@contra]

Si van a usar esta estrategia, recuerden las reglas de negación.
#align(center)[
  $
    not (forall x in X. P(x)) & iff exists x in X. not(P(x)) \
    not (exists x in X. P(x)) & iff forall x in X. not(P(x)) \
            not (P implies Q) & iff (not Q) implies (not P) \
                 not (P or Q) & iff (not P) and (not Q) \
                not (P and Q) & iff (not P) or (not Q) \
                      not bot & iff top \
                      not top & iff bot
  $]

Vemos frecuentemente el error #text(red)[$not (P implies Q) iff not P implies not Q$], y #text(red)[$not (P implies Q) iff Q implies P$]. A continuación hay varios ejemplos de usos de negación y contradicción, sólo algunos son correctos.

#let reddish = red.lighten(80%)
#let greenish = green.lighten(80%)
#let yellowish = yellow.lighten(80%)
#grid(
  columns: 2,
  stroke: 0.5pt + black,
  fill: (_, y) => if y in (0, 2, 4, 8, 10) { reddish } else if y in (6,) { yellowish } else { greenish },
  inset: 5pt,
  [Si la inflamación no se va, el dolor vuelve. Luego, voy a tomar Anaflex, porque saca la inflamación.],
  [$P =$ La inflamación se va, $Q =$ El dolor vuelve, $R =$ Tomo Anaflex. Asumimos que $(not P) implies Q$, y que $R implies P$. No podemos concluir que $R implies not Q$. Perfectamente puede ser que $Q = top$, y el dolor siempre vuelve. Tomar Anaflex no hace nada para el dolor. La "demostración" asume que $(not P implies Q) iff (P implies not Q)$, que es mentira#footnote[El autor de este documento ha odiado esa publicidad más de 20 años, precísamente por ser un mal uso de operaciones lógicas.].],

  [Sea $A$ un conjunto que contiene a todos los conjuntos. Sea $B = {x in A | x in.not x}$. Si $B in B$, entonces por definición de $B$, $B in.not B$, que no puede suceder. Si no, $B in.not B$, y por definición de $B$, $B in B$, que no puede suceder. Luego, $A$ no puede existir.],
  [Esto es correcto. En ambas ramas, llegamos a una contradicción. Si $P implies Q$ y $not(P) implies Q$, entonces vale $Q$. En este caso, $Q = bot$, $P = B in B$. Luego, si asumimos que $A$ existe, probamos $bot$, y por ende concluimos que $A$ no existe.#footnote[Esta es la paradoja de Russell@russell.]],

  [Queremos ver si vale la siguiente proposición: "Sea $k gt.eq 1$, con $k in ZZ$. Si $k$ es tal que $2^k equiv 0 (mod 3)$, entonces $8 equiv 1 (mod 3)$". Vemos que hay un contraejemplo, con $k = 1$, tenemos $8^1 = 8 equiv.not 3 (mod 2)$, pues $8 = 2 times 3 + 2 equiv 2 (mod 3)$.],
  [Esto está mal. Tenemos una proposición $P(k): Q(k) implies R(k)$ sobre todos los $k in ZZ, k gt.eq 1$, con $Q(k): 2^k equiv 0 (mod 3)$, y $R(k): 8 equiv 1 (mod 3)$. Lo que encontramos es un contraejemplo a $R(k)$, pero esto no implica que $P(k)$ sea falsa. De hecho $P(k)$ siempre es cierta, pues $Q(k)$ es falsa para todo tal $k$. $P(k)$ es equivalente a $not Q(k) or R(k)$, y como $Q(k)$ es siempre $bot$, entonces $P(k)$ es equivalente a $top or R(k)$, que es equivalente a $top$. Luego, $P(k)$ siempre es cierta para tales $k$.],

  [Queremos ver que si $a^2 = 0$, con $a in RR$, entonces $a = 0$. Supongamos que $a eq.not 0$. Entonces existe $a^(-1) in RR$. Luego, $a^2 = 0 implies a^(-1) a^2 = 0 implies a = 0$, con lo cual concluimos que $a = 0$, una contradicción pues asumimos que $a eq.not 0$. Luego, lo que asumimos no puede suceder, y tenemos que $a = 0$.],
  [Está bien. Asumimos $not P$, y llegamos a una contradicción. En particular, llegamos a $P$. Luego, no puede suceder que valga $not P$, y efectivamente tenemos que vale $P$ sin asumir nada.],

  [Sea $n in NN$, y $f: {1, dots, n} arrow {1, dots, n}$. Queremos probar que si $f$ es inyectiva, entonces es sobreyectiva. Asumimos, entonces, que $f$ no es inyectiva. Luego existen $1 lt.eq a, b lt.eq n$ tales que $f(a) = f(b)$. Como a algún elemento del codominio le llegan dos flechas, hay algún elemento del codominio al que no le llega ninguna. Luego $f$ no es sobreyectiva.],
  [Esto confunde $A implies B$ con $not A implies not B$. Lo que el autor quizo probar, quizás, es $not B implies not A$, que sí es equivalente a $A implies B$. Se confundió, quizás, por no ser suficientemente formal.],

  [Queremos ver que existe un irracional $x in RR$ tal que $x^x$ es racional. Sea $x$ una solución real a $x^x = 2$, que existe en $(1, 2)$ por el teorema del valor medio, pues $1^1 = 1$ y $2^2 = 4$, con $x^x$ continua. Supongamos que $x = p/q$, con $p$ y $q$ enteros positivos coprimos. Como $x > 1$, entonces $p > q$, y luego $p - q > 0$. Tomando $q$-ésimas potencias a ambos lados de $x^x = 2$, obtenemos $(p/q)^p = 2^q$, y luego $p^p = q^p 2^q$. Luego $p$ es par, $p = 2k$ para algún $k in NN$. Tenemos $(2k)^(2k) = q^p 2^q implies 2^(2k) k^(2k) = q^p 2^q implies 2^(2k - q) k^(2k) = q^p implies 2^(p - q) k^(2k) = q^p$. Como una potencia de $q$ es par, $q$ es par, lo cual contradice que $p$ y $q$ eran coprimos. Luego no pueden existir $p, q$, y $x$ es irracional. ],
  [Está bien. Asumimos $P: exists p, q in NN. gcd(p, q) = 1 and p, q > 0 and x = p/q$, que es equivalente a que $x$ es un racional positivo. Llegamos a un absurdo, pues $2 divides gcd(p, q)$, y $2 divides.not 1$. Luego no puede ser que valga $P$, o equivalentemente, no puede ser que $x in QQ$. Como $x in RR$, entonces $x in RR without QQ = II$.],

  [Queremos probar que si $x$ e $y$ son racionales, entonces $x + y$ es racional. Escribimos $x = a/b, y = c/d$, con $b eq.not 0$, $c eq.not 0$, y $a, b, c, d in ZZ$. Asumimos que $x + y in.not QQ$. Luego vemos que $x + y = a/b + c/d = (a d + b c)/(b d)$. Como $b eq.not 0$, y $d eq.not 0$, entonces $b d eq.not 0$. Como $a, b, c, d in ZZ$, entonces $a d + b c in ZZ$, y $b d in ZZ, b d eq.not 0$. Luego $x + y in QQ$, que contradice que $x + y$ era irracional. Luego lo que asumimos no puede suceder, y concluímos que $x + y in QQ$.],
  [Esta demostración no está "mal", pero no usa la contradicción en ningún momento. Es de la forma "Asumo $not P$. Pruebo $P$ sin usar $not P$. Esto contradice que $not P$, luego vale $P$." Pero $P$ vale porque probamos $P$, no por la contradicción con $not P$. La contradicción es enteramente superflua, y sólo hace más difícil leer la demostración, ambos para el que la corrige, y para el alumno que intenta ver si cometió un error.

    Esto pasa cuando los alumnos mecánicamente intentan usar contradicción, sin pensar por qué lo está haciendo.],

  [Queremos ver que existen dos irracionales $x, y in RR without QQ$, tales que $x^y in QQ$. Sea $A = sqrt(2)^(sqrt(2))$. Si $A$ es racional, terminamos, pues $x = sqrt(2), y = sqrt(2)$ resuelve lo pedido. Si no, $A$ es irracional. Pero luego, $A^(sqrt(2)) = sqrt(2)^(sqrt(2) sqrt(2)) = sqrt(2)^2 = 2 in QQ$, y luego $x = A, y = sqrt(2)$ resuelve lo pedido.],
  [Está bien. Si $P: A in QQ$, y $Q: exists x, y in II. x^y in QQ$, entonces probamos que $P implies Q$, y que $(not P) implies Q$. Juntando ambas oraciones, tenemos que $(P or not P) implies Q$, que es equivalente a $top implies Q$, que es equivalente a $Q$. Luego, probamos $Q$. Notar que esta demostración no prueba que $A$ es racional.#footnote[Uno puede usar el teorema de Gelfond-Schneider@niven para probar que $A$ no sólo es irracional, sino que es transcendental.].],

  [Queremos probar que para todo $n in NN$, si $2n + 1 equiv 0 (mod 3)$, entonces $n^2 + 1 equiv 0 (mod 3)$. Por contrarecíproco, asumimos que $2n + 1 equiv.not 0 (mod 3)$. Entonces partimos en casos:
    - Si $n = 3k + 1$ con $k in NN$, entonces $n^2 + 1 = 9k^2 + 6k + 2 equiv 2 equiv.not 0 (mod 3)$.
    - Si $n = 3k + 2$ con $k in NN$, entonces $n^2 + 1 = 9k^2 + 12k + 5 equiv 2 equiv.not 0 (mod 3)$.

    En ambos casos, $n^2 + 1 equiv.not 0 (mod 3)$. Por contrarecíproco, si $2n + 1 equiv 0 (mod 3)$, entonces $n^2 + 1 equiv 0 (mod 3)$, que es lo que queríamos demostrar.],
  [
    Esto está mal, confunde $A(n) implies B(n)$ con $not A(n) implies not B(n)$, donde $A(n): 2n + 1 equiv 0 (mod 3)$, y $B(n): n^2 + 1 equiv 0 (mod 3)$. Lo que queríamos probar es $A(n) implies B(n)$, pero lo que esto prueba es $not A(n) implies not B(n)$.

  ],

  [Sean $u, v, w$ vectores linealmente independientes en un espacio vectorial real $V$, y $T: V arrow W$ una transformación lineal inyectiva. Queremos probar que ${T(u), T(v), T(w)}$ es linealmente independiente. Asumamos que no. Luego, como ${T(u), T(v), T(w)}$ es linealmente dependiente, existen $alpha, beta, gamma in RR$, no todas cero, tal que $alpha T(u) + beta T(v) + gamma T(w) = 0$. Asumamos sin pérdida de generalidad que $alpha eq.not 0$. Luego $T(u) = -beta/alpha T(v) - gamma/alpha T(w)$. Esto es lo mismo que decir que $T(u) = T(-beta v / alpha - gamma w / alpha)$. Pero $T$ es inyectiva, luego $u = -beta v / alpha - gamma w / alpha$. Esto no puede suceder, pues $u$ sería una combinación lineal de $v$ y $w$, y sabemos que ${u, v, w}$ son linealmente independientes.],
  [Está bien. Notar cómo asumimos $alpha eq.not 0$ sin pérdida de generalidad. Esto significa que como alguno de los tres coeficientes no es cero, podemos renombrar las variables para que se coeficiente sea $alpha$. Nada en la demostración depende de cuál exactamente es $u$, $v$, o $w$, o $alpha$, $beta$, o $gamma$.

    Asumimos que vale $not ({T(u), T(v), T(w)}$ es linealmente independiente$)$, y llegamos a una contradicción. Esto nos dice que ${T(u), T(v), T(w)}$ es linealmente independiente, que es lo que queríamos probar.],

  [Queremos ver que para todo $x in RR, x^2 gt.eq 0$. Asumimos, por contradicción, que para todo $x in RR, x^2 lt 0$. Tomemos $x = 3$, y vemos que $3^2 = 9 gt.eq 0$. Esto contradice lo que asumimos, y por lo tanto $x^2 gt.eq 0$ para todo $x in RR$.],
  [Esto está mal. Intenta negar $forall x in RR. x^2 gt.eq 0$, y dice que eso es $forall x in RR. x^2 < 0$. La negación correcta es $exists x in RR. x^2 < 0$. La demostración no prueba lo pedido.],

  [Queremos ver que no existe un programa $H$ que, dado cualquier programa $P$, devuelve #smallcaps("True") si y sólo si $P()$ se detiene, y #smallcaps("False") si no. Asumamos que $H$ existe. Sea $A$ el siguiente program:

    #algorithm({
      import algorithmic: *
      Procedure(
        "A",
        (),
        {
          If($H(A)$, {
            While(smallcaps("True"))
          })
        },
      )
    })

    Consideremos $H(A)$. Si $H(A) = #smallcaps("True")$, entonces $A()$ debe detenerse, con lo cual nunca entramos al ciclo infinito, pero entonces $not H(A)$, que no puede suceder pues asumimos $H(A)$.
    Por otro lado, si $H(A) = #smallcaps("False")$, entonces $A$ tuvo que entrar al ciclo, y luego $H(A)$, que no puede suceder pues asumimos $not H(A)$.

    Luego $H$ no puede existir.
  ],
  [Está bien. Partimos en casos, dependiendo del valor de $H(A)$. En ambas ramas, llegamos a una contradicción asumiendo la rama. Luego lo que asumimos inicialmente es falso, es decir, $H$ no puede existir. Este es un caso particular del "halting theorem"@halting.],
)


=== Si y sólo si
Si tenemos que probar un si-y-sólo-si ($iff$), podemos probar por separado $implies$ y $arrow.double.l$. Es muy común que uno de los dos sea muy fácil, y el otro sea más difícil. Por ejemplo:

#teo(title: [Cantor-Schröder-Bernstein])[
  Sean $A$ y $B$ dos conjuntos. Entonces son equivalentes:
  - Existe una función biyectiva $h: A arrow B$.
  - Existe una función inyectiva $f: A arrow B$, y una función inyectiva $g: B arrow A$.
]
#demo[
  - $implies$) Asumamos que existe una función biyectiva $h: A arrow B$. Entonces, $h$ es inyectiva, y su inversa $h^(-1): B arrow A$ también es inyectiva. Luego, existen funciones inyectivas $f=h: A arrow B$ y $g=h^(-1): B arrow A$.
  - $implied$) Esta demostración es de Dedekind@dedekind. Sea $C_0 = A without g(B)$, y para $n gt.eq 0$, definimos recursivamente $C_(n+1) = g(f(C_n))$. Definimos $C = union_(n in NN) C_n$. Definimos la función $h: A arrow B$ como:
    $
      h(x) = cases(
        f(x) "si" x in C,
        g^(-1)(x) "si" x in.not C
      )
    $

    Para ver que $h$ está bien definida, sea $x in A$. Si $x in.not C$, entonces $x in.not C_0$, con lo cual $x in g(B)$, y luego existe $g^(-1)(x) in B$. Luego, $h(x)$ está bien definida.

    Ahora veamos que $g^(-1)(A without C)$ siempre cae en $B without f(C)$. Asumamos lo contrario, y supongamos que existe un $x in A without C$ tal que $g^(-1)(x) = f(z)$ para algún $z in C$. Llamemos $y = f(z)$. Como $C = union_(n in NN) C_n$, existe $n$ tal que $z in C_n$. Como $y = f(z)$ y $x = g(y)$ (pues $y = g^(-1)(x)$), y entonces $x = g(f(z)) in C_(n+1) subset.eq C$, lo cual contradice que $x in A without C$. Luego, $g^(-1)(A without C) subset.eq B without f(C)$.

    Con esto, veamos que $h$ es inyectiva. Sabemos que $f$ y $g^(-1)$ son inyectivas. Luego, si $h$ fuera no-inyectiva, tendríamos que tener $h(x) = h(y)$ con $x in C$ e $y in.not C$, es decir, $f(x) = g^(-1)(y)$. Sin embargo, $f$ manda elementos de $C$ a elementos de $f(C)$, mientras que, como vimos, $g^(-1)$ manda elementos de $A without C$ a elementos de $B without f(C)$. Luego las imágenes de $f$ y $g^(-1)$ no intersecan, y nunca podemos tener $f(x) = g^(-1)(y)$. Luego, $h$ es inyectiva.

    Ahora vamos a mostrar que si $y in B$ es tal que $g(y) in C$, entonces $y in f(C)$. Como $g(y) in C = union_(n in NN) C_n$, existe $n$ tal que $g(y) in C_n$. Si $n = 0$, entonces $g(y) in C_0 = A without g(B)$, lo cual no puede suceder. Luego, $n gt.eq 1$, y entonces $g(y) in C_n = g(f(C_(n-1)))$. Como $g$ es inyectiva, tenemos que $y in f(C_(n-1)) subset.eq f(C)$. Luego, si $g(y) in C$, entonces $y in f(C)$.

    Para ver que $h$ es sobreyectiva, consideremos cualquier $y in B$. Queremos decir que $y in h(A)$. $y$ puede estar en $f(C)$, o no. Si $y in f(C)$, entonces existe un $x in C subset.eq A$ tal que $f(x) = y$, y por lo tanto $h(x) = y$. Si $y in.not f(C)$, por el párrafo anterior sabemos que $g(y) in A without C$. Luego, $h(g(y)) = g^(-1)(g(y)) = y$. En ambos casos, existe un $x in A$ tal que $h(x) = y$. Luego, $h$ es sobreyectiva.
]

/*
#teo(title: [Erdős-Gallai])[
    Sea $d_1 gt.eq d_2 gt.eq dots gt.eq d_n$ una secuencia de números naturales no-creciente. Entonces existe un grafo $G = (V, E)$ con $|V| = n$ y $d_G (v_i) = d_i$ para todo $1 lt.eq i lt.eq n$, si y sólo si $sum_i d_i$ es par y para todo $1 lt.eq k lt.eq n$, tenemos

    $
      sum_(i = 1)^k d_i lt.eq k (k-1) + sum_(i=k+1)^n min(d_i, k)
    $
  ]

 Probar que una secuencia gráfica cumple eso es fácil. El probar que si eso se cumple para una secuencia, entonces existe un grafo con esa secuencia gráfica, es bastante difícil. Una demostración constructiva es dada por el algoritmo de Havel-Hakimi.

 Esencialmente lo que está pasando en esa demostración es que uno de los lados del si-y-sólo-si es una condición global (el existir un grafo que cumple con lo pedido), mientras que el otro lado es un montón de condiciones locales (una por cada $k$). Es fácil implicar cada condición local, pero probar que la unión de todas las condiciones locales implica la condición global es difícil.
*/
#show figure: set align(center)
#grid(
  columns: (1fr, 1fr),
  column-gutter: 0pt,
  figure(
    image("../sisyphus.jpg", height: 40mm),
    caption: [Sísifo probando la vuelta de Cantor-Schröder-Bernstein.],
  ),
  figure(
    rotate(270deg, reflow: true, image("../sisyphus.jpg", width: 40mm)),
    caption: [Sísifo probando la ida de Cantor-Schröder-Bernstein.],
  ),
)

#warning-box[Uno puede probar un si-y-sólo-si mediante una cadena de $iff$, pero tiene que tener cuidado que absolutamente todos los pasos que uno haga a las proposiciones que está manejando, sean equivalencias, y no sólo implicaciones. Por esto frecuentemente es más fácil hacer cada implicación por separado, y luego si uno se da cuenta que se puede hacer ambas al mismo tiempo, reescribirlo de esa forma.

  Por ejemplo, la siguiente demostración es incorrecta porque usa una implicación pero dice usar un si-y-sólo-si.

  #prop[
    $-2 = 2$.
  ]
  #text(red)[
    #demo[
      Sea $x = -2$. Entonces:
      $
                x & = -2      & iff \
              x^2 & = 4       & iff \
        sqrt(x^2) & = sqrt(4) & iff \
                x & = 2
      $
    ]]

  El error está en que $x = 2$ implica $sqrt(x^2) = sqrt(4)$, pero la vuelta no vale. Para probar una cadena de si-y-sólo-si, absolutamente todos los pasos deben ser si-y-sólo-si. Con que haya una implicación sin vuelta cierta, todo está mal.

  Sucede lo mismo dando vuelta el argumento:

  #text(red)[
    #demo[
      Sea $x = 2$. Entonces:

      $
                x & = 2       & iff \
        sqrt(x^2) & = sqrt(4) & iff \
              x^2 & = 4
      $

      Por lo tanto cualquier solución a $x^2 = 4$ es solución de nuestra ecuación, y en particular $-2 = 2$.
    ]]
]

=== Partir en casos
Si tenemos que probar $forall x in X. P(x)$ y podemos dividir el dominio $X$ de forma productiva, donde cada subconjunto de $X$ tiene una demostración de $P$ simple pero mayormente independiente, podemos partir en casos. Por ejemplo:

#ej[
  Sea $n in ZZ$. Entonces $n(n+1)$ es par.
]
#demo[
  Partimos en casos.
  + Si $n$ es par, entonces existe $k in ZZ$ tal que $n = 2k$. Luego, $n(n+1) = 2k(2k+1)$. Llamando $m = k(2k+1)$, vemos que $n(n+1) = 2m$, con lo cual $n(n+1)$ es par.
  + Si $n$ es impar, entonces existe $k in ZZ$ tal que $n = 2k+1$. Luego, $n(n+1) = (2k+1)(2k+1+1) = (2k+1)(2k+2) = (2k+1)2(k+1)$. Llamando $m = (k+1)(2k+1)$, tenemos que $n(n+1) = 2m$, con lo cual $n(n+1)$ es par.
]

Cuando hacemos esto, es importante tener en cuenta cuán difícil es la demostración en cada caso. Si partimos en, por ejemplo, $n = 0$ y $n eq.not 0$, pero uno de los casos es mucho más difícil que el otro, entonces el caso que es más difícil requiere mucho más esfuerzo y detalle. A veces vemos alumnos que hacen el caso simple con detalle, y el caso complejo lo dejan vago, lo cual es bastante inútil.

=== Unicidad
Si tenemos que probar que "existe un único $x$ en $X$ tal que $P(x)$", una estrategia común es tomar dos objetos que cumplan $P(x)$, y concluir que son el mismo.

#ej[
  Probar que existe una única matriz $I$ en $M_n (ZZ)$, el conjunto de matrices $n times n$ con entradas con coeficientes enteros, tal que para toda matriz $A in M_n (ZZ)$, vale $I A = A I = A$.
]
#demo[
  Sean $I, J$ dos matrices en $M_n (ZZ)$ tales que para toda matriz $A in M_n (ZZ)$, vale $I A = A I = A$ y $J A = A J = A$. Queremos ver que $I = J$. Consideremos la matriz $A = J$. Entonces, por definición de $I$, tenemos $J I = J$. Por otro lado, considerando $A = I$, por definición de $J$ tenemos que $J I = I$. Luego, $I = J I = J$.
]

/*
Otro ejemplo de unicidad, pero en grafos y árboles.

#ej[
  Un ciclo es un circuito simple, es decir, que no repite vértices.

  Sea $G = (V, E)$ un grafo, $T = (V, E_T)$ un árbol generador, y $e in E without E_T$. Entonces $T' = (V, E_T union {e})$ tiene un único ciclo.
]
#demo[
  Sean ${u, v} = e$ los extremos de $e$. Como $T$ es un árbol, para todo par de vértices en $T$, hay un único camino entre ellos en $T$. Luego, sea $P = [u, x_1, x_2, dots, x_k, v]$ el camino en $T$ entre $u$ y $v$. Entonces $C = [u, x_1, x_2, dots, x_k, v, u]$ es un circuito en $T'$ que usa $e$. Tenemos que probar que este circuito es simple, y que no hay otro ciclo en $T'$.

  Si $C$ no fuera simple, entonces existe un vértice $w$ en $C$ que $C$ visita dos veces. Luego $C = [u, x_1, x_2, dots, x_(i-1), x_i = w, x_(i+1), dots, x_(j - 1), x_j = w, x_(j+1), dots, v, u]$, con $j - i > 0$ (si no, $C$ no está visitando $w$ dos veces). Luego aún sin la arista ${v, u}$, tenemos un ciclo $[x_i = w, x_(i+1), dots, x_(j-1), x_j = w] subset.eq E_T$ con longitud $j - i > 0$, pero $T$ era un árbol, luego acíclico, y esto no puede suceder. Luego $C$ es simple.

  Entonces, $C$ es simple. Sea $C'$ otro ciclo simple en $T'$. Si $C'$ no contiene a $e$, entonces $C'$ está también en $T$, lo cual no puede pasar por ser $T$ acíclico. Entonces escribimos $C' = [u, y_1, dots, y_q, v, u]$. Esto nos da dos caminos entre $u$ y $v$ en $T$: $P = [u, x_1, dots, x_k, v]$, y $P' = [u, y_1, dots, y_q, v]$. Pero como $T$ es un árbol, existe sólo un camino entre $u$ y $v$ en $T$, y luego $[x_1, dots, x_k] = [y_1, dots, y_q]$.

  Luego, $C' = C$, que es lo que queríamos demostrar.
]
*/

A veces vamos a usar el contrarecíproco para probar unicidad, postulando que existen dos objetos distintos que cumplen una propiedad, y llegando a un absurdo. Les reitero que no usan el contrarecíproco mecánicamente, pero sí que lo conozcan como herramienta.

== Pasar en limpio

Gran parte de una demostración es jugar con los objetos, e intentar ver qué sucede. Eventualmente, uno llega a un argumento formal sólido. Sin embargo, al comunicarle este argumento a alguien, no hace falta comunicar todas las cosas que pensamos, las ecuaciones que no llevaron a nada, los errores que cometimos, los ejemplos que intentamos, los dibujos que nos confundieron, etcétera.

Es difícil comunicar el patrón incoherente de ideas que pasan por la cabeza mientras uno juega, pero el siguiente es un intento de mostrarlo, y luego la demostración final que uno pasa en limpio, obviando todos los caminos sin salida. No se supone que el texto a continuación sea totalmente comprensible, es sólo un camino vueltero que pueden transitar al jugar.

#ej[
  Demostrar que para todo $n in NN$, $n > 0$, todo tablero de $2^n times 2^n$ casillas con una casilla removida, puede ser cubierto completamente con triominos (pieza que cubre tres casillas, en forma de L).
]
// The type of pieces is an array of pairs (color, array of positions). It
// instead be a dictionary, but in Typst dictionary keys must be strings, and
// it's also not possible to convert a string name to a color.
#let striped = diagonal-stripes(size: 10pt, angle: 45deg, stripe-color: gray, thickness-ratio: 50%, mirror: true)
#let show_dominoes = (n, missing: (-1, -1), pieces: (), highlight_axes: false) => {
  return block(breakable: false, grid(
    columns: calc.pow(2, n),
    rows: calc.pow(2, n),
    inset: (x: 10pt, y: 10pt),
    stroke: 0.5pt + gray,
    fill: (i, j) => {
      if ((i, j) == missing) {
        return striped
      }
      for (c, positions) in pieces {
        if ((i, j) in positions) {
          return c
        }
      }
      return white
    }
  ))
}
#quote-box[
  Hrm, dibujemos algunos ejemplos. Con $n = 1$, hay realmente sólo una grilla, salvo rotación:

  #show_dominoes(1, missing: (1, 1))

  Y no hay más de una forma de poner un triomino:
  #show_dominoes(1, missing: (1, 1), pieces: ((red.lighten(20%), ((0, 0), (0, 1), (1, 0))),))

  Con $n = 2$, la grilla es:
  #show_dominoes(2)
  Y realmente hay solo tres formas de poner un cuadrado faltante, salvo rotaciones y reflecciones:
  #stack(
    dir: ltr,
    spacing: 6mm,
    show_dominoes(2, missing: (0, 0)),
    show_dominoes(2, missing: (0, 1)),
    show_dominoes(2, missing: (1, 1)),
  )

  Parece enorme el espacio de cosas para hacer... no parece haber mucha estructura si empiezo a poner triominos al azar. El que me digan $2^n times 2^n$ me hace pensar en dividir y conquistar, quizás dividiendo el tablero en cuatro tableros $2^(n-1) times 2^(n-1)$... pero no parece fácil, porque los tableros chicos no tienen una casilla removida cada uno... por ejemplo, para la primera:

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (red.lighten(10%), ((0, 1), (1, 1), (1, 0))),
      (green.lighten(80%), ((2, 0), (2, 1), (3, 0), (3, 1))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 2), (1, 3))),
      (orange.lighten(80%), ((2, 2), (2, 3), (3, 2), (3, 3))),
    ),
  )

  Cubrí el primero perfectamente, pero arruiné los otros tres, porque ya no se parecen al caso $n=1$, tienen cero bloques faltantes, no uno. Y si sigo poniendo triominos parece que me voy a quedar corto...

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (red.lighten(10%), ((0, 1), (1, 1), (1, 0))),
      (purple.lighten(10%), ((2, 0), (2, 1), (3, 0))),
      (green.lighten(80%), ((2, 0), (2, 1), (3, 0), (3, 1))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 2), (1, 3))),
      (orange.lighten(80%), ((2, 2), (2, 3), (3, 2), (3, 3))),
    ),
  )

  Voy a estar en problemas cuando intente cubrir la casilla verde... a ver de otra manera:

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (red.lighten(10%), ((0, 1), (1, 1), (1, 0))),
      (purple.lighten(10%), ((2, 0), (3, 1), (3, 0))),
      (green.lighten(80%), ((2, 0), (2, 1), (3, 0), (3, 1))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 2), (1, 3))),
      (orange.lighten(80%), ((2, 2), (2, 3), (3, 2), (3, 3))),
    ),
  )

  Mismo problema... no puedo entonces cubrir la casilla verde poniendo un triomino enteramente en ella. Hrm... pero podría poner otro triomino en el centro, que cubra una casilla de cada uno de los otros tres tableros... así:

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (red.lighten(10%), ((0, 1), (1, 1), (1, 0))),
      (green.lighten(80%), ((2, 0), (3, 1), (3, 0))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 3))),
      (orange.lighten(80%), ((2, 3), (3, 2), (3, 3))),
      (purple.lighten(10%), ((1, 2), (2, 1), (2, 2))),
    ),
  )

  Hrm eso parece funcionar... pero no fue algo divide-and-conquer, sólo tuve suerte... cómo puedo hacer esto mediante divide-and-conquer?

  Hrm y si lo hago en el otro orden? Puedo poner el triomino violeta primero:

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (purple.lighten(10%), ((1, 2), (2, 1), (2, 2))),
      (green.lighten(80%), ((2, 0), (3, 1), (3, 0))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 3))),
      (orange.lighten(80%), ((2, 3), (3, 2), (3, 3))),
    ),
  )

  Y ahora me quedaron cuatro sub-grillas, donde cada una tiene una casilla removida! Este tablero es equivalente a tener:

  #show_dominoes(
    2,
    missing: (0, 0),
    pieces: (
      (striped, ((1, 2), (2, 1), (2, 2))),
      (green.lighten(80%), ((2, 0), (3, 1), (3, 0))),
      (blue.lighten(80%), ((0, 2), (0, 3), (1, 3))),
      (orange.lighten(80%), ((2, 3), (3, 2), (3, 3))),
    ),
  )

  Y esto sí tiene estructura recursiva, porque en cada sub-grilla de $2 times 2$ tengo el mismo problema anterior. A ver cómo se ve esto en tableros más grandes, con $n = 3$...

  #show_dominoes(3, missing: (6, 2))

  Puedo poner un triomino en el centro, cubriendo una casilla de cada uno de los sub-tableros, excepto en el que se encuentra la ya-faltante:

  #show_dominoes(
    3,
    missing: (6, 2),
    pieces: (
      (purple.lighten(10%), ((3, 3), (3, 4), (4, 4))),
    ),
  )

  Y ahora tenemos cuatro sub-tableros, cada uno con una casilla removida:

  #show_dominoes(
    3,
    missing: (6, 2),
    pieces: (
      (striped, ((3, 3), (3, 4), (4, 4))),
      (red.lighten(80%), range(4).map(x => range(4).map(y => (x, y))).sum()),
      (green.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y))).sum()),
      (blue.lighten(80%), range(4).map(x => range(4).map(y => (x, y + 4))).sum()),
      (orange.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y + 4))).sum()),
    ),
  )

  Y podemos aplicar divide-and-conquer. Bueno, ahora a formalizar...
]
#demo[
  Sea $n in NN$, con $n > 0$. Vamos a demostrar por inducción en $n$ que todo tablero de $2^n times 2^n$ casillas con una casilla removida, puede ser cubierto completamente con triominos.

  Si $n = 1$, el tablero tiene $2 times 2 = 4$ casillas, y al remover una casilla quedan exactamente tres casillas, que pueden ser cubiertas con un triomino. Los cuatro casos posibles son:

  #stack(
    dir: ltr,
    spacing: 6mm,
    show_dominoes(
      1,
      missing: (0, 0),
      pieces: (
        (red.lighten(20%), ((1, 1), (0, 1), (1, 0))),
      ),
    ),
    show_dominoes(
      1,
      missing: (0, 1),
      pieces: (
        (red.lighten(20%), ((1, 1), (0, 0), (1, 0))),
      ),
    ),
    show_dominoes(
      1,
      missing: (1, 0),
      pieces: (
        (red.lighten(20%), ((1, 1), (0, 1), (0, 0))),
      ),
    ),
    show_dominoes(
      1,
      missing: (1, 1),
      pieces: (
        (red.lighten(20%), ((0, 0), (0, 1), (1, 0))),
      ),
    ),
  )

  Esto prueba el caso base.

  Supongamos que la afirmación es cierta para todo $k < n$, y probémosla para $n$. Sea $T$ un tablero de $2^n times 2^n$ casillas con una casilla removida. Dividimos $T$ en cuatro sub-tableros $T_1, T_2, T_3, T_4$, cada uno de tamaño $2^(n-1) times 2^(n-1)$, ubicados en las cuatro esquinas de $T$. Como ejemplo, para $n = 3$ se ve así:

  #show_dominoes(
    3,
    missing: (-1, -1),
    pieces: (
      (red.lighten(80%), range(4).map(x => range(4).map(y => (x, y))).sum()),
      (green.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y))).sum()),
      (blue.lighten(80%), range(4).map(x => range(4).map(y => (x, y + 4))).sum()),
      (orange.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y + 4))).sum()),
    ),
  )

  Sin pérdida de generalidad, supongamos que la casilla removida está en $T_1$, aunque no sabemos _dónde_ en $T_1$. A modo de ilustración, podría ser esta casilla:


  #show_dominoes(
    3,
    missing: (1, 2),
    pieces: (
      //(striped, ((3, 3), (3, 4), (4, 4))),
      (red.lighten(80%), range(4).map(x => range(4).map(y => (x, y))).sum()),
      (green.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y))).sum()),
      (blue.lighten(80%), range(4).map(x => range(4).map(y => (x, y + 4))).sum()),
      (orange.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y + 4))).sum()),
    ),
  )

  Podemos colocar un triomino en el centro de $T$, cubriendo una casilla de cada uno de los otros tres sub-tableros, $T_2, T_3, T_4$. De esta forma, cada uno de los sub-tableros $T_1, T_2, T_3, T_4$ tiene exactamente una casilla removida. En este ejemplo quedaría así:

  #show_dominoes(
    3,
    missing: (1, 2),
    pieces: (
      (striped, ((4, 3), (3, 4), (4, 4))),
      (red.lighten(80%), range(4).map(x => range(4).map(y => (x, y))).sum()),
      (green.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y))).sum()),
      (blue.lighten(80%), range(4).map(x => range(4).map(y => (x, y + 4))).sum()),
      (orange.lighten(80%), range(4).map(x => range(4).map(y => (x + 4, y + 4))).sum()),
    ),
  )

  Usando la hipótesis inductiva $P(n-1)$, como cada uno de esos cuatro sub-tableros tiene tamaño $2^(n-1) times 2^(n-1)$, y tiene exactamente una casilla faltante. cada uno de ellos puede ser cubierto completamente con triominos. Juntando estas coberturas disjuntas de las cuatro sub-grillas de $T$, obtenemos una cobertura de $T$ por triominos, que es lo que buscábamos.
]

/*
#ej[
Sea $G$ un grafo. Determinar si es cierto que si $G$ tiene exactamente dos vértices de grado impar, entonces existe en $G$ un camino entre ellos. Si es cierto, demostrarlo. Si es falso, dar un contraejemplo.
]
#quote-box[
Hrm, OK. Qué raro. ¿Cómo puede ser que algo totalmente local, como el grado de un vértice, concluya en algo global, como la existencia de un camino que puede ser larguísimo? A priori no le creo, vamos a intentar hacer un contraejemplo...

Empiezo con algo así, donde quiero que haya exactamente un vértice de grado impar. Si logro eso, después simplemente pongo dos copias de esto lado a lado, sin juntarlas con ninguna arista, y voy a tener dos vértices de grado impar que no se conectan.

#let nodes1 = (($v_0$, red), ($v_1$, green), ($v_2$, blue),  ($v_3$, fuchsia))
#diagram({
  draw_circle_graph(nodes1, ((0, 1), (0, 2), (0, 3)))
})

Bueno pero eso tiene a las tres hojas con grado 1, entonces no hay exactamente 2 vértices de grado impar... a ver si juntándolas pasa algo...

#diagram({
  draw_circle_graph(nodes1, ((0, 1), (0, 2), (0, 3), (1, 2), (2, 3)))
})

Bueno eso no queda bien porque ahora $v_2$ también tiene grado impar, y hay un camino... A ver, intento hacer que $v_2$ tenga grado par otra vez. Como ya está conectado a los otros vértices, tengo que agregar uno. Si agrego uno solo, entonces no va a haber manera de lograr lo que quiero...

#let nodes2 = nodes1 + (($v_4$, orange),)
#diagram({
  draw_circle_graph(nodes2, ((0, 1), (0, 2), (0, 3), (1, 2), (2, 3), (2, 4)))
})

Eso arregla $v_2$... pero $v_4$ está roto... y sin importar cómo uno a $v_4$, no puedo hacer que haya exactamente _un_ vértice de grado impar en el grafo resultante...

Parece que ser que hay algo invariante, que el número de vértices de grado impar, es par... ¿puede ser algo aritmético eso? A ver, le pongo nombre a las cosas, así puedo usar aritmética y ecuaciones...

Separemos los vértices en los que tienen grado impar, $V_1$, y los que tienen grado par, $V_2$. La suma de los grados de todos los vértices ya sabíamos que es $2m$... entonces $sum_(v in V_1) d_G (v) + sum_(v in V_2) d_G (v) = sum_(v in V) d_G (v) = 2m$. Como $d_G (v)$ es impar para todos los vértices $v$ en $V_1$, entonces quizás la suma esa da algo impar... pero la otra suma, sobre $V_2$, da algo par...

Entonces tendría algo como `impar + par = par`, y eso no puede pasar. El `impar` va a ser cuando el número de sumandos sea impar, porque un número impar de números impares, sumados, da resultado impar.

¿Cómo puedo usar esto para lo que me piden?

Si no hay un camino entre los dos vértices, $u$ y $v$, entonces están en dos componentes conexas. Pero entonces puedo hacer este argumento en cada componente conexa, como si fuera cada una un grafo por separado. No puede ser que haya _un_ vértice de grado impar en cada componente, porque etaríamos en la condición `impar + par = par` de arriba, en cada uno de estos subgrafos.

OK, creo que eso cierra. A ver cómo se puede escribir bien...
]

#demo[
  Sea $G = (V, E)$ un grafo. Queremos ver que si hay exactamente dos vértices con grado impar, entonces están en la misma componente conexa.

  Asumo que no. Entonces existen dos componentes conexas en $G$, $G_1 = (V_1, E_1)$ y $G_2 = (V_2, E_2)$, tal que $V_1 inter V_2 = emptyset$, y hay dos vértices, $v_1$ y $v_2$, tal que $v_1 in V_1$, $v_2 in V_2$, $d_G (v_1) = d_(G_1)(v_1)$ es impar, y $d_G (v_2) = d_(G_2)(v_2)$ es impar. Sabemos que $d_G (v_1) = d_(G_1) (v_1)$ porque $v_1$ sólo tiene aristas hacia $V_1$ (porque definimos $V_1$ como la componente conexa donde está $v_1$, no puede haber una arista desde $v_1$ a alguien en $V_2$, pues entonces ese alguien estaría en la componente $V_1$, pero sabemos que $V_1 inter V_2 = emptyset$.)

  Entonces $G_1$ y $G_2$ son subgrafos de $G$, y en cada uno existe un único vértice con grado par.

  Probemos el siguiente lema.
  #lemma[
    Sea $H$ un grafo. Entonces el número de vértices en $H$ de grado impar, es par.
  ]
  #demo[
    Sean $W_1$ los vértices de $H$ de grado impar, y $W_2$ los vértices de $H$ de grado par. Si los vértices de $H$ son $W$, sabemos que $W = W_1 union.sq W_2$. Entonces si $H$ tiene $m$ aristas, sabemos que $sum_(v in W) d_H (v) = 2m$. Pero como $W = W_1 union.sq W_2$, esta suma es igual a $sum_(v in W_1) d_H (v) + sum_(v in W_2) d_H (v)$. Por claridad llamemos $X = sum_(v in W_1) d_H (v)$, y $Y = sum_(v in W_w) d_H (v)$.

    Como llamamos a $W_1$ el subconjunto de vértices de $H$ de grado impar, sabemos que $d_H (v) equiv 1 (mod 2)$ para todo $v in W_1$. Luego la suma de todos ellos es congruente a $|W_1|$, módulo $2$. Es decir, $X equiv |W_1| (mod 2)$.

    Con un argumento análogo, vemos que $Y equiv 0 (mod 2)$.

    Entonces, tenemos que $X + Y = 2m$, con $X equiv |W_1| (mod 2)$ y $Y equiv 0 (mod 2)$. Tomando módulo dos a ambos lados de la primer ecuación, nos queda que $|W_1| + 0 = 0 (mod 2)$, y luego $|W_1|$ es par.

    Luego, el número de vértices en $H$ con grado impar, es par.
  ]

  Entonces llamando $H = G_1$, vemos que no puede ser que haya en $G_1$ exactamente un vértice de grado impar. Luego, lo que asumimos tiene que estar mal, que había dos componentes conexas, una con un vértice de grado impar cada una.

  Luego estos dos vértices tienen que estar en la misma componente conexa, y luego hay un camino de uno al otro.
]
*/

#quote-box[
  #let im = image("../proof_erased.png", height: 50mm)
  #let t = [Hrm, quedó medio desordenado eso. Mejor lo emprolijo un poco. Puedo ponerle nombre a los tableros, y enunciar bien mi hipótesis inductiva...]
  #wrap-content(im, t)
]

/*
#demo[
  Primero, probemos un lema.
  #lemma[
    Sea $H$ un grafo. Entonces el número de vértices en $H$ de grado impar, es par.
  ] <parimpar>
  #demo[
    Sean $W_1$ los vértices de $H$ de grado impar, y $W_2$ los vértices de $H$ de grado par. Si los vértices de $H$ son $W$, sabemos que $W = W_1 union.sq W_2$. Entonces si $H$ tiene $m$ aristas, sabemos que $sum_(v in W) d_H (v) = 2m$. Pero como $W = W_1 union.sq W_2$, esta suma es igual a $sum_(v in W_1) d_H (v) + sum_(v in W_2) d_H (v)$. Por claridad llamemos $X = sum_(v in W_1) d_H (v)$, y $Y = sum_(v in W_w) d_H (v)$.

    Como llamamos a $W_1$ el subconjunto de vértices de $H$ de grado impar, sabemos que $d_H (v) equiv 1 (mod 2)$ para todo $v in W_1$. Luego, $sum_(v in W_1) 1 (mod 2) equiv |W_1| (mod 2)$. Es decir, $X equiv |W_1| (mod 2)$.

    Con un argumento análogo, vemos que $Y equiv 0 (mod 2)$, por ser la suma de varios números pares.

    Entonces, tenemos que $X + Y = 2m$, con $X equiv |W_1| (mod 2)$ y $Y equiv 0 (mod 2)$. Tomando módulo $2$ a ambos lados de la primer ecuación, nos queda que $|W_1| + 0 = 0 (mod 2)$, y luego $|W_1|$ es par.

    Luego, el número de vértices en $H$ con grado impar, es par.
  ]

  Ahora sea $G = (V, E)$ un grafo con exactamente dos vértices de grado impar, $v_1$ y $v_2$. Asumamos, por contradicción, que $v_1$ y $v_2$ están en componentes conexas distintas. Entonces existen $V_1, V_2 subset V$, tales que $V_1 inter V_2 = emptyset$, $v_1 in V_1$, $v_2 in V_2$, y $d_G (v_1) equiv d_G (v_2) equiv 1 (mod 2)$. Tomemos la componente conexa inducidas por $V_1$, llamémosla $G_1$. Sabemos que $v_1 in G_1$, y $v_2 in.not G_1$. Como $G$ tiene exactamente dos vértices con grado impar, son sólo $v_1$ y $v_2$, entonces en $G_1$ hay exactamente un vértice de grado impar, y es $v_1$.

  Por el @parimpar, esto no puede pasar. Luego, lo que asumimos por contradicción era falso, y entonces esos dos vértices no están en componentes conexas distintas. Luego están en la misma componente conexa, y luego hay un camino entre ellos.
]
*/

Si sólo ven la demostración final, parece compacta, no comete errores, no intenta varias cosas, no nombra cosas que no usa, no deja cosas sin demostrar para después, tiene notación sensible, y hasta tiene estructura, planteando una inducción formal. No piensen que la demostración nació así - como ven, uno pasa por jugar, probar cosas, planear, y emprolijar. No se frustren si sus demostraciones no se ven como esta última, en su primer pasada.

#tip-box[
  Las siguientes son cosas que pueden hacer al pasar en limpio una demostración:
  - Introducir notación útil. A veces un argumento complejo puede ser simplificado introduciendo un símbolo y usándolo repetidamente.
  - Extraer sub-lemas. Si en el medio de su demostración tienen que demostrar un lema sobre algún objeto, pueden extraerlo como un sub-lema, que se puede entender por separado. Al extraerlo, tengan cuidado que las variables que mencionan en la demostración del lema, sean parte del enunciado lema, y estén cuantificadas correctamente en el mismo.

    Esto a veces acorta nuestras demostraciones mucho, pues podemos reutilizar el mismo lema varias veces con distintos objetos en la misma demostración.
  - Evitar usar simbolismo innecesario. Si no están trabajando explícitamente con fórmulas lógicas, usen "para todo" en vez de $forall$, "existe" en vez de $exists$, "entonces" en vez de $implies$, etcétera. Su lector tiene décadas de experiencia usando el idioma español, sabemos leer oraciones mucho más rápidamente en se idioma que en notación simbólica de lógica formal.
  - Usar conectores lógicos y explicaciones entre sus ecuaciones. Una demostración es un argumento, no una serie de ecuaciones sin semántica.
  - Si no necesitan usar contrarecíproco o contradicción, intenten estructurar su demostración para argumentar de forma directa. Es muy difícil leer un argumento que contiene contradicciones anidadas.
  - Revisar si en algún lugar dijeron que algo es "obvio", si realmente pueden asumir que el lector lo va a considerar obvio. Es tentador decir que algo es "obvio" como táctica de intimidación para que el lector acepte nuestras proposiciones, pero no va a funcionar en una instancia de evaluación, y es de mal gusto al escribir a un par científico.
]

#load-bib()
