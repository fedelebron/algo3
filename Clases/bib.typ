// Shared bibliography loader for multi-file setup
// Based on: https://forum.typst.app/t/how-to-share-bibliography-in-a-multi-file-setup/1605/9

#let load-bib(main: false) = {
  counter("bibs").step()
  context if main {
    [#bibliography("/biblio.yml", full: true) <main-bib>]
  } else if query(<main-bib>) == () and counter("bibs").get().first() == 1 {
    // This is the first bibliography, and there is no main bibliography
    bibliography("/biblio.yml", full: true)
  }
}
