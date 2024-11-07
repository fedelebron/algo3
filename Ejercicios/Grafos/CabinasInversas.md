## Enunciado

Para organizar el tráfico, la ciudad de Ciclos Positivos ha decidido implementar las cabinas de peaje inverso. La idea de estas cabinas es incentivar la circulación de vehículos por caminos alternativos, estableciendo un monto que se le paga al conductor de un vehículo cuando pasa por la cabina. Estas cabinas inversas se suman a las cabinas regulares, donde el conductor paga por pasar por la cabina.

Dado que no tenemos empleo y aún no vendimos nuestro vehículo, queremos explotar un nuevo negocio que consiste en transitar por la ciudad de Ciclos Positivos a fin de obtener una ganancia que nos permita subsistir. Para ello, obtuvimos la información del costo $c_i$ de transitar por cada cabina $i$ de peaje ($c_i < 0$ si la cabina es inversa) y del costo $c_{i, j} > 0$ que cuesta viajar de forma directa de cada cabina $i$ a cada cabina $j$ en caso de que esto sea posible (es decir, no pasando por otras cabinas intermedias).

* Modelar el problema de determinar si es posible obtener una ganancia recorriendo eternamente las cabinas de la ciudad.
* Dar un algoritmo para resolver el problema del inciso anterior, indicando su complejidad temporal.

## Resolución

### Modelado

Cuando vemos la palabra "camino", de las primeras cosas que se nos tendría que ocurrir es el concepto de camino en un grafo. Luego, modelemos este problema como algo sobre caminos en grafos. Se nos pregunta si podemos "obtener una ganancia", "recorriendo eternamente". Lo segundo debería recordarnos a un ciclo en un grafo. Obtener una ganancia está preguntando si cierta cantidad es positiva. Luego, podemos pensar qué algoritmos nos permiten saber si existe un ciclo, tal que algo sobre ese ciclo es positivo?

La respuesta es que sabemos que el algoritmo de Bellman-Ford nos permite saber si hay, en el grafo, un ciclo alcanzable desde una fuente, cuyo peso total sea negativo. Luego, si creamos nuestro grafo de forma que los pesos en las aristas sean "ganancia negativa", y empezamos Bellman-Ford desde un vértice que pueda alcanzar a todos los ciclos, Bellman-Ford nos va a decir si es posible alcanzar un ciclo en el grafo, cuya suma de pesos sea negativa - que es lo mismo que la ganancia total sea positiva.

Definamos, entonces, nuestro grafo dirigido y pesado $G = (V, E, w)$. Va a ser dirigido porque nos importa la dirección de una arista: a priori no sabemos que $c_{i, j} = c_{j, i}$ para todo $i, j$. Va a ser pesado porque dijimos que queríamos poner "ganancias negativas" como pesos en las aristas.

* Los vértices van a ser las cabinas por las que pasamos, $V = \{1, 2, \dots, n\}$. Vamos a agregar un vértice especial, $0$, que es de donde vamos a correr Bellman-Ford.
* El problema nos dice que podemos viajar desde cada cabina a cada otra cabina, con lo cual tenemos una arista desde $i$ a $j$ para todo $i, j$. Tenemos, también, aristas que salen desde nuestro vértice $0$. Las aristas van a ser, entonces, $E = \{(i, j)\mid 1 \le i, j \le n\} \cup \{(0, i) \mid 1 \le i \le n\}$. 
* La función de peso de una arista va a ser $w:E \to \mathbb{R}$, donde para todo $1 \le i, j \le n$, definimos $w((i, j)) = c_i + c_{i, j}$, y $w((0, i)) = 0$. Podríamos haber usado $c_j$ en vez de $c_i$, es lo mismo. La idea es que pagamos un peaje $c_i$ para que nos suban la barrera del $i$-ésimo peaje y salgamos del mismo, y pegamos $c_{i, j}$ para llegar hasta el próximo peaje, sin salir del mismo. Esta suma es normalmente positiva, pero el problema tiene $c_i < 0$ para algunos $i$, y por lo tanto podemos tener aristas de peso negativo, y consecuentemente ciclos de peso negativo.

Veamos que el modelado es correcto. Queremos ver que existe en la ciudad una forma de transitar eternamente y tener ganancia positiva, si y sólo si existe un ciclo de peso negativo en nuestro grafo.

* $\Rightarrow)$. Supongamos que existe en la ciudad una manera de transitar eternamente y tener ganancia positiva. Como el número de peajes es finito (esto no lo aclaran en el enunciado, pero no vemos en la materia cómo modelar con grafos infinitos - en un parcial, uno se para y pide que aclaren esto), al transitarlos eternamente debemos necesariamente estar haciendo un circuito.

  Les dejo como ejercicio probar que si la ganancia total de un _circuito_ es positiva, entonces hay al menos un _ciclo_ cuya ganancia total es positiva. Notar la diferencia entre circuito y ciclo, el primero puede repetir vértices, el segundo no. 

  Como sabemos que hay un _ciclo_ de ganancia positiva, sea entonces $L$ la longitud de un _ciclo_ de ganancia positiva que recorre, y sean $p_1, \dots, p_L$ los índices de los peajes en ese ciclo. Al recorrer este ciclo una vez, pagamos $c_{p_1} + c_{p_2} + \dots c_{p_L}$ para pasar por los peajes, y $c_{p_1, p_2} + c_{p_2, p_3} + \dots + c_{p_{L-1}, p_L} + c_{p_L, p_1}$ para ir de peaje en peaje. Notar cómo tenemos que volver al principio del ciclo, desde el peaje $p_L$, pagando $c_{p_L, p_1}$ al final. En total, entonces, la cantidad que pagamos es $X = \bigl(\sum_{i = 1}^{L-1} c_{p_i} + c_{p_i, p_{i + 1}}\bigr) + c_{p_L} + c_{p_L, p_1}$ al recorrer este ciclo de peajes. Como dijimos que la ganancia es positiva, tenemos que $X < 0$, es decir, pagamos una cantidad de dinero negativa.
  Consideremos, entonces, el ciclo $C = [p_1, p_2, \dots, p_L]$ en el grafo. Por lo que dijimos arriba, esto es un ciclo, es decir, no repite vértices. El costo de este ciclo es la suma de los pesos de las aristas, es decir, el costo es $Y = \bigl(\sum_{i = 1}^{L-1} w((p_i, p_{i + 1}))\bigr) + w((p_L, p_1))$. Reemplazando $w$ por lo que vale, tenemos que $Y = \bigl(\sum_{i=1}^{L-1} c_{p_i} + c_{p_i, p_{i+1}}\bigr) + c_{p_L} + c_{p_L, p_1} = X$. Luego, como $X < 0$, tenemos un ciclo $C$ en nuestro grafo $G$ de peso $X$, con $Y < 0$.

* $\Leftarrow$). El argumento es idéntico a $\Rightarrow$). Sea $C = [p_1, \dots, p_L]$ un ciclo de peso negativo en $G$. El costo de recorrer el ciclo una vez es $Y = \bigl(\sum_{i = 1}^{L-1} w((p_i, p_{i + 1}))\bigr) + w((p_L, p_1)) = \bigl(\sum_{i = 1}^{L-1}c_{p_i} + c_{p_i, p_{i+1}}\bigr) + c_{p_L} + c_{p_L, p_1} < 0$. Luego, al recorrer los peajes en ese orden, $p_1, \dots, p_L$, tenemos que pagar $Y$, con $Y$ negativo, y luego tenemos una ganancia positiva, $-Y$. Notar que un ciclo simple en $G$ nunca puede involucrar el vértice $0$, porque no hay aristas que vayan hacia $0$. Luego, siempre podemos convertir los vértices de un ciclo en $G$ a una lista de peajes, mandando al $i$-ésimo vértice al $i$-ésimo peaje.

Por último, para saber si "existe un ciclo de peso negativo en $G$", corremos Bellman-Ford desde el vértice $0$. Bellman-Ford nos dice si hay un ciclo de peso negativo alcanzable desde el origen que elegimos, y como $0$ tiene una arista hacia todos los vértices, entonces existe un ciclo de peso negativo en $G$ si y sólo si existe un ciclo de peso negativo en $G$ alcanzable desde el vértice $0$.

## Algoritmo

El algoritmo es simplemente Bellman-Ford, en el grafo $G$ de arriba, empezando desde el vértice $0$. Habiendo $n$ peajes, tenemos $n + 1$ vértices en $G$, y $m$ aristas, con $m = n(n-1) + n = n^2$. Luego, la complejidad temporal de Bellman-Ford sobre $G$ representado como listas de adjacencia es $O((n+1)m) = O(n^3)$.