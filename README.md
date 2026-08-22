# dotfiles

macOS. Tiling, a status bar, and a terminal that stays out of the way.

| | |
|---|---|
| wm | [aerospace](https://github.com/nikitabobko/AeroSpace) |
| bar | [sketchybar](https://github.com/FelixKratz/SketchyBar) (lua) |
| borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) |
| hotkeys | [skhd](https://github.com/koekeishiya/skhd) |
| launcher | [vicinae](https://github.com/vicinaehq/vicinae) |
| terminal | [ghostty](https://github.com/ghostty-org/ghostty) · [cmux](https://github.com/manaflow-ai/cmux) · [herdr](https://github.com/herdr) |
| editor | [neovim](https://github.com/neovim/neovim) ([NvChad](https://github.com/NvChad/NvChad) base) |
| monitor | [btop](https://github.com/aristocratos/btop) |
| fetch | [fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| sheets | [sc-im](https://github.com/andmarti1424/sc-im) |

Light/dark follows the system appearance — `sketchybar/items/theme_watcher.lua`
picks it up and fans it out to btop and the wallpaper.

`i3-dotfiles/` is the linux setup this grew out of. Different machine, different
rules — see [linux](#linux) below.

## layout

The macOS side maps 1:1 onto `~/.config`, so the repo *is* the config
directory. One package per top level directory, no symlink management, nothing
to run on a fresh clone.

```sh
.
├── aerospace
│   ├── aerospace.toml
│   └── set-gaps.sh
├── borders
│   └── bordersrc
├── btop
│   ├── btop.conf
│   └── theme-sync.sh
├── cmux
│   └── cmux.json
├── fastfetch
│   └── config.jsonc
├── ghostty
│   ├── config
│   ├── ghostty-shaders
│   ├── icons
│   ├── shaders
│   └── themes
├── herdr
│   ├── config.toml
│   └── plugins.json
├── nvim
│   ├── init.lua
│   └── lua
│       ├── core
│       ├── custom
│       └── plugins
├── sc-im
│   ├── scimrc
│   └── themes
├── sketchybar
│   ├── sketchybarrc
│   ├── bar.lua
│   ├── colors.lua
│   ├── helpers
│   ├── items
│   └── plugins
├── skhd
│   └── skhdrc
├── vicinae
│   └── settings.json
└── wallpaper
    ├── apply.sh
    ├── dark.plist
    └── light.plist
```

The linux side is the exception. It predates all of this and is laid out for
[GNU stow][stow] instead: one directory per package, and inside it the path
relative to `~`.

```sh
i3-dotfiles
├── i3
│   └── .config
│       └── i3
│           ├── config
│           └── config-old
├── polybar
│   └── .config
│       └── polybar
│           ├── config
│           ├── launch.sh
│           ├── power.sh
│           └── scripts
│               └── weather.sh
└── waybar
    └── .config
        └── waybar
            ├── config
            ├── style.css
            ├── get_kbdlayout.sh
            ├── get_media.sh
            └── get_network.sh
```

## install

    git clone git@github.com:<you>/dotfiles.git ~/.config
    cd ~/.config/sketchybar/helpers && make

Then start the services you actually want:

    brew services start aerospace
    brew services start sketchybar
    brew services start skhd
    borders &

Neovim will bootstrap lazy.nvim on first launch. Give it a minute, then
`:Lazy sync` and `:MasonInstallAll`.

## linux

Stow makes the symlinks. From inside `i3-dotfiles/`:

    stow i3
    stow polybar
    stow waybar

If a config already exists at the target, `stow --adopt <package>` will pull it
into the repo first, then `git restore <package>` if you'd rather keep the
version that was already committed here.

> [!WARNING]
> `--adopt` overwrites what's in the repo with what's on the machine. Check
> `git status` before you restore anything.

[stow]: https://www.gnu.org/software/stow/
