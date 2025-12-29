// Shared preamble for Demostraciones book
// This file contains all imports, macros, and styling configuration
// When compiling a chapter standalone, this provides necessary context

// Safe cross-reference function - shows placeholder if label doesn't exist or can't be referenced
// Usage: #xref(<labelname>) instead of @labelname for cross-chapter references
#let xref(label-name, supplement: auto) = context {
  let elems = query(label-name)
  if elems.len() > 0 {
    let el = elems.first()
    // Check if we're in book mode (main-bib exists) or standalone mode
    let is-book-mode = query(<main-bib>).len() > 0
    
    if el.func() == math.equation {
      if is-book-mode {
        // In book mode, show rule adds numbering - ref() works
        ref(label-name, supplement: supplement)
      } else {
        // Standalone mode - equation may not be numbered, show placeholder
        text(fill: red, weight: "bold")[\(?)]
      }
    } else {
      ref(label-name, supplement: supplement)
    }
  } else {
    // Label doesn't exist - show placeholder
    text(fill: red, weight: "bold")[?]
  }
}


#import "@preview/wrap-it:0.1.1": wrap-content
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/theorion:0.3.3": *
#import "@preview/suiji:0.4.0": *
#import "@preview/algorithmic:1.0.0"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
// We use the old CeTZ version because Fletcher does not work with the new one yet.
#import "@preview/cetz:0.3.4": canvas as old_canvas, decorations as old_decorations, draw as old_draw
#import "@preview/cetz:0.4.2": canvas, draw, tree
#import "@preview/chatter:0.1.0": *;
#import "@preview/finite:0.5.0": automaton
#import "@preview/cetz-venn:0.1.4": venn2
#import "@preview/fancy-tiling:1.0.0": diagonal-stripes


#import algorithmic: algorithm
#import cosmos.fancy: *

// Frame definitions - these are #let so they export correctly
#let (ej-counter, ej-box, ej, show-ej) = make-frame(
  "ej",
  theorion-i18n-map.at("exercise"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: get-tertiary-border-color,
    get-body-color: get-tertiary-body-color,
    get-symbol: get-tertiary-symbol,
  ),
)
#let (teo-counter, teo-box, teo, show-teo) = make-frame(
  "teorema",
  theorion-i18n-map.at("theorem"),
  inherited-levels: 0,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)
#let (conj-counter, conj-box, conj, show-conj) = make-frame(
  "conjetura",
  "Conjetura",
  inherited-levels: 0,
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (def-counter, def-box, def, show-def) = make-frame(
  "def",
  theorion-i18n-map.at("definition"),
  render: fancy-box.with(
    get-border-color: get-primary-border-color,
    get-body-color: get-primary-body-color,
    get-symbol: get-primary-symbol,
  ),
)
#let (prop-counter, prop-box, prop, show-prop) = make-frame(
  "prop",
  theorion-i18n-map.at("proposition"),
  counter: theorem-counter,
  inherited-levels: 0,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)
#let (defi-counter, defi-box, defi, show-defi) = make-frame(
  "defi",
  theorion-i18n-map.at("definition"),
  counter: theorem-counter,
  inherited-levels: 0,
  render: fancy-box.with(
    get-border-color: get-primary-border-color,
    get-body-color: get-primary-body-color,
    get-symbol: get-primary-symbol,
  ),
)
#let demo(body) = {
  block(
    {
      proof[#body]
    },
    stroke: 0.5pt + blue.lighten(10%),
    inset: 5mm,
    radius: 5pt,
  )
}
#let sol(body) = {
  block(
    {
      solution[#body]
    },
    stroke: 0.5pt + orange.lighten(10%),
    inset: 5mm,
    radius: 5pt,
  )
}
#let implies = $arrow.double$
#let implied = $arrow.double.l$
#let iff = $arrow.double.l.r$
#let RR0 = $RR_(gt.eq 0)$
#let RRg0 = $RR_(gt 0)$

#let pitagoras = canvas({
  let a = 1
  let b = 3
  let col_a = blue.transparentize(80%)
  let col_b = red.transparentize(80%)
  let c = (0, 0)
  let li(c, col, ..pts) = {
    let (cx, cy) = c
    let tps = pts.pos().map(((x, y)) => (x + cx, y + cy))
    draw.line(fill: col, close: true, ..tps)
  }
  li(c, white, (0, a), (0, a + b), (b, a + b), (b, a))
  li(c, white, (b, 0), (b, a), (a + b, a), (a + b, 0))
  li(c, col_a, (0, 0), (0, a), (b, 0))
  li(c, col_a, (0, a), (b, a), (b, 0))
  li(c, col_b, (b, a), (b, a + b), (a + b, a + b))
  li(c, col_b, (b, a), (b + a, a), (a + b, a + b))

  c = (5, 0)
  li(c, col_a, (0, 0), (0, a), (b, 0))
  li(c, col_b, (b, 0), (a + b, 0), (a + b, b))
  li(c, col_a, (a + b, b), (a + b, a + b), (a, a + b))
  li(c, col_b, (0, a), (a, a + b), (0, a + b))
})
#let stereographic = canvas({
  draw.circle((0, 0), radius: 15mm)
  draw.circle((0, 15mm), radius: 2mm, fill: yellow, name: "o")
  let y = -1.5
  draw.line((-5, y), (6, y))
  draw.circle((-4, y), radius: 2mm, fill: red, name: "a")
  draw.circle((2, y), radius: 2mm, fill: green, name: "b")
  draw.circle((5, y), radius: 2mm, fill: blue, name: "c")
  draw.line("o", "a")
  draw.line("o", "b")
  draw.line("o", "c")
})

// This function applies all #set and #show rules to the document
// Usage in chapter files: #show: apply-preamble
#let apply-preamble(body) = {
  // Text settings
  set text(lang: "es")
  set heading(numbering: "1.1")
  
  // Equation numbering for labeled equations only
  show math.equation: it => {
    if it.fields().keys().contains("label") {
      math.equation(block: true, numbering: "(1)", it)
    } else {
      it
    }
  }
  
  // Reference formatting for equations
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(el.location(), numbering(
        "(1)",
        counter(math.equation).at(el.location()).at(0) + 1,
      ))
    } else {
      it
    }
  }
  
  // Apply theorion and frame show rules
  show: show-theorion
  show: show-theorem
  show: show-teo
  show: show-ej
  show: show-def
  show: show-prop
  show: show-conj
  show: show-defi
  
  body
}
