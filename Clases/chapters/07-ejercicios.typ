// Chapter 7: Ejercicios
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= Ejercicios
== Lógica
#ej[
  Sean $x, y in RR$. Probar que $min(x, y) + max(x, y) = x + y$.
]
#ej[
  Sean $x, y in RR$. Probar que $|x + y| lt.eq |x| + |y|$.
]
#ej[
  Sean $x, y in RR_(gt.eq 0)$. Probar que $(x + y)/2 gt.eq sqrt(x y)$, y que la igualdad vale si y sólo si $x = y$.
]
#ej[
  Sean $a, n in NN$. Probar que si $a^n$ es par, entonces $a$ es par.
]
#ej[
  Sean $a, b in RR$, y sea $c = a b$. Probar que $a lt.eq sqrt(c)$, o $b lt.eq sqrt(c)$.
]
== Inducción
#ej[
  Probar que para todo $n in NN$, $sum_(i = 1)^n i = 1 + 2 + 3 + dots + n = n(n + 1)/2$.
]

#ej[
  Probar que todo número natural se puede expresar como un producto de números primos.
]

#ej[
  Probar que $4 | 5^n - 1$ para todo $n in NN, n gt.eq 1$.
]

#ej[
  Probar que para todo $n in NN$, $1^3 + 2^3 + 3^3 + dots + n^3$ es un cuadrado perfecto.
]

#ej[
  Probar que para todo $n in NN$, $sum_(i=1)^n 1/((2i-1)(2i+1)) = n/(2n + 1)$.
]

== Análisis asintótico
#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 4T(n/3) + O(n log n)$, y $T(0) = 0$. Probar que $T in Theta(n^1.5)$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 2T (n/2) + n log n$, y $T(0) = 7$. Probar que $T in Theta(n log^2 n)$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 4$, $T (n) = 16T (n/4) + n!$, y $T(k) = k^2$ para $0 lt.eq k lt.eq 4$. Probar que $T in Theta(n!)$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = sqrt(2) T(n/2) + log n$, y $T(0) = 0$. Probar que $T in Theta(sqrt(n))$.
]

#ej[
  Sea $T: NN arrow NN$ una función que cumple que para todo $n > 0$, $T(n) = 3T(n/3) + sqrt(n)$, y $T(0) = 0$. Probar que $T in Theta(n)$.
]

#ej[
  Encontrar el número de operaciones que realiza este algoritmo para una entrada de valor $n$.

  #algorithm({
    import algorithmic: *
    Procedure(
      "Fib",
      ($n in NN$),
      {
        If($n <= 1$, {
          Return[$1$]
        })
        Return(FnInline[Fib][$n - 1$] + " + " + FnInline[Fib][$n - 2$])
      },
    )
  })
]

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
        Assign($M_5$, FnInline[Strassen][$A_(1, 1) + A_(1, 2), B_(1, 1)$])
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
== Divide and conquer
#ej[Se tienen dos arrays de $n$ naturales, $A$ y $B$. $A$ está ordenado de manera creciente, y $B$ de manera decreciente. Ningún valor aparece más de una vez en el mismo array. Para cada posición $i$, consideramos la diferencia absoluta entre los valores de los arrays, $|A[i] - B[i]|$. Se desea buscar el mínimo valor posible de dicha cuenta. Por ejemplo, si los arrays son $A = [1,2,3,4]$, y $B = [6, 4, 2, 1]$, los valores de las diferencias son $[5, 2, 1, 3]$, y el resultado es $1$.

  + Diseñar un algoritmo basado en divide-and-conquer que resuelva este problema.
  + Demostrar que es correcto.
  + Dar una cota superior ajustada de su complejidad temporal asintótica.
]

#ej[
  Probar que el siguiente algoritmo multiplica dos enteros $x, y$ dados, para cualquier valor entero de $c gt.eq 2$.

  #algorithm({
    import algorithmic: *
    Procedure(
      "F",
      ($x in ZZ$, $y in NN$),
      {
        If($y = 0$, {
          Return[$0$]
        })
        Assign($t$, FnInline[F][$c times x, floor(y / c)$])
        Return[$t + x times (y mod c)$]
      },
    )
  })
]

#ej[
  Diseñar un algoritmo que, dada una lista de longitud $n$ con los primeros $n$ números naturales, en orden, excepto un elemento faltante, encuentre tal elemento faltante. Por ejemplo, para la lista $[0, 1, 3, 4, 5]$, debe devolver $2$, y para la lista $[1, 2, 3]$, debe devolver $0$.

  Probar formalmente que es correcto, y dar una cota superior ajustada de su complejidad temporal asintótica. Dicha cota debe estar en $O(log n)$.
]

#ej[
  Un array se dice monotónico si está compuesto por un prefijo de enteros creciente, y luego un sufijo de enteros decreciente. Por ejemplo, $[5, 8, 9, 3, 1]$ es unimodal.

  Diseñar un algoritmo que, dado un array unimodal de longitud $n$, encuentre su valor máximo en tiempo $O(log n)$. Demostrar formalmente que es correcto, y dar una cota superior ajustada de su complejidad temporal asintótica en el peor caso.
]

== Programación dinámica

#ej[
  Se tiene una escalera de $n$ escalones. En cada momento, podemos subir de a un escalón, o de a tres escalones. Por ejemplo, si $n = 9$, desde el cuarto escalón podemos ir o bien al quinto, o al séptimo. Si estamos en el séptimo u octavo escalón, sólo podemos subir de a un escalón, y si estamos en el noveno escalón hemos terminado.

  - Diseñar un algoritmo basado en programación dinámica que calcule de cuántas maneras distintas se puede subir la escalera entera.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n)$ operaciones en todo caso, y $O(1)$ memoria.
]

#ej[
  Se tiene una grilla de $n times m$ casillas. Empezamos en la casilla superior izquierda. En cada casilla nos podemos mover a la casilla de abajo, o a la casilla de la derecha. Por ejemplo, si estamos en la casilla $(2, 3)$, podemos ir a la casilla $(3, 3)$ o a la casilla $(2, 4)$. Si estamos en la última fila, sólo podemos movernos a la derecha, y si estamos en la última columna, sólo podemos movernos hacia abajo. Si llegamos a la casilla inferior derecha hemos terminado.

  - Diseñar un algoritmo basado en programación dinámica que, dados dos enteros positivos $n$ y $m$, calcule de cuántas maneras distintas se puede llegar a la casilla inferior derecha.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(min(n, m))$ memoria.
]

#ej[
  Similar al ejercicio anterior, pero ahora en cada casilla tenemos un entero, el entero en la celda $(i, j)$ está en $A[i][j]$. Si el entero es positivo o cero, indica la ganancia que obtenemos al pasar por esa casilla. Si el entero es negativo, indica que no podemos pasar por esa casilla.

  - Diseñar un algoritmo basado en programación dinámica que, dada una matriz $A$ de $n times m$ enteros, calcule la máxima ganancia posible al llegar a la casilla inferior derecha, partiendo desde la superior izquierda, y nuevamente yendo siempre o hacia abajo, o hacia la derecha.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(min(n, m))$ memoria.
]

#ej[
  Se tiene un array $A$A de $l$ cadenas de ceros y unos, por ejemplo $A = ["10", "0001", "111", "100101", "111001", "1", "0"]$, con $l = 7$. Dados enteros positivos $n$ y $m$, encontrar el máximo número de cadenas de $A$ con a lo sumo $n$ unos y $m$ ceros.

  Sea $k$ la suma de las longitudes de las cadenas en $A$, es decir, $k = sum_(i=1)^l |A_i|$.

  - Diseñar un algoritmo basado en programación dinámica que resuelva este problema.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(l n m + k)$ operaciones en todo caso, y $O(n m)$ espacio.
]

#ej[
  Dada una matriz $A$ de $n times m$ de enteros, encontrar la longitud del camino creciente más largo en $A$. El camino va desde una celda hacia arriba, abajo, a la derecha, o a la izquierda, pero no en diagonal.

  Por ejemplo, en la siguiente matriz:

  #table(
    columns: 3,
    rows: 3,
    [9], [9], [4],
    [6], [6], [8],
    [2], [1], [1],
  )

  El camino creciente más largo es `[1, 2, 6, 9]`, de longitud 4.

  - Diseñar un algoritmo basado en programación dinámica que resuelva este problema.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n m)$ operaciones en todo caso, y $O(n m)$ espacio.
]

#ej[
  Tenemos un árbol arraigado, con $n$ vértices. Podemos instalar cámaras en algunos vértices. Cada cámara puede monitorear al vértice donde está instalada, y a sus vecinos inmediatos, es decir su padre (si existe) y todos sus hijos inmediatos (si existen).
  Queremos saber cuántas cámaras como mínimo necesitamos para monitorear todos los vértices del árbol.

  La entrada consiste de dos líneas. La primera línea contiene $n$, el número de vértices del árbol. La segunda línea contiene $n$ enteros. El $i$-ésimo entero es el índice del vértice padre del vértice $i$, o $-1$ si se trata de la raíz del árbol.

  Por ejemplo,

  ```
  4
  -1 0 1 1
  ```

  Esto representa el siguiente árbol:
  ```
       0
      /
     1
   /   \
  2     3
  ```

  Y la respuesta correcta es $1$, pues podemos instalar una cámara en el vértice $1$ y monitorear todos los vértices.

  La entrada

  ```
  8
  -1 0 1 2 3 3 3 1
  ```

  representa el siguiente árbol:
  ```
            0
           /
          1
         / \
        2   7
       /
      3
    / | \
   4  5  6
  ```

  Y la respuesta correcta es $2$, pues podemos instalar cámaras en los vértices $1$ y $3$.

  - Diseñar un algoritmo basado en programación dinámica que calcule el número mínimo de cámaras necesarias para monitorear todos los vértices del árbol.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n)$ operaciones en todo caso, y $O(n)$ espacio.
]


#ej[
  Se nos dan precios de acciones en días consecutivos en un array $A$, donde $A[i]$ es el precio de una acción el día $i$. También se nos da un entero $k$.

  Queremos maximizar la ganancia total haciendo a lo sumo $k$ transacciones. Una transacción es comprar una acción en un día, y venderla en un día posterior. No podemos tener más de una acción a la vez, es decir, debemos vender la acción antes de comprar otra.

  Por ejemplo, si $A = [3,2,6,5,0,3]$ y $k = 2$, podemos comprar en el día 2 (precio 2) y vender en el día 3 (precio 6), ganando 4, y luego comprar en el día 5 (precio 0) y vender en el día 6 (precio 3), ganando 3, para un total de 7.

  - Diseñar un algoritmo basado en programación dinámica que calcule la máxima ganancia posible haciendo a lo sumo $k$ transacciones.
  - Demostrar formalmente que es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n k)$ operaciones en todo caso, y $O(k)$ espacio.
]

#ej[
  Se tiene una grilla de $m$ filas y $n$ columnas, con $m < n$. Cada celda debe ser pintada de color blanco o negro. Dos celdas son consideradas vecinas si comparten un borde y tienen el mismo color. Dos celdas $A$ y $B$ se consideran en la misma componente si son vecinas, o si hay un vecino de $A$ en la misma componente que $B$.

  Llamamos a una forma de pintar la grilla "linda" si tiene exactamente $k$ componentes.

  - Diseñar un algoritmo que, dados $n$ y $m$, determine el número de formas lindas de pintar la grilla.
  - Demostrar que el algoritmo es correcto.
  - Dar una cota superior ajustada de su complejidad temporal asintótica, y demostrar que es correcta. Su algoritmo debería usar $O(n^2 4^m)$ operaciones en todo caso.

  Sugerencia: Resolver para $m = 1$ y $m = 2$ antes de intentar el caso general.
]

== Caminos mínimos
#ej[
  Demostrar la correctitud del algoritmo de Dijkstra para caminos mínimos.
]

== Árboles generadores mínimos
#ej[
  Demostrar la correctitud del algoritmo de Kruskal para árboles generadores mínimos.
]

#ej[
  Demostrar la correctitud del algoritmo de Prim para árboles generadores mínimos.
]

#load-bib()
