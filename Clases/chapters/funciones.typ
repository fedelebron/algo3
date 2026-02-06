#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble

== Funciones

Imagino que ya tienen en mente una noción del concepto de función. En esta sección quiero mostrarles una definición formal, y algunas propiedades básicas, para que vean cómo se hacen demostraciones sobre funciones.

#def[
  Sean $A, B$ conjuntos, $A times B = {(a, b) | a in A, b in B}$ el producto cartesiano entre $A$ y $B$. Una *función* $f$ es un subconjunto de $A times B$, tal que para todo $a in A$, existe un único $b in B$ tal que $(a, b) in f$. Escribimos $f:A arrow B$. Llamamos a $A$ el *dominio* de $f$, y a $B$ el *codominio* de $f$.
]

Usualmente vamos a definir funciones usando expresiones de la forma $f(X) = Y$, donde $X$ es un elemento del dominio, e $Y$ un elemento del codominio, cuya expresión depende de $X$. Por ejemplo, $f: NN times NN arrow ZZ, f(n, m) = n + m$, $g: RR arrow NN, g(x) = 45$, o $h: QQ arrow QQ times A times NN, h(y) = (y, k(y + 3), 2)$. Notar que algunas tales expresiones no definen una única función, por ejemplo $f:RR arrow RR, f(x) = f(x)$, $g:RR arrow RR, g(x) = 2 + g(x - 2)$, o aún $g: ZZ arrow ZZ, h(x) = 2 k(x + 1)$ con $k:ZZ arrow ZZ, k(x) = h(x - 1) / 2$.

#def[
  Sea $f: A arrow B$ una función. Decimos que $f$ es:
  - *inyectiva* si para todo $x, x' in A$, si $f(x) = f(x')$, entonces $x = x'$.
  - *sobreyectiva* si para todo $y in B$, existe algún $x in A$ tal que $f(x) = y$.
  - *biyectiva* si es inyectiva y sobreyectiva.
]

#def[
  Sean $f: A arrow B, g: B arrow C$ funciones. Definimos la *composición* de $f$ y $g$, notada $g compose f: A arrow C$, como la función dada por $(g compose f)(x) = g(f(x))$ para todo $x in A$.
]

#def[
  Sea $A$ un conjunto. Definimos $id_A: A arrow A$ como la función identidad sobre $A$, dada por $id_A (x) = x$ para todo $x in A$.
]

#prop[
  Sea $f: A arrow B$ una función. Entonces $f$ es biyectiva si y sólo si existe una función $g: B arrow A$ tal que $f compose g = id_B$, y $g compose f = id_A$.
]
#demo[
  - $implies$) Asumimos que $f$ es biyectiva. Definimos $g: B arrow A$ como sigue: para cada $y in B$, como $f$ es sobreyectiva, existe algún $x in A$ tal que $f(x) = y$. Como $f$ es inyectiva, este $x$ es único. Definimos entonces $g(y) = x$.

    Veamos que $f compose g = id_B$. Sea $y in B$. Entonces, por definición de $g$, $f(g(y)) = f(x) = y$, luego $(f compose g)(y) = y = id_B (y)$ para todo $y$, y luego $f compose g = id_B$. Análogamente, sea $x in A$. Entonces, por definición de $f$, $g(f(x)) = g(y) = x$, luego $(g compose f)(x) = x = id_A (x)$ para todo $x$, y luego $g compose f = id_A$.
  - $implied$) Asumimos que existe una función $g: B arrow A$ tal que $f compose g = id_B$, y $g compose f = id_A$. Queremos probar que $f$ es biyectiva, es decir, inyectiva y sobreyectiva.
    + Inyectiva: Sean $x, x' in A$ tal que $f(x) = f(x')$. Podemos aplicarle $g$ a ambos lados de la ecuación, obteniendo $g(f(x)) = g(f(x'))$, luego $(g compose f)(x) = (g compose f)(x')$. Como $g compose f = id_A$, entonces $id_A (x) = id_A (x')$, y luego $x = x'$, probando que $f$ es inyectiva.
    + Sobreyectiva: Sea cualquier $y in B$, y definamos $x = g(y)$. Entonces podemos aplicar $f$ a ambos lados, obteniendo $f(x) = f(g(y))$, o equivalentemente, $f(x) = (f compose g)(y)$. Como $f compose g = id_B$, tenemos $f(x) = id_B (y)$, y luego $f(x) = y$. Como esto vale para todo $y in B$, vemos que $f$ es sobreyectiva.
]


#prop[
  Sean $f: A arrow B, g: B arrow C$ funciones. Si $f$ y $g$ son inyectivas, entonces $g compose f$ es inyectiva.
]
#demo[
  Sea $x, x' in A$ tal que $(g compose f)(x) = (g compose f)(x')$. Entonces, por definición de composición, $g(f(x)) = g(f(x'))$. Como $g$ es inyectiva, entonces $f(x) = f(x')$. Como $f$ es inyectiva, entonces $x = x'$. Luego, $g compose f$ es inyectiva.
]
#prop[
  Sean $f: A arrow B, g: B arrow C$ funciones. Si $g compose f$ es inyectiva, entonces $f$ es inyectiva.
]
#demo[
  Sea $x, x' in A$ tal que $f(x) = f(x')$. Entonces, por definición de composición, $(g compose f)(x) = g(f(x)) = g(f(x')) = (g compose f)(x')$. Como $g compose f$ es inyectiva, entonces $x = x'$. Luego, $f$ es inyectiva.

  Notemos que no necesariamente $g$ es inyectiva. Por ejemplo, si $A = {1}$, $B = {2, 3}$, y $C = {4}$, y definimos $f: A arrow B$ como $f(1) = 2$, y $g: B arrow C$ como $g(2) = g(3) = 4$, entonces $g compose f: A arrow C$ es inyectiva, pero $g$ no lo es.
]

#prop[
  Sean $f: A arrow B, g: B arrow C$ funciones. Si $f$ y $g$ son sobreyectivas, entonces $g compose f$ es sobreyectiva.
]
#demo[
  Sea $z in C$. Como $g$ es sobreyectiva, existe algún $y in B$ tal que $g(y) = z$. Como $f$ es sobreyectiva, existe algún $x in A$ tal que $f(x) = y$. Luego, $(g compose f)(x) = g(f(x)) = g(y) = z$. Luego, $g compose f$ es sobreyectiva.
]

#prop[
  Sean $f: A arrow B, g: B arrow C$ funciones. Si $g compose f$ es sobreyectiva, entonces $g$ es sobreyectiva.
]
#demo[
  Sea $z in C$. Como $g compose f$ es sobreyectiva, existe algún $x in A$ tal que $(g compose f)(x) = z$. Por definición de composición, $g(f(x)) = z$. Llamando $y = f(x)$, tenemos que $y in B$, y $g(y) = z$. Luego, $g$ es sobreyectiva.

  Notemos que no hace falta que $f$ sea sobreyectiva. Por ejemplo, si $A = {1, 0}, B = {1, 0, -1}, C = {1, 0}$, y definimos $f: A arrow B$ como $f(1) = 1, f(0) = 0$, y $g: B arrow C$ como $g(1) = 1, g(0) = 0, g(-1) = 0$, entonces $g compose f: A arrow C$ es sobreyectiva, pero $f$ no lo es.
]

#prop[
  Sea $f: A arrow B$ una función. Si existe una función $g: B arrow A$ tal que $f compose g = id_B$, y $g compose f = id_A$, entonces $f$ es biyectiva, y $f^(-1) = g$.
]
#demo[
  Para probar que $f$ es biyectiva, tenemos que mostrar que es inyectiva y sobreyectiva.

  - Sean $x$, $x'$ tal que $f(x) = f(x')$. Podemos aplicarle $g$ a ambos lados de la ecuación, obteniendo $g(f(x)) = g(f(x'))$, luego $(g compose f)(x) = (g compose f)(x')$. El enunciado nos dice que $g compose f = id_A$, luego esto es $id_A (x) = id_A (x')$, pero $id_A (y) = y$ para todo $y in A$, luego esto nos dice que $x = x'$, probando que $f$ es inyectiva.
  - Sea cualquier $y in B$, y definamos $x = g(y)$. Entonces podemos aplicar $f$ a ambos lados, obteniendo $f(x) = f(g(y))$, o equivalentemente, $f(x) = (f compose g)(y)$. El enunciado nos dice que $f compose g = id_B$, entonces sabemos que $f(x) = id_B (y)$. Pero $id_B (y) = y$, y luego $f(x) = y$. Luego, para todo $y in B$, encontramos un $x in A$ tal que $f(x) = y$, probando que $y$ es sobreyectiva.

  Luego $f$ es biyectiva. Para ver que $f^(-1) = g$, tenemos que probar que $f^(-1)(y) = g(y)$ para todo $y in B$. Sea $y in B$. Como $f$ es sobreyectiva, existe un $x in A$ tal que $f(x) = y$. Luego, $f^(-1)(y) = f^(-1)(f(x)) = x$ por definición de función inversa. Asimismo, $g(y) = g(f(x)) = (g compose f)(x) = id_A (x) = x$. Luego ambos $f^(-1)(y)$ y $g(y)$ son iguales a $x$, y luego $f^(-1)(y) = g(y)$ para todo $y in B$, que es precisamente la definición de $f^(-1) = g$.
]

Finalmente, esta notación nos va a ser útil:

#def[
Sean $f, g: NN arrow RR0$, y $k in RR0$. Definimos las funciones $f + g$, $f g$, y $k f$, tal que para todo $n in NN$:
- $(f + g)(n) = f(n) + g(n)$
- $(f g)(n) = f(n) g(n)$
- $(k f)(n) = k f(n)$

Asimismo, cuando $A$ y $B$ son dos conjuntos de funciones $NN arrow RR0$, y $k in RR0$, definimos:

- $A + B = {a + b | a in A, b in B}$
- $A B = {a b | a in A, b in B}$
- $k A = {k a | a in A}$
]

#load-bib()