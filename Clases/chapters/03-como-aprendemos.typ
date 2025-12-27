// Chapter 3: ¿Cómo aprendemos a demostrar?
#import "../preamble.typ": *
#import "/bib.typ": load-bib

#show: apply-preamble


= ¿Cómo aprendemos a demostrar? <comoaprender>

Nadie aprendió a andar en bicicleta viendo a otros andar en bicicleta. Tampoco van a aprender a demostrar leyendo cómo alguien más demostró. La *única* forma que van a aprender es escribiendo demostraciones ustedes mismos. Por cada segundo que pasan leyendo este documento, sugiero que pasen cinco pensando y escribiendo sus propias demostraciones.

Empiecen demostrando proposiciones simples. Si intentan ambos aprender un tema nuevo (como teoría de grafos) y _al mismo tiempo_ aprender a demostrar, les va a resultar demasiado difícil, se van a confundir, y frustrar. Demuestren, primero, propiedades de conjuntos, de enteros, de racionales, de matrices, de objetos con los que ya saben trabajar.

#teo(title: [Teorema de Euclides])[
  Hay un número infinito de primos.
]
#demo[
  Esta demostración se encuentra en "Elementos" @elementa.

  Sea $L = [p_1, dots, p_n]$ una lista finita de números primos distintos. Vamos a mostrar que existe algún número primo que no está en esta lista.

  Sea $P = product_(p in L) p$ el producto de todos los números en $L$. Sea $q = P + 1$. Entonces o bien $q$ es primo, o no es primo.

  + Si $q$ es primo, entonces como $q > p$ para todo $p in L$, al menos hay un número primo ($q$ mismo) fuera de $L$.
  + Si $q$ no es primo, entonces hay algún factor primo $p$ que divide a $q$. Entonces $p in L$, o $p in.not L$.
    + Si $p in.not L$, encontramos un número primo ($p$) que no está en $L$.
    + Si $p in L$, entonces $p | P$, pues $P$ es el producto de todos los números en $L$. Como $p | P$ y $p | q$, entonces $p | (q - P)$, es decir $p | 1$. Como ningún número primo puede dividir a $1$, este caso no puede suceder.

  Concluímos que para toda lista finita $L$ de números primos, existe algún número primo que no está en $L$, y luego hay infinitos números primos.
]

En este momento, muchos de ustedes no tienen todavía una intuición sobre cuándo una demostración es correcta, versus cuándo les están mintiendo. Más aún, tienen sesgos entendibles por su educación: si léen una demostración en un libro, "debe estar bien", o si se los dice un docente, "debe estar bien". Lo que el practicar les va a dar es la confianza de decir "No, no creo que lo que esté diciendo el docente / libro esté bien.", así como también "Estoy seguro/a de que el argumento que acabo de escribir es correcto." La matemática es el único lugar donde podemos tener esta certeza, ninguna ciencia puede tenerla. ¡Aprovechémosla! *No acepten como cierto algo sólo porque lo dice un docente.* Si no lo pueden demostrar, no saben si es cierto, y no deberían usarlo.


#let body_paths = [La matemática que van a ver en la universidad no es como la que vieron en secundario. No hace falta seguir una receta particular, hacer cálculos larguísimos de memoria como derivar 50 polinomios de grado 9, o memorizar patrones de demostración y usar los que el docente quiera. Si se les pide demostrar que $P$ implica $Q$, el objetivo es que ustedes produzcan una demostración clara y convincente de ese hecho. Si el docente pensó que la demostración tenía que ser por inducción, y ustedes la hicieron partiendo en casos, por contrarecíproco, o por absurdo; no importa. Tienen una enorme flexibilidad a la hora de argumentar, lo que da lugar a la *creatividad* en matemática.]
#let image_paths = block({
  image("../proof_paths.png")
})
#wrap-content(image_paths, body_paths, align: right)

Finalmente, al momento de empezar una demostración, sepan que les debería tomar tiempo. Si esperan que las demostraciones les salgan en 10 minutos, van a cometer errores. Es frecuente que lleven horas. No está _mal_ que tomen ese tiempo, y no se deberían sentir mal cuando lo hacen. Tengan paciencia, practiquen con tiempo, entiendan que el objetivo _no_ es "que salga el ejercicio". El objetivo es que aprendan a demostrar. Si llegan de $P$ a $Q$, pero no están seguros si lo que hicieron está bien, _no terminaron el ejercicio_. Si la demostración ni siquiera los convence a ustedes, ¿cómo va a convencer a cualquier par? Vayan lento, vayan seguro, y van a aprender a hacerlo. No hay trucos, sólo sudor y tiza.

#tip-box[*El aprendizaje no sucede cuando terminan un ejercicio. El aprendizaje sucede cuando piensan, intentan, juegan, fallan, y reflexionan, durante horas*. Su objetivo debe ser este, y no el terminar el mayor número de ejercicios.]

#load-bib()
