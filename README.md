# MarkTex
A Markdown to LaTeX compiler that combines the power of the LaTeX typesetting engine with the simple and readable syntax provided by Markdown.

## Motivation

As university students, we frequently take notes in class. Previously, we used LaTeX to compose these notes. We loved the typesetting capabilities of LaTeX, but ran into two problems:

1. Though LaTeX elements are displayed quite well once they've been compiled,
   the source-file syntax for LaTeX is cumbersome and difficult to read.
2. LaTeX is quite powerful, and expects the user to customize nearly every
   aspect of the way a document is displayed. However, we found that we nearly always
   used the same configuration for each document we produced, copying and
   pasting the declaration from a template each time.

MarkTex attempts to solve both of these problems by allowing LaTeX documents to
be composed in Markdown, favouring convention over customization when it comes
to document configuration. The result is a readable, simple source file that can
still be typeset using LaTeX.

MarkTex allows us to replace this:

```latex
\documentclass{article}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage[normalem]{ulem}
\usepackage[margin=1in]{geometry}
\usepackage{cancel}
\usepackage{enumerate}
\usepackage{hyperref}
\usepackage{titling}
\usepackage{float}

\DeclareGraphicsExtensions{.pdf,.png,.jpg}

\let\Re\relax
\DeclareMathOperator{\Re}{\operatorname{Re}}
\let\Im\relax
\DeclareMathOperator{\Im}{\operatorname{Im}}

\setlength\parindent{0pt}
\setlength{\droptitle}{-7em}
\begin{document}
\title{My Short Document}
\author{Arthur Dent}
\maketitle
\textbf{MarkTex} is pretty awesome.
\end{document}
```

With this:
```
~title: My Short Document
~author: Arthur Dent

*MarkTex* is pretty awesome.
```

## Usage

- Dependencies
- Only tested on OS X
- Version of ruby
