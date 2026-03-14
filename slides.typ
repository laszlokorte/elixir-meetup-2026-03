#import "@preview/typslides:1.3.2": *
#show link: underline

// Project configuration
#show: typslides.with(
  ratio: "16-9",
  theme: "purply",
  font: "Fira Sans",
  font-size: 20pt,
  link-style: "color",
  show-progress: true,
)

// The front slide is the first slide of your presentation
#front-slide(
  title: "Control flow Abstractions",
  subtitle: [Rank-Polymorphism, Convolution, Recursion Schemes],
  authors: "Laszlo Korte",
  info: [#link("https://github.com/laszlokorte/elixir-meetup-2026-03")],
)

// Custom outline
#table-of-contents()

// Title slides create new sections
#title-slide[Motivation: Advent of Code - Day 4]


// Columns
#slide(title: "AOC Day 4: Printing Department")[
  #cols(columns: (2fr, 1fr), gutter: 2em)[
    The *forklifts* can only access a roll of paper if there are *fewer than four rolls of paper in the eight adjacent positions*.
    #footnote[https://adventofcode.com/2025/day/4]

    How many rolls of paper *in total* can be removed by the Elves and their forklifts?
  ][
    #set align(center)
    #let code = read("input.txt")

    #set text(font: "DejaVu Sans Mono", size: 1.2em)

    #let cellSize = 1em
    #grid(columns: (cellSize,)*10, rows: (cellSize,)*10, gutter: 0mm, row-gutter: 0mm, column-gutter: 0mm, align: center+horizon,
      ..code.codepoints().filter(c => c != "\n").map(c => {
              if c=="@" {
                text(color.rgb("#952cae").darken(10%), top-edge: 1em, tracking: 0mm, weight: "bold", c)
              } else {
                text(gray,top-edge: 1em, tracking: 0mm, c)
              }
           })
    )

  ]

]

// Columns
#slide(title: "Day 4: Solution")[

  Multiple kinds of iteration:
  #line()
  #cols(columns: (3fr, 1fr), gutter: 2em)[
 == Counting

  - *for each* roll of paper: count the neighbors
    - *for each* neighbor: check if its a roll

 == Repetition
  - *after each* each removal of a roll, count again
  ][
    #set align(center)
    === AOC Day 4 \ Elixir Solution
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Faoc2025-livebook%2Fblob%2Fmain%2Faoc.livemd", image("livebook.svg"))
  ]
]

#title-slide[Abstractions]



#slide(title: "Rank-Polymorphism: Array/Tensor Programming")[
    #cols(columns: (3fr, 1fr), gutter: 2em)[
Applying operations to each element of an array:
#line()
  ```ex
doubled = for a <- [1,2,3] do
  a * 2
end

product = for {a, b} <- Enum.zip([1,2,3], [9,8,7]) do
  a * b
end

# --- VS ---

doubled  =   Nx.tensor([1,2,3]) |> Nx.multiply(2)
product  =   Nx.tensor([1,2,3]) |> Nx.multiply([9,8,7])
  ```
  ][
    #set align(center)
    === Introduction to Elixir Nx
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Felixir-nx-livebook%2Fblob%2Fmain%2Fhello.livemd", image("livebook.svg"))
  ]
]

#slide(title: "Convolution (in german: Faltung)")[
Combining elements with their neighborhood inside a structure (array):
#line()
#cols(columns: (3.2fr, 1fr), gutter: 2em)[
```ex
grid = [[0,1,1,0,1, ...], [1,0,1,0,1, ...], ...]
for rows123 <- grid |> Enum.chunk_every(3, 1)  do
  for row <- rows123 do
    row
    |> Enum.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
  end
  |> Enum.zip_with(&Enum.sum/1)
end

# --- VS ---
summed_neighbors = grid
  |> Nx.tensor()
  |> Nx.conv(Nx.broadcast(1, {3, 3}))
  ```

  ][
    #set align(center)
   ===  Introduction to Elixir Nx
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Felixir-nx-livebook%2Fblob%2Fmain%2Fhello.livemd", image("livebook.svg"))

    #line()

    #link("https://static.laszlokorte.de/dft2d/")[
      Interactive \ Web Demo
    ]
  ]
]

#slide(title: "Recursion Schemes: Enum.reduce, Stream.unfold...")[
Producing, consuming and transforming recursive data structures:
  #line()
#cols(columns: (3fr, 1fr), gutter: 2em)[

  ```ex
Stream.unfold(5, fn 0 -> nil; n -> {n, n - 1} end)
#=> [5, 4, 3, 2, 1]
defmodule Tree do
  def rec( :empty, _fun), do:      :empty
  def rec({:leaf, val}, _fun), do: {:leaf, val}
  def rec({:inner, v, l, r},  fun), do: {
    :inner, v, fun.(l), fun.(r)
  }
  def grow(0), do: :empty
  def grow(1), do: {:leaf, 1}
  def grow(h), do: {:inner, h, h - 1, h - 2}
end
# generate barely balanced binary tree
Anamorphism.ana(3, &Tree.rec/2, &Tree.grow/1)
  ```

  ][
    #set align(center)
   === Introduction to Recursion Schemes
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Felixir-recursion-livebook%2Fblob%2Fmain%2Fintro.livemd", image("livebook.svg"))

    #line()

    #link("https://static.laszlokorte.de/recursion-schemes/")[
      Interactive \ Web Demo
    ]
  ]
]


#title-slide[Applications]

#slide(title: "Application: Video and Image Processing (1)")[
Generating Blue Noise for visual effects:
  #line()
#cols(columns: (3fr, 1fr), gutter: 2em)[

  #grid(
    columns: 3,
    gutter: 5mm
  )[
    #image("images/orig-blue.png", width: 100%, scaling: "pixelated")
  ][
     #image("images/blur.png", width: 100%, scaling: "pixelated")
  ][
    #image("images/blue.png", width: 100%, scaling: "pixelated")
  ]

  ][
    #set align(center)
   === Generating Blue Noise
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Fbluenoise-elixir%2Fblob%2Fmain%2Felixir_bluenoise.livemd", image("livebook.svg"))

    #line()

    #link("https://static.laszlokorte.de/blue-noise/")[
      Interactive \ Web Demo
    ]
  ]
]

#slide(title: "Application: Video and Image Processing (2)")[
Other image transformations:
#cols(columns: (3fr, 1fr), gutter: 2em)[


  #grid(
    columns: 3,
    gutter: 5mm
  )[
    #image("images/orig.png", width: 80%, scaling: "pixelated")
  ][
     #image("images/rot.png", width: 80%, scaling: "pixelated")
  ][
    #image("images/edges.png", width: 80%, scaling: "pixelated")
  ][
      #image("images/swirl.png", width: 80%, scaling: "pixelated")
    ][
       #image("images/orange-swirl.png", width: 80%, scaling: "pixelated")
    ][
      #image("images/fish.png", width: 80%, scaling: "pixelated")
    ]


  ][

    #set align(center)
   === Introduction to Elixir Nx
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Faoc2025-livebook%2Fblob%2Fmain%2Faoc.livemd", image("livebook.svg"))

  ]
]

#title-slide[More Livebooks]

#let icon(source, size-to: "P", scale: 1.0) = context {
  let text-edge = measure(size-to).height
  let text-bounds = measure(text(top-edge: "bounds", size-to)).height
  let img = image(source, height: text-bounds * scale)
  let extend = calc.max(0pt, text-bounds - text-edge) * scale
  let shift = (text-bounds * scale - text-bounds) / 2
  return box(img, height: text-bounds, inset: (top: -extend - shift, bottom: shift))
}

#slide(title: "Plotting Tensors in Livebook with Kino")[

#cols(columns: (4fr, 2fr), gutter: 2em)[

- *`vega_lite`* can be used to render images in Livebook, *but not* `Nx.Tensor`

- *`kino_rewind`* for easy rendering of `Nx.Tensor` via `vega_lite` #h(1fr) #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Faoc2025-livebook%2Fblob%2Fmain%2Faoc.livemd")[
#icon("rewind.svg", scale: 1.5)]

- *`kino_zoetrope`* for rendering 4D `Nx.Tensor` as slideshow *without* `vega_lite` #h(1fr) #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Faoc2025-livebook%2Fblob%2Fmain%2Faoc.livemd")[
#icon("zoetrope.svg", scale: 1.5)]

  ][

    #set align(center)

  === `vega_lite` Example

    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Fvega-lite-examples%2Fblob%2Fmain%2Fvegalite.livemd", image("livebook.svg"))


    === `kino_rewind` Example

      #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Fkino_rewind%2Fblob%2Fmain%2Fguides%2Fexample.livemd", image("livebook.svg"))


  === `kino_zoetrope` Example

    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Fkino_zoetrope%2Fblob%2Fmain%2Fguides%2Fexample.livemd", image("livebook.svg"))


  ]
]

#slide(title: "Experiment: Einsum Notation")[

Vibe-coded experimental Elixir macro for bringing `np.einsum`/`torch.einsum` notation to Elixir `Nx`.

#cols(columns: (4fr, 2fr), gutter: 2em)[
$#text[Out] = sum_i^I sum_j^J A_(i j) B_(j i) C_j$

#line()

```ex
defmodule Summation do
  import NxEinsum
  # shorthand notation for n-D sum/product
  defeinsum(weighted_trace, "ij,ji,j->")
end

out = Summation.weighted_trace(
  Nx.tensor([[3, 2], [4, 5]]),
  Nx.tensor([[1, -1], [1, 3]]),
  Nx.tensor([1, 2])
)
```

  ][
    #set align(center)

    === `Nx.Einsum` \ Proof of concept
    #link("https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Flaszlokorte%2Felixir-nx-einsum%2Fblob%2Fmain%2Feinsum.livemd", image("livebook.svg"))

    #line()

    #link("https://static.laszlokorte.de/einsum/")[
      Interactive \
      Web Demo
    ]


  ]
]

#focus-slide[
#set text(size: 24pt)
#context raw(
  "iex(" + str(counter(page).get().first()) + ")> # 🤍 Thank you for attention",
  block: true,
  lang: "txt"
)
#v(1cm)
```
BREAK: (q) Questions
       (f) Feedback  (h) Go Hacking
```
]
