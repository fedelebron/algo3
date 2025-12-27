// Chapter 1: ¿Qué es una demostración matemática?
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= ¿Qué es una demostración matemática?

Una demostración matemática es un argumento convincente de la veracidad de una proposición matemática. Inmediatamente tenemos la pregunta, ¿convence a _quién_? Distintos argumentos van a convencer a distinta gente. Por ejemplo, el siguiente es un argumento de la veracidad del teorema de Pitágoras.

#teo(
  title: [Teorema de Pitágoras],
)[Dado un triángulo rectángulo, la suma de los cuadrados de los catetos es igual al cuadrado de la hipotenusa.]
#demo[
  #align(center)[
    #pitagoras
  ]]

¿Esto es siquiera una demostración? ¿Los convence? ¿Convencería a sus amigos o a alguien que parasen en la calle? ¿Cómo saben, o definen, si "está bien"?

== Demostraciones en la historia
Históricamente, empezamos haciendo matemática sin generalidad, y sin demostraciones. Un matemático en el 2000 a.c.#footnote[No había un concepto de "matemático" en ese momento. Los babilonios entendían conceptos sobre aritmética y álgebra desde el punto de vista de la geometría. Describían relaciones entre ángulos, lados, y perímetros de figuras dibujadas, y usaban esto para construir, arar, estimar distancias, etc.] hubiera afirmado una proposición, y listo. Con suerte hubiera dado ejemplos que mostraran la veracidad de esa proposición en casos particulares. No había un lenguaje formal para hablar en generalidades sobre, por ejemplo, "los enteros". Había tablas de recíprocos de enteros y soluciones a ecuaciones cuadráticas, pero no un algoritmo de división o una expresión como $(-b plus.minus sqrt(b^2 - 4 a c))/(2a)$.

Los griegos son los primeros que intentan dar argumentos de algún tipo para proposiciones generales. Thales de Mileto demostró el siguiente teorema, aunque la primer demostración que sobrevive es la de Euclides.

#teo(
  title: [Teorema de Thales],
)[Si tenemos tres puntos $A$, $B$, y $C$ en un círculo, donde la línea $overline(A B)$ pasa por el centro del círculo, entonces $angle A B C$ es un triángulo rectángulo.]
#demo[

  #let drawing = canvas({
    let r = 2
    draw.circle((0, 0), radius: r)
    draw.circle((0, 0), radius: 0.1, fill: red, name: "E")
    draw.content((rel: (0, -0.4)), text[$E$])
    draw.circle((r * 0.7, r * 0.7), radius: 0.1, fill: blue, name: "A")
    draw.content((rel: (-0.4, 0.1)), text[$A$])
    draw.circle((-r, 0), radius: 0.1, fill: fuchsia, name: "C")
    draw.content((rel: (-0.3, 0)), text[$C$])
    draw.circle((r, 0), radius: 0.1, fill: yellow, name: "B")
    draw.content((rel: (-0.3, 0)), text[$B$])
    draw.circle((0.7, r * 1.4), radius: 0.1, fill: green, name: "F")
    draw.content((rel: (-0.3, 0)), text[$F$])
    draw.line("B", "A", stroke: (dash: "dashed"))
    draw.line("C", "A", stroke: (dash: "dashed"))
    draw.line("F", "A", stroke: (dash: "dashed"))
    draw.line("A", "E", stroke: (dash: "dashed"))
  })
  #let body = [Dada por Euclides@elementa.

    Sea $A B C$ un círculo, $overline(B C)$ su diámetro, $E$ su centro. Unir $overline(B A)$, y $overline(A C)$.

    Digo que el ángulo $angle B A C$ es rectángulo.

    Unir $overline(A E)$, y extender $overline(B A)$ hasta $F$. Como $overline(B E)$ es igual a $overline(E A)$, el ángulo $angle A B E$ también es igual al ángulo $angle B A E$. Como $overline(C E)$ es igual a $overline(E A)$, el ángulo $angle A C E$ es igual al ángulo $angle C A E$. Luego, el ángulo $angle B A C$ es igual a la suma de los dos ángulos $angle A B C$ y $angle A C B$. Pero el ángulo $angle F A C$ exterior al triángulo $A B C$ también es igual a la suma de los dos ángulos $angle A B C$ y $angle A C B$. Luego el ángulo $angle B A C$ también es igual al ángulo $angle F A C$. Luego ambos son rectángulos. Luego el ángulo $angle B A C$ es rectángulo.]
  #wrap-content(drawing, body)
]

¿Los convence esa demostración? ¿Dónde precísamente está $F$? ¿Por qué $angle F A C$ es igual a la suma de $angle A B C$ y $angle A C B$? En su momento, esta demostración no sólo era convincente, sino que fue parte del libro de demostraciones de geometría más famoso y celebrado de la historia. ¿Por qué puede ser que hoy en día nos resulta confusa?

Viajamos luego al 1758, donde en "De numeris qui sunt aggregata duorum quadratorum" ("Sobre números que son la suma de dos cuadrados") Leonhard Euler prueba el siguiente teorema.

#teo[
  Si $p$ y $q$ son dos números, cada uno de los cuales la suma de dos cuadrados, entonces el producto $p q$ es también una suma de cuadrados.
]
#demo[
  Sea $p = a a + b b$ y $q = c c + d d$. Tendremos que $p q = (a a + b b)(c c + d d) = a a c c + a a d d + b b c c + b b d d$, que se puede representar de manera tal que $p q = a a c c + 2 a b c d + b b d d + a a d d - 2 a b c d + b b c c$ y por tal razón $p q = (a c + b d)^2 + (a d - b c)^2$, de donde el producto $p q$ será la suma de dos cuadrados.
]

¿Qué les parece esa demostración? ¿Es más fácil de entender que las dos anteriores? ¿Los convence? ¿Les parece que convencería a _cualquiera_? ¿Qué asume esta demostración? ¿Qué significa "número" acá#footnote[El concepto formal de número real que usamos hoy en dia se definió en 1872, en paralelo por Richard Dedekind y Georg Cantor. Euler y sus matemáticos contemporaneos usaban nociones no totalmente formales, llegando a veces a paradojas.]? Si mis números son las horas del reloj, y estoy haciendo aritmética modular módulo 12, ¿sigue valiendo el teorema? ¿Y si mis "números" son funciones de $RR$ a $CC$? ¿Y si son elementos de punto flotante#footnote[Siguiendo el standard de IEEE 754, por ejemplo punto flotante de 32 bits.] en una computadora, sigue valiendo, o se rompe algo que está asumiendo?

Ahora veamos una demostración formal, escrita en el lenguaje de programación Lean 4.
#teo[Para todo $n in NN$, existe un número primo más grande que $n$.]<proof:formal>
#demo[
  ```lean
    -- Primo (p : ℕ) : Prop
  theorem hay_infinitos_primos (n : ℕ) : ∃ p, n ≤ p ∧ Primo p :=
    let fac := n ! + 1
    -- minFac (n : ℕ) : ℕ, el mínimo factor de n
    let p := minFac fac
    -- factorial_pos (n : ℕ) : 0 < n !
    -- succ_lt_succ {n m : ℕ} : n < m → n + 1 < m + 1
    -- ne_of_gt {a b : ℕ} (h : b < a) : a ≠ b
    have f1 : fac ≠ 1 := ne_of_gt <| succ_lt_succ <| factorial_pos n
    -- minFac_es_primo {n : ℕ} (n1 : n ≠ 1) : Primo (minFac n)
    have pp : Primo p := minFac_es_primo f1
    -- le_of_not_ge: {α: Tipo} {a b : α} : ¬(a ≤ b) → b ≤ a
    have np : n ≤ p :=
      le_of_not_ge fun h =>
        -- dvd_factorial {m n : ℕ} : 0 < m → m ≤ n → m ∣ n !
        -- minFac_pos (n : ℕ) : 0 < minFac n
        have h₁ : p ∣ n ! := dvd_factorial (minFac_pos fac) h
        -- dvd_suma {k m n : ℕ} (h : k ∣ m) : k ∣ n ↔ k ∣ m + n
        -- minFac_dvd (n : ℕ) : (minFac n) ∣ n
        have h₂ : p ∣ 1 := (dvd_suma h₁).2 (minFac_dvd fac)
        -- no_divide_uno {p : ℕ} (pp : Primo p) : ¬(p ∣ 1)
        no_divide_uno pp h₂
    ⟨p, np, pp⟩
  ```
]

#let tt = [La correctitud de esta demostración es verificable automáticamente por una computadora. Esta demostración, ¿los convence? ¿Siquiera la pueden leer? Indudablemente es correcta, formal, y rigurosa (porque las computadoras no nos "creen" nada), ¿eso significa que "está bien"? ¿Ustedes escribirían algo así para comunicarle algo a un par? Si estas demostraciones se pueden verificar formalmente, ¿por qué no escribimos todas las demostraciones así? Esto nos dice que la formalidad no implica legibilidad para nuestra audiencia.]
#let img = image("../proof_robot.png", width: 80%)
#wrap-content(img, tt)

Por último, veamos un teorema moderno, traducido del libro Algebra de Serge Lang. Este es un libro de estudio clásico para álgebra abstracta, y el teorema se ve en la carrera de Matemática en la facultad.

#teo(title: "Teorema de Jordan-Hölder")[
  Sea $G$ un grupo, y sea
  $
    G = G_1 supset G_2 supset dots supset G_r = {e}
  $

  sea una torre normal tal que cada grupo $G_i \/ G_(i+1)$ es simple, y $G_i eq.not G_(i+1)$ para $i = 1, dots, r - 1$. Entonces cualquier otra torre normal de $G$ teniendo las mismas propiedades es equivalente a esta.
]
#demo[
  Dado cualquier refinamiento ${G_(i, j)}$ para nuestra torre, observamos que para cada $i$ existe precísamente un único índice $j$ tal que $G_i \/ G_(i+1) = G_(i, j) \/ G_(i, j+1)$. Luego esta secuencia de factores no-triviales para la torre original, o la torre refinada, es la misma. Esto prueba nuestro teorema.
]

¿Qué tal esta última? ¿Los convence? ¿Les parece clara la demostración? Imagino que a la mayoría les va a resultar incomprensible. Si le está faltando algo para convencerlos, ¿significa que esta demostración "está mal"?

Con estos ejemplos concluímos que lo que se considera una demostración matemática ha evolucionado, como ha evolucionado la noción de matemática que usamos. También, lo que se considera una demostración correcta va a depender del contexto en que uno se encuentre, qué puede uno asumir del lector, y para qué propósito uno está demostrando.

== Contexto en el que están demostrando

Ustedes se encuentran cursando una carrera universitaria en las ciencias formales. El objetivo de la carrera es formarlos como computadores científicos. Como tales, deberían salir de la carrera ambos con conocimientos sobre objetos y herramientas específicas como grafos, números racionales, programación dinámica, sistemas operativos, inducción, cálculo diferencial, teoría de lenguajes, y algoritmos numéricos; pero más importantemente *deberían adquirir la habilidad de razonar formalmente*, de demostrar a cualquiera que se los pida que sus conclusiones son correctas, de entender y criticar razonamientos de otros, de saber cuándo y cómo usar las herramientas que conocen, y cuándo y cómo desarrollar ideas y algoritmos nuevos.

Para la primer parte, el temario de la carrera incluye esos temas en distintas materias. Para la segunda es que se los entrena en demostrar formalmente la veracidad de proposiciones, y la correctitud#footnote[Nota pedante: La RAE no reconoce el término "correctitud", sino "corrección". Sin embargo, el término "corrección" tiene otros significados que pueden confundirlos en el contexto de una carrera universitaria (e.g. corrección de un parcial, corrección de una aproximación numérica). Es común, entonces, usar el término "correctitud" para referirse a la propiedad de ser correcto. Es la diferencia en Inglés entre "correctness" y "correction", que la RAE no hace.] de argumentos. Se usan los objetos de estudio como grafos o números enteros como sujetos de las proposiciones y algoritmos que desarrollen.

Es por esto que la pregunta clásica de "¿pero cuándo voy a usar esto?" está mal planteada. Asume que se les enseña sobre, por ejemplo, grafos, porque alguien les va a "dar un grafo" en su vida profesional. En cambio, se les enseña sobre grafos para que ustedes los introduzcan al modelar problemas que tengan, y para que los usen como sujetos en proposiciones al aprender a demostrar. Podrían estos sujetos ser otros, como fluídos y campos eléctricos en física, o anillos y ecuaciones diferenciales en matemática. En computación, se usan los objetos de ese campo de estudio.

Sus demostraciones, entonces, cumplen un doble propósito. Tienen que:

1. Convencer al lector de la veracidad de la proposición que afirman. Esto es común a todas las demostraciones matemáticas.
2. Convencer al docente que entienden cómo convencer a _cualquier persona_. El docente ya sabe que la proposición es cierta, no se les va a pedir demostrar proposiciones falsas. Luego, ya está convencido/a de la veracidad de la proposición antes de empezar a leer lo que escribieron. El docente va a evaluar si sus argumentos pueden convencer a _cualquiera_.

Como vimos, _cualquiera_ está definido dentro de un contexto. Sus argumentos no van a convencer a un bebé de seis meses, porque no los puede leer. Muchas veces tampoco van a convencer a alguien que no hable español.

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    rows: 50mm,
    block({
      image("../speech_baby.jpeg", width: 100%)
      place(center + horizon, dx: 6mm, dy: -15mm, text(size: 13pt)[$m lt.eq n(n-1)/2$])
    }),
    block({
      image("../speech_russian.jpeg", width: 100%)
      place(center + horizon, dx: 0mm, dy: -17mm, text(size: 20pt)[что?])
    }),
  )]

¿A quién están convenciendo, entonces? Al interlocutor para el cual la carrera los prepara: Un par suyo, de la comunidad científica. Estamos formando científicos, después de todo.
Llegamos entonces a la siguiente definición.

#defi(title: "Demostración")[
  Una demostración es un argumento formal de la veracidad de una proposición, que puede convencer a _cualquier_ par suyo en la comunidad científica.
]

Esto nos dice que tenemos que ser un poco paranóicos, si nuestro objetivo es convencer a _cualquier_ par. Si somos imprecisos, nuestro lector puede no comprender lo que quisimos decir, y luego no estar convencido. Si no demostramos una proposición que usamos, nuestro lector puede no creernos que esa proposición es cierta, y luego no estar convencido. Tenemos no sólo que estar seguros de la veracidad de lo que estamos probando, sino también saber comunicar las razones por las que _cualquier_ par tiene que estar de acuerdo, inclusive si nuestro par nos odia, si nunca vio la proposición antes, si no sabe si es cierta o no antes de empezar a leernos, o si es su primera vez viendo el objeto de estudio sobre el cual estamos hablando (números naturales, programas imperativos, árboles, lo que sea).

Por otro lado, uno puede valerse de que el lector es un par. Sus conocimientos son similares a los que tienen ustedes, y al momento de estar cursando una materia, pueden asumir que el lector cursó y aprobó las materias correlativas. Por ende, si sabemos que $m lt.eq n(n-1)/2$, podemos concluir que $m < n^2$, porque asumimos que el lector aprobó álgebra del secundario. Debemos _decir_ que estamos usando que $m lt.eq n(n-1)/2$ para concluír que $m lt.eq n^2$, pero no hace falta demostrar esa conclusión. Sí debemos decir quién es $n$ y quién es $m$, y si estamos usando, por ejemplo, que $n gt.eq 0$, debemos afirmarlo explícitamente. De nuevo: Estamos siendo un poco paranoicos, porque no queremos que quede ninguna duda en la mente de ningún par que nos lea (en particular, en la mente del docente que nos va a evaluar).

== Formalidad y rigor

Cuando uno habla de "formalidad" en matemática, se está refiriendo a la _forma_ en la que algo está escrito. Las demostraciones, entonces, existen en un continuo de formalismo. Ese formalismo va desde argumentos heurísticos, como "$n! + 1$ no es divisible por nadie debajo de $n$, luego es primo", hasta demostraciones verificables por un asistente de demostración, como la que vimos en el @proof:formal. El formalismo, en el contexto en el que están, se usa para intentar ser riguroso en nuestros argumentos. Un argumento informal como el primero puede ser cierto, como puede ser falso (en particular, $n! + 1$ no siempre es primo, por ejemplo $4! + 1 = 25 = 5^2$).

Razonar informalmente es parte de hacer matemática y computación, pero es sólo la primer parte. Al intentar argumentos, primero los vamos a pensar de forma vaga, no formal. Luego, si queremos asegurarnos de su veracidad, los formalizamos, para estar seguros de ser rigurosos.

La siguiente tabla muestra ejemplos de niveles de formalidad. No es importante que sepan o recuerden cómo tomar derivadas o que sepan lo que es un grafo, el objetivo es que vean el tipo de oración que se usa.
#let row_color(_, y) = {
  let alpha = y / 5
  let beta = 1 - alpha
  color.mix((red, beta), (blue, alpha)).lighten(80%)
}
#grid(
  fill: row_color,
  columns: (0.5fr, 1fr),
  inset: 10pt,
  stroke: 0.5pt + black,
  align: ((x, y) => if x == 0 { center + horizon } else { left }),
  [Heurístico],
  [El número de subconjuntos de un conjunto de $n$ elementos es $2^n$, porque cada cosa puede o estar o no estar.],

  [Poco formal],
  [Como vemos en el siguiente dibujo, siempre vamos a tener suficientes aristas para que $u$ y $v$ tengan un vecino en común.],

  [Razonablemente formal],
  [Sea $S = 1 + 2 + dots + n$ la suma de los primeros $n$ enteros positivos. Podemos escribir a $S$ de dos maneras:

    $
      S & = 1 & + & 2     & + & dots & + & n \
      S & = n & + & (n-1) & + & dots & + & 1
    $

    Sumando término a término, cada término suma $n + 1$, con lo cual

    $
      2S = n (n + 1)
    $

    y $S = (n (n+1))/2$.],

  [Obviamente formal],
  [Queremos ver que $f:RR arrow RR, f(x) = 2x$ es diferenciable en todo su dominio. Sea $x_0 in RR$. Vemos que $lim_(h arrow 0) (2(x_0+h) - 2 x_0)/h = lim_(h arrow 0) (2x_0 + 2h - 2x_0)/h = 2$. Luego, la derivada existe en $x_0$, y es igual a $2$. Luego $f$ es diferenciable en todo su dominio.

    #line()

    Sea $X$ un conjunto con $|X| = n$, y sea $cal(P)(X) = {A subset.eq X}$ su conjunto de partes. Para cada $k in {0, dots, n}$, sea $cal(P)_k (X) = {A subset.eq X | |A| = k}$. Luego, $cal(P)(X) = union.sq.big_(k=0)^n cal(P)_k (X)$. Entonces,
    $
      |cal(P)(X)| & = sum_(k=0)^n |cal(P)_k (X)| \
                  & = sum_(k=0)^n binom(n, k)
    $
    Asimismo, $|cal(P)(X)| = 2^n$ por la proposición 7.  Luego, $sum_(k=0)^n binom(n, k) = 2^n$.
  ],

  [Extremadamente formal],
  [Queremos probar que $1 + 1 = 2$. Los naturales $NN$ están definidos inductivamente como:

    - $0 in NN$.
    - $forall x. x in NN implies S(x) in NN$.

    La suma entre naturales está definida inductivamente como:

    $
         a + 0 & = a \
      a + S(b) & = S(a + b)
    $

    Notamos por conveniencia $1 = S(0)$, y $2 = S(S(0))$. Luego,

    $
      1 + 1 & = S(0) + S(0) \
            & = S(S(0) + 0) \
            & = S(S(0)) \
            & = 2
    $

    Luego $1 + 1 = 2$, que es lo que queríamos demostrar.],

  [Totalmente formal],
  [
    ```Lean
    inductive N where
      | Z : N
      | S (n : N) : N
    open N
    def suma (m n : N) : N :=
      match n with
      | Z   => m
      | S n => S (suma m n)
    def uno : N := S Z
    def dos : N := S (S Z)
    theorem teorema_de_lebron : suma uno uno = dos := rfl
    ```],
)

Lo que se espera de ustedes es que puedan escribir y leer demostraciones entre los niveles "Razonablemente formal" y "Obviamente formal".

Mencioné dos veces la palabra "rigor", pero ¿qué significa? En el contexto de demostraciones matemáticas, el rigor significa que *el lector debería poder seguir la demostración paso a paso*, y no preguntarse ¿y esto por qué vale? a cada momento.

#important-box[Mientras que la formalidad se refiere a *la forma en la que escribimos*, el rigor se refiere a *la implicación lógica de nuestras oraciones*.]

Acá vemos otra vez que el contexto es importante. Podemos asumir, al momento de escribir demostraciones en una materia universitaria, que el lector ha completado las materias correlativas a la que están cursando. Por ejemplo, si ya vieron que diferenciabilidad implica continuidad, pueden asumir que el lector sabe eso, y no tienen que demostrarlo.

Veamos un ejemplo de una demostración no rigurosa:

#ej[
  Sea $A subset.eq NN, A eq.not emptyset$. Demostrar que existe un $a in A$ tal que para todo $b in A$, $a lt.eq b$.
]
#demo[
  Supongamos por contradicción que $A$ no tiene un tal mínimo elemento. Sea $x_0$ cualquier elemento de $A$. Como $A$ no tiene un mínimo elemento, sea $x_1 in NN$ tal que $x_0 > x_1$ (si $x_1$ no existiera, $x_0$ sería menor o igual a todo elemento en $A$, que asumimos no sucede). Como $A$ no tiene un mínimo elemento, sea $x_2 in NN$ tal que $x_1 > x_2$.  Siguiendo de esta manera tenemos una sucesión infinitamente decreciente de naturales, que no puede suceder. Por lo tanto, lo que asumimos debe haber sido falso, y $NN$ tiene un mínimo elemento.]

El lenguaje en el que está escrito esto es razonablemente formal. Sin embargo, esta demostración no es rigurosa. Un lector se va a preguntar qué exactamente está pasando cuando decimos "Siguiendo de esta manera". Estamos haciendo alusión a un proceso implícito, y usando alguna noción no definida de límite. Después de todo, todos los procesos que podríamos enumerar en una demostración son finitos, entonces hacer alusión a que primero elegimos $x_0$, luego $x_1$, luego $x_2$, "$dots$", esconde la dificultad en explicitar exactamente qué es ese "$dots$".

Una vez más, esto depende del contexto. Los antiguos griegos usaban este tipo de argumentos todo el tiempo, y esa demostración hubiera sido considerada rigurosa. Fue sólo a principios del 1900, con el trabajo de Ernst Zermelo@choice, que nos dimos cuenta que ese tipo de razonamientos, si no tenemos cuidado, llevan a paradojas.

#load-bib()
