## Consigna

- Demostrar por inducción que todo grafo tiene $2n$ vértices con más de $n^2$ aristas tiene algún triangulo. **¿Se puede dar una cota mejor que funcione a partir de algún $n_0$?** Es decir, ¿Existe $c(n) < n^2$ tal que todo grafo de $2n \geq n_0$ vertices con más de $c(n)$ aristas tenga triangulos?

## Proposición

$P(n)$: Si $G$ es un grafo, con $|V(G)| = 2n$, y $|E(G)| > n^2$, entonces $G$ contiene al menos un triángulo.

## Caso base

Veamos que vale $P(1)$. Queremos probar que si $G$ es un grafo con $|V(G)| = 2$, y $|E(G)| > 1^2$, entonces $G$ contiene un triángulo.  Sabemos que para todo grafo $G$,  $|E(G)| \le \frac{|V(G)| (|V(G)| - 1)}{2}$, porque a lo sumo tiene todas las aristas que puede tener, una entre cada par de vértices distintos. Luego, $G$ tiene a lo sumo $\frac{2 * 1}{2} = 1$ arista, y luego nunca puede pasar que $|E(G)| > 1$. Luego, vale la implicación de $P$, porque el antecedente es trivialmente falso.

## Paso inductivo

Sea $n \in \mathbb{N}, n > 1$. Veamos que vale $(P(n) \Rightarrow P(n+1))$. Es decir, queremos probar $P(n+1)$, y podemos asumir $P(n)$. Para probar $P(n+1)$, sea $G$ un grafo con $|V(G)| = 2(n+1)$, y $|E(G)| > (n+1)^2$. Queremos ver que $G$ contiene un triángulo.

Como $|E(G)| > (n+1)^2 \ge 1$, existe alguna arista $\{v, w\} \in E(G)$. Consideremos $G' = (G - v) - w$. Notar que $G'$ tiene $2n$ vértices. Si $|E(G')| > n^2$, entonces por hipótesis inductiva $G'$ contiene un triángulo, y luego $G$ contiene un triángulo, que es lo que queríamos demostrar. Si $|E(G')| \le n^2$, como sabemos que $|E(G)| > (n+1)^2$, tenemos que $|E(G)| - |E(G)'| > (n+1)^2 - n^2 = n^2 + 2n + 1 - n^2 = 2n + 1$. Luego, $|E(G)| - |E(G')| \ge 2n + 2$.

Calculemos cuántas aristas tiene $G'$. $|E(G')| = |E(G)| - d(v) - d(w) + 1$. Esto es porque le sacamos todas las aristas incidentes a $v$, todas las aristas incidentes a $w$, pero si restamos ambos, estamos contando dos veces la arista $\{v, w\}$, luego sumamos 1 para no contar dos veces esa arista.

Juntando esto con la desigualdad de arriba, tenemos que $|E(G)| - |E(G')| = d(v) + d(w) - 1 \ge 2n + 2$, y luego $d(v) + d(w) - 2 \ge 2n + 1$. Vemos que $d(v) + d(w) - 2$ es el tamaño del conjunto de aristas en $G$ que salen de $v$ o $w$, y llegan a alguien en $G$ que no es ni $v$ ni $w$ (restamos 2 porque $\{v, w\}$ está contado en ambos $d(v)$ y $d(w)$, y no lo queremos contar ninguna vez). Es decir, que llegan a alguien en $V(G) \setminus \{v, w\} = V(G')$. Como sólo hay $|V(G')| = 2n$ de esos otros vértices, pero al menos $2n + 1$ aristas en $G$ que salen de $v$ o $w$ y que llegan a $V(G')$, existen dos aristas en $G$ que salen de $v$ o $w$ y van al mismo vértice $z$ en $G'$. Como $G$ es un grafo, y no multigrafo, esas aristas no pueden venir del mismo vértice (es decir, ambas viniendo de $v$ o ambas viniendo de $w$). Luego, existe un vértice $z$ en $G'$, tal que $v$ tiene una arista con $z$, y $w$ tiene una arista con $z$. Esto forma un triángulo en $G$, $\{v, z\}, \{z, w\}, \{w, v\}$, que es lo que queríamos demostrar.

## Extensión

Consideremos el grafo $G = K_{n, n}$, bipartito completo. $G$ tiene $2n$ vértices, $n^2$ aristas, pero, obviamente, es bipartito. Si hubiera, entonces, una función $c(n) < n^2$ tal que todo grafo con $2n$ vértices y más de $c(n)$ aristas tiene un triángulo, entonces como $G$ es un tal grafo con $2n$ vértices y $n^2 > c(n)$ aristas, tendría un triángulo, y no lo tiene.