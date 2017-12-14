mptikz - graphical tensor notation for LuaTeX
=============================================

The mptikz package provides convenience functions for drawing tensor networks in graphical notation.
Right now, it manly deals with the 1D tensor networks, i.e. matrix-product states and operators, but it's readily extensible.


## Installation

Just copy the `mptikz.sty` file in your working directory or any directory in the search path of LuaTeX.

## Drawing single nodes

Drawing a single tensor is as easy as loading the mptikz package via `\usepackage{mptikz}` and running the following command inside a tikzpicture.

```latex
\tensor{{N=2, S=3, E=1}}
```

Note the double `{{}}`.
This draws a tensor with 1, 2, and 3 legs on the left (EAST), top (NORTH), and bottom (SOUTH) position, respectively.

<p align='center'>
	<img height='150' src='img/example_1.svg'>
</p>

See [example_1.tex](example_1.tex) for the full source code.
Note that all examples rely on `lualatex`, see the [Makefile](Makefile) for how to compile the pictures in this repo.

`mptikz` automatically names tensors and the legs, which then can be used to add annoations to the graph (see [example_2.tex](example_2.tex) for the full source code).
Also, the exaple below shows how to customize the look of the tensors using the `tensor_style` properties passed to the `\tensor` command.
It accepts any valid TikZ style including (as shown below) the name of predefined styles.

```latex
\tikzstyle{tensornode}=[draw,minimum size=1, fill=green, rounded corners=0.1cm]
\tensor{{N=1, tensor_name='A', tensor_style='tensornode', len_vertical_legs=1}}
\node at (A) {$A$};
\node [anchor=west] at (A_N1) {$i$};
```

<p align='center'>
	<img height='150' src='img/example_2.svg'>
</p>

For each legs, two different TikZ coordinates are defined:
`A_N1` stands for the middle first northern leg of the tensor `A` and `A_N1e` stands for the end of that leg.

## Drawing more complex MPAs

Beside the TeX interface, we also provide a Lua interface to most functions.
The equivalent to `\tensor` is the `mptikz.draw_tensor` function in Lua.
This also allows easily modifying style arguments as shown below.
For drawing chain of tensors (so called Matrix Product Arrays), we provide the `\mpa` and `mptikz.draw_mpa` functions shown below
We also show how to manipulate the `mptikz.defaults` table in order to change the styling of tensors globally.
See [example_3.tex](example_3.tex) for the full code

```latex
\begin{luacode}
  local style = 'draw, fill=orange, rounded corners=0.1cm'
  mptikz.defaults['len_vertical_legs'] = 0.25
  mptikz.defaults['tensor_style'] = style

  -- Draw MPA manually
  mptikz.draw_tensor({S=1, W=0, E=1, x=0})
  mptikz.draw_tensor({S=1, W=1, E=1, x=1.5})
  mptikz.draw_tensor({S=1, W=1, E=0, x=3.0})

  -- Draw MPA using appropriate function
  mptikz.defaults['tensor_style'] = style .. ', fill=green'
  mptikz.draw_mpa(3, {N=1, y=-1.5, tensor_name='A'})
\end{luacode}
```

<p align='center'>
	<img height='150' src='img/example_3.svg'>
</p>


## More examples

For more examples, see the [documentation of mpnum](https://github.com/dseuss/mpnum/tree/feat-docs/docs/fig).
However, the interface of mptikz has since been updated.
Many of the things there could have been down easier using the pure latex interface.


## Why LuaTeX?

Sure, mptikz could just as well be implemented in pure PGF/TikZ.
But the syntax is slightly messy at best and learning Lua is time well spend for me anyway.
Also, by using TikZ externalize feature, one can compile the document with pdftex, which is generally faster, and only compile the TikZ images using LuaTeX.

