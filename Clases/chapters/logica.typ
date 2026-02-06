#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Lógica

El área de lógica es rica y profunda. En este libro vamos a ver los conceptos necesarios para entender las demostraciones matemáticas que se encuentran en el mismo. Para alumnos interesados en ver más profundamente el tema, y cómo se relaciona con la computación, recomiendo el libro @logicincs. Para una mirada más matemática, incluyendo los famosos teoremas de completitud e incompletitud de Gödel, recomiendo @introtologic.

#def[
  Una proposición es una afirmación que puede ser verdadera o falsa.
]

Los siguientes son ejemplos de proposiciones:
- $2 + 2 = 4$.
- El número $pi$ es irracional.
- Para todo número natural $n$, $n + 0 = n$.
- Existe un número primo par mayor que $2$.

Mientras tanto, las siguientes no son proposiciones:
- $x + 2 = 5$ (no sabemos si es verdadera o falsa, porque no sabemos qué es $x$).
- "Cierre la puerta." (no es una afirmación, es una orden).
- "¿Cuánto es $2 + 2$?" (no es una afirmación, es una pregunta).

Podemos asignarle nombres a proposiciones, por ejemplo escribiendo "Sea $P$: $2 + 2 = 4$." Luego podemos usar estos nombres para construir proposiciones más complejas, usando conectores lógicos. Por ejemplo, si decimos "Sea $P: 2 + 2 = 4$ y $Q: 3 + 3 = 6$.", entonces podemos construir la proposición $P and Q$, que es verdadera sólo si ambas $P$ y $Q$ son verdaderas. Otros conectores lógicos son:

#table(
  columns: (0.1fr, 1fr),
  [Símbolo], [Definición],
  align: ((x, y) => if x == 0 { center + horizon } else { left }),
  [$and$], ["Y". La expresión $A and B$ significa que valen ambas proposiciones $A$ y $B$.],
  [$or$],
  ["O". La expresión $A or B$ significa que vale al menos una de las proposiciones $A$ o $B$. En particular, si vale $A$, entonces vale $A or B$, sin importar si vale o no $B$. Lo mismo si vale $B$.],

  [$not$],
  ["No". La expresión $not A$ significa que no vale la proposición $A$. Si vale $A$, entonces no vale $not A$. Si no vale $A$, entonces vale $not A$. Notar que $not$ liga fuertemente a una variable o expresión, luego $not A or B$ significa $(not A) or B$.],

  [$implies$],
  ["Implica". La expresión $A implies B$ significa que si vale la proposición $A$, entonces vale la proposición $B$. Si no vale $A$, entonces no hay nada que probar, y la expresión es cierta. Si vale $A$, tenemos que probar que vale $B$. Notar que esto es equivalente a decir que "o no vale $A$, o vale $B$", es decir, que $not A or B$ es equivalente a $A implies B$.],

  [$iff$],
  ["Si y sólo si". La expresión $A iff B$ significa que ambas proposiciones son equivalentes: Si vale una, entonces vale la otra, y viceversa. Es decir, $A iff B$ es lo mismo que $(A implies B) and (B implies A)$.],
)

A veces vamos a querer referirnos a los valores de verdad de proposiciones complejas. Para esto, usamos los siguientes símbolos:
#table(
  columns: (0.1fr, 1fr),
  [Símbolo], [Definición],
  align: ((x, y) => if x == 0 { center + horizon } else { left }),
  [$top$], ["Verdadero". La proposición $top$ es siempre verdadera.],
  [$bot$], ["Falso". La proposición $bot$ es siempre falsa.],
)

Aún cuando no sepamos la veracidad de algunas proposiciones, podemos razonar sobre su composición usando tablas de verdad. En la proposición $Q: P implies P$, no sabemos quién es $P$, pero podemos afirmar que $Q$ es siempre verdadera, usando la siguiente tabla:

#table(
  columns: (0.2fr, 0.2fr),
  [$P$], [$P implies P$],
  align: center + horizon,
  [$top$], [$top$],
  [$bot$], [$top$],
)

Si tenemos más proposiciones, podemos agregar columnas a la tabla. Por ejemplo, para la proposición $R: (P and Q) implies P$, tenemos:

#table(
  columns: (0.2fr, 0.2fr, 0.2fr, 0.2fr),
  [$P$], [$Q$], [$P and Q$], [$(P and Q) implies P$],
  align: center + horizon,
  [$top$], [$top$], [$top$], [$top$],
  [$top$], [$bot$], [$bot$], [$top$],
  [$bot$], [$top$], [$bot$], [$top$],
  [$bot$], [$bot$], [$bot$], [$top$],
)

#def[
  Un predicado es una proposición que depende de una o más variables.
]

Por ejemplo, "$x$ es par" es un predicado que depende de la variable $x$. Si le damos un valor a $x$, obtenemos una proposición. Por ejemplo, si $x = 4$, entonces el predicado "$x$ es par" se vuelve la proposición "4 es par", que es verdadera. Si $P$ es un predicado que depende de una variable, podemos escribir $P(x)$ para referirnos a la proposición que resulta al darle el valor $x$ a la variable. Por ejemplo, si $P(x): x$ es par, entonces $P(4)$ es la proposición "4 es par", y $P(5)$ es la proposición "5 es par".

También tenemos cuantificadores, que nos permiten introducir variables en nuestras proposiciones.

#table(
  columns: (0.1fr, 1fr),
  [Símbolo], [Definición],
  align: ((x, y) => if x == 0 { center + horizon } else { left }),
  [$forall$],
  ["Para todo", o "Sea". La oración $forall x. P(x)$ significa que el predicado $P$ vale para todo $x$. Algo común es escribir $forall x in X. P(x)$, que es una abreviación de $forall x. x in X implies P(x)$. Notar cómo el $forall$ captura todo lo que viene después del "." que le sigue al símbolo, luego no es necesario aclarar que la oración anterior es lo mismo que $forall x. (x in X implies P(x))$.],

  [$exists$],
  ["Existe". La oración $exists y. P(y)$ significa que hay al menos un $y$ tal que el predicado $P$ vale para $y$. Algo común es escribir $exists y in Y. P(y)$, que es una abreviación de $exists y. y in Y and P(y)$. Al igual que $forall$, el símbolo $exists$ captura todo lo que viene después del "." que le sigue al símbolo, luego no es necesario aclarar que la oración anterior es lo mismo que $exists y. (y in Y and P(y))$.

    Como abreviación, se usa $exists! x in X. P(x)$ para significa "Existe un _único_ $x$ en $X$, tal que $P(x)$". Puede haber otros $x$ que cumplan $P(x)$, pero en $X$ sólo hay uno.],
)

Crear variables nos da muchísimo poder, y nos lleva de la lógica proposicional, donde sólo tenemos proposiciones y predicados, a la lógica de primer orden, donde tenemos variables y cuantificadores. La lógica de primer orden es la base de las demostraciones matemáticas, y es lo que vamos a usar en este libro.

#table(
  columns: (0.75fr, 1fr, 1fr),
  inset: 10pt,
  stroke: 0.5pt + black,
  align: left,
  [*Oración*], [*Significado*], [*Cómo probarla*],
  [Para todo $x in RR$, tenemos que $x^2 gt.eq 0$.],
  [Para cualquier $x$ que elijamos en los reales, $x^2$ es mayor o igual a cero. Otra forma de escribir esto es $forall x. (x in RR implies x^2 gt.eq 0)$. Es decir, para todo $x$, si $x$ está en los reales, entonces $x^2 gt.eq 0$.],
  [Nos van a dar un $x$, y sabemos que $x in RR$. Tenemos que probar que $x^2 gt.eq 0$. Podemos partir en casos, dependiendo de si $x gt.eq 0$ o $x < 0$. En el primero, el producto de dos números no-negativos es no-negativo, y en el segundo caso, $x = -y$ con $y > 0$, y luego $x^2 = (-y)(-y) = y^2 > 0$, y luego en ambas ramas tenemos $x^2 gt.eq 0$.],

  [Para todo $x in RR$, existe un $y in NN$, tal que $y > x$.],
  [Para cualquier $x$ que elijamos en el conjunto $RR$, hay algún $y$ en $NN$ que es más grande. Otra forma de escribir esto es $forall x. (x in RR implies (exists y. (y in NN and y > x)))$. Es decir, para todo $x$, si $x$ está en $RR$, entonces existe un $y$, tal que $y$ está en $NN$, y también $y > x$.],
  [Nos van a dar un $x$, y sabemos que $x in RR$. Tenemos que mostrar que existe un $y$ tal que $y in NN$, e $y > x$. A veces vamos a poder encontrar $y$ explícitamente, otras veces sólo vamos a saber que existe. $y$ puede depender de $x$. En este caso, podemos elegir $y = ceil(x) + 1$, y sabiendo que $ceil(x) gt.eq x$, y que $ceil(space):RR arrow NN$, concluímos que $y = ceil(x) + 1 > x$, con $y in NN$. Notar que puede haber otros $y$ posibles, por ejemplo $ceil(x) + 5$, pero basta con encontrar uno y estamos.],

  [Existe un $x in RR$, tal que para todo $y in {0, 1, dots, 8}$, $y > x$.],
  [Hay alguien en $RR$ que es menor a todo elemento de ${0, 1, dots, 8}$.],
  [Tenemos que probar que existe un tal $x$. A veces vamos a poder decir quién es $x$ explícitamente, otras veces sólo vamos a poder probar que existe. Tenemos que mostrar que para este $x$ que elegimos, sin importar qué $y in {0, 1, dots, 8}$ alguien elija, tendremos $y > x$. Podemos elegir $x = -1$, y vemos que $-1 < 0$, $-1 < 1$, $dots$, $-1 < 8$, y por lo tanto $x < y$ para todo $y in {0, 1, dots, 8}$.],

  [Existe un $x in RR$, tal que para todo $y in {0, 1, dots, ceil(x)}$, $x > y$.],
  [Hay algún real $x$, tal que $x$ es más grande que cualquier elemento en ${0, 1, dots, ceil(x)}$.],
  [Tenemos que dar un tal $x in RR$. Llamemos $X = {0, 1, dots, ceil(x)}$. Veamos a quién podemos elegir:
    - Si elegimos un $x > -1$, entonces $X$ tiene al menos 1 elemento ($ceil(x) gt.eq 0$). Como $ceil(x) gt.eq x$, y $ceil(x) in X$, nunca vamos a poder probar que $x > y$ para todo $y in X$, pues alguien podría darnos $y = ceil(x) gt.eq x$.
    - Si elegimos un $x lt.eq -1$, entonces $X = {0, 1, dots, ceil(x)}$ con $ceil(x) < 0$, y luego $X = emptyset$. Luego, "para todo $y in emptyset$, $x > y$" es trivialmente cierto sobre $x$, puesto que no hay ningún tal $y in emptyset$. Luego, podemos elegir $x = -1$ (o si quisiéramos, $x = -47$), y vemos que este $x$ cumple lo pedido.
  ],

  [Para todo $n in NN$ tal que $n > 1$, para todo $m in NN$ tal que $m gt.eq 2n$, existe un $p in NN$ tal que $n < p < m$, y $p$ es primo.],
  [Esto nos dice que siempre que tengamos dos numeros naturales $n$ y $m$, si sabemos que $n > 1$ y $m gt.eq 2n$, entonces vamos a poder encontrar un primo entre $n$ y $m$.],
  [Nos van a dar dos números naturales, $n$ y $m$, y sabemos que $n > 1$ y $m gt.eq 2n$. Tenemos que probar que existe un primo $p$ tal que $n < p < m$.

    Esta proposición es un corolario del postulado de Bertrand.],
)


=== Ejercicios
#ej[
  Sea $P$ la proposición "Está lloviendo", $Q$ la proposición "Voy a llevar un paraguas", y $R$ la proposición "Me voy a mojar". Escribir las siguientes proposiciones usando $P, Q, R$ y los conectores lógicos:
  - "Está lloviendo y voy a llevar un paraguas."
  - "Si está lloviendo, entonces voy a llevar un paraguas."
  - "No me voy a mojar si y sólo si llevo un paraguas."
  - "No está lloviendo, o me voy a mojar."
  - "Si no llevo un paraguas, entonces me voy a mojar."
]

#ej[
  Dados $P: top$, $Q: bot$, y $R: top$, determinar el valor de verdad de las siguientes proposiciones, usando una tabla de verdad:
  - $P and Q$
  - $(not P) or Q$
  - $P implies Q$
  - $(P and R) implies not Q$
  - $not (P or Q) iff ((not P) and (not Q))$
]

#ej[
  Sean $P, Q$ proposiciones. Demostrar que $(P implies Q) or (Q implies P)$.
]

#ej[
  Sean $P, Q$ proposiciones. Probar que $((P implies Q) implies P) implies P$.

  Esta fórmula se conoce como la Ley de Peirce@peirce.
]
#ej[
  Para cada una de las siguientes proposiciones:
  + $exists x. x^2 = 2$.
  + $forall x. exists y. x^2 = y$.
  + $forall y. exists x. x^2 = y$.
  + $forall x. (x eq.not 0 implies exists y. x y = 1)$.
  + $forall x exists y. 2x - y = 0$
  + $forall x exists y. x - 2y = 0$
  + $forall x. ((x > 10) implies (forall y. (y < x implies y < 9)))$
  + $forall x. exists y. (y > x and exists z. (y + z = 100))$
  + $exists x. exists y. x + 2y = 2 and 2x + 4y = 5$

  Indicar cuáles son *falsas* cuando $x, y, z$ son:
  + Números naturales.
  + Números enteros.
  + Números reales.
]
#ej[
  Mostrar que la siguiente proposición es falsa para algún conjunto $D$, y alguna proposición $P$:

  $
    (forall x in D. exists y in D. P(x, y)) implies (forall z in D. P(z, z))
  $
]

#load-bib()