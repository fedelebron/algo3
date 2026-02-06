// Chapter 5: Errores comunes
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


== Errores comunes
=== Ser informal

Este es *de lejos* el error que más cometen los alumnos. En este momento de su educación, todavía no les recomiendo dejar de lado la formalidad, y hacer argumentos informales. Un argumento informal puede ser riguroso, pero requiere experiencia hacer esto sin cometer errores. Todavía no tienen esa experiencia. Por ende, a la hora de argumentar, sean formales. Algunas recomendaciones sobre formalidad:

+ Pónganle nombre a todo.
  Si un sustantivo no tiene nombre, no podemos hablar de él claramente. Muchas veces se quedan "sin saber cómo seguir", porque no tienen a mano suficientes sustantivos para ver relaciones entre ellos, o ver qué cosas cumple cada uno.

  Si se encuentran usando preposiciones como "el vértice vecino de ..." o "la lista $l$ pero sin el $i$-ésimo elemento", deténganse y ponganle nombre a esos objetos. Por ejemplo, "sea $u$ el vértice vecino de ...", o "sea `l' = l.remove(i)`". Ahora pueden hablar de $u$ y $l'$ directamente, y ver qué propiedades y relaciones cumplen.

  /*
  Ante el siguiente ejercicio:

  #ej[
    Demostrar, usando inducción en el número de vértices, que todo grafo de $n$ vértices que tiene más de $((n-1)(n-2))/2$ aristas es conexo.
  ]
  Esta es una duda de un alumno:

  #quote[Ok, le saco $v$ a $G_(n+1)$, el tema es que $G_(n+1)$ tenía mas de $n(n-1)/2$, y le saco por ejemplo un $v$ con $n-1$ aristas, me queda que $G_n$ tiene mas de $n(n-1)/2 - (n-1) = ((n-1)(n-2))/2$ aristas y por tanto es conexo y ahi ya estoy. Si el $v$ que sacara tuviera menos aristas, no sé si sigue andando.]

  La duda acá sale de no haberle puesto nombre a todo. En particular, usar $d_(G_(n+1)) (v)$, que es el número de aristas que estamos sacando al sacar $v$ de $G_(n+1)$ para obtener $G_n$. El ponerle nombre nos deja usar álgebra. En particular, sabemos que $0 lt.eq d_(G_(n+1)) (v) lt.eq n - 1$, puesto que como máximo, $v$ está conectado a los otros $n$ vértices de $G_(n+1)$. Vamos a tener que argumentar cuidadosamente usando esto.

  #demo[
    Vamos a probar la proposición $P(n):$ Si $G$ es un grafo con $n$ vértices y más de $n(n-1)/2$ aristas, entonces $G$ es conexo.

    $P(0)$ vale trivialmente porque no hay grafos sin vértices. $P(1)$: Un grafo con $n = 1$ vértice siempre es conexo.

    Ahora sea $n gt.eq 2$. Asumo que vale $P(n - 1)$, quiero ver que vale $P(n)$. Sea $G = (V, E)$ un grafo de $n$ vértices, con más de $((n-1)(n-2))/2$ aristas, y $v$ cualquier vértice en $V$. Sea $m = |E|$.

    Consideremos $G' = G - v = (V - {v}, E')$, el grafo que resulta de sacarle $v$ a $G$, junto con todas las aristas incidentes a $v$ en $G$. Notar que sólo puedo hacer esto porque $n gt.eq 2$. No podría sacarle un vértice a un grafo que sólo tuviera un vértice#footnote[En la carrera generalmente requerimos, en la definición de "grafo", que haya al menos un vértice.].

    Sabemos que $0 lt.eq d_G (v) lt.eq n - 1$, porque como mínimo $v$ tiene cero vecinos en $G$, y como máximo tiene a todos los otros $n - 1$ vértices de $G$ como vecinos.

    Partimos en casos.
    + Si $d_G (v) = 0$, entonces $v$ es un vértice aislado. Esto no puede pasar, porque $G$ tiene $m > ((n-1)(n-2))/2$ aristas, y aún poniendo una arista entre _todo_ otro par de vértices en $G$, nos quedarían sólo $((n-1)(n-2))/2$ aristas. Como $m$ es mayor que $((n-1)(n-2))/2$, tiene que haber al menos una arista incidente a $v$.
    + Si $d_G (v) = n - 1$, entonces $v$ comparte una arista con cada uno de los otros vértices de $G$. Luego para cualquier par de vértices $u, w in V$, tenemos un camino $[{u, v}, {v, w}]$ en $G$, y luego $G$ es conexo, que es lo que queríamos demostrar.
    + Caso contrario, $0 < d_G (v) lt.eq n - 2$. Como sabemos que $m > ((n-1)(n-2))/2$, al sacarle $d_G (v)$ aristas a $G$, y sabiendo que $d_G (v) lt.eq n - 2$, obtenemos $|E'| = m - d_G (v) gt.eq m - (n - 2) > ((n-1)(n-2))/2 - (n - 2) = ((n-2)(n-3))/2$ aristas en $G'$. Por hipótesis inductiva, como $G'$ es un grafo de $n - 1$ vértices con más de $((n-2)(n-3))/2$ aristas, sabemos que $G'$ es conexo. Finalmente, como sabemos que $d_G (v) > 0$, al agregar $v$ a $G'$ con todas sus $d_G (v)$ aristas que tenía en $G$, estamos conectando $v$ con un grafo conexo ($G'$) con al menos una arista, y luego $G$ es conexo.
  ]*/

  + No usen el mismo nombre para dos cosas distintas. Si están modificando un objeto, no usen el mismo nombre para el objeto antes y después de modificarlo.
    #ej[Sean $a, b in ZZ$, tal que $a equiv 1 (mod 3)$ y $b equiv 2 (mod 3)$. Probar que $a + b equiv 0 (mod 3)$.]
    #text(red)[
      #demo[
        Como $a equiv 1 (mod 3)$, entonces existe un $k in ZZ$ tal que $a = 3k + 1$. Como $b equiv 2 (mod 3)$, existe un $k in ZZ$ tal que $b = 3k + 2$. Luego, $a + b = (3k + 1) + (3k + 2) = 6k + 3 = 3(2k + 1)$, y luego $a + b equiv 0 (mod 3)$.
      ]
    ]
    Esto está mal, porque usa $k$ para dos cosas distintas. En particular, esto asume que $b = 3k + 2 = (3k + 1) + 1 = a + 1$, lo cual no podemos asumir.

  + Si el objeto $X$ depende de un objeto $Y$, nómbrenlo $X_Y$ o $X(Y)$, para recordar la dependencia. A veces se olvidan, al crear un objeto, de qué depende, y terminan concluyendo algo falso. Un ejemplo tosco:

    #text(red)[
      #demo[
        Queremos ver que el conjunto de los números reales está acotado. Sea $x in RR$. Elegimos $M = x + 1$. Claramente, $x < x + 1$, es decir, $x < M$. Luego para cualquier $x in RR$, $x$ está acotado por $M$, y $RR$ está acotado.
      ]
    ]

    Formalmente, el error es que esto prueba $forall x in RR. exists M in RR. x < M$, mientras que lo pedido es $exists M in RR. forall x in RR. x < M$ (y esto último es obviamente falso).
  + #let im = block(width: 60mm, figure(
      image("/images/neo.png", width: 60mm),
      caption: [Neo intentando probar algo sin darle nombre a todas las cosas.],
    ))
    #let t = [Si terminan definiendo un sustantivo y no lo usan para su conclusión, o no es necesario, pueden removerlo al terminar. Pero si no empezamos dándole nombre, seguro no lo podemos usar.

      Nombrar los objetos que usamos nos deja ser creativos al ver relaciones entre ellos, y crear aún más objetos a partir de ellos.]
    #wrap-content(im, t, align: bottom + right)
+ Cuantifiquen todo.
  + Si usan una variable, cuantifíquenla. Una variable sin cuantificar es inútil. "$G$ es conexo." ¿Quién es $G$? ¿Vale para todo $G$? ¿Existe algún $G$? ¿Es un $G$ particular que definimos nosotros?
  + Presten atención al anidado de cuantificadores. En $forall x in X. exists y in Y. P(x, y)$, $y$ puede depender de $x$, pero $x$ no puede depender de $y$. La oración "$exists x in X. forall y in Y. P(x, y)$" es completamente distinta, no tienen nada que ver una con la otra. Recuerden la #xref(<conversacionn>), donde interpretamos demostraciones como una conversación entre nosotros y alguien que no está pidiendo demostrarles algo.
+ Usen ecuaciones y desigualdades. En vez de decir "El peor caso es que $m = n$", digan explícitamente que $m lt.eq n$, o $m gt.eq n$, sea cual fuere el caso. Muchas veces cometen el error de asumir que un objeto es "un peor caso" (y luego basta probar lo que tienen que probar sólo para ese objeto), pero están confundiéndose con la dirección de la desigualdad. Razonen formalmente, usen ecuaciones y desigualdades.
+ Usen lenguaje formal, cuando existe. La oración "La función seno se ve igual cada $2 pi$." es vaga. ¿Qué significa "se ve igual"? ¿Quién la "ve", y cómo? Escribir esto con precisión resultaría en "Para todo $x in RR$, $sin(x) = sin(x + 2 pi)$.", que es preciso, y nos da una ecuación con la cual trabajar y reemplazar en el futuro.

+ Sean claros en qué es lo que afirman, qué es lo que asumen, y qué es lo que quieren probar. Ver un montón de oraciones donde todas son afirmaciones dificulta la comprensión. Usen conectores lógicos, como "porque", "luego", "si", y "entonces". Pueden usar frases como "Vamos a probar que", "Acá usamos la hipótesis tal", "Asumimos por contradicción que tal cosa", "Vamos a usar tal estrategia (inducción, partir en casos, etcétera)".

=== No decir nada

Si la demostración les salió en una oración, está mal. Generalmente veo esto cuando sólo están reiterando el enunciado, o reiterando la conclusión, y no hay ningún argumento en el medio que los conecte. Saben que tienen que ir de $P$ a $Q$, entonces saben que al menos van a tener que mencionar a $P$ y a $Q$, se confunden, y sólo dicen "$P$. Luego $Q$.", o sólo "$Q$.". Si la demostración fuera una sola oración, no sería un ejercicio de una materia universitaria. Si un ejercicio les resultó totalmente trivial, probablemente lo hicieron mal. Vuelvan a leer la #xref(<conversacionn>), sobre comprender qué nos están pidiendo.

#warning-box[
  Esto es un ejemplo de un alumno, donde sólo se reitera lo que hay que probar.
  #ej[
    Dado un grafo $G = (V, E)$ y un vértice $v in V$, un árbol generador $T$ de $G$ es $v$-geodésico si $"dist"_G (v, w) = "dist"_T (v, w)$ para todo $w in W$.

    Sea $T$ un árbol que genera BFS al comenzar desde un vértice $v$. Probar que $T$ es $v$-geodésico.
  ]
  #text(red)[
    #demo[
      El árbol que queda explícitamente definido después de correr BFS en $G$ con el vértice $v$ cumple que $"dist"_T (v, w)$ es igual a $"dist"_G (v, w)$ para todo $w in V$. Por lo tanto si $T$ es el árbol de BFS en $G$ enraizado en $v$, entonces queda probado que $T$ es $v$-geodésico.
    ]]
  Esto no prueba nada. Sólo reitera la conclusión.
]

Esto sucede también cuando afirman proposiciones sin probarlas, a veces simplemente diciendo que "es obvio". La proposición "Todo árbol de al menos dos vértices tiene al menos dos hojas" es "obvia", e imagino que la mayoría no la puede probar fácilmente. Frecuentemente piensan en varios ejemplos, todos cumplen una propiedad, y concluyen que "es obvio". Lo que es obvio es _que esos ejemplos la cumplen_, lo que no es obvio es _cómo demostrar que todos los objetos la cumplen_. Después de todo, esta conjetura:

#conj(title: "Goldbach")[
  Para todo $n in NN$ par, $n > 2$, existen dos números primos $p, q in NN$, tal que $n = p + q$.
]

jamás ha sido probada, aún después de cientos de años de intentos. Sin embargo, absolutamente todos los números naturales pares que ustedes piensen van a cumplirla, porque no se le conocen contraejemplos. Sólo afirmarla porque no se nos ocurren contraejemplos no dice nada.

En general, pueden usar sin probar (pero mencionando qué es lo que están usando!) lo que hayan visto en materias correlativas, y en el material demostrado en clase. Si quieren usar algo más, pregunten si lo pueden usar. La respuesta muchas veces va a ser "Lo podés usar sólo si lo podés probar", que es lo mismo que "No".

=== Empezar con la conclusión
No empiecen con la conclusión e intenten probar la premisa. Si logran hacer esto, de milagro, usando sólo implicaciones bilaterales ($iff$), en el mejor caso es una pobre y confusa exposición de la implicación pedida. En el peor caso, casi siempre van a cometer el error de usar una implicación que no tiene vuelta válida, y su demostración no va a decir nada.

#warning-box[
  Asumir la conclusión y probar algo cierto no dice nada.
  #postulate[1 = -1]
  #text(red)[
    #demo[
      $
          1 & = -1     & "hago lo mismo en ambos lados" \
        1^2 & = (-1)^2 &                   "simplifico" \
          1 & = 1
      $
      Como llegamos a algo cierto, debemos haber empezado con algo cierto.
    ]]]

Si llegaron a algo razonando así, este es el momento para emprolijar su idea, y empezar desde el principio. No se preocupen porque "parezca un galerazo" que su objeto justo cumpla lo pedido al final. Esa es una preocupación pedagógica del docente, no de ustedes.

=== No entender qué estamos asumiendo

Frecuentemente vemos que usan algo sin saber que lo están usando. Por ejemplo, "sean $u, v in V$ tales que hay un camino entre $u$ y $v$". Nada en esto nos deja concluir que $u eq.not v$. Si luego asumimos que el camino tiene longitud mayor a cero, por ejemplo diciendo "sea $P = [u, x, dots, v]$ el camino entre $u$ y $v$, y tomemos la arista $(u, x)$" (que no tiene por qué existir), estamos asumiendo algo sin siquiera entender que lo estamos haciendo.


#let body_assumption = [Mismo cuando decimos "sea $x$ el vértice tal que $P(x)$". El decir _el_ vértice implica que existe un único tal vértice que cumple $P$. Esto ambos requiere probar que existe, y que no hay otro que cumpla $P$. Si sólo queremos decir que existe (y lo demostramos anteriormente), podemos decir "sea $x$ un vértice tal que $P(x)$".

  Finalmente, a veces lo que asumen no es explícito. Por ejemplo, si se les pide probar que $a$ y $b$ conmutan (es decir, que $a b = b a$), y usan $(a b)^2 = a^2 b^2$, están precisamente asumiendo conmutatividad para probar conmutatividad.]
#let image_assumption = {
  image("/images/proof_abc.png", height: 50mm)
}
#wrap-content(image_assumption, body_assumption)

#load-bib()
