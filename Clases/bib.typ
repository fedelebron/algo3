// Based on: https://forum.typst.app/t/how-to-share-bibliography-in-a-multi-file-setup/1605/9

#import "@preview/hidden-bib:0.1.0": hidden-bibliography

#let load-bib(main: false) = {
  counter("bibs").step()
  context if main {
    [#bibliography("/biblio.yml", full: true) <main-bib>]
  } else if query(<main-bib>) == () and counter("bibs").get().first() == 1 {
    // Si no estamos compilando todo el libro, sino un capítulo o sección,
    // queremos que funcionen las referencias, pero no queremos ver la
    // bibliografía al final de cada capítulo.
    hidden-bibliography(
      bibliography("/biblio.yml", full: true)
    )
  }
}
