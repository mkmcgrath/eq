#!/bin/sh
# usage: eq 'E = mc^2'
#        eq -s 'Integral(x**2, x)'      (sympy -> latex)
#        eq -o out.png 'E = mc^2'       (write PNG, print path)

out=""
sym=0
while [ $# -gt 1 ]; do
  case "$1" in
    -o) out="$2"; shift 2 ;;
    -s) sym=1; shift ;;
    *)  break ;;
  esac
done

if [ "$sym" = 1 ]; then
  tex=$(python -c "from sympy import *; from sympy.parsing.sympy_parser import parse_expr; print(latex(parse_expr('''$1''')))") || exit 1
else
  tex="$1"
fi

d=$(mktemp -d)
cat > "$d/e.tex" <<EOF
\documentclass[preview,border=4pt]{standalone}
\usepackage{amsmath,amssymb}
\begin{document}
\$\displaystyle $tex \$
\end{document}
EOF

(cd "$d" && latex -interaction=nonstopmode e.tex >log 2>&1 \
  && dvipng -T tight -D 200 -fg 'rgb 1 1 1' -bg Transparent -o e.png e.dvi >>log 2>&1) \
  || { tail -n 15 "$d/log" >&2; rm -rf "$d"; exit 1; }

if [ -n "$out" ]; then
  mkdir -p "$(dirname "$out")"
  cp "$d/e.png" "$out"
  echo "$out"
else
  img2sixel "$d/e.png"
fi
rm -rf "$d"
