#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Análisis de complejidad de algoritmos

Vamos a poner en práctica lo que aprendimos sobre análisis asintótico de funciones, para entender el comportamiento de algoritmos. Para eso, necesitamos establecer un puente entre el mundo abstracto de las funciones $f: NN arrow RR0$ y el mundo concreto de los algoritmos que corren en computadoras.

=== Modelo de cómputo

Cuando analizamos un algoritmo, estamos haciendo una abstracción. No analizamos código en un lenguaje particular corriendo en una computadora específica, con su procesador, su memoria, y su sistema operativo. En cambio, asumimos un _modelo de cómputo_: una descripción simplificada de cómo funciona una computadora, que define qué operaciones básicas podemos realizar.

#def[
  El *Random Access Machine*@ram (RAM) es un modelo de cómputo con las siguientes características:
  - La memoria es una secuencia infinita de celdas, cada una capaz de almacenar un número entero de tamaño arbitrario.
  - Leer o escribir cualquier celda de memoria toma tiempo constante (de ahí "random access").
  - Las operaciones aritméticas básicas (suma, resta, multiplicación, división, comparación) toman tiempo constante.
  - Las operaciones de control de flujo (saltos condicionales, llamadas a funciones) toman tiempo constante.
]

Este es el modelo que usamos implícitamente cuando analizamos algoritmos en esta materia. Es una simplificación útil: nos permite ignorar detalles como el tamaño del caché, la velocidad del disco, o las optimizaciones del compilador, y enfocarnos en la estructura del algoritmo: operaciones aritméticas/lógicas, control de flujo, y acceso a memoria.

#note-box[
  Existen otros modelos de cómputo. Las _máquinas de Turing_@turing son el modelo teórico más fundamental, usado para definir qué es computable. El modelo _word RAM_@wram asume que los enteros tienen un tamaño máximo de $w$ bits. El modelo de _memoria externa_@external-memory cuenta accesos a disco en vez de operaciones. El modelo de _random-access stored-program machine_@rasp (RASP) es igual a RAM, excepto que la lista de instrucciones está en sí almacenada en la memoria, en vez de en un lugar separado. Cada modelo es útil para distintos propósitos, pero el modelo RAM es el estándar para análisis de algoritmos.

  Notemos que el modelo RAM asume que sumar o multiplicar cualquier par de enteros es una única operación. Si queremos que este modelo modele nuestras computadoras, esto es demasiado para asumir: Nuestras computadoras representan enteros grandes usando muchos bits, y el tiempo real que toma sumarlos depende del número de bits que tengan. El modelo word RAM es más realista cuando trabajamos con enteros que caben en una palabra de $w$ bits, y además nos permite analizar operaciones bit a bit. Sin embargo, si nuestro problema trata de enteros de precisión arbitraria (mucho más grandes que $w$ bits), como en criptografía o teoría de números, ni RAM ni word RAM son adecuados: deberíamos contar operaciones sobre bits o dígitos.
]

El modelo determina qué operaciones contamos y cómo las pesamos. Cuando decimos que una ejecución de un algoritmo con cierta entrada hace "$n^2$ operaciones", estamos diciendo que hace $n^2$ operaciones básicas bajo el modelo RAM. Si usáramos otro modelo, el conteo podría ser diferente.

=== Tamaño de entrada

Para analizar un algoritmo, necesitamos definir qué significa el "tamaño" de una entrada. Esta elección no es única, y es parte del modelado del problema.

#def[
  Dado un algoritmo $A$ que recibe entradas de un conjunto $cal(I)$, una *función de tamaño* es una función $|dot|: cal(I) arrow NN$ que asigna a cada entrada un número natural que llamamos su _tamaño_.
]

Algunas elecciones comunes de tamaño:

#table(
  columns: (0.35fr, 0.65fr),
  inset: 8pt,
  stroke: 0.5pt + black,
  align: left,
  [*Tipo de entrada*], [*Tamaño típico*],
  [Lista o arreglo], [$n =$ número de elementos],
  [Cadena de caracteres], [$n =$ longitud de la cadena],
  [Número entero $k$], [$n = k$ (valor), o $n = log_2 k$ (bits)],
  [Matriz $M$ de $m times n$ enteros], [$m times n$],
)

#warning-box[
  La elección del tamaño afecta el análisis. Consideremos un algoritmo que determina si un número $k$ es primo, iterando desde $2$ hasta $sqrt(k)$. 
  ```py
  def es_primo(k: int) -> bool:
    for i in range(2, int(sqrt(k)) + 1):
      if k % i == 0:
        return False
    return True
  ```
  
  - Si definimos tamaño como $n = k$, el algoritmo hace $O(sqrt(n))$ operaciones.
  - Si definimos tamaño como $n = log_2 k$ (el número de bits para representar $k$), el algoritmo hace $O(sqrt(2^n)) = O(2^(n/2))$ operaciones.
  
  Ambos análisis son correctos, pero dicen cosas distintas. El segundo es más honesto, pues tenemos que usar $log_2 k$ bits para representar $k$. También es fácil ver por qué el algoritmo trivial es demasiado lento en la práctica: toma tiempo _exponencial_ en el tamaño de la entrada en el peor caso.
]

Sugiero que sean precisos a la hora de definir el tamaño de entrada de su problema. Cuando veamos algoritmos sobre grafos, no va a ser lo mismo que nuestra entrada sea una lista de $m$ pares de enteros, que una matriz binaria de $n times n$ celdas. El tamaño de entrada, así como el algoritmo entero, va a tener que corresponderse con cómo representamos la entrada.

=== Funciones de costo

Una vez fijados el modelo de cómputo y la función de tamaño, podemos definir funciones que miden el costo de ejecutar un algoritmo. Algunas funciones comunes son las que miden el número de operaciones necesarias y el espacio necesario.

#def[
  Sea $A$ un algoritmo que recibe entradas del conjunto $cal(I)$. Definimos:
  - $T_A: cal(I) arrow RR0$, donde $T_A (x)$ es el número de operaciones que realiza $A$ al recibir la entrada $x$. Esto también se conoce como el *tiempo* que toma ejecutar $A(x)$.
  - $S_A: cal(I) arrow RR0$, donde $S_A (x)$ es la cantidad de memoria que usa $A$ al recibir la entrada $x$, por encima de la memoria usada por la entrada.
]

Estas funciones dependen del algoritmo y de la entrada específica, no sólo de su tamaño. Por ejemplo, un algoritmo de ordenamiento puede hacer distinto número de comparaciones para dos listas de la misma longitud.

#note-box[
  Podemos usar funciones de costo para medir otros recursos además de tiempo y espacio:
  - Número de comparaciones (para algoritmos de ordenamiento o búsqueda).
  - Número de accesos a disco (para algoritmos de memoria externa).
  - Número de mensajes enviados (para algoritmos distribuidos).
  - Número de multiplicaciones (para algoritmos numéricos donde son costosas).
  
  La elección depende de qué recurso es el cuello de botella en nuestra aplicación.
]

Veamos algunos ejemplos de funciones de costo que miden distintos recursos.

#ejemplo(title: "Tiempo")[
  Consideremos el siguiente algoritmo que calcula la suma de los elementos de una lista:
  ```py
  def sumar(lista: list[int], n: int) -> int:
    total = 0
    i = 0
    while i < n:
      total += lista[i]
      i += 1
    return total
  ```

  Sea $n$ la longitud de la lista `lista`. Definimos el tamaño de entrada como $n$. En cada iteración del ciclo se realizan una comparación, dos sumas, y un acceso a memoria (constantes bajo el modelo RAM), y hay $n$ iteraciones. Antes de entrar al ciclo hay dos asignaciones, y luego de la última iteración del ciclo realizamos una comparación que da falso, que nos dice que podemos salir del ciclo. Luego, si estamos midiendo el número de operaciones, $T_A (x) = 4n + 3$ para toda lista $x$ de longitud $n$. En este caso, la función de costo no depende de los valores concretos de la lista, sino sólo de su longitud.
]

Notemos cómo analizando los pasos que realiza el algoritmo, y contando lo que nos interesa, conseguimos la función de costo.

#ejemplo(title: "Comparaciones")[
  Consideremos un algoritmo que encuentra el máximo de una lista:

  ```py
  def maximo(lista: list[int], n: int) -> int:
    m = lista[0]
    for i in range(1, n):
      if lista[i] > m:
        m = lista[i]
    return m
  ```

  Si definimos nuestro costo $C_A$ como el número de comparaciones que realiza nuestro algoritmo $A$, para cualquier lista de longitud $n$ se realizan exactamente $n - 1$ comparaciones: una por cada iteración del ciclo. La función de costo es, luego, $C_A (x) = n - 1$, independiente de los valores de la entrada.

  En cambio, si midiéramos el número de _asignaciones_ a `m`, ese valor sí depende de la entrada. Si la lista está ordenada de menor a mayor, se hacen $n$ asignaciones (la inicial más una por cada iteración). Si está ordenada de mayor a menor, se hace una sola asignación (la inicial). Esto muestra que la elección del recurso a medir puede hacer que la función de costo dependa o no de la entrada concreta.
]

#ejemplo(title: "Mensajes enviados")[
  En sistemas distribuidos, a menudo medimos el número de mensajes que se envían entre los nodos de una red. Consideremos una red de $n$ nodos conectados en anillo (cada nodo puede comunicarse con sus dos vecinos), y un algoritmo simple de _broadcast_: el nodo $0$ quiere enviar un dato a todos los demás.

  ```py
  def broadcast(x, id: int, n: int):
    if id == 0:
      send(x, id + 1)
    else:
      y = receive(id - 1)
      if id != n - 1:
        send(y, id + 1)
  ```

  Este algoritmo envía exactamente $n - 1$ mensajes: el nodo $0$ inicia, y luego cada nodo intermedio reenvía, hasta que el dato llega al nodo $n - 1$. La función de costo es $M_A (x) = n - 1$, donde $M$ mide mensajes enviados. 

  En cambio el siguiente algoritmo, que envía mensajes en paralelo, usa el mismo número de mensajes, pero tiempo logarítmico:

  ```py
  def broadcast_paralelo(x, id: int, n: int):
    if id != 0:
      x = receive(id//2)
    if id < n / 2:
      parallel(
        send(x, 2 * id + 1),
        send(x, 2 * id + 2),
      )
  ```
]

#ejemplo(title: "Espacio")[
  Consideremos dos algoritmos que invierten una lista.

  El primero usa un arreglo auxiliar:
  ```py
  def invertir_con_copia(lista: list[int]) -> list[int]:
    n = len(lista)
    resultado = [0] * n
    for i in range(n):
      resultado[n - 1 - i] = lista[i]
    return resultado
  ```

  El segundo lo hace _in-place_, intercambiando elementos:
  ```py
  def invertir_sin_copia(lista: list[int]) -> None:
    n = len(lista)
    for i in range(n // 2):
      lista[i], lista[n - 1 - i] = (
        lista[n - 1 - i], lista[i]
      )
  ```

  Si medimos el espacio _auxiliar_ (la memoria adicional que usa el algoritmo más allá de la entrada), el primero tiene $S_A (x) = n$ (necesita un arreglo de $n$ celdas), mientras que el segundo tiene $S_A (x) = 1$ (sólo usa una variable temporal para el intercambio). Ambos realizan $Theta(n)$ operaciones en tiempo, pero difieren significativamente en el uso de espacio.
]

#ejemplo(title: "Tiempo amortizado", breakable: true)[
Consideremos un ejemplo más interesante sobre uso de tiempo, donde debemos amortizar el costo de una operación. El siguiente código es esencialmente el mismo que usa C++ para insertar en `std::vector`, o en general, cualquier vector redimensionable en cualquier lenguaje.

```c
void* malloc(int size); // Tiempo constante.
void free(void* ptr); // Tiempo constante.

struct vector {
  int* datos;
  int capacidad;
  int tamaño;
};

void vector_agregar(struct vector* v, int x) {
  if (v->tamaño == v->capacidad) {
    // Duplicamos la capacidad.
    int nueva_capacidad = max(1, v->capacidad * 2);
    int* nuevos_datos = malloc(nueva_capacidad * sizeof(int));
    
    // Copiamos los elementos existentes.
    for (int i = 0; i < v->tamaño; i++) {
      nuevos_datos[i] = v->datos[i];
    }
    
    // Liberamos la memoria anterior.
    free(v->datos);
    
    // Actualizamos el vector.
    v->datos = nuevos_datos;
    v->capacidad = nueva_capacidad;
  }
  
  // Agregamos el nuevo elemento.
  v->datos[v->tamaño] = x;
  v->tamaño++;
}

void f(int n) {
  struct vector v = {
    datos: NULL,
    capacidad: 0,
    tamaño: 0
  };

  for (int i = 0; i < n; i++) {
    vector_agregar(&v, i);
  }
}
```

Para entender cuánto tiempo toma `f(n)`, tenemos que entender cuánto tiempo va a tomar cada llamada a `vector_agregar`. Cada llamada a `vector_agregar` toma tiempo $Theta(1)$ si `v->tamaño < v->capacidad`, y tiempo $Theta(t)$ (donde $t$ es `v->tamaño`) si hay que redimensionar, porque se copian todos los elementos. En el peor caso una sola llamada toma $Theta(n)$, pero las redimensiones son infrecuentes: ocurren cuando el tamaño es $0, 1, 2, 4, 8, dots$, es decir en potencias de $2$.

Contemos el costo total de las $n$ llamadas a `vector_agregar`. La $j$-ésima redimensión (para $j gt.eq 1$) copia $2^(j-1)$ elementos. La última redimensión antes de la inserción $n$-ésima ocurre cuando el tamaño es $2^(floor(log_2(n-1)))$. Luego, el costo total de todas las copias es:

$
  sum_(j = 0)^(floor(log_2(n - 1))) 2^j = 2^(floor(log_2(n-1)) + 1) - 1 lt.eq 2(n - 1) - 1 < 2n in O(n)
$

Sumando esto con las $n$ asignaciones de costo $Theta(1)$ cada una, el costo total de las $n$ llamadas es $Theta(n)$. El costo _amortizado_ por llamada es entonces $Theta(n) / n = Theta(1)$: si bien una llamada individual a `vector_agregar` puede tomar $Theta(n)$ en el peor caso, el costo promediado sobre la secuencia de $n$ llamadas es constante.

La función `f`, entonces, toma tiempo $Theta(n)$.
]

Este último ejemplo fue un caso de análisis amortizado. Hay varias otras formas de hacer este tipo de análisis, como el método de banquero y el método de potencial. Para los interesados en estos métodos, recomiendo el libro @clrs, la sección de análisis amortizado. La fuente original del análisis amortizado es @amortized.

Cuando un algoritmo es recursivo, su función de costo se expresa naturalmente como una _recurrencia_: una ecuación que define $T(n)$ en términos de $T$ evaluada en entradas más pequeñas. Para derivar la recurrencia, leemos el código e identificamos:

+ El caso base: qué hace el algoritmo cuando no hace recursión. Esto nos dice cuánto vale $T$ para los tamaños más chicos.
+ Las llamadas recursivas: cuántas hay, y con qué tamaño de entrada. Cada llamada contribuye un término $T(dots)$.
+ El trabajo no recursivo: qué hace el algoritmo además de las llamadas recursivas. Esto nos da los términos aditivos a $T$.

Veamos un ejemplo.

#ejemplo(title: "Algoritmos recursivos")[
  En el problema de las Torres de Hanoi@concrete, tenemos $n$ discos de tamaños distintos apilados en una varilla (el más grande abajo), y queremos moverlos a otra varilla, usando una varilla auxiliar, moviendo un disco a la vez y sin nunca colocar un disco más grande sobre uno más pequeño.

  #align(center)[
    #image("/images/hanoi.png", height: 25%)
  ]

  ```py
  def hanoi(n: int, src: int, dst: int, aux: int):
    if n == 0:
      return
    hanoi(n - 1, src, aux, dst)
    mover(src, dst) # Mover el disco de arriba de la pila src a la pila dst.
    hanoi(n - 1, aux, dst, src)
  
  hanoi(n, 0, 2, 1)
  ```

  Midamos el número de movimientos que realiza `hanoi`. Siguiendo los pasos de arriba:

  + Caso base. Cuando $n = 0$, no hacemos ningún movimiento. Luego $T(0) = 0$.
  + Llamadas recursivas. Hay dos llamadas a `hanoi` con argumento $n - 1$. Cada una contribuye $T(n - 1)$ movimientos.
  + Trabajo no recursivo. Una llamada a `mover`, que cuesta $1$ movimiento.

  Ensamblando, obtenemos la recurrencia $T(0) = 0$ y $T(n) = 2T(n-1) + 1$ para $n gt.eq 1$. Expandiendo los primeros valores, $T(1) = 1, T(2) = 3, T(3) = 7, T(4) = 15$, sospechamos que $T(n) = 2^n - 1$. Probémoslo por inducción.

  - $T(0) = 0 = 2^0 - 1$. #sym.checkmark
  - Si $T(n-1) = 2^(n-1) - 1$, entonces $T(n) = 2T(n-1) + 1 = 2(2^(n-1) - 1) + 1 = 2^n - 1$. #sym.checkmark

  Luego, $T(n) = 2^n - 1$ para todo $n in NN$, y luego $T in Theta(2^n)$.
]

=== Peor caso, mejor caso, y caso promedio

Como la función de costo depende de la entrada específica, y puede haber muchas entradas del mismo tamaño, definimos funciones que agregan el costo sobre todas las entradas de un tamaño dado. Esto nos deja razonar sobre el comportamiento de nuestro algoritmo a medida que el tamaño de la entrada crece, en vez de preocuparnos por la entrada específica.

#def[
  Sea $A$ un algoritmo, $|dot|$ una función de tamaño, y $T_A$ una función de costo. Definimos:
  
  - *Peor caso*: $T_"max" (n) = max {T_A (x) : |x| = n}$
  - *Mejor caso*: $T_"min" (n) = min {T_A (x) : |x| = n}$
  - *Caso promedio*: $T_"avg" (n) = EE_(x tilde D_n) [T_A (x)]$
  
  donde $D_n$ es una distribución de probabilidad sobre las entradas de tamaño $n$.
]

El peor caso es el más usado, porque nos da una *garantía*: sin importar qué entrada $x$ recibamos, el algoritmo no tardará más que $T_"max" (|x|)$. Esto es útil para sistemas donde necesitamos predecir tiempos de respuesta.

El mejor caso rara vez se usa solo, porque es demasiado optimista. Sin embargo, es útil para establecer _cotas inferiores_ para problemas. Por ejemplo, uno puede demostrar que todo algoritmo que sume $n$ enteros es tal que $T_"min" in Omega(n)$.

El caso promedio es útil cuando las entradas vienen de una distribución conocida, o cuando queremos entender el comportamiento "típico". Sin embargo, tiene una sutileza importante:

#warning-box[
  El caso promedio requiere especificar una distribución $D_n$ sobre las entradas. Distintas distribuciones dan distintos promedios. Cuando no se especifica, se suele asumir la distribución uniforme sobre todas las entradas de tamaño $n$, pero esto no siempre refleja la realidad.
  
  Por ejemplo, para Quicksort con pivote fijo, el caso promedio bajo distribución uniforme es $Theta(n log n)$, pero si las entradas reales tienden a estar casi ordenadas, el tiempo va a estar cerca de $n^2$.
]

Veamos un ejemplo concreto para ilustrar estos conceptos.

#ej[
  Consideremos el siguiente algoritmo de búsqueda lineal:
  
  ```py
  def buscar(lista: list[int], x: int) -> int:
    for i in range(len(lista)):
      if lista[i] == x:
        return i
    return -1
  ```
  
  Definimos el costo del algoritmo como el número de comparaciones que hace el algoritmo al buscar $x$ en la lista $L$. Definimos el tamaño de la entrada como la longitud de la lista.

  Analizar el peor caso, mejor caso, y caso promedio del número de comparaciones.
]
#sol[
  - Mejor caso. Si $x$ está en la primera posición, hacemos una sola comparación. Luego $T_"min" (n) = 1$ y luego $T_"min" in Theta(1)$.
  
  - Peor caso. Si $x$ no está en la lista, o está en la última posición, hacemos $n$ comparaciones. Luego $T_"max" (n) = n$, y luego $T_"max" in Theta(n)$.
  
  - Caso promedio. Asumamos que $x$ está en la lista, y que está en cada posición con igual probabilidad $1/n$. Si $x$ está en la posición $i$ (indexando desde $1$), hacemos $i$ comparaciones. Entonces:
  
    $
    T_"avg" (n) = sum_(i=1)^n i dot 1/n = 1/n dot (n(n+1))/2 = (n+1)/2
    $
  
    Luego $T_"avg" in Theta(n)$. Si en cambio asumimos que $x$ puede no estar en la lista con probabilidad fija $p in [0, 1]$, el análisis cambia:
  
    $
    T_"avg" (n) = p dot n + (1-p) dot (n+1)/2 = n (p + (1-p)/2) + (1-p)/2 = n ((1+p)/2) + (1-p)/2
    $
  
    Luego $T_"avg" in Theta(n)$. En ambos casos, el promedio es $Theta(n)$, pero las constantes son distintas.
]

=== Del algoritmo a la función asintótica

Juntando lo que aprendimos sobre análisis asintótico con lo que aprendimos sobre algoritmos, el proceso completo de análisis de un algoritmo $A$ tiene los siguientes pasos:

+ *Fijar el modelo de cómputo*. Usualmente el modelo RAM, implícitamente.

+ *Definir el tamaño de entrada*. ¿Qué significa $n$ para este problema? ¿Es el número de elementos de una lista, el máximo elemento de un conjunto, el número de dígitos de un entero dado, el número de aristas en un árbol, etc? Si hay dos variables, ¿el tamaño de entrada es $n + m$? ¿Es $n times m$? ¿Es $n^(3+m)$?

+ *Definir la función de costo* $T_A (x)$ para cada entrada $x$. Elegir qué recurso medir (tiempo, espacio, comparaciones, etc.) y definir $T_A (x)$ como la cantidad de ese recurso que consume $A$ al recibir la entrada $x$. La función de costo va a ser inducida por el código del algoritmo.

+ *Agregar por tamaño*. Elegir peor caso, mejor caso, o promedio de $T_A$ para obtener una función $T: NN arrow RR0$. Notemos como estas son precisamente las funciones para las cuales aprendimos a hacer análisis asintótico.

+ *Analizar asintóticamente*. Usar las herramientas de la sección anterior ($O$, $Omega$, $Theta$, límites, árboles de recursión, teorema maestro) para caracterizar $T$.

#note-box[
  Es importante ser preciso al reportar. No es lo mismo decir:
  - "$A$ es $O(n^2)$" (ambiguo: ¿qué estamos midiendo? ¿peor caso?)
  - "$A$ corre en tiempo $Omega(n^2)$ en el peor caso" (claro)
  - "El número de comparaciones de $A$ es $Theta(n log n)$ en el peor caso" (muy claro)
]

#ejemplo[
  Consideremos el siguiente algoritmo de búsqueda binaria, que busca un elemento $x$ en una lista ordenada:

  ```py
  def busqueda_binaria(lista: list[int], x: int) -> int:
    lo = 0
    hi = len(lista)
    while lo < hi:
      mid = (lo + hi) // 2
      if lista[mid] == x:
        return mid
      elif lista[mid] < x:
        lo = mid + 1
      else:
        hi = mid
    return -1
  ```

  El invariante del ciclo es que si $x$ está en la lista, entonces está en `lista[lo:hi]`. Definimos el tamaño de la entrada como $n$, la longitud de la lista. Sea $C(x)$ el número de comparaciones entre elementos que realiza `busqueda_binaria` sobre la entrada $x$. Analizar el peor caso y el mejor caso de $C$.
]
#sol[
  Siguiendo los pasos del proceso de análisis:

  + *Modelo de cómputo*: RAM.
  + *Tamaño de entrada*: $n$, la longitud de la lista.
  + *Función de costo*: $C(x)$ es el número de comparaciones entre elementos que realiza `busqueda_binaria` sobre la entrada $x$.
  + *Agregación por tamaño*: peor caso, $T_"max" (n)$, y mejor caso, $T_"min" (n)$.
  + *Análisis asintótico*:

    - Mejor caso. Si `lista[mid] == x` en la primera iteración, hacemos una sola comparación. Luego $T_"min" (n) = 1$, y luego $T_"min" in Theta(1)$.

    - Peor caso. El intervalo `[lo, hi)` comienza con $n$ elementos. En cada iteración donde no encontramos $x$, se reemplaza `lo` por `mid + 1` o `hi` por `mid`, reduciendo el intervalo de $"hi" - "lo"$ elementos a lo sumo $floor(("hi" - "lo") / 2)$ elementos. El ciclo termina cuando el intervalo se vacía ($"lo" gt.eq "hi"$) o cuando encontramos $x$. En el peor caso ($x$ no está en la lista), el ciclo ejecuta $floor(log_2 n) + 1$ iteraciones, cada una con a lo sumo $2$ comparaciones.
      
      Tras $k$ iteraciones, el intervalo tiene a lo sumo $floor(n / 2^k)$ elementos. El ciclo termina cuando el intervalo se vacía, lo cual requiere $floor(n / 2^k) = 0$, es decir $2^k > n$, por lo que el número de iteraciones es $floor(log_2 n) + 1$. Como cada iteración realiza a lo sumo $2$ comparaciones, $T_"max" (n) lt.eq 2(floor(log_2 n) + 1)$.
      Recíprocamente, cuando $x$ no está en la lista, el ciclo ejecuta las $floor(log_2 n) + 1$ iteraciones, cada una con al menos $1$ comparación, con lo cual $T_"max" (n) gt.eq floor(log_2 n) + 1$. Luego, $T_"max" in Theta(log n)$.

      También podemos pensar en `busqueda_binaria` como un algoritmo recursivo implícito: cada iteración resuelve el problema en un subintervalo de tamaño $floor(n/2)$, sumando $O(1)$ costo adicional (una comparación). Esto nos da la recurrencia $T_"max" (n) = T_"max" (floor(n/2)) + O(1)$. Aplicando el teorema maestro con $a_1 = 1$, $a_2 = 0$, $b = 2$, y $f in O(1)$, tenemos $c = log_2 1 = 0$, y $f in Theta(n^0 log^0 n) = Theta(1)$. Caemos en el segundo caso con $k = 0$, y concluimos que $T_"max" in Theta(log n)$.
]

#ejemplo[
  Mergesort es un algoritmo de ordenamiento a base de comparaciones.

  ```py
  def merge(left: list[int], right: list[int]) -> list[int]:
    result = []
    i = 0
    j = 0
    while i < len(left) and j < len(right):
      if left[i] <= right[j]:
        result.append(left[i])
        i += 1
      else:
        result.append(right[j])
        j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

  def mergesort(arr: list[int]) -> list[int]:
    if len(arr) <= 1:
      return arr
    mid = len(arr) // 2
    left = mergesort(arr[:mid])
    right = mergesort(arr[mid:])
    return merge(left, right)
  ```

  Dada una lista de enteros $x$, sea $C(x)$ el número de comparaciones que hace `mergesort(x)`. Se define $T:NN arrow NN$ como $T(n) = max_x {C(x) | "len"(x) = n}$. Es decir, el máximo número de comparaciones que realiza ```py mergesort(x)```, entre todas las listas `x` tales que ```py len(x) = n```.

  Probar que $T in O(n log n)$.
]
#sol[
  Sigamos los pasos del proceso de análisis para analizar el comportamiento de `mergesort` en el peor caso.

  + *Modelo de cómputo*: RAM.

  + *Tamaño de entrada*: $n$, la longitud de la lista.

  + *Función de costo*: sea $C(x)$ el número de comparaciones que realiza `mergesort(x)`.

  + *Agregación por tamaño*: peor caso. Definimos $T(n) = max {C(x) : "len"(x) = n}$.

  + *Análisis asintótico*: `mergesort` divide la lista en dos mitades de tamaños $floor(n/2)$ y $ceil(n/2)$, las ordena recursivamente, y luego las combina con `merge`. La función `merge` recorre ambas listas de izquierda a derecha, haciendo una comparación por paso, y en cada paso avanza en una de las dos listas. Como las listas tienen $n$ elementos en total, `merge` hace a lo sumo $n - 1 in O(n)$ comparaciones (el último elemento no necesita ser comparado). Esto nos da la recurrencia:

    $
      T(n) = T(floor(n/2)) + T(ceil(n/2)) + O(n)
    $

    Aplicamos el teorema maestro con $a_1 = 1$, $a_2 = 1$ (luego $a = 2$), $b = 2$, y $f in O(n)$. Tenemos $c = log_2 2 = 1$, y $f in Theta(n^1 log^0 n) = Theta(n)$. Caemos en el segundo caso del teorema maestro con $k = 0$, y concluimos que $T in Theta(n log n)$.
]

/*

FIXME: Este algoritmo es estocástico, y todavía no expliqué eso.

#ej[
  Determinar cuánto tiempo va a tomar el siguiente algoritmo, en el caso promedio:

  ```py
  def f(n: int) -> int:
    if n <= 0: return 0
    i = random(n)
    return f(i) + f(n - 1 - i)
  ```

  asumiendo que `random` toma una unidad de tiempo, y todas las otras operaciones toman tiempo despreciable. `random(n)` devuelve un número uniformemente al azar en $[0, n)$.
]
#demo[
  Si $T(n)$ es la función que nos dice el tiempo que va a tomar ejecutar `f(n)`, en el tiempo promedio, entonces tenemos que $T(0) = 0$. Para ver qué es $T(n)$ en general, vemos que

  $
    T(n) & = EE_(i ~ U[0, n))[T(i) + T(n - 1 - i) + 1] \
         & = sum_(i = 0)^(n - 1) (T(i) + T(n - 1 - i) + 1)/n \
         & = sum_(i = 0)^(n - 1) (2T(i) + 1)/n ", reordenando los términos"
  $

  Luego $n T(n) = n + sum_(i = 0)^(n - 1) 2T(i)$, para todo $n in NN$. Queremos una fórmula más simple para $T(n)$. Jugando un poco con las ecuaciones, podemos usar que $(n - 1) T(n-1) = n - 1 + sum_(i = 0)^(n - 2) 2T(i)$, y restar estos dos para hacer desaparecer la sumatoria. Obtenemos $n T(n) - (n - 1) T(n-1) = 2T(n - 1) + 1$. Esto nos da una relación simple entre $T(n)$ y $T(n - 1)$, que nos da la idea de seguir usando esta relación una y otra vez a ver si podemos hacer desaparecer las $T$ de un lado, quedándonos sólo con $T(n)$ en el otro.

  Reescribiendo, $n T(n) = (n + 1) T(n - 1) + 1$, o también, $T(n)/(n+1) = T(n - 1)/n + 1/(n (n + 1))$. Esto finalmente es simétrico (los dos términos con $T$ son similares, siendo de la forma $T(x)/(x+1)$), y podemos repetir esto hasta llegar a $n = 0$:

  $
    T(n)/(n + 1) & = T(n - 1)/n + 1/(n (n + 1)) \
                 & = T(n - 2)/(n - 1) + 1/((n - 1) n) + 1 / (n (n + 1)) \
                 & = T(n - 3)/(n - 2) + 1/((n-2)(n-1)) + 1/((n - 1) n) + 1 / (n (n + 1) ) \
                 & = dots \
                 & = T(0)/1 + sum_(i=1)^n 1/(i (i + 1)) \
                 & = T(0) + sum_(i=1)^n 1/(i (i + 1))
  $

  que, como $T(0) = 0$, nos dice que $T(n)/(n+1) = sum_(i=1)^n 1/(i (i + 1))$.

  Ahora queremos ver quién es $T(n) = (n+1) sum_(i=1)^n 1/(i (i + 1))$. Una estrategia que podemos usar es simplemente ver qué valores tiene $T$ para los primeros números, a mano.

  + $T(1) = 2 (1/2) = 1$
  + $T(2) = 3 (1/2 + 1/6) = 3 (3/6 + 1/6) = 3 (4/6) = 2$
  + $T(3) = 4 (1/2 + 1/6 + 1/12) = 4(6/12 + 2/12 + 1/12) = 4(9/12) = 3$

  + Para el siguiente, intentemos hacernos la vida un poco más fácil:
    $
      T(4) & = 5 (1/2 + 1/6 + 1/12 + 1/20) \
           & = (4 + 1) ((1/2 + 1/6 + 1/12) + 1/20) \
           & = 4 (1/2 + 1/6 + 1/6) + 4/20 + (1/2 + 1/6 + 1/12) + 1/20 \
           & = T(3) + (4/20 + (1/2 + 1/6 + 1/12) + 1/20) \
           & = T(3) + (4/20 + T(3)/4 + 1/20) \
           & = T(3) + (T(3)/4 + 1/4) \
           & = 4
    $

  El hacer esto a mano nos dio una pista sobre qué va a pasar en el caso general. No sólo vemos que $T(n) = n$, sino que para demostrarlo vamos a poder usar inducción, porque apareció $T(3)$ al calcular $T(4)$.


  Definimos, entonces, $P(n): T(n) = n$.

  + $P(0): T(0) = 0$. Esto es cierto porque $T(0) = 1 times 0 = 0$, donde $0$ es el valor de una suma de cero términos.
  + $P(n) implies P(n+1)$. Hagamos lo mismo que hicimos para $T(4)$, pero en general:
    $
      T(n+1) & = (n+2) sum_(i=1)^(n+1) 1/(i (i+1)) \
             & = ((n+1) + 1) (1/((n+1)(n+2)) + sum_(i=1)^n 1/(i (i+1))) \
             & = ((n+1) sum_(i=1)^n 1/(i (i+1))) + (n+1)/((n+1)(n+2)) + 1/((n+1)(n+2)) + sum_(i=1)^n 1/(i (i+1)) \
             & = T(n) + 1/(n+1) + T(n)/(n+1) \
             & = n + 1/(n+1) + n/(n+1) = n + 1 \
    $
  Luego vale $P(n)$ para todo $n in NN$, y luego $T(n) = n$ para todo $n in NN$.]
*/

#ejemplo[
  Consideremos el siguiente algoritmo que determina si una lista está ordenada:

  ```py
  def is_sorted(lista: list[int], n: int) -> bool:
    for i in range(n - 1):
      if lista[i] > lista[i + 1]:
        return False
    return True
  ```

  Sea $C(x)$ el número de comparaciones que realiza `is_sorted` sobre la entrada $x$, y $n$ la longitud de la lista. Analizar el peor caso, mejor caso, y caso promedio del número de comparaciones, asumiendo para el caso promedio que la entrada es una permutación uniformemente al azar de ${1, dots, n}$.
]
#sol[
  - Mejor caso. Si $"lista"[0] > "lista"[1]$, el algoritmo retorna en la primera iteración, habiendo hecho una sola comparación. Luego $T_"min" (n) = 1$, y luego $T_"min" in Theta(1)$.

  - Peor caso. Si la lista está ordenada, el algoritmo recorre todo el ciclo sin retornar temprano, realizando $n - 1$ comparaciones. Luego $T_"max" (n) = n - 1$, y luego $T_"max" in Theta(n)$.

  - Caso promedio. Para cada $i in {0, dots, n - 2}$, definimos la variable indicadora $X_i$, que vale $1$ si el algoritmo realiza la comparación en la iteración $i$, y $0$ si ya retornó antes. El número total de comparaciones es $C = sum_(i=0)^(n-2) X_i$.

    El algoritmo llega a la iteración $i$ si y sólo si no encontró ningún descenso en las iteraciones anteriores, es decir, si $"lista"[0] < "lista"[1] < dots < "lista"[i]$. Como la entrada es una permutación uniformemente al azar, los primeros $i + 1$ elementos están en alguno de los $(i+1)!$ órdenes posibles, todos equiprobables. Exactamente uno de esos órdenes es el creciente, luego $EE[X_i] = 1/(i+1)!$.

    Por linealidad de la esperanza:

    $
      T_"avg" (n) = EE[C] = sum_(i=0)^(n-2) EE[X_i] = sum_(i=0)^(n-2) 1/((i+1)!) = sum_(k=1)^(n-1) 1/(k!)
    $

    Como $sum_(k=0)^infinity 1/(k!) = e$, tenemos que $sum_(k=1)^(n-1) 1/(k!) lt.eq e - 1 < 2$. A su vez, $T_"avg" (n) gt.eq 1$ para todo $n gt.eq 2$, porque siempre hacemos al menos una comparación. Luego $T_"avg" in Theta(1)$.

    El caso promedio está en $Theta(1)$, dramáticamente distinto del peor caso, que está en $Theta(n)$. Intuitivamente, una permutación al azar tiene un descenso muy temprano con alta probabilidad: sólo una fracción $1/(k!)$ de las permutaciones tiene sus primeros $k$ elementos en orden creciente, y esa fracción decrece extremadamente rápido.
]

#ejemplo[
  Se tienen tres algoritmos que resuelven el mismo problema. Todos realizan algún número positivo de operaciones cuando su entrada tiene tamaño cero.
  + El primero divide un problema de tamaño $n$ en $5$ subproblemas de tamaño $n/2$ cada uno, y combina sus soluciones en $O(n)$ operaciones.
  + El segundo divide un problema de tamaño $n$ en $2$ subproblemas de tamaño $n - 1$ cada uno, y combina sus soluciones en $O(1)$ operaciones.
  + El tercero divide un problema de tamaño $n$ en $9$ subproblemas de tamaño $n/3$ cada uno, y combina sus soluciones en $Theta(n^2)$ operaciones.

  ¿Si nuestro $n$ es enorme, y queremos minimizar el número de operaciones que requiere encontrar una solución, podemos determinar cuál algoritmo nos conviene usar sólo sabiendo esto?
]

Para esta demostración les voy a escribir el razonamiento que hago mientras escribo la demostración.

#quote-box[
  El primer caso es fácil, $log_2(5) > 1$, y el costo de combinar soluciones es pequeño porque $1 < log_2(5))$, entonces el costo está dominado por las hojas del árbol de recursión, y uso el teorema maestro para saber que esto es $Theta(n^(log_2(5)))$.

  Para el segundo esto me recuerda a la función $2^n = 2 times 2^(n - 1)$, o también a la sucesión de Fibonacci, $F_n = F_(n - 1) + F_(n - 2)$. Esas tienen solución exponencial, entonces supongamos que $T(n) lt.eq gamma c^n$ para algún $gamma, c in RR_(> 0)$. $T(0)$ es alguna constante, pongámosle $T(0) = alpha$. Entonces si quiero que $T(0) lt.eq gamma c^0 = gamma$, voy a tener $alpha lt.eq gamma$, y luego mi $gamma$ tiene que cumplir $gamma gt.eq alpha$. Como hay un $O(1)$ en la definición de $T$, sea $h: NN arrow NN$ tal que $T(n) = 2T(n-1)+h(n)$, existen $n_0 in NN, beta in RR_(>0)$ tal que para todo $n gt.eq n_0, h(n) lt.eq beta$. Veamos qué puedo deducir sobre $gamma$ usando $beta$...
  $
    T(n) = & 2T(n - 1) + h(n) \
     lt.eq & 2T(n - 1) + beta \
     lt.eq & 2 gamma c^(n - 1) + beta
  $

  Entonces, si quiero probar que $T(n) lt.eq gamma c^n$, tengo que probar que $2 gamma c^(n - 1) + beta lt.eq gamma c^n$, y por transitividad de $lt.eq$ está. Voy a encontrar $gamma$ y $c$ que hagan cierto esto. Moralmente espero que $c approx 2$ porque esa es la solución cuando $alpha = 1, beta = 0$ (y $T(n) = 2^n$ para todo $n$ ahí).

  $
    2 gamma c^(n - 1) + beta lt.eq gamma c^n
  $

  A ver qué pasa si pongo $gamma = beta$...

  $
    2 beta c^(n - 1) + beta & lt.eq &          beta c^n \
              2 c^(n-1) + 1 & lt.eq &               c^n \
                          1 & lt.eq & c^(n - 1) (c - 2)
  $

  pero eso no va a ser cierto si $c = 2$. Todavía no sé que $c = 2$, pero puede ser.

  Expandamos un poco, asumiendo $n$ grande (bastante más grande que $n_0$ para poder usar $beta$)...

  $T(n) &lt.eq 2T(n - 1) + beta\
  &lt.eq 2(2T(n - 2) + beta) + beta\
  &= 4T(n - 2) + 2beta + beta\
  &lt.eq 4(2T(n - 3) + beta) + 2beta + beta\
  &= 8T(n - 3) + 4beta + 2beta + beta\
  &dots,\
  &"lo siguiente es falso porque la cota de "h(n)lt.eq beta" sólo vale para "n>n_0,\
  &"pero estoy siendo informal"dots\
  &lt.eq 2^n T(0) + sum_(i = 0)^(n - 1) 2^i beta\
  &= 2^n alpha + beta (2^n - 1)\
  &= 2^n (alpha + beta) - beta$

  OK, eso me facilita las cosas, puedo usar $gamma = alpha + beta$, y la forma que va a tener la cota es $gamma 2^n - beta$, no sólo $gamma 2^n$. Después lo formalizo.

  Eso igual sólo me da una cota superior. Tendría que también argumentar una cota inferior para saber bien quién es ese $T$ y poder compararlo.

  Para el tercero, tengo $T(n) = 9T(n/3) + Theta(n^2)$. Como $log_3(9) = 2$, no tenemos que $2 < 2$, entonces tenemos que usar el segundo caso del teorema maestro, que con $a = 9, b = 3, k = 0$, nos dice que $T in Theta(n^2 log n)$.
]
#sol[
  Calculemos el comportamiento asintótico de cada uno. Vamos a llamar $T_1, T_2, T_3: NN arrow NN$ a las funciones que, dado un $n in NN$, nos dicen cuántas operaciones toma cada algoritmo para resolver un problema de tamaño $n$. Como cada algoritmo está descrito usando $O(dots)$, no vamos a poder encontrar quiénes son exactamente, sino que vamos a conocer su comportamiento asintótico. Como nos dicen que $n$ es enorme, esto es realmente lo único que importa, porque los factores constantes no van a importar si $n$ es enorme.

  + El primer algoritmo cumple que $T_1(n) = 5T_1(n/2) + O(n)$. Usando el teorema maestro con $a = 5, b = 2, f in O(n)$, tenemos que $c = log_2(5) > log_2(4) = 2 > 1$, donde $1$ es el exponente polinomial de $f$, por estar en $O(n^1)$. Como $c > 1$, entonces caemos en el primer caso del teorema maestro, el cual nos dice que $T_1 in Theta(n^(log_2(5)))$.

  + Como $T_2(n)$ está definido en términos de $T_2(n - 1)$, vamos a usar inducción para ver quién es $T_2$. La recurrencia que cumple $T_2$ es $T_2(n) = 2T_2(n - 1) + O(1)$. Sea $alpha = T_2(0)$. Como $T_2(n) = 2T_2(n - 1) + O(1)$, ese $O(1)$ nos dice que existe una función $h: NN arrow NN$, $h in O(1)$, tal que $T_2(n) = 2T_2(n - 1) + h(n)$ para todo $n gt.eq 0$. Como $h in O(1)$, sean $n_0 in NN, beta > 0 in RR$, tales que para todo $n gt.eq n_0, h(n) lt.eq beta$. Sea $delta = display(max(beta, max_(0 lt.eq i lt.eq n_0) h(i)))$, y por lo tanto $h(k) lt.eq delta$ para todo $k in NN$. Sea $gamma = alpha + delta$.

    Vamos a probar $P(n): alpha 2^n lt.eq T_2(n) lt.eq gamma 2^n - delta$.

    + Caso base, $P(0)$. Por definición de $alpha$, $T_2(0) = alpha = alpha + delta - delta = gamma - delta = gamma 2^0 - delta$, que junto con $alpha 2^0 = alpha$, prueba $P(0)$.
    + Paso inductivo. Asumimos $P(n)$, queremos probar $P(n + 1)$. Sabemos que $T_2(n + 1) = 2T_2(n) + h(n)$.

    $
      T_2(n + 1) & = 2T_2(n) + h(n) \
               & lt.eq 2T_2(n) + delta \
               & lt.eq 2(gamma 2^n - delta) + delta \
               & =gamma 2^(n + 1) - 2delta + delta \
               & =gamma 2^(n + 1) - delta
    $

    Asimismo,

    $
      T_2(n+1) & = 2T_2(n) + h(n) \
             & gt.eq 2T_2(n) \
             & gt.eq 2(alpha 2^n) \
             & gt.eq alpha 2^(n + 1)
    $

    y concluímos que $alpha 2^(n + 1) lt.eq T_2(n+1) lt.eq gamma 2^(n + 1) - delta$, que es lo que queríamos demostrar, $P(n+1)$.

    Luego, como $alpha > 0$ porque nos lo dice el enunciado, y sabemos que $T_2(n) lt.eq gamma 2^n$ (descartando el término $- delta$ por transitividad), tenemos que $T_2 in O(2^n)$ y $T_2 in Omega(2^n)$, con lo cual $T_2 in Theta(2^n)$.
  + Para el tercer caso, usamos el segundo caso del teorema maestro, con $a = 9, b = 3, k = 0$, y concluimos que $T_3 in Theta(n^2 log n)$.

  Sabemos entonces que el número de operaciones que estos tres algoritmos hacen, ante una entrada de tamaño $n$, está respectivamente en $Theta(n^(log_2(5)))$, $Theta(2^n)$, y $Theta(n^2 log n)$.

  Veamos cuál nos conviene usar. Recordando que $lim_(n arrow infinity) f(n)/g(n) = infinity implies g in O(f)$, y usando las reglas usuales de orden de conjuntos asintóticos:

  - Como $T_2 in Omega(2^n)$, entonces llamando $f(n) = 2^n$, tenemos que $f in O(T_2)$. Luego, como $T_1 in O(n^(log_2(5)))$, y $O(n^(log_2(5))) subset O(f)$, tenemos que $T_1 in O(f)$. Como $T_1 in O(f)$ y $f in O(T_2)$, tenemos que $T_1 in O(T_2)$.
  - Usando la regla de L'Hopital, tenemos que
    $
    lim_(n arrow infinity) n^(log_2(5))/(n^2 log n) &= lim_(n arrow infinity) n^(log_2(5) - 2) / (log n) \
    &= lim_(n arrow infinity) n^epsilon / (log n) \
    &= lim_(n arrow infinity) n epsilon n^(epsilon - 1) \
    &= lim_(n arrow infinity) epsilon n^epsilon \
    &= infinity
    $
    Pues $log_2(5) - 2 = epsilon approx 0.32 > 0$. Luego tenemos que $T_3 in O(T_1)$.
  - Como $T_3 in O(T_1)$ y $T_1 in O(T_2)$, tenemos que $T_3 in O(T_2)$.

  Luego, como $T_3$ está asintóticamente dominada por las otras dos, y $n$ es enorme, nos conviene usar el tercer algoritmo.
]

#ejemplo[
  Un entero de precisión arbitraria se puede representar como una lista de $n$ palabras de $w$ bits cada una, donde $w$ es el tamaño de palabra de la máquina. Por ejemplo, el entero $2^{65} + 3$ se puede representar, en una máquina con $w = 64$, como la lista `[3, 2]`, donde `words[0] = 3` contiene los $64$ bits menos significativos y `words[1] = 2` contiene los siguientes $64$ bits.

  El _popcount_ (population count) de un entero es la cantidad de bits en $1$ en su representación binaria. Consideremos el siguiente algoritmo en el modelo word RAM con palabras de $w$ bits, donde las operaciones bit a bit (`&`, `>>`) sobre una palabra toman $O(1)$ cada una:

  ```py
  def popcount(words: list[int]) -> int:
      count = 0
      for word in words:
          while word > 0:
              count += word & 1
              word >>= 1
      return count
  ```

  Definimos el tamaño de la entrada como $n$, el número de palabras. Sea $C("words")$ el número de operaciones que realiza `popcount(words)`. Analizar el peor caso y el mejor caso de $C$.
]
#sol[
  Siguiendo los pasos del proceso de análisis:

  + *Modelo de cómputo*: word RAM con palabras de $w$ bits. Las operaciones aritméticas y bit a bit sobre palabras de $w$ bits toman $O(1)$.
  + *Tamaño de entrada*: $n$, el número de palabras.
  + *Función de costo*: $C("words")$, el número de operaciones que realiza `popcount(words)`.
  + *Agregación por tamaño*: peor caso, $T_"max" (n)$, y mejor caso, $T_"min" (n)$.
  + *Análisis asintótico*:

    - Mejor caso. Si todas las palabras son $0$, el ciclo interno no se ejecuta nunca, y el ciclo externo hace una comparación por palabra. Luego $T_"min" in Theta(n)$.

    - Peor caso. En cada iteración del ciclo interno, se realizan una comparación (`word > 0`), una operación bit a bit (`word & 1`), una suma, y un shift (`word >>= 1`). En el modelo word RAM, cada una toma $O(1)$, por lo que cada iteración del ciclo interno toma $O(1)$. Como cada palabra tiene a lo sumo $w$ bits, el ciclo interno ejecuta a lo sumo $w$ iteraciones por palabra. En el peor caso (todas las palabras tienen todos sus bits en $1$), el ciclo interno ejecuta exactamente $w$ iteraciones por cada una de las $n$ palabras. Luego, $T_"max" in Theta(n w)$.
]

#ejemplo[
  Consideremos la siguiente implementación recursiva de la sucesión de Fibonacci:

  ```py
  def fib(n: int) -> int:
      if n <= 1:
          return n
      return fib(n - 1) + fib(n - 2)
  ```

  Definimos el tamaño de la entrada como $n$. Sea $T(n)$ el número de operaciones que realiza `fib(n)`, y sea $S(n)$ la máxima profundidad de la pila de llamadas durante la ejecución de `fib(n)` (es decir, la máxima cantidad de llamadas a `fib` simultáneamente activas). Analizar el comportamiento asintótico de $T$ y de $S$.
]
#sol[
  + *Modelo de cómputo*: RAM.
  + *Tamaño de entrada*: $n$.
  + *Funciones de costo*: $T(n)$, el número de operaciones, y $S(n)$, la máxima profundidad de pila.
  + *Análisis asintótico*:

    - *Número de operaciones.* Cada llamada a `fib` realiza, sin contar sus llamadas recursivas, un número de operaciones acotado: al menos $1$ (la comparación `n <= 1`) y a lo sumo alguna constante $c > 0$ (la comparación, la resta, y la suma). Tenemos la recurrencia $T(n) = T(n - 1) + T(n - 2) + h(n)$ para $n gt.eq 2$, con $T(0)$ y $T(1)$ constantes positivas, donde $1 lt.eq h(n) lt.eq c$ para todo $n$.

      Sea $phi = (1 + sqrt(5))/2$. Recordemos que $phi$ satisface $phi^2 = phi + 1$.

      *Cota inferior.* Probemos por inducción que $T(n) gt.eq phi^(n - 1)$ para todo $n gt.eq 0$.
      + $T(0) gt.eq 1 > 1/phi = phi^(-1)$. #sym.checkmark
      + $T(1) gt.eq 1 = phi^0$. #sym.checkmark
      + Para $n gt.eq 2$, $T(n) = T(n - 1) + T(n - 2) + h(n) gt.eq T(n - 1) + T(n - 2) gt.eq phi^(n - 2) + phi^(n - 3) = phi^(n - 3)(phi + 1) = phi^(n - 3) phi^2 = phi^(n - 1)$. #sym.checkmark

      Luego $T in Omega(phi^n)$.

      *Cota superior.* Sea $beta = max(T(0) + c, (T(1) + c) / phi)$. Probemos por inducción que $T(n) lt.eq beta phi^n - c$ para todo $n gt.eq 0$.
      + $T(0) lt.eq beta - c$, ya que $beta gt.eq T(0) + c$. #sym.checkmark
      + $T(1) lt.eq beta phi - c$, ya que $beta gt.eq (T(1) + c) / phi$. #sym.checkmark
      + Para $n gt.eq 2$:
        $
          T(n) &= T(n - 1) + T(n - 2) + h(n) \
               &lt.eq (beta phi^(n - 1) - c) + (beta phi^(n - 2) - c) + c \
               &= beta(phi^(n - 1) + phi^(n - 2)) - c \
               &= beta phi^(n - 2)(phi + 1) - c \
               &= beta phi^n - c
        $

      Luego $T(n) lt.eq beta phi^n$ y $T in O(phi^n)$. Combinando, $T in Theta(phi^n)$.

    - *Profundidad de pila.* En la expresión `fib(n - 1) + fib(n - 2)`, la llamada `fib(n - 1)` se ejecuta completamente (y su frame se elimina de la pila) antes de que comience `fib(n - 2)`. Luego, la pila en cualquier momento contiene los frames a lo largo de un único camino desde la raíz hasta el nodo actual en el árbol de recursión.

      Formalmente, $S(0) = S(1) = 1$ y $S(n) = 1 + max(S(n - 1), S(n - 2))$ para $n gt.eq 2$. Notemos que $S$ es creciente: como $max(S(n-1), S(n-2)) gt.eq S(n - 1)$, tenemos $S(n) gt.eq 1 + S(n - 1) > S(n - 1)$ para todo $n gt.eq 2$, y $S(1) gt.eq S(0)$. Luego, $max(S(n-1), S(n-2)) = S(n - 1)$ y $S(n) = 1 + S(n - 1)$ para todo $n gt.eq 2$, de donde $S(n) = n$ para $n gt.eq 1$. Luego, $S in Theta(n)$.

      Notar el contraste: el número de operaciones es exponencial ($Theta(phi^n)$), pero la profundidad de pila es lineal ($Theta(n)$).
]

#ejemplo[
  Consideremos la criba de Eratóstenes, que calcula todos los primos hasta $n$:

  ```py
  def sieve(n: int) -> list[bool]:
      is_prime = [True] * (n + 1)
      is_prime[0] = False
      is_prime[1] = False
      for i in range(2, n + 1):
          if is_prime[i]:
              for j in range(i * i, n + 1, i):
                  is_prime[j] = False
      return is_prime
  ```

  Definimos el tamaño de la entrada como $n$. Sea $T(n)$ el número de operaciones que realiza `sieve(n)`. Analizar el comportamiento asintótico de $T$.

  _Ayuda: se sabe por @mertens que si definimos $g(x) = display(sum_(p lt.eq x,\ p "primo") 1/p)$, entonces $g in Theta(log log x)$._
]
#sol[
  + *Modelo de cómputo*: RAM.
  + *Tamaño de entrada*: $n$.
  + *Función de costo*: $T(n)$, el número de operaciones que realiza `sieve(n)`.
  + *Análisis asintótico*:

    La inicialización del arreglo toma $O(n)$. El ciclo externo itera $n - 1$ veces, haciendo $O(1)$ trabajo por iteración (verificar `is_prime[i]`). El ciclo interno solo se ejecuta cuando $i$ es primo, y como comienza en $i^2$, solo tiene iteraciones cuando $i lt.eq sqrt(n)$. Para cada primo $p lt.eq sqrt(n)$, el ciclo interno recorre los múltiplos de $p$ desde $p^2$ hasta $n$ en pasos de $p$, haciendo $floor((n - p^2) / p) + 1 lt.eq n/p$ iteraciones.

    El número total de operaciones del ciclo interno es:

    $
      sum_(p lt.eq sqrt(n),\ p "primo") n / p = n sum_(p lt.eq sqrt(n),\ p "primo") 1 / p in Theta(n log log n)
    $

    pues $display(sum_(p lt.eq sqrt(n)) 1/p) in Theta(log log sqrt(n)) = Theta(log log n)$, ya que $log log sqrt(n) = log (1/2 log n) = log log n - log 2 in Theta(log log n)$.

    Sumando el $O(n)$ de la inicialización y el ciclo externo, que está dominado por $Theta(n log log n)$ para $n$ suficientemente grande, concluimos que $T in Theta(n log log n)$.
]

#ejemplo[
  Se tiene el siguiente algoritmo recursivo:

  ```py
  def f(cuts: list[int], i: int, j: int) -> int:
    if j == i + 1:
      return 0
    r = inf
    for k in range(i + 1, j):
      r = min(r, f(cuts, i, k) + f(cuts, k, j))
    return r + cuts[j] - cuts[i]
  ```

  Dar una cota asintótica superior ajustada para el número de operaciones que realice este algoritmo, en función del tamaño de entrada `j - i`.
]
#sol[
  Definimos el tamaño de una entrada $("cuts", i, j)$ como $j - i$. La función que describe el tiempo que toma $f$ en correr, en términos del tamaño de entrada, es $T(n) = O(1) + sum_(k = 1)^(n-1) T(k) + T(n - k)$.

  Obviamente no podemos usar el teorema maestro para esto, porque $T$ no tiene la forma correcta, así que vamos a tener que analizar cuidadosamente qué está pasando. Jugando un poco, vemos que:

  $
    T(n) & = O(1) + T(1) + T(n - 1) + T(2) + T(n - 2) + dots + T(n - 1) + T(1) \
         & = O(1) + 2 sum_(i=1)^(n-1) T(i)
  $

  Esto nos puede recordar a la fórmula para las potencias de un número. Por ejemplo, $2^n = 1 + sum_(i=0)^(n-1) 2^i$, o $3^n = 1 + 2 sum_(i=0)^(n-1) 3^i$. Como esto se parece bastante a la serie de potencias de tres, vamos a intentar adivinar que $T(n) lt.eq alpha 3^n$ para todo $n in NN$, y algún $alpha > 0 in RR$. Esto nos diría que $T in O(3^n)$.

  Probemos esto por inducción. Por definición de "$O(1)$", sabemos que existe una función $h:NN arrow NN$, tal que $T(n) = h(n) + 2 sum_(i=1)^(n-1) T(i)$, y existen $n_0 in NN, beta > 0$ tales que para todo $n gt.eq n_0$, $h(n) lt.eq beta$. Sea $r = max(beta, max_(i = 0)^n_0 h(i))$. Entonces tenemos que para todo $n$, $h(n) lt.eq r$. La cota vale para los primeros $n_0$ valores de $n$ por la segunda rama del $max$, y vale para todos los valores después de $n_0$ por la primer rama, que a su vez vale por la definición de $h in O(1)$.

  Luego, para todo $n$, $T(n) lt.eq r + 2 sum_(i=1)^(n-1) T(i)$. Si esto tiene que ser menor o igual a $alpha 3^n$, veamos quién tiene que ser $alpha$.

  $
    T(n) & lt.eq r + 2 sum_(i=1)^(n-1) T(i) \
         & lt.eq r + 2 sum_(i=1)^(n-1) alpha 3^i \
         & lt.eq r + 2 alpha (1/2) (3^n - 3) \
         & lt.eq r + alpha 3^n - 3 alpha
  $

  Vamos a querer concluir que $T(n) lt.eq alpha 3^n$. Luego, queremos que $r - 3 alpha = 0$, y luego $alpha = r / 3$. Verifiquemos que con ese $alpha$ se cumple lo que queremos:

  $
    T(n) lt.eq r + alpha 3^n - 3 (r / 3) = alpha 3^n
  $

  Esto parece funcionar. Probémoslo por inducción, entonces. Sea $P(n): n gt.eq 1 implies T(n) lt.eq alpha 3^n$

  - $P(1) = h(1) lt.eq r = 3 alpha = 3^1 alpha$.
  - Asumimos que $P(j)$ vale para todo $j < n$, queremos probar $P(n)$. $T(n) lt.eq r + 2 sum_(i=1)^(n-1) T(i) lt.eq alpha 3^n$ por el argumento de arriba, donde usamos la hipótesis inductiva para acotar cada $T(i)$ por $alpha 3^i$.

  Luego vemos que tomando $n_0 = 1$, $alpha = max(beta, (max_(i=0)^n_0 h(i))/3)$, tenemos que para todo $n gt.eq n_0$, $T(n) lt.eq alpha 3^n$, y por lo tanto $T in O(3^n)$.]

=== Ejercicios

#ej[
  El siguiente es el algoritmo de Strassen para multiplicar dos matrices de $n times n$.

  #algorithm({
    import algorithmic: *
    Procedure(
      "Strassen",
      ($A in ZZ^(n times n)$, $B in ZZ^(n times n)$),
      {
        // Base case (you can switch to a small threshold if desired)
        If($n lt.eq n_0$, {
          Return[$A times B$]
        })

        // Split into quadrants (assume n is even; otherwise pad)
        Assign($m$, $n / 2$)
        Assign(($mat(A_(1,1), A_(1, 2); A_(2, 1), A_(2, 2))$), FnInline[Split][$A, m$])
        Assign(($mat(B_(1, 1), B_(1, 2); B_(2, 1), B_(2, 2))$), FnInline[Split][$B, m$])

        // Seven Strassen products
        Assign($M_1$, FnInline[Strassen][$A_(1, 1) + A_(2, 2), B_(1, 1) + B_(2, 2)$])
        Assign($M_2$, FnInline[Strassen][$A_(2, 1) + A_(2, 2), B_(1, 1)$])
        Assign($M_3$, FnInline[Strassen][$A_(1, 1), B_(1, 2) - B_(2, 2)$])
        Assign($M_4$, FnInline[Strassen][$A_(2, 2), B_(2, 1) - B_(1, 1)$])
        Assign($M_5$, FnInline[Strassen][$A_(1, 1) + A_(1, 2), B_(2, 2)$])
        Assign($M_6$, FnInline[Strassen][$A_(2, 1) - A_(1, 1), B_(1, 1) + B_(1, 2)$])
        Assign($M_7$, FnInline[Strassen][$A_(1, 2) - A_(2, 2), B_(2, 1) + B_(2, 2)$])

        // Combine to get the result blocks
        Assign($C_(1, 1)$, $M_1 + M_4 - M_5 + M_7$)
        Assign($C_(1, 2)$, $M_3 + M_5$)
        Assign($C_(2, 1)$, $M_2 + M_4$)
        Assign($C_(2, 2)$, $M_1 - M_2 + M_3 + M_6$)

        // Reassemble the full matrix
        Return[$mat(C_(1, 1), C_(1, 2); C_(2, 1), C_(2, 2))$]
      },
    )
  })

  Sabiendo que el caso base usa un algoritmo cúbico para multiplicar matrices, y despreciando las operaciones necesarias para las sumas y restas que hace el algoritmo, cuántas operaciones realiza este algoritmo, al ser llamado con dos matrices de tamaño $n times n$, con $n = 2^k$? Probar formalmente que este algoritmo necesita, en el peor caso, $O(n^(log_2 7))$ operaciones, con $log_2 7 < 3$.
]

#ej[
  Consideremos el siguiente algoritmo que determina si una lista tiene elementos duplicados:

  ```py
  def tiene_duplicados(lista: list[int], n: int) -> bool:
    for i in range(n):
      for j in range(i + 1, n):
        if lista[i] == lista[j]:
          return True
    return False
  ```

  Sea $C(x)$ el número de comparaciones entre elementos que realiza `tiene_duplicados` sobre la entrada $x$, y $n$ la longitud de la lista. Analizar el peor caso y el mejor caso de $C$.
]

#ej[
  Consideremos el siguiente algoritmo de exponenciación rápida:

  ```py
  def potencia(base: int, exp: int) -> int:
    resultado = 1
    while exp > 0:
      if exp % 2 == 1:
        resultado *= base
      base *= base
      exp //= 2
    return resultado
  ```

  Sea $T(n)$ el número de multiplicaciones que realiza `potencia(base, n)`. Demostrar que $T in Theta(log n)$.
]

#ej[
  Consideremos el siguiente algoritmo que calcula el $k$-ésimo número de Fibonacci:

  ```py
  def fib(n: int) -> int:
    if n <= 1:
      return n
    prev, curr = 0, 1
    for i in range(2, n + 1):
      prev, curr = curr, prev + curr
    return curr
  ```

  Sea $T(n)$ el número de operaciones que realiza `fib(n)`, y sea $S(n)$ el espacio auxiliar que utiliza (sin contar la entrada). Demostrar que $T in Theta(n)$ y que $S in Theta(1)$.
]

#ej[
  Consideremos el siguiente algoritmo recursivo:

  ```py
  def f(n: int) -> int:
    if n <= 1:
      return 1
    return f(n - 1) + f(n - 1)
  ```

  Sea $T(n)$ el número de sumas que realiza `f(n)`. Plantear la recurrencia para $T$ y demostrar que $T in Theta(2^n)$.

  Ahora consideremos la siguiente variante:

  ```py
  def g(n: int) -> int:
    if n <= 1:
      return 1
    x = g(n - 1)
    return x + x
  ```

  Sea $T'(n)$ el número de sumas que realiza `g(n)`. Demostrar que $T' in Theta(n)$. ¿Por qué la diferencia?
]

#ej[
  Consideremos la siguiente implementación de insertion sort:

  ```py
  def insertion_sort(lista: list[int], n: int):
    for i in range(1, n):
      key = lista[i]
      j = i - 1
      while j >= 0 and lista[j] > key:
        lista[j + 1] = lista[j]
        j -= 1
      lista[j + 1] = key
  ```

  Sea $C(x)$ el número de comparaciones entre elementos que realiza `insertion_sort` sobre la entrada $x$, y $n$ la longitud de la lista.

  + Demostrar que $C_"max" in Theta(n^2)$.
  + Demostrar que $C_"min" in Theta(n)$.
  + Asumiendo que la entrada es una permutación uniformemente al azar de ${1, dots, n}$, demostrar que $C_"avg" in Theta(n^2)$. _Sugerencia: para cada par $i < j$, considerar la probabilidad de que el elemento originalmente en la posición $j$ sea comparado con el originalmente en la posición $i$._
]

#ej[
  Se tiene una pila (stack) implementada con un arreglo, que soporta dos operaciones:
  - `push(x)`: agrega un elemento al tope de la pila.
  - `multi_pop(k)`: elimina $min(k, |S|)$ elementos del tope de la pila, donde $|S|$ es el tamaño actual de la pila.

  ```py
  def multi_pop(stack: list[int], k: int):
    pops = min(k, len(stack))
    for i in range(pops):
      stack.pop()
  ```

  Una llamada a `push` toma $O(1)$, y una llamada a `multi_pop(k)` toma $O(min(k, |S|))$.

  Demostrar que, partiendo de una pila vacía, cualquier secuencia de $n$ operaciones `push` y `multi_pop` toma tiempo total $O(n)$, y luego el costo amortizado por operación es $O(1)$.
]

/*
FIXME: En algún momento voy a traer de vuelta este ejercicio, pero por ahora falta explicar demasiado, y se van a asustar con la palabra autómata.

#ej[
  Sea $A$ el siguiente autómata finito:

  #align(center)[
    #automaton(
      (
        q0: (q0: "b", q1: "a, c"),
        q1: (q0: "b", q2: "a, c"),
        q2: (q2: "a, b, c"),
      ),
      initial: "q0",
      final: ("q1",),
    )]

  Dado un $n in NN$, cuántas cadenas de texto de longitud $n$ acepta $A$?]
El propósito de este ejercicio es que pasen un tiempo jugando con las ecuaciones, viendo qué pueden deducir. No imagino que hayan visto un ejercicio exactamente así. Sugiero que pasen un tiempo largo (>1 hora) pensando y jugando antes de ver cómo lo hace esta demostración. Si no saben qué es un autómata finito, tomen $T$ como definida en un enunciado.
#demo[

  Definiendo $T(x, i)$ como el número de cadenas de texto que nos llevan al estado $x$ luego de $i$ caracteres, vemos que:

  - $T(q, k) = 0$ para todo $q$, si $k < 0$
  - $T(q_0, 0) = 1$
  - $T(q_0, i) = T(q_1, i - 1) + T(q_0, i - 1)$
  - $T(q_1, i) = 2 T(q_0, i - 1)$
  - $T(q_2, i) = T(q_1, i - 1) + 3 T(q_2, i - 1)$

  Como el único estado que acepta es $q_1$, queremos encontrar $T(q_1, n)$. Para este $A$ en particular, podemos notar que para todo $i gt.eq 2$, $T(q_0, i) = T(q_0, i - 1) + T(q_1, i - 1) = T(q_0, i - 1) + 2 T(q_0, i - 2)$, que se parece bastante a la sucesión de Fibonacci. Encontremos, entonces, una solución general para esta recurrencia. Llamemos por comodidad $G(i) = T(q_0, i)$.

  Supongamos que existe una solución de la forma $G(i) = c^i$ a la recurrencia $G(i) = G(i - 1) + 2 G(i - 2)$. Entonces tendríamos que $c^i = G(i) = G(i - 1) + 2 G(i - 2) = c^(i - 1) + 2 c^(i - 2)$. Dividiendo ambos lados por $c^(i - 2)$, nos queda $c^2 = c + 2$, que tiene como soluciones $c = -1$ y $c = 2$.

  Veamos entonces que ambas $G(i) = 2^i$ y $G(i) = (-1)^i$ son soluciones:
  - $2^i = 2^(i - 1) + 2 2^(i - 2) = 2^(i - 1) + 2^(i - 1) = 2^i$
  - $(-1)^i = (-1)^(i-1) + 2 (-1)^(i - 2) = (-1)^(i - 1) + 2 (-1)^i$, y restando $(-1)^i$ a ambos lados obtenemos la igualdad $0 = (-1)^(i - 1) + (-1)^i$.

  Luego ambas son soluciones. También, si $A(n)$ y $B(n)$ son soluciones a la recurrencia, pasa lo mismo con $A(n) + B(n)$, y si $C(n)$ es una solución a la recurrencia, también $gamma C(n)$ lo es, para cualquier $gamma in RR$:

  - Sea $Z(n) = A(n) + B(n)$. Entonces $Z(n) = A(n - 1) + 2 A(n - 2) + B(n - 1) + 2 B(n - 2) = A(n - 1) + B(n - 1) + 2 (A(n - 2) + B(n - 2)) = Z(n - 1) + 2 Z(n - 2)$
  - Si $Z(n) = gamma C(n)$, $Z(n) = gamma (C(n - 1) + 2 C(n - 2)) = (gamma C(n - 1)) + 2 (gamma C(n - 2)) = Z(n - 1) + 2 Z(n- 2)$.

  Luego tenemos una familia de soluciones $G(n) = alpha 2^n + beta (-1)^n$, a la recurrencia $G(n) = G(n - 1) + 2G(n - 2)$.

  Intentemos encontrar los coeficientes $alpha, beta$, tales que $G(0) = T(q_0, 0) = 1$, y $G(1) = T(q_0, 1) = T(q_1, 0) + T(q_0, 0) = 2T(q_0, -1) + T(q_0, 0) = 2 times 0 + 1 = 1$.

  - $alpha 2^0 + beta (-1)^0 = 1 iff alpha + beta = 1$
  - $alpha 2^1 + beta (-1)^1 = 1 iff 2 alpha - beta = 1$

  Los únicos $alpha, beta$ que cumplen esto son $alpha = 2/3, beta = 1/3$.

  Entonces encontramos una fórmula general para _nuestra_ $G(n)$: $G(n) = (2/3 2^n + 1/3 (-1)^n)$. Verificamos que $G(0)$, así definida, cumple que $G(0) = 1$, y $G(1) = 1$, y ya vimos arriba que esta definición cumple la recurrencia pedida. Notemos que hasta ahora, sólo habíamos supuesto la existencia de soluciones de la forma $G(n) = c^n$ que nos sirvieran, pero la existencia de $alpha$ y $beta$ nos dice que efectivamente encontramos la solución que tiene valor exactamente iguales a nuestra función $T(q_0, n)$.

  Luego, como queremos $T(q_1, n)$, y $T(q_1, n) = 2 G(n - 1)$, vemos que la respuesta al enunciado es $T(q_1, n) = 4/3 2^(n-1) + 2/3 (-1)^(n-1)$.]
*/

#load-bib()