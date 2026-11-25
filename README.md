# vis-insertbar

A [vis](https://github.com/martanne/vis) [plugin](https://github.com/martanne/vis/wiki/Plugins) that shows a blinking bar cursor in insert mode and a block cursor in the other modes.

vis hides the terminal cursor and draws its own as a styled cell. In insert mode this plugin clears that style and shows the terminal's real cursor as a bar instead, using the `DECSCUSR` escape sequence. Your terminal needs to support it, which most modern terminals do.

Secondary cursors (multiple selections) can't use the terminal's bar, so in insert mode they're drawn as blocks with the theme's selection colors.

## Install

With [vis-plug](https://github.com/erf/vis-plug):

```lua
{ 'erf/vis-insertbar', alias = 'insertbar' },
```

Or clone it to your plugins folder and add `require('plugins/vis-insertbar')` to your `visrc.lua`.

## Options

Set options on the module, e.g. `plug.plugins.insertbar` with vis-plug:

```lua
local insertbar = plug.plugins.insertbar

-- 5 = blinking bar (default), 6 = steady bar
insertbar.insert_shape = 6

-- cursor style outside insert mode (default "fore:black,back:white")
insertbar.styles.normal = "fore:black,back:yellow"

-- style for secondary cursors in insert mode (default: the theme's selection style)
insertbar.styles.insert_secondary = "back:blue"
```
