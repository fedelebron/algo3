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
#let (ejemplo-counter, ejemplo-box, ejemplo, show-ejemplo) = make-frame(
  "ejemplo",
  theorion-i18n-map.at("example"),
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
#let (propf-counter, propf-box, propf, show-propf) = make-frame(
  "propf",
  "Proposición falsa",
  counter: theorem-counter,
  inherited-levels: 0,
  render: fancy-box.with(
    get-border-color: (..) => { red },
    get-body-color: (..) => { red.lighten(80%) },
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
#let demof(body) = {
  block(
    {
      proof(title: [Demostración incorrecta])[#body]
    },
    stroke: 0.5pt + red.lighten(10%),
    fill: red.lighten(80%),
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


#let show_master_theorem_infographic() = {
canvas({
  import draw: *

  let leaf-color =rgb("#ED7D31")
  let internal-color =rgb("#5B9BD5")
  let draw-cylinder = (a, width, height, color, name: "", contents: [], ellipse-radius: 0.25) => {
    let b = (a.at(0) + width, a.at(1) + height)
    // A cylinder is a rectangle with two properly-composited ellipses, one
    // at the top and one at the bottom.
    let top-ellipse-center = (a.at(0) + (b.at(0) - a.at(0))/2, b.at(1))
    let bottom-ellipse-center = (a.at(0) + (b.at(0) - a.at(0))/2, a.at(1))
    draw.circle(bottom-ellipse-center, 
                fill: color,
                radius: ((b.at(0) - a.at(0))/2, ellipse-radius),
                stroke: 0.5pt)
    // CetZ rectangles only have a single stroke for all edges. We want
    // no top and bottom edges, but some side edges. We draw the rectangle
    // without stroke, and then draw the two edges we want.
    rect(a, b, fill: color, stroke: none)
    let (x1, y1) = (calc.min(a.at(0), b.at(0)), calc.min(a.at(1), b.at(1)))
    let (x2, y2) = (calc.max(a.at(0), b.at(0)), calc.max(a.at(1), b.at(1)))
    draw.line((x1, y1), (x1, y2), stroke: 0.5pt)
    draw.line((x2, y1), (x2, y2), stroke: 0.5pt)
    
    draw.circle(top-ellipse-center, 
                fill: color.lighten(40%),
                radius: ((b.at(0) - a.at(0))/2, ellipse-radius),
                stroke: 0.5pt,
                name: name)
    
    // Draw centered text.
    draw.content((a.at(0) + (b.at(0) - a.at(0))/2, b.at(1) + (a.at(1) - b.at(1))/2 - 0.3), text(contents))
  };

  let internal-sum-text = "Suma de valores de\n vértices internos:\n" + $display(sum_(j < d) a^j f(n/b^j))$ + "\ncon " + $d = floor(log_b (n / n_0)) + 1$
  let leaf-sum-text = "Suma de valores de\nhojas:\n" + $Theta(a^d) = Theta(n^c)$ + "\ncon " + $c = log_b a$ + ", y\n" + $d = floor(log_b (n / n_0)) + 1$

  let leaf = (label: "") => ((body: $Theta(1)$, label: label),)
  let data = (
    (body: $f(n)$, label: none),
    (
      (body: $f(floor(n/b))$, label: $a_1$),
      leaf(label: $a_1^2$),
      (
        (body: $f(ceil(floor(n/b)/b))$, label: $a_2 a_1$), 
        leaf(), leaf()
      ),
    ),
    (
      (body: $f(ceil(n/b))$, label: $a_2$),
      (
        (body: $f(floor(ceil(n/b)/b))$, label: $a_1 a_2$), 
        leaf(), leaf()
      ),
      (
        (body: $f(ceil(n/b^2))$, label: $a_2^2$), 
        leaf(), leaf()
      ),
    )
  )
  
  draw.group({
    translate((-5, 0))
    tree.tree(
      data,
      grow:0.5,
      spread: 1,
      draw-node: (v) => {
        let is-leaf = v.children.len() == 0
        let radius = if is-leaf { 0.5 } else { 0.75 }
        let color = if is-leaf { leaf-color } else { internal-color }
        draw.circle((0, 0), radius: radius, fill: color, stroke: 0.5pt + black)
        draw.content((0, 0), text(size: 0.8em, v.content.body))
      },
      draw-edge: (parent-name, child-name, parent, child) => {
        if parent != none {
          let start = parent-name + ".south"
          let end = child-name + ".north"
          draw.line(start, end, mark: (end: ">>", fill: black), stroke: 0.5pt)
          if child.content.label != none and child.content.label != "" {
            draw.content((start, 0.5, end), 
              box(fill: white, inset: 2pt, text(size: 10pt, child.content.label))
            )
          }
        }
      }
    )
  })
  draw-cylinder((-5, -10.5), 5, 3, internal-color, name: "internal-bucket", contents: internal-sum-text)
  draw-cylinder((1, -10.5), 5, 3, leaf-color, name: "leaf-bucket", contents: leaf-sum-text)

  // Divisions between scales.
  draw.group({
    translate((-7, -11))
    line((0, 0), (15, 0), stroke: (thickness: 0.5pt, paint: black))
    line((5, -0.5), (5, -4.5), stroke: (thickness: 0.5pt, paint: black))
    line((10, -0.5), (10, -4.5), stroke: (thickness: 0.5pt, paint: black))
  })

  let draw-scales(center, angle, leaf-color, internal-color) = {
    angle += 90deg
    let arm_length = 2.5
    let height = 2
    let base_center = (center.at(0), center.at(1) - height)
    let base_left = (base_center.at(0) - 1, base_center.at(1))
    let base_right = (base_center.at(0) + 1, base_center.at(1))
    let cyl_width = 0.6
    let cyl_height = 0.5
    let left_point = (center.at(0) - calc.sin(angle) * arm_length / 2, center.at(1) - calc.cos(angle) * arm_length / 2)
    let right_point = (center.at(0) + calc.sin(angle) * arm_length / 2, center.at(1) + calc.cos(angle) * arm_length / 2)

    line(left_point, right_point, stroke: (thickness: 2pt))
    line(center, base_center, stroke: (thickness: 2pt))
    line(base_left, base_right, stroke: (thickness: 2pt))
    circle(center, radius: 0.08, fill: black)
  
    let draw_side = (side_center, color) => {
      let left_anchor = (side_center.at(0) - 0.3, side_center.at(1) - 0.8)
      line(side_center, left_anchor)
      let right_anchor = (side_center.at(0) + 0.3, side_center.at(1) - 0.8)
      line(side_center, right_anchor)
      let left_cyl_position = (left_anchor.at(0), left_anchor.at(1) - cyl_height)
      draw-cylinder(left_cyl_position, cyl_width, cyl_height, color, ellipse-radius: 0.1)
    }

    draw_side(left_point, internal-color)
    draw_side(right_point, leaf-color)
  }

  draw.group({
    translate((-4.5, -12))
    draw-scales((0,0), 20deg, leaf-color, internal-color)
    draw.content((0,-2.4), [Caso 1: Las hojas dominan.])
    draw-scales((5, 0), 0deg, leaf-color, internal-color)
    draw.content((5,-2.9), "Caso 2: Las hojas y\nlos vértices internos\nestán balanceados.")
    draw-scales((10, 0), -20deg, leaf-color, internal-color)
    draw.content((10,-2.6), "Caso 3: Los vértices internos\ndominan.")
  })
})
}


// This function applies all #set and #show rules to the document
// Usage in chapter files: #show: apply-preamble
#let apply-preamble(body) = {
  // Text settings
  set text(lang: "es")

  let show-heading = (..nums) => {
    let (part, ..chapter-and-sections) = nums.pos()
    if chapter-and-sections.len() == 0 {
      return "Parte " + numbering("I", part) + ":" 
    } else {
      return numbering("1.1.1.1.1.1", ..chapter-and-sections)
    }
  }
  set heading(numbering: show-heading)
  
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
  show: show-ejemplo
  show: show-def
  show: show-prop
  show: show-propf
  show: show-conj
  show: show-defi
  
  body
}
