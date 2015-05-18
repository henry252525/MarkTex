# MarkTex
A Markdown to LaTeX compiler that combines the power of the LaTeX typesetting engine with the simple and readable syntax provided by Markdown.

MarkTex is currently under development, and should be treated as a work in progress. However, it should still be usable except for the occasional bug or missing feature you may encounter.

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

## Instructions

Since MarkTex is a work in progress, we've yet to create a package for it. For
now, you'll need to clone the git repository. When we're ready to release
the first version, we'll package it as a Ruby gem.

We've been developing MarkTex on OS X, but it should work on Linux if the proper
dependencies are installed.

### Dependencies

- Ruby 2.0.0p481 (other versions of Ruby will likely work)
- `latexmk`. On OS X, the easiest way to get it is to install
  [MacTex](https://tug.org/mactex/)

### Usage

First clone the repo:

- `git clone git@github.com:henry252525/MarkTex.git`
- `cd MarkTex`


MarkTex comes with a few scripts. The most important one is `topdf.sh`, which
takes a MarkTex file as input and opens a PDF with the compiled document.

`./topdf.sh sample.mtex`

The PDF that was opened can be found in `build/sample.pdf`. The name of the PDF
file will always be that of the MarkTex file without its extension.


Another script is `marktex.sh`, which outputs the compiled LaTeX to standard
output. Use this is you want to integrate MarkTex into another toolchain:

`./marktex.sh sample.mtex`

*Note*: the scripts currently rely on the directory from which they were
executed. Therefore, you should only execute them from the MarkTex directory.

## Contributing

First off -- thank you for contributing! You are awesome.

Tests can be executed by running `marktex_tests.sh`. 

Tests are located in the `test_cases` directory, under a subdirectory for the
test category. For each category, there are several files with `.in` and
`.out` extensions. The tests take each `<name>.in` file, run it through MarkTex, then
verify that the output matches that of the `<name>.out` file. Tests are added by
creating a new `.in` and `.out` file pair; no code has to be modified for the
new test case to be executed.


## Syntax

TODO

## To do
- Proper packaging (using Ruby gems)
- Better scripts that do not depend on current directory
- Test on Linux
- Commenting


