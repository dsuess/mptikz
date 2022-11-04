mptikz - graphical tensor notation for LuaTeX
=============================================

The mptikz package provides convenient functions for drawing tensor networks in graphical notation.
Right now, it manly deals with the 1D tensor networks, i.e. matrix-product states and operators, but it's readily extensible.
The package needs LuaLatex or LuaTex to work, I would reccomend to make the diagrams in a `standalone` file and import the pdf file with `\includegraphics`.

Tip: `\includegraphics` also works in math environments. The `valign` option to `\includegraphics` allows the user to set the vertical alignmnet. To enable it, you need to import `\usepackage[export]{adjustbox}`.


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
Note that all examples rely on `lualatex`.

`mptikz` automatically names tensors and legs, which then can be used to add annoations to the graph (see [example_2.tex](example_2.tex) for the full source code).
Also, the example below shows how to customize the look of the tensors using the `tensor_style` properties passed to the `\tensor` command.
It accepts any valid TikZ style including (as shown below) the name of predefined styles.

```latex
\tikzstyle{tensornode}=[draw,minimum size=1, fill=orange, rounded corners=0.1cm]
\tensor{{N=1, tensor_name='A', tensor_style='tensornode', len_vertical_legs=1, leg_style='line width= .2mm', leg_color_NS='black'}}
\node at (A) {$A$};
\node [anchor=west] at (A_N1) {$i$};
```

<p align='center'>
	<img height='150' src='img/example_2.svg'>
</p>

For each legs, three different TikZ coordinates are defined:
`A_N1` stands for the middle first northern leg of the tensor `A`, `A_N1e` stands for the end of that leg and `A_N1b` for the base of the leg.

## Drawing more complex MPAs

For drawing chain of tensors (so called Matrix Product Arrays), we provide the `\mpa` functions shown below.
We also show how to manipulate the default values for styling using the `\tensorstyle` command.
See [example_3.tex](example_3.tex) for the full code

```latex
\tensorstyle{{len_vertical_legs=0.25, tensor_style='draw, fill=orange, rounded corners=0.1cm', leg_style='line width= .2mm', leg_color_NS='black', leg_color_EW='black'}}
% Draw MPA manually
\tensor{{S=1, W=1, E=1, x=0}}
\tensor{{S=1, W=1, E=1, x=1.25}}
\tensor{{S=1, W=1, E=1, x=2.5}}

% Draw MAP using appropriate function
\tensorstyle{{tensor_style='draw, fill=green, rounded corners=0.1cm'}}
\mpa{3}{{N=1, E=1, W=1, y=-1.25, tensor_name='A'}}
\node at (A_1_2) {$A$};
```

<p align='center'>
	<img height='150' src='img/example_3.svg'>
</p>

### Block structure

More generally, the first input to `\mpa` is expected to be an array of integers, and the function will draw blocks of tensors separated by ellipses according to the input. As shown in [example_4.tex](example_4.tex) for the input `{3,2,1}` we get 3 blocks: the first with 3 tensors, the second with 2 and the last with 1. The function `\tlabel` also allows to name every tensor in the array at once (to use a `\` in the label, to put for instance a greek letter, one has to use `\\` instead, more on that below).

```latex
\tensorstyle{{len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85 }}
\mpa{{3,2,1}}{{N=1,E=1,W=1, y=0.65, tensor_name='A'}}

\tlabel{'A'}{{ label='$A$' }}
```
<p align='center'>
	<img width='500' src='img/example_4.svg'>
</p>

For naming the tensors, we simply append `_i_j` to the given name, where `i` is the number of the block and `j` is the number of the tensor within the block (both starting with 1).
Therefore, if we want to address the northern leg of the 2nd tensor in the 1st block, we can use the keys `A_1_2_N1`, `A_1_2_N1e` and `A_1_2_N1b`.

### Traces and removing external legs

To draw structures akin to those of Matrix Product States one often has to trace out elements in the diagram by connecting opposite lines. The `\mpa` command can do so automatically in two different ways. The `\mpa` command has an optional argument that can take the values `-1`, `0`, `1` and `2`.

* `0` is the default value and does nothing and yields results similar to [example_4.tex](example_4.tex).

* `-1` removes the most external (East-West) legs, as shown in [example_5.tex](example_5.tex):

```latex
\tensorstyle{{len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85 }}
\mpa[-1]{{2,1,2}}{{N=1,E=1,W=1, y=0.65, tensor_name='A'}}

\tlabel{'A'}{{ label='$A$' }}
```

<p align='center'>
	<img width='500' src='img/example_5.svg'>
</p>


* `1` adds red dots on the most external (East-West) legs, as shown in [example_6.tex](example_6.tex):

```latex
\tensorstyle{{len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85 }}
\mpa[1]{{2,1,2}}{{N=1,E=1,W=1, y=0.65, tensor_name='A'}}

\tlabel{'A'}{{ label='$A$' }}
```
<p align='center'>
	<img width='500' src='img/example_6.svg'>
</p>

This is a more "tidy" version of `2`.

* `2` makes most external (East-West) legs loop around as shown in [example_7.tex](example_7.tex), so they are easier to link as shown in [example_8.tex](example_8.tex).

Example 7:

```latex
\tensorstyle{{len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85 }}
\mpa[2]{{2,1,2}}{{N=1,E=1,W=1, y=0.65, tensor_name='A'}}

\tlabel{'A'}{{ label='$A$' }}
```

<p align='center'>
	<img width='500' src='img/example_7.svg'>
</p>

Example 8:

```latex
\tensorstyle{{trace_offsetEW=-0.3, len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85}}
\mpa[2]{{2,1,2}}{{N=1,E=1,W=1, y=0.65, tensor_name='A1'}}
	
\draw[line width=1mm, leg_color_EW] (A1_1_1_W1e) -- (A1_3_2_E1e);
	
\tensorstyle{{trace_extensionEW=3}}
	
\mpa[2]{{2,1,2}}{{S=1,E=1,W=1, y=-0.65, tensor_name='A2', trace_inverterE=-1, trace_inverterW=-1}}
	
\tlabel{'A1'}{{ label='$A$' }}
\tlabel{'A2'}{{ label='$\\bar{A}$' }}
```

<p align='center'>
	<img width='500' src='img/example_8.svg'>
</p>

This examples features two ways to link the lines that were looped by the option: 

1. By using the `\draw` command of tikz with the tikz coordinates for the ends of the lines. The color names `leg_color_EW` and `leg_color_NS` are loaded with the package to the default color values for horizontal and vertical legs respectively.
2. By the `trace_extensionEW` option. This styling option only works with the `2` optional argument of `\mpa`. It extends the legth of the line by the given argument, therefore changing the position of the tikz coordinate corresponding to the end of the line. It also accepts negative inputs to reduce the length of the line.

The `tikz` coordinate `A1_1_1_W1` is halfway on the "external"/"end" line, with this option there is the new coordinate `A1_1_1_W1m` which is half way on "turn".

The vertical displacement of the looped line changed between [example_7.tex](example_7.tex) and [example_8.tex](example_8.tex). This is thanks to the `trace_offsetEW` option which allows to control for the displacement of the line looping back.

The options `trace_inverterE=-1` and `trace_inverterW=-1` allow us to change the side on which the line is looped around in example 8.

The same effect can be obtained for the vertical legs of the chain with the style option `trace_NS`. It takes as argument an array of an array of integers. Each sub-array corresponds to the block of the same index and contains the indices of the tensors within the block that we want to loop around. As is shown in [example_9.tex](example_9.tex):

```latex
\tensorstyle{{trace_offsetNS=-0.2, len_horizontal_legs=0.22, len_vertical_legs = 0.3, x=1.4, tensor_width=0.85, tensor_height=0.85 }}
	
\mpa[-1]{{2,1,2}}{{N=1,E=1,W=1, y=0.65, tensor_name='A1', traceNS = {{1,2},{},{1}} }}
\mpa[-1]{{2,1,2}}{{S=1,E=1,W=1, y=-0.65, tensor_name='A2', traceNS = {{1},{},{1}} }}
	
\tlabel{'A1'}{{ label='$A$' }}
\tlabel{'A2'}{{ label='$\\bar{A}$' }}
```

<p align='center'>
	<img width='500' src='img/example_9.svg'>
</p>

Here we used `traceNS = {{1,2},{},{1}}` for the first line, so for the first block the 1st and 2nd tensor had the vertical leg looped around, for the second block no leg is looped around since the corresponding array is empty and for the last block we have the array `{1}` therefore only the first tensor has the vertical leg looped around. Whereas for the second line we used `traceNS = {{1},{},{1}}` therefore for the first block only the first tensor has the looped around leg.

With the option `legs_order`, which takes as input a string of the form `'NSWE'` or `'EWNS'`, one can decide in which order the legs of the tensor are drawn so to decide which is on top of the other at the intersections.

The options `trace_inverterN`, `trace_inverterS`, `trace_offsetNS` and `trace_extensionNS` also exists and have the analogous effect of their horizontal counterparts.


There are many more options that come into play for `\mpa[2]` and `traceNS`, one can use them both in the second input of `\mpa` or in `\tensorstyle`.
All these options are listed here:

* `trace_extensionNS` and `trace_extensionEW` correspond to how much the "long trace" is extended (can take negative values).
	* e.g. `trace_extensionNS = e` in the visual help below.
	* default value: `0`.

* `trace_widthNS` and `trace_widthEW` give control to the value of `w` in the visual help below. In the example given `w` and `w'` increase proportionally to `trace_widthNS`.
	* default value: `0.5`.

* `trace_offsetNS` and `trace_offsetEW` give an offset to the "long" part of the lines (can take negative values).
	* e.g. `trace_offsetNS = a` in the visual help below.
	* default value: `0`.

* `trace_inverterN`, `trace_inverterE`, `trace_inverterS` and `trace_inverterW` choose the side on which the lines curve. The allowed inputs are `+1` and `-1`. If `+1` make the line go right, then `-1` will make them go left.
	*  default value: `+1`.

* `leg_W_mult` and `leg_H_mult` control the width between the lines coming out of a tensor.
	* 	e.g. In the visual help below `leg_W_mult` corresponds to `leg_W_mult` = `length blue line`/`length green line`.
	*  default value: `1.0`.

* `legs_order` chooses the order in which the legs are drawn.
	* `legs_order='EWNS'` will first draw forst the east legs, then the west legs, then the north legs and finally the south legs. Therefore the south legs will be on top and the east legs will be at the bottom. Caution: `legs_order='EWN'` will make the code fail and `legs_order='EWNN'` will not draw the south legs.
	* deafult value: `'NSEW'`.

* `trace_long` chooses which legs are looped around in all of the array. 
	* e.g. `trace_long='NE'` loops around automatically all north and east legs.
	* default value: `''`.

* `trace_short` chooses which legs will have a red dot in all of the array. (The optional inputs `2`  and `traceNS` will override `trace_short` for the legs on which they act)
	* e.g. `trace_short='NS'` adds a red dot automatically all north and south legs except those that are looped around by `traceNS`.
	* default value: `''`.

visual help ([example_10.tex](example_10.tex)):
<p align='center'>
	<img width='300' src='img/example_10.svg'>
</p>
In this example the black lines correspond to the default and the grey lines correspond the modified version.


### Labelling
The function `\tlabel` work "en par" with `\mpa`. In [example_9.tex](example_9.tex) we saw the two following examples:

```latex
\tlabel{'A1'}{{ label='$A$' }}
\tlabel{'A2'}{{ label='$\\bar{A}$' }}
```
`A1` and `A2` refer to the tikz name for the first and second array. In the second argument the option `label` takes the wanted label to be repeated to on each tensor. And any `\` has to be escaped (because the string is parsed in `lua`), therefore `\bar` is replaced by `\\bar`.

The second argument can take other options than `label`. For instance `start_indices` which is an array with as many elements as there are blocks. Each element of the array is either an integer (see [example_11.tex](example_11.tex)) or an array of the following structure `{string, integer}` (see [example_12.tex](example_12.tex)).

Example 11:

```latex
\mpa[-1]{{3,2}}{{tensor_name='A'}}
\tlabel{'A'}{{ label='$A$', start_indices={1,9}}}
```
<p align='center'>
	<img width='450' src='img/example_11.svg'>
</p>

By putting intgerers as elements of `start_indices` we tell the code to start counting from that index within the block and it is incremented (it also accepts negative numbers).

Example 12:

```latex
\mpa[-1]{{2,3,1}}{{tensor_name='A'}}
\tlabel{'A'}{{ label='$A$', start_indices={1,{'j',-1},{'n',0}} }}
```
<p align='center'>
	<img width='500' src='img/example_12.svg'>
</p>

This allows for the fast naming of complicated structures. If the input to a given block is `{str, i}` then the index that is given to the j-th tensor of the block is `$str+i+j-1$`. There are other options that allow for the styling of how these indices are added and more technical things:

* `index_placer` for how to place the index after the label (`'^'`, `'_'` or `' '`).
	* default value: `'^'`.
* `index_delimiter` takes a 2 character string that defines the delimiters to use before and after the indices.
	* e.g. `[]`, `()`, `||`, `  ` (2 spaces for no delimiter), ...
	* default value: `()`.
* `label` (as seen above) is a string that is put as is in every tensor.  (`\` needs to be escaped)
	* deault value: `''`.
* `labels` is an array of strings where each element is copied as is (after `label`) within the corresponding block (`\` needs to be escaped).
	* deault value: `''`
* `blocks_lenghts` the code remembers from the last `\mpa` used the corresponding lengths of each block. Though if `\mpa` is used again with different block lengths than in the first case `blocks_lenghts` needs to be set to the correct lengths or the code risks failing.

These options can all be seen at work in [example_13.tex](example_13.tex):

```latex
\mpa[-1]{{2,3,1}}{{tensor_name='A'}}
\tlabel{'A'}{{ label='$A$', start_indices={1,{'j',-1},{'n',0}}, index_placer='_', index_delimiter='  ',
labels={'$a$','$b$','$c$'}, blocks_lenghts={2,3,1} }}
```
<p align='center'>
	<img width='500' src='img/example_13.svg'>
</p>


## Tensor Style Parameters
The function `\tensorstyle` changes the default values to the options that are specified as input. Here are the possible inputs it can take that were not mentioned before:

* `len_vertical_legs` and `len_horizontal_legs`, default: `0.25`,
* `tensor_height` and `tensor_width`, default: `0.75`,
* `tensor_name`, default: `'T'`,
* `tensor_style`, default: `'draw, fill=default_fill, rounded corners=0.1cm'`,
* `leg_style`, default: `'line width = 1mm'`,
* `leg_color_EW` and `leg_color_NS`, defaults: `'leg_color_EW'` and `'leg_color_NS'`,
* `show_name`, default: `false`,
* `name_style`, default: `''`,
* `N`, `E`, `S` and `W`: the number of legs on each side, default: `0`,


## Lua Interface

Beside the TeX interface, we also provide a Lua interface to the drawing functions.
See [example_14.tex](example_14.tex) for the full code.

```Lua
for i = 1, nr_rows do
  local name = string.format('T%i', i)
  mptikz.draw_mpa(nr_cols, {y=-(i - 1) * 1.2, tensor_name=name},-1)

  for j = 1, nr_cols do
    local node_name = string.format('T%i_1_%i', i, j)
    local node_label = string.format('$T_{%i,%i}$', i, j)
    local tex_cmd = string.format('\\node at (%s) {%s};', node_name, node_label)
    tex.print(tex_cmd)
  end
end
```

<p align='center'>
	<img height='200' src='img/example_14.svg'>
</p>


