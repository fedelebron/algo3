// Chapter 6: Temario
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= Temario

En los siguientes capítulos vamos a ver los temas de la materia, con un enfoque en las demostraciones. Todas son rigurosas, y tienen el nivel de formalidad esperado de los alumnos de la carrera.

Luego de cada capítulo van a tener ejemplos de ejercicios de demostración resueltos. Sugiero _fuertemente_ no leer la solución sin haber intentado resolver cada ejercicio, durante al menos una hora. Como dije en la #xref(<comoaprender>), no aprenden cuando terminan un ejercicio, y aprenden muy poco cuando leen cómo alguién más resuelve un ejercicio. El aprendizaje sucede principalmente cuando intentan, durante horas, resolver ejercicios. Intenten jugar con los objetos, pónganle nombre a todo, usen ecuaciones, vean qué pueden deducir, y no se rindan si no les sale en los primeros 20 minutos.









=

// FIXME: La sección de teoría de grafos debería venir antes que esta, pues definimos áboles como casos particulares de grafos.




== Programación lineal


/*
== Matching
#defi[
Sea $G = (V, E)$ un grafo. Un subconjunto $M subset.eq E$ es un *matching* si para todo $e, e' in M$, $e inter e' = emptyset$. Es decir, ningún par de aristas en $M$ comparten vértices.
]
#ej[
Sea $G = (V, E)$ un grafo con $n = |V|$ vértices, y $M$ un matching. Demostrar que $|M| lt.eq n/2$.
]
#demo[
Como las aristas de $M$ no comparten vértices, si marcamos todos los vértices que tocan las $|M|$ aristas, tenemos $2|M|$ vértices, todos distintos. Luego, $2|M| lt.eq n$, o lo que es lo mismo, $|M| lt.eq n/2$.
]
*/

#load-bib()
