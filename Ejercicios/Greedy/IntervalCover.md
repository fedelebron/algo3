## Enunciado

Dado un conjunto finito $S$ de intervalos de $\mathbb{R}$ decimos que un conjunto $P \subset \mathbb{R}$ es _transversal a $S$_ si para todo intervalo $[a, b] \in S$ existe un punto $p \in P$ tal que $a \le p \le b$. Consideremos el problema de, dado un conjunto $S$, encontrar un conjunto $P$ transversal a $S$ de menor tamaño. Para ello, dado $x \in \mathbb{R}$, llamemos $S_x = \{[a, b] \in S : a \le x \le b\}$ al conjunto de intervalos de $S$ que son atravesados por el punto $x$.
Para resolver este problema se propone el siguiente esquema de estrategia greedy: se elegirá un punto $x \in \mathbb{R}$ que atraviese algunos intervalos $S_x$ de $S$, y luego se hará recursión buscando un conjunto mínimo $P$ transversal a $S \setminus S_x$, para luego devolver como respuesta final al conjunto $P \cup \{x\}$. Como caso base, cuando $S = \emptyset$, se devolverá el conjunto vacío.

Demostrar que si elegimos $x$ de acuerdo a la regla $x = \min\{b \mid [a, b] \in S\}$, obtenemos un algoritmo que devuelve un conjunto transversal a $S$ de tamaño mínimo.

## Demostración

Vamos a demostrar esto como se demuestran todos los algoritmos greedy, por inducción. Sea entonces $\mathcal{I}$ el conjunto de conjuntos de intervalos en $\mathbb{R}$, y notemos por $2^\mathbb{R}$ al conjunto de subconjuntos de $\mathbb{R}$. Llamemos entonces al algoritmo $A: \mathcal{I} \to 2^\mathbb{R}$. Dado un conjunto de intervalos $S \in \mathcal{I}$, decimos que $A$ _es correcto_ para $S$, cuando $A(S)$ es un conjunto transversal a $S$ de tamaño mínimo entre todos los conjuntos transversales a $S$. La proposición que vamos a probar por inducción es:

​	$P(n)$: Para todo conjunto de intervalos $S \in \mathcal{I}$, con $|S| \le n$, $A$ es correcto para $S$.

Como toda demostración por inducción, vamos a tener algunos casos base, y un paso inductivo. En este caso, nos basta con usar $0$ como caso base.

* $P(0)$. Queremos probar que si tenemos un conjunto de intervalos $S$, con $|S| \le 0$, entonces $P = A(S)$ es un conjunto transversal a $S$ de tamaño mínimo entre todos los conjuntos transversales a $S$. Como $|S| \le 0$, entonces $|S| = 0$, y $S = \emptyset$. Luego, $P = A(S) = A(\emptyset) = \emptyset$. Para ver que $P$ es transversal a $S$, tenemos que er que para todo intervalo $[a, b] \in S$, existe un punto $p \in P$ tal que $a \le p \le b$. Como $S = \emptyset$, esto es un "para todo" de un conjunto vacío, y por lo tanto trivialmente cierto. Para ver que  $P$ tiene tamaño mínimo entre todos los conjuntos transversales a $S$, basta ver que $P$ tiene tamaño cero, y no puede haber un conjunto $X$ transversal a $S$ de menor tamaño que $P$, puesto que $X$ necesitaría tener un número negativo de elementos.

* $P(n) \Rightarrow P(n + 1)$. Sabemos que $A$ es correcto para todos los conjuntos de a lo sumo $n$ intervalos, y queremos ver que es correcto para todos los conjuntos de a lo sumo $n + 1$ intervalos. Sea $S$, entonces, un conjunto de $n + 1$ intervalos. Por como definimos $A$, tenemos que si $P = A(S)$, entonces $P = \{x\} \cup A(S \setminus S_x)$, con $x = \min\{b \mid [a, b] \in S\}$. Sea $[a, b] \in S$ el conjunto de donde sale ese $x$, donde en particular, $x = b$. Como $a \le x \le b$, entonces $[a, b] \in S_x$, y luego $|S_x| > 0$.

  Como $|S_x| > 0$, entonces $|S \setminus S_x| < |S| = n + 1$, y luego $|S \setminus S_x| \le n$. Por hipótesis inductiva, $A$ es correcto para $S \setminus S_x$, y si $A(S \setminus S_x)$ es transversal a $S \setminus S_x$, entonces $A(S) = \{x\} \cup A(S \setminus S_x)$ es transversal a $S$. Falta ver que $A(S)$ es de tamaño mínimo entre todos los conjuntos transversales de $S$. 

  Como $x$ no toca a nadie en $S \setminus S_x$, si $x \in A(S \setminus S_x)$, podríamos simplemente eliminarlo, obteniendo un conjunto transversal a $S \setminus S_x$ de menor tamaño, y eso no puede suceder porque $A$ es correcto para $S \setminus S_x$. Luego sabemos que $x \notin A(S \setminus S_x)$, y luego $|A(S)| = |\{x\} \cup A(S \setminus S_x)| = 1 + |A(S \setminus S_x)|$.

  Sea $Q$ una solución óptima para $S$. Es decir, $Q$ es un conjunto transversal a $S$, con el mínimo tamaño entre todos los conjuntos transversales a $S$.

  Tenemos dos opciones:
  
  * $x \in Q$. Luego, $Q \setminus \{x\}$ es un conjunto transversal a $S \setminus S_x$. Como $A$ es correcto para $S \setminus S_x$, y $Q \setminus \{x\}$ es transversal a $S \setminus S_x$, tenemos que $|A(S \setminus S_x)| \le |Q \setminus \{x\}|$.
    Luego, $|A(S)| = |\{x\} \cup A(S \setminus S_x)| = 1 + |A(S \setminus S_x)| \le 1 + |Q \setminus \{x\}| = |Q|$. Como $Q$ es un conjunto transversal a $S$ de mínimo tamaño entre todos los conjuntos transversales a $S$, y $A$ es al menos tan pequeño como él, entonces $A$ es correcto para $S$.
  * $x \notin Q$. Como $Q$ es transversal a $S$, y $[a, b] \in S$, existe un $q \in Q$ tal que $a \le q \le b$. Consideremos el conjunto de intervalos en $S$ que $q$ interseca, $S_q$. Tenemos que para todo $[a', b'] \in S_q$, $a' \le q \le b \le b'$, puesto que $b$ es el mínimo extremo derecho entre todos los intervalos en $S$. Luego, todos los intervalos que $q$ interseca, $b$ también interseca, y por lo tanto, $S_q \subseteq S_b = S_x$. 
    Luego, como $Q \setminus \{q\}$ es transversal a $S \setminus S_q$, y $(S \setminus S_x) \subseteq (S \setminus S_q)$, tenemos que $Q \setminus \{q\}$ es transversal a $S \setminus S_x$. Por hipótesis inductiva, entonces, $|A(S \setminus S_x)| \le |Q \setminus \{q\}|$, y por lo tanto $|A(S)| = |\{x\} \cup A(S \setminus S_x)| = 1 + A(S \setminus S_x)| \le 1 + |Q \setminus \{q\}| = |Q|$ , con $Q$ un conjunto transversal a $S$ de mínimo tamaño. Luego, $A$ es correcto para $S$.
  

En ambos casos encontramos que $A$ es correcto para $S$, que es lo que queríamos demostrar.