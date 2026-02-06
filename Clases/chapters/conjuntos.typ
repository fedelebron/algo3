
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble
== Conjuntos

#def[
  Un conjunto es una colección no-ordenada de elementos distintos.
]
Si $A$ es un conjunto, y $a$ es un elemento del conjunto, escribimos $a in A$. Si $b$ no es un elemento del conjunto, escribimos $b in.not A$. Podemos escribir conjuntos usando llaves, por ejemplo, $A = {1, 2, 3, 4}$ es el conjunto cuyos elementos son exactamente $1$, $2$, $3$, $4$, y ningún otro. Como los conjuntos no son ordenados, ${4, 3, 2, 1}$ es el mismo conjunto que el anterior. Asimismo, como los elementos deben ser distintos, ${1, 2, 2, 3, 4, 4}$ es también el mismo conjunto.

#def[
  Dos conjuntos son iguales cuando tienen los mismos elementos. Escribimos $A = B$ si y sólo si para todo $x$, $x in A$ si y sólo si $x in B$.
]

También podemos escribir conjuntos por comprensión, diciendo que son todos los elementos que cumplen alguna propiedad. Por ejemplo, $C = {x in {1, 2, 3, 4} | x$ es par$}$ es el conjunto de todos los elementos pares en ${1, 2, 3, 4}$, es decir, $C = {2, 4}$.

Si todos los elementos de $A$ están en $B$, notamos $A subset.eq B$. Si la inclusión es estricta, es decir, si $A subset.eq B$ y existe algún elemento en $B$ que no está en $A$, notamos $A subset B$.

Finalmente, notamos al conjunto vacío, que no tiene elementos, como $emptyset$. Otros conjuntos conocidos son el conjunto de los números naturales, $NN$, el conjunto de los enteros, $ZZ$, el conjunto de los racionales, $QQ$, y el conjunto de los reales, $RR$.

Veamos algunas propiedades fundamentales sobre conjuntos.

#prop[
  Sean $A$ y $B$ conjuntos. Entonces $A = B$ si y sólo si $A subset.eq B$ y $B subset.eq A$.
]
#demo[
  Para probar un si-y-sólo-si, probamos ambas implicaciones.
  - $implies$) Asumimos que $A = B$, queremos probar que $A subset.eq B$ y $B subset.eq A$. Sea $x in A$. Como $A = B$, entonces $x in B$. Luego, por definición de inclusión, $A subset.eq B$. Análogamente, si $y in B$, como $A = B$, entonces $y in A$, y luego $B subset.eq A$.
  - $implied$) Asumimos que $A subset.eq B$ y $B subset.eq A$, queremos ver que $A = B$. Sea $x$ un elemento cualquiera. Vamos a probar que $x in A$ si y sólo si $x in B$.
    + $implies$) Asumimos que $x in A$. Como $A subset.eq B$, entonces $x in B$.
    + $implied$) Asumimos que $x in B$. Como $B subset.eq A$, entonces $x in A$.
    Luego, $x$ está en $A$ si y sólo si $x$ está en $B$. Como $x$ era arbitrario, entonces $A = B$.
]

#prop[Sean $A$, $B$, y $C$ conjuntos. Si $A subset.eq B$ y $B subset.eq C$, entonces $A subset.eq C$.
]
#demo[
  Para probar que $A subset.eq C$ tenemos que probar que cualquier elemento de $A$ está también en $C$. Sea entonces $x in A$. Como $A subset.eq B$, entonces $x in B$. Luego, como $B subset.eq C$, tenemos que $x in C$. Luego, cualquier elemento de $A$ está en $C$, que es la definición de $A subset.eq C$.

  Notar que la vuelta no vale necesariamente. Por ejemplo, si $A = {1}$, $B = {3}$, y $C = {1, 2}$, entonces $A subset.eq C$, pero no valen ni $A subset.eq B$ ni $B subset.eq C$.
]

Dados dos conjuntos, vamos a definir operaciones útiles.

#def[
  Dados dos conjuntos $A$ y $B$, definimos:
  - La intersección de $A$ y $B$, notada $A inter B$, como el conjunto de todos los elementos que están en $A$ y en $B$. Es decir, $A inter B = {x | x in A$ y $x in B}$.
  - La unión de $A$ y $B$, notada $A union B$, como el conjunto de todos los elementos que están en $A$ o en $B$. Es decir, $A union B = {x | x in A$ o $x in B}$. Notar que el "o" no es exclusivo, es decir, si $x$ está en ambos conjuntos, está en la unión. Si queremos comunicar que la unión es de conjuntos disjuntos (es decir, que $A inter B = emptyset$) escribimos $A union.sq B$.
  - La diferencia entre $A$ y $B$, notada $A without B$, como el conjunto de todos los elementos que están en $A$ pero no en $B$. Es decir, $A without B = {x | x in A$ y $x in.not B}$. Notar que la diferencia no es simétrica, es decir, en general $A without B eq.not B without A$.
  - La diferencia simétrica entre $A$ y $B$, notada $A triangle B$, es $(A without B) union (B without A)$.
  - El complemento de $A$, notado $A^c$, como el conjunto de todos los elementos que no están en $A$. Es decir, $A^c = {x | x in.not A}$.
]

Hay reglas muy útiles que relacionan estas operaciones entre sí, llamadas las Leyes de De Morgan@demorgan.

#prop(title: [Leyes de De Morgan])[
  Sean $A, B, C$ conjuntos. Entonces:

  $
    A union (B inter C) = (A union B) inter (A union C)\
    A inter (B union C) = (A inter B) union (A inter C)
  $
]
#demo[
  Para la primer ecuación:
  $
    A union (B inter C) & = {x | x in A or x in (B inter C)} \
                        & = {x | x in A or (x in B and x in C)} \
                        & = {x | (x in A or x in B) and (x in A or x in C)} \
                        & = (A union B) inter (A union C)
  $

  y para la segunda:

  $
    A inter (B union C) & = {x | x in A and (x in B or x in C)} \
                        & = {x | (x in A and x in B) or (x in A and x in C)} \
                        & = (A inter B) union (A inter C)
  $
]

La unión y la intersección son operaciones duales, usando el complemento.

#prop[
  Sean $A$, $B$ conjuntos. Entonces

  $
    (A union B)^c = A^c inter B^c
  $

  Como corolario, $(A inter B)^c = A^c union B^c$.
]
#demo[
  Vamos a probar una igualdad de conjuntos probando que cada uno está incluído en el otro.

  - $(A union B)^c subset.eq A^c inter B^c$: Sea $x in (A union B)^c$. Entonces $x in.not (A union B)$. Como $A union B = {y | y in A" o "y in B}$, entonces tenemos que es falso que $(x in A" o "x in B)$, y luego tenemos que $x in.not A$ y $x in.not B$. Pero $A^c = {y | y in.not A}$, y análogamente para $B^c$, luego $x in A^c$ y $x in B^c$. Por definición de $inter$, entonces, $x in A^c inter B^c$.
  - $A^c inter B^c subset.eq (A union B)^c$. Sea $x in A^c inter B^c$. Luego por definición de $inter$, $x in A^c$ y $x in B^c$. Luego por definición de $X^c$ para conjuntos $X$, $a in.not A$, y $x in.not B$. Luego $x in.not A union B$, dado que $A union B = {y | y in A" o "y in B}$. Luego $x in (A union B)^c$.

  El corolario es inmediato, pues $(A inter B)^c = ((A^c union B^c)^c)^c = A^c union B^c$.
]

#prop[
  Sean $A, B$ conjuntos. Entonces $B without (B without A) = A inter B$.
]
#demo[
  Hagamos esto enteramente por definición.

  $
    B without (B without A) & = {x | x in B and x in.not (B without A)} \
                            & = {x | x in B and x in.not {y in B | y in.not A}} \
                            & = {x | x in B and (x in.not B or (x in B and x in A))} \
                            & = {x | x in B and x in A} \
                            & = A inter B
  $
]

#prop[
  Sean $A, B, C$ conjuntos. Entonces $(A without B) without C subset.eq A without (B without C)$.
]
#demo[
  Sea $x in (A without B) without C$. Entonces $x in A$, $x in.not B$, y $x in.not C$. Como $x in.not B$, entonces con más razon $x in.not (B without C)$, dado que $B without C subset.eq B$. Luego $x in A and x in.not (B without C)$, y luego $x in A without (B without C)$.

  La igualdad no vale en general. Por ejemplo, podemos tomar $A = {1, 2, 3}$, $B = {2, 3}$, y $C = {3, 4, 5}$. Entonces $(A without B) without C = {1}$, pero $A without (B without C) = {1, 3}$.
]


#prop[
  Sea $f: X arrow Y$ una función, y denotemos por $f^(-1)(C) = {x in X | f(x) in C}$, para cualquier subconjunto $C subset.eq Y$.

  Entonces para todo $A, B$ subconjuntos de $Y$, tenemos que $f^(-1)(A triangle B) = f^(-1)(A) triangle f^(-1)(B)$.
]
#demo[
  - $subset.eq$: Sea $x in f^(-1)(A triangle B)$. Entonces $f(x) in A triangle B$, es decir, $f(x) in (A without B) union (B without A)$. Partimos en casos:
    + Si $f(x) in A without B$, entonces $f(x) in.not B$, y $f(x) in A$. Luego, $x in.not f^(-1)(B)$, y $x in f^(-1)(A)$, y luego $x in (f^(-1)(A) \\ f^(-1)(B)) subset.eq f^(-1)(A) triangle f^(-1)(B)$.
    + Si $f(x) in B without A$ sucede algo análogo, y por ende $x in f^(-1)(A) triangle f^(-1)(B)$.
  - $supset.eq$. Sea $x in f^(-1)(A) triangle f^(-1)(B) = (f^(-1)(A) without f^(-1)(B)) union (f^(-1)(B) without f^(-1)(A))$. Partimos en casos:
    + Si $x in f^(-1)(A) without f^(-1)(B)$, entonces $f(x) in A$, pero $f(x) in.not B$. Luego $f(x) in (A without B) subset.eq A triangle B$, y por lo tanto $x in f^(-1)(A triangle B)$.
    + Si $x in f^(-1)(B) without f^(-1)(A)$, pasa algo análogo, y tenemos que $x in f^(-1)(A triangle B)$.
]

#prop[
  Sean $A$ y $B$ conjuntos tal que $|A| = |B|$. Entonces:

  1. $|A without B| = |B without A|$.
  2. $|Delta(A, B)|$ es par.
  3. Si $Delta(A, B) eq.not emptyset$, entonces $(A without B) eq.not emptyset$ y $(B without A) eq.not emptyset$.
]
#demo[Recordemos cómo funcionan las uniones e intersecciones de conjuntos.

  #set align(center)
  #canvas({
    draw.scale(1.5)

    venn2(
      name: "venn",
      a-fill: red.transparentize(40%),
      b-fill: blue.transparentize(40%),
      ab-fill: purple.transparentize(40%),
      not-ab-stroke: 0mm,
    )

    draw.content("venn.center", [$A$], padding: (0, -3))

    draw.content("venn.east", [$B$], padding: (0, -1))

    draw.hobby((rel: (0.1, 0.85), to: "venn.a"), (-0.95, 0.9), (-0.99, 1.1), name: "arrow")
    draw.content("arrow.end", text(fill: red)[$A without B$], padding: -0.5)

    draw.hobby((rel: (0.1, 0.7), to: "venn.b"), (1.22, 1), (1.2, 1.1), name: "arrow2")
    draw.content("arrow2.end", text(fill: blue)[$B without A$], padding: -0.5)

    draw.hobby((rel: (0, 0.5), to: "venn.ab"), (0.1, 0.7), (0.1, 1), name: "arrow3")
    draw.content("arrow3.end", text(fill: purple)[$A inter B$], padding: -0.5)
    draw.content(
      "venn.south",
      $A =$ + " " + text(fill: red, $(A without B)$) + " " + $union.sq$ + " " + text(fill: purple, $(A inter B)$),
      padding: (-1, 0),
    )
    draw.content(
      "venn.south",
      $B =$ + " " + text(fill: blue, $(B without A)$) + " " + $union.sq$ + " " + text(fill: purple, $(A inter B)$),
      padding: (-0.5, 0),
    )
  })
  #set align(left)
  Sabemos que $A = (A without B) union.sq (A inter B)$, y $B = (B without A) union.sq (A inter B)$. Llamando a $|A without B| = alpha$, $|B without A| = beta$, y $|A inter B| = gamma$, tenemos que $|A| = alpha + gamma$, y $|B| = beta + gamma$. Como $|A| = |B|$, tenemos que $alpha + gamma = beta + gamma$. Luego, $alpha = beta$, es decir, $|A without B| = |B without A|$.

  Para el segundo punto, como $Delta(A, B) = (A without B) union.sq (B without A)$, tenemos que $|Delta(A, B)| = |(A without B)| + |(B without A)| = alpha + beta = 2 alpha = 2 beta$, luego es par.

  Finalmente, si $Delta(A, B) eq.not emptyset$, entonces $|Delta(A, B)| = 2alpha = 2beta > 0$, luego $alpha = beta > 0$, y luego $(A without B) eq.not emptyset$, como también $(B without A) eq.not emptyset$.]

=== Ejercicios

#ej[
Sea $A$ un conjunto. Probar que $(A^c)^c = A$.
]

#ej[
  Sean $A, B$ conjuntos. Probar que las siguientes proposiciones son equivalentes:
  - $A subset.eq B$
  - $A inter B = A$
  - $A union B = B$
]

#ej[
  Sean $A, B$ conjuntos. Probar que:
  $
    A without (A without B) = A inter B
  $
]

#ej[
  Sean $A, B, C$ conjuntos. Probar que:

  $
    A without (B inter C) = (A without B) union (A without C)
  $
]

#ej[
  Sean $A, B, C$ conjuntos. Probar que la siguiente proposición es cierta, o exhibir un contraejemplo.

  $
    (A union B) without C = A union (B without C)
  $
]

#ej[
  Se define el producto cartesiano de dos conjuntos $A$ y $B$ como $A times B = {(a, b) | a in A, B in B}$. Sean $A, B, C$ conjuntos. Probar que:

  $
    A times (B without C) = (A times B) without (A times C)
  $
]

#ej[
  Se define el conjunto de partes de un conjunto $A$ como $cal(P)(A) = {X | X subset.eq A}$. Probar que:

  $
    cal(P)(A) inter cal(P)(B) = cal(P)(A inter B)
  $
]

#ej[
  Sean $A, B, C$ conjuntos. Probar que:

  $
    A inter (B triangle C) = (A inter B) triangle (A inter C)
  $
]

#ej[
  Sean $A, B$ conjuntos. Probar que si $A triangle B = A triangle C$, entonces $B = C$.


  Pueden ver esto como un análogo a que para variables enteras, $X xor (X xor Y) = Y$, es decir, el o-exclusivo es cancelativo.
]


#ej[
  Sea $f: X arrow Y$ una función, y $A, B subset.eq Y$. Probar que:

  $
    f^(-1)(A without B) = f^(-1)(A) without f^(-1)(B)
  $
]

#ej[
  Sea $f:X arrow Y$ una función, y $A, B subset.eq X$. Probar que la siguiente proposición es cierta, o dar un contraejemplo:

  $
    f(A inter B) = f(A) inter f(B)
  $
]

#load-bib()