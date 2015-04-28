# MarkTex
A Markdown to LaTeX compiler. The combined power of the LaTeX typesetting engine along with the awesome syntax provided by Markdown.

# Proposed Grammar
## Headers
In Markdown, there are six different levels for headers. Namely,
```markdown
# Header 1
## Header 2
### Header 3
#### Header 4
##### Header 5
###### Header 6
```

LaTeX, however, only has three different levels for sections. Instead, we can use `\paragraph{}` and `\subparagraph{}` to gain an additional two levels. Header 6 will be ignored. Therefore, the above headers in Markdown will translate to the following in LaTeX
```latex
\section{Header 1}
\subsection{Header 2}
\subsubsection{Header 3}
\paragraph{Header 4}
\subparagraph{Header 5}
% TODO: Header 6 not implemented
```

Another consideration to think about is the additional `\part{}` and `\chapter{}` levels available to the `report` and `book` document classes in LaTeX. For now, we will ignore these two options and default to the `article` document class.

Currently, all headers will be rendered as numbered sections. As a bonus, we may later allow an option to toggle between numbered and unnumbered sections.

## Emphasis
In Markdown, either one of `*` or `_` can be used to render **bold** or *italic* text. Therefore, the following code in Markdown
```markdown
**bold** and __bold__
*italic* and _italic_
```
should translate to the following equivalent code in LaTeX
```latex
\textbf{bold} and \textbf{bold}
\textit{italic} and \textit{italic}
```
Of course, nesting of the two should also work. That is, in Markdown
```markdown
**bold and _bold and italic_**
```
is equivalent to the following LaTeX
```latex
\textbf{bold and \textit{bold and italic}}
```

## Code
Code should render differently than normal text and should appear in monospaced font. In Markdown, you can reference code as either inline or a block

    This `code` is inline
    ```
    This code is in a block
    ```
Equivalently in LaTeX, we ahve
```latex
This \texttt{code} is inline
\begin{verbatim}
  This code is in a block
\end{verbatim}
```

## Lists
TODO: Do we want to manually specify the number in a numbered list? Or do we want to add a twist to the original syntax?

## Tables
TODO: What's a good syntax we can use to make typesetting tables easy?

## Images
TODO: Coming soon

## Special Characters and Character Escaping
There are certain characters in LaTeX that should be escaped. Escaping of these characters should be done automatically within the compiler to enable more fluid note-taking. The following in Markdown
```markdown
I got a 95% on my exam! How awesome is that? ^_^
```
should be escaped to LaTeX as
```latex
I got a 95\% on my exam! How awesome is that? ^\_^
```
We also saw earlier that a pair of `_` and `__` is used to bold and italicize text. Following the same principle as the Github flavoured Markdown, we should also be able to detect whether the `_` character is used to wrap text or delimit text. That is, the following code in Markdown
```markdown
_This entire block is in italics_, but this_random_word is not
```
should compile to
```latex
\textit{This entire block is in italics}, but this\_random\_word is not
```

Another consideration would be the `$` character used to enter math-mode. This can be handled in one of two ways:

1. This should be escaped manually by the user, or
2. An alternate syntax should be used to indicate math-mode

If option 1 is to be used, then this is a non-issue. If option 2 is to be used, the new proposed syntax would make no distinguishment between block-level math-mode and inline math-mode. For example, the following in Markdown
```markdown
Given an equation in the form of \[ 0 = ax^2 + bx + c \], we can solve for \[x\] using the quadratic formula as follows
\[
  x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\]
```
should translate to the following in LaTeX
```latex
Given an equation in the form of $0 = ax^2 + bx + c$, we can solve for $x$ using the quadratic formula as follows
\[
  x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\]
```
The mapping to either `$` or `\[` should be inferred by the compiler.

# Resources
https://guides.github.com/features/mastering-markdown/
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
