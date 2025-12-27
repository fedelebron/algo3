// Chapter 2: ¿Cuándo, qué, y para qué demostramos?
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= ¿Cuándo, qué, y para qué demostramos?
Un computador científico escribe demostraciones cuando quiere establecer sin dudas la veracidad de una proposición lógica. Por ejemplo, si queremos probar que nuestro sistema no va a quedarse sin memoria independientemente de las consultas que arriven, si queremos probar que nuestro programa no se va a ralentar desmedidamente a medida que se aumente el tamaño de su entrada, o si queremos probar que en nuestro programa con ejecución en paralelo no va a haber "deadlock"#footnote[Un deadlock ocurre cuando hay al menos dos componentes en un programa, cada una esperando a que la otra haga algo, y ninguna pudiendo avanzar.] o livelock#footnote[Un livelock ocurre cuando hay al menos dos componentes en un programa, y cada una cambia su estado en respuesta a la otra, pero ninguna progresa.] en ninguna circumstancia. El siguiente es un ejemplo clásico de un algoritmo concurrente que resuelve el problema de los filósofos comensales@dining. Probar que este programa nunca va a sufrir deadlock debe hacerse formalmente, no basta con probarlo varias veces y ver cómo se comporta.

#algorithm({
  import algorithmic: *
  Procedure(
    "Filosofo",
    ($i$, $n$, "Palitos"),
    {
      While(smallcaps("True"), {
        Call[Pensar][]
        Call[Agarrar-Palito][Palitos\[$i$\]]
        Call[Agarrar-Palito][Palitos\[$(i + 1) mod n$\]]
        Call[Comer][]
        Call[Soltar-Palito][Palitos\[$(i + 1) mod n$\]]
        Call[Soltar-Palito][Palitos\[$i$\]]
      })
    },
  )
})

No está muy lejos de la verdad el decir que *la ciencia de la computación sin demostraciones es ingeniería*#footnote[Un ingeniero respondería, "la ingeniería irrelevante y pedante es ciencia de la computación".]. Vamos a ver luego cómo podemos usar herramientas formales para referirnos a los algoritmos que escribimos, y demostrar propiedades sobre los mismos.

No todas las cosas que querramos saber las vamos a demostrar formalmente. El motivo por el cual la computación es una ciencia, y no sólo matemática, es que hay propiedades de nuestro sistema que vamos a evaluar con argumentos prácticos (por ejemplo, tomando mediciones de nuestro sistema). A veces vamos a usar ambas cosas: Vamos a ver que nuestro programa se comporta bien en tamaños pequeños, y luego mostramos que su comportamiento asintótico es bueno. Al usar nociones asintóticas de complejidad, nos van a quedar constantes sin resolver analíticamente. Para encontrar esas constantes, vamos a medir el sistema real.

#align(center)[
  #grid(
    columns: (1fr, 1fr),
    rows: 50mm,
    canvas({
      draw.set-style(
        axes: (
          y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
          x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
        ),
      )

      plot.plot(
        size: (4, 4),
        x-min: 0,
        x-max: 80,
        y-min: 0,
        y-max: 200,
        x-label: $n$,
        y-label: $T(n) = alpha n log (n) + beta in Theta(n log n)$,
        x-tick-step: 20,
        y-tick-step: 25,
        axis-style: "left",
        legend-style: (
          default-position: "north-east",
          spacing: -1.8,
        ),
        {
          for (a, b, color) in (
            (1, 20, red),
            (4, 50, green),
            (2, 10, blue),
            (0.5, 80, fuchsia),
          ) {
            plot.add(
              style: (stroke: color + 1pt),
              domain: (1e-5, 100),
              samples: 200,
              x => {
                a * x * calc.log(x) + b
              },
              label: [$alpha$=] + str(a) + [, $beta=$] + str(b),
            )
          }
        },
      )
    }),
    canvas({
      draw.set-style(
        axes: (
          y: (label: (anchor: "north-west", offset: -0.2), mark: (end: "stealth", fill: black)),
          x: (label: (anchor: "north", offset: 0.1), mark: (end: "stealth", fill: black)),
        ),
      )

      plot.plot(
        size: (4, 4),
        x-min: 0,
        x-max: 80,
        y-min: 0,
        y-max: 200,
        x-label: [$n$],
        y-label: [Segundos en terminar],
        x-tick-step: 20,
        y-tick-step: 25,
        axis-style: "left",
        legend-style: (
          default-position: "north-east",
          spacing: -1.8,
        ),
        {
          let rng = gen-rng-f(0xFEDE)
          let dy = ()
          let vy = 14
          plot.add(
            (
              for n in range(1, 40) {
                let nn = 2 * n
                (rng, dy) = uniform-f(rng, low: -1.0, high: 1.0)
                ((nn, 21 + nn * calc.log(nn) + vy * dy),)
              }
            ),
            style: (stroke: none),
            mark-style: (stroke: maroon),
            mark: "o",
            mark-size: 0.5mm,
          )
        },
      )
    }),
  )
]

Cuando decidimos demostrar algo formalmente, entonces, es porque realmente queremos concluir algo con total seguridad. No nos alcanza con argumentos heurísticos, como mirar qué pasa con "$n$ chico", o verificar que es cierto para todos los casos que se nos ocurre.

Recordando el contexto en el que están como alumnos de una carrera universitaria, el otro motivo es, como dijimos antes, convencer a su docente que pueden convencer a cualquier par. Esto a veces va a requerir explicitar argumentos en más detalle que lo que esperan. Veamos un ejemplo de la diferencia. El siguiente es un ejercicio de la práctica 1, y la demostración dada por un alumno, verbatim.

#ej[
  Calcule la complejidad de un algoritmo que utiliza $T(n)$ pasos para una entrada de tamaño $n$, donde $T$ cumple:

  $
    T(n) = 2T(n - 4)
  $
]
#demo[
  $
    T(n) & = 2T(n-4) = 2(2T(n-4-4)) \
    dots & = 2^i T(n - 4i)
  $
  Como $n - 4i = 1 iff i = (n-1)/4$.
  Luego,
  $
    = 2^((n-1)/4) T(1) = (2^(1/4))^n 2^(-1/4) = O((2^(1/4))^n)
  $
]

¿Qué les parece esa demostración? ¿Los convence? ¿Les parece que sería marcado correcto en un parcial?

Esta demostración a mi me convenció al leerla. Si me la presentara un compañero en el trabajo, estaría de acuerdo que $T in O((2^(1/4))^n)$. Sin embargo, alguien podría preguntar, "estás restando de a 4 a $n$ hasta llegar a $1$ pero, ¿y si $n$ no es congruente con 1 módulo 4?", o "¿cómo sabés qué T(1) = 1?" El alumno asumió que $T(1) = 1$, y no pensó realmente en una inducción formal, ni en una definición precisa de $T$ (que hubiera requerido definir su dominio, y asignarle a cada elemento de tal dominio un valor del codominio).

Veamos otra demostración, un poco más formal.

#demo[
  Sea $T: NN arrow NN$. Asumo que $T(n) = 2T(n - 4)$ para todo $n gt.eq 4$. Sea $a = max(T(0), T(1), T(2), T(3))$.

  #line(length: 100%, stroke: 0.1mm)

  Definimos $P(n): T(n) lt.eq a 2^(n/4)$. Vamos a probar que $P(n)$ es cierta para todo $n in NN$.

  Como nuestra recurrencia usa un valor de $n$ menor por $4$ que el que recibe, tenemos que probar cuatro casos base, donde no tiene sentido restar $4$ a $n$, pues saldríamos de $NN$.

  Para todo $0 lt.eq n lt.eq 3$, tenemos que $T(n) lt.eq max(T(0), T(1), T(2), T(3)) = a$. Como $2^(n/4) gt.eq 1$ para $0 lt.eq n lt.eq 3$, y $T(n) lt.eq a$, tenemos que $T(n) lt.eq a 2^(n/4)$, que prueba nuestros cuatro casos base.

  Ahora el paso inductivo. Asumo $P(k)$ para todo $k < n$, quiero probar $P(n)$. Si $n lt.eq 3$, ya probamos los casos base arriba, y vale $P$ para ellos. Si $n gt.eq 4$, entonces como sabemos, $T(n) = 2T(n-4)$. Como $0 lt.eq n - 4 < n$, podemos usar la hipótesis inductiva, $P(n - 4)$, obteniendo que $T(n - 4) lt.eq a 2^((n-4)/4)$. Entonces, como $2^((n-4)/4) = 2^(n/4) 2^(-1)$, vemos que $T(n) = 2T(n-4) lt.eq 2 a 2^(n/4) 2^(-1) = a 2^(n/4)$. Esto es precísamente $P(n)$, que es lo que queríamos demostrar.
  #line(length: 100%, stroke: 0.1mm)

  Como sabemos que $T(n) lt.eq a 2^(n/4)$ para todo $n in NN$, podemos usar la definición de $O$, que es que $f in O(g) iff exists alpha in RR_(gt.eq 0), n_0 in NN$, tal que para todo $n in NN$, si $n gt.eq n_0$, entonces $f(n) lt.eq alpha g(n)$.

  Podemos acá elegir $alpha = a$, $n_0 = 0$, $g(n) = 2^(n/4)$, y vemos que $T in O(g)$.
]

¿Qué les pareció esa demostración? Es más larga. Es más detallada. La anterior no "estaba mal", sólo no muestra que el escritor entiende los conceptos que se están evaluando (en este caso, inducción, comportamiento asintótico, y funciones recursivas). Al no tener en cuenta los detalles difíciles sobre inducción en esta demostración, el docente no puede tener confianza que el alumno sabe hacer esto bien, y no va a cometer un error por olvidárselos. De nuevo: Nunca se les va a pedir probar algo falso, por lo cual no importa que sea _cierto_ que $T in O(2^(n/4))$. Lo que importa es si lo saben demostrar.

Para un computador científico, la segunda demostración tiene otro "sabor". Al leerla, nos lleva de la mano, de paso a paso, explicitando cada uno. Uno llega a la conclusión con una seguridad de que cada paso está bien fundado, sin tener que adivinar qué quiere decir cada oración, y sin tener que preguntarse "¿y qué pasa si tal cosa no se cumple?". Las demostraciones que ustedes escriban tienen que dejarlos, y dejar al lector, con la misma sensación. Parece poco serio lo que estoy diciendo, pero realmente es una buena guía para saber cuándo están haciendo las cosas bien. Esa sensación la van a afilar practicando, haciendo demostraciones, recibiendo correcciones de sus docentes, cometiendo errores, viendo dónde les faltó definir algo, asumieron algo, no se acordaron de un caso, o no entendieron la consigna.

Finalmente, la longitud de la demostración no es algo a intentar emular en sí. De hecho, lo contrario es cierto: si pueden ser precisos y concisos, ¡mejor! Es muy común, sin embargo, que erren por el otro lado, haciendo demostraciones extremadamente escuetas, de una o dos oraciones, pretendiendo que eso le demuestre al lector lo que dijimos que una demostración tiene que mostrar. A veces es porque piensan que, como no saben probar algo, mejor ni lo mencionan y "si pasa pasa"#footnote[En mi experiencia como docente, esto no funciona nunca. El docente ya sabe cómo demostrar lo que hay que demostrar, y cuál es la parte difícil de la demostración. Si su demostración no menciona y resuelve esa parte explícitamente, es inmediato darse cuenta que el/la alumno/a está mandando fruta.]. Otras veces es porque no se dan cuenta que están asumiendo algo. Otras es porque no entendieron qué se les está pidiendo demostrar. En las próximas secciones vamos a ver errores clásicos y cómo no cometerlos.

#load-bib()
