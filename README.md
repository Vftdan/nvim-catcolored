This plugin allows to print files with syntax highlighting (according to vim syntax rules and colorscheme). Applying syntax rules to a big file may be slow.

It only works with NeoVim, because `--headless` options is required to prevent vim from using the terminal.

## Examples

`bin/catcolored.sh $FILENAME` — print the file with colors.

`bin/catcolored.sh +'set ft=json' -` — print json from stdin with colors.

## Installation

Use a plugin manager:

```
Plug 'Vftdan/nvim-catcolored'
```
