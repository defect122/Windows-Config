# Personal Windows Config
This is my personal Windows configuration for development, until I can switch to Linux and avoid Windows applications
- For Neovim, based on the [nvim-lite](https://github.com/radleylewis/nvim-lite) and added some personal additions
- For Windows Ricing, from [MrDLingters/Win11GruvboxMaterial](https://github.com/MrDLingters/Win11GruvboxMaterial) and his YASB *Shibumi* bar

Credit:
- https://www.youtube.com/@theradlectures (Neovim)
- https://www.youtube.com/@sethyedw (Neovim)
- https://www.youtube.com/@darrenlingters3512 (Windows Ricing)

## Requirements

### Neovim
- `Neovim` v0.12+
- `go` (`efm language server`)
- `Nerdfont`

### Tiling Window Manager and Status Bar
- `Komorebi` (Tiling Window Manger)
- `YASB` (Status Bar)
- `Windhawk` (Optional; Gets rid of task bar)

### Windows Powershell Config
- `PSReadLine`, `PSFzf`, `Ripgrep` (For quicker terminal commands)
- `oh-my-posh`, `Fastfetch` (Optional; For prettier looking terminal)
- `git` for version control
- `Terminal-Icons` for terminal icons

## Keymaps
| Keybind | Action |
| -------------- | --------------- |
| `Alt + Space` | Quick Find for Windows Files |


### Terminal
| Keybind   | Action    |
|--------------- | --------------- |
| `ctrl + t`   | Fuzzy find files and directories within current path   |
| `alt + c`   | Fuzzy find subdirectory and cd into it   |
| `ctrl + r`   | Fuzzy find shell's command history   |
| `ArrowLeft`   | Accept PSReadLine suggestion   |


### Neovim

`<leader>` is space bar

| Keybind   | Action    |
|--------------- | --------------- |
| `<leader>pk`   | Search through keybinds   |
| `<leader>ff`   | Fuzzy find files   |
| `<leader>fg`   | Live Grep   |
| `<leader>t`   | Floating terminal   |
| `<leader>ca`   | Code Action   |
| `<leader>q`   | Quick fixes   |
| `[h` / `]h`   | Previous and Next Hunk   |
| `<leader>hb`   | Git Blame   |

