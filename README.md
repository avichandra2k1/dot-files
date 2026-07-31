# dotfiles

macOS. Tiling, a status bar, and a terminal that stays out of the way.

| | |
|---|---|
| wm | [aerospace](https://github.com/nikitabobko/AeroSpace) |
| bar | [sketchybar](https://github.com/FelixKratz/SketchyBar) (lua) |
| borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) |
| hotkeys | [skhd](https://github.com/koekeishiya/skhd) |
| launcher | [vicinae](https://github.com/vicinaehq/vicinae) |
| terminal | [cmux](https://github.com/manaflow-ai/cmux) · [herdr](https://github.com/herdr) |
| monitor | [btop](https://github.com/aristocratos/btop) |
| fetch | [fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| sheets | [sc-im](https://github.com/andmarti1424/sc-im) |

Light/dark follows the system appearance — `sketchybar/items/theme_watcher.lua`
picks it up and fans it out to btop and the wallpaper.

## install

    git clone git@github.com:<you>/dotfiles.git ~/.config
    cd ~/.config/sketchybar/helpers && make
