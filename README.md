# eq

Render math equations right in your terminal, or save them as PNGs.

`eq` takes a LaTeX expression (or a SymPy expression), typesets it with LaTeX, and displays it inline using Sixel graphics. It's a tiny POSIX shell script with no build step.

![demo](assets/demo.gif)

- Note - In order for this program to work, you will need a terminal emulator with Sixel support. You can check https://www.arewesixelyet.com/ to see if your terminal emulator supports it.

## Usage

```sh
eq 'E = mc^2'                              # render LaTeX in the terminal
eq -s 'Integral(x**2, x)'                  # convert a SymPy expression to LaTeX, then render
eq -o out.png '\frac{a}{b}'                # save as PNG and print the path
eq -s -o img/int.png 'Integral(x**2, x)'   # combine flags
```

| Flag       | Meaning                                                        |
|------------|----------------------------------------------------------------|
| `-s`       | Treat the input as a SymPy expression and convert it to LaTeX  |
| `-o FILE`  | Write a PNG to `FILE` instead of displaying it                 |

The equation is always the last argument. Quote it with single quotes so the shell leaves backslashes and `$` alone.

## Examples

```sh
eq '\sum_{n=1}^{\infty} \frac{1}{n^2} = \frac{\pi^2}{6}'
eq '\int_0^1 x^2 \, dx'
eq '\begin{pmatrix} a & b \\ c & d \end{pmatrix}'
eq -s 'sqrt(x**2 + y**2)'
eq -s 'Limit(sin(x)/x, x, 0)'
```

## Requirements

- A LaTeX distribution providing `latex`, plus the `standalone`, `preview`, `amsmath` and `amssymb` packages
- `dvipng`
- `img2sixel` from [libsixel](https://github.com/saitoha/libsixel), and a terminal with Sixel support (e.g. WezTerm, foot, xterm, mlterm, Konsole, iTerm2). Not needed when using `-o`.
- Python with [SymPy](https://www.sympy.org/), only for `-s`

**Debian / Ubuntu**

```sh
sudo apt install texlive-latex-base texlive-latex-extra dvipng libsixel-bin python3-sympy
```

**Fedora**

```sh
sudo dnf install texlive-scheme-basic texlive-standalone texlive-preview texlive-amsmath \
  texlive-amsfonts texlive-dvipng libsixel-utils python3-sympy
```

**Arch**
- NOTE - I had trouble getting it to work with the libsixel package available in pacman. I installed libsixel-git from the AUR and it worked fine after that.
```sh
sudo pacman -S texlive-basic texlive-latex texlive-latexextra texlive-binextra libsixel python-sympy
```

## Installation

```sh
git clone https://github.com/mkmcgrath/eq.git
cd eq
install -m 755 eq ~/.local/bin/eq
```

Make sure `~/.local/bin` is on your `PATH`.

## Notes

- Output is **white text on a transparent background**, designed for dark terminals. PNGs saved with `-o` will be invisible on white backgrounds; change `-fg 'rgb 1 1 1'` to `-fg 'rgb 0 0 0'` in the script for black text.
- `-s` evaluates its input with SymPy's `parse_expr`, which runs Python code. So only pass it expressions you trust.
- For LaTeX errors, the last 15 lines of the LaTeX log are printed to stderr.
