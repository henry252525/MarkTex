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

### Why Ruby?

We decided to write MarkTex in Ruby for the following reasons:

1. It's a high-level scripting language that allows for rapid prototyping. Since
   MarkTex is still in heavy development, we wanted to use a language that would
   allow us to build MarkTex is a short amount of time.
2. Compared to Python, Ruby has fantastic regular expression and string manipulation support

We will likely reach a point where Ruby is too slow for MarkTex. At this point,
we will rewrite MarkTex in a lower-level language where we can perform more
optimizations. For now, Ruby seems to be fast enough, since `latexmk` is
actually the slowest part of the compilation process.

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


MarkTex comes with a few scripts, which are located in the `bin` directory. You
should add this directory to your `PATH`.

The most important script is `pdfmarktex`, which takes a MarkTex file as input and
opens a PDF with the compiled document.

`pdfmarktex sample.mtex`

The PDF that was opened can be found in `build/sample.pdf`. The name of the PDF
file will always be that of the MarkTex file without its extension.

As an added convenience, the `pdfmarktexwatch` script can be used to track a
`.mtex` file and automatically run `pdfmarktex` in the background on file change.
This, when combined with the Skim pdf viewer, provides real-time updates during
note-taking.

Another script is `marktex`, which outputs the compiled LaTeX to standard
output. Use this is you want to integrate MarkTex into another toolchain:

`marktex sample.mtex`


## Syntax

MarkTex uses a modified version of Markdown. It is not a strict superset of
Markdown; some Markdown constructs have been removed or retooled. However,
anybody who is familiar with Markdown should have no problem adapting to
MarkTex.

See `sample.mtex`, `sample_awesome.mtex`, and `sample_new.mtex` for a quick
overview of the MarkTex syntax, or below for a detailed explaination of the
language constructs.

### Title and Author

Every MarkTex document starts with the following two lines:

```
~title: <Awesome title>
~author: <My name; optional>
```

Where the content in angle brackets can be replaced with anything you'd like.

### Text

After this, you can type text normally. Each paragraph should have its own line,
with a blank line separating paragraphs (use a text editor that has word wrap).

### Emphasis (Bold & Italics)

Text can be bolded by surrounding it with `*`. Text can be italicized by
surrounding it in `/`. Text can be both italicized and bolded.

```
*bold*
/italic/
*/bold and italic/*
```


*Note*: Bold and italic elements cannot span more than one line.


### Headings

MarkTex supports three levels of headings:

```
# <Section Name>
## <Subsection Name>
### <Subsubsection Name>
```

### Lists

MarkTex unordered lists start with `*` or `-`.

```
- First list element
- Second list element
  * Nested list element 1
  * Nested list element 2
- Third list element
```

Elements can be nested within lists. Elements under a list item are
indented with two spaces to indicate that they are a nested element.

MarkTex does not support ordered lists yet, but we'll be adding it soon.

### Code

MarkTex supports inline code at this time:

```
This line has `code`.
```

### Figures

Figure locations should be specified relative to the location of your source
file. Right now, `.pdf`, `.jpg`, and `.png` files are supported. *Note*: when
you specify your file location, **do not** put the file extension.

```
![Figure caption!](figure/location)
```

### Embedded Latex

LaTeX can be embedded into your document if you need a feature that is not
supported by MarkTex. Make sure that you indent the content in the `~latex` block
with two spaces.

```
~latex{

  \begin{center}
    \begin{tabular}{c | c}
      $x$ & $y$ \\
      \hline
      1 & 2 \\
      1 & 2 \\
      1 & 2
    \end{tabular}
  \end{center}

}
```

Hopefully you won't have to use this much, since MarkTex should define most
constructs that you'd use.




## Contributing

First off — thank you for contributing! You are awesome.

Tests can be executed by running `marktex_tests.sh`. 

Tests are located in the `test_cases` directory, under a subdirectory for the
test category. For each category, there are several files with `.in` and
`.out` extensions. The tests take each `<name>.in` file, run it through MarkTex, then
verify that the output matches that of the `<name>.out` file. Tests are added by
creating a new `.in` and `.out` file pair; no code has to be modified for the
new test case to be executed.

## To do
- Proper packaging (using Ruby gems)
- Better scripts that do not depend on current directory
- Add official Linux support
- Add support for commenting out lines
- Add support for ordered lists
- Add support for block-level math mode (using `align`)
- Add support for code blocks
- Extend figure notation to allow for labels and text-width to be specified
- Add continuous integration

