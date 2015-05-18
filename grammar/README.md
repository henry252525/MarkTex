# Proposed Grammar
MarkTeX uses the grammar of Markdown as its base. There were slight modifications to the grammar in order to make the syntax both more readable and easy to type.

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
In Markdown, either one of `*` or `_` can be used to render **bold** or *italic* text. There is no support for underlining. The proposed syntax is to use pairs of `*`, `/`, and `_` to bold, italicize, and underline respectively. Therefore, in MarkTeX
```
*bold*, /italic/, and _underline_
```
should translate to the following equivalent code in LaTeX
```latex
\textbf{bold, \textit{italic}, and \uline{underline}
```
where `\uline{}` comes from the the `uline` package in LaTeX. Of course, nesting of these should also work. That is,
```
*bold and /bold and italic/*
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
### Unordered Lists
In Markdown, unordered lists can be specified with either `-` or `*`. The concept of nested lists also exists through indentation. Below is an example of how to specify unordered lists in Markdown
```markdown
* Some point
  * Nesting is cool
  * Seriously cool
* Some other point
  - I am also a list
  - No lies
* Some awesome point
```
The above Markdown produces the following list

* Some point
  * Nesting is cool
  * Seriously cool
* Some other point
  - I am also a list
  - No lie
* Some awesome point

This is equivalent to the following in LaTeX
```latex
\begin{itemize}
    \item Some point
        \begin{itemize}
            \item Nesting is cool
            \item Seriously cool
        \end{itemize}
    \item Some other point
        \begin{itemize}
            \item I am also a list
            \item No lie
        \end{itemize}
    \item Some awesome point
\end{itemize}
```

### Ordered Lists
Ordered lists are preceeded by `n.` instead of `-` or `*`, where `n` is a number. For example, a list in Markdown would look as follows
```markdown
1. I am a point
2. I am the second point
3. Me too!
```
Although the syntax is nice and clean, it doesn't really make sense for the user to have to specify his/her own numbering. This should be done by default. The proposed equivalent grammar for ordered lists in MarkTeX is
```
n. I am a point
n. I am the second point
n. Me too!
```
Identical nesting concepts exist for ordered lists as they do for unordered lists. Mixing of the two also works. For example, to produce the following list

1. I am number 1
   * As per usual
   * #YOLOSWAG #LifeIsTooEasy #FBB
2. I am the first loser
3. Just barely got bronze!

the code MarkTeX would look like
```
n. I am number 1
   * As per usual
   * #YOLOSWAG #LifeIsTooEasy #FBB
n. I am the first loser
n. Just barely got bronze!
```
And equivalently, the LaTeX code would look like
```latex
\begin{enumerate}
    \item I am number 1
        \begin{itemize}
            \item As per usual
            \item #YOLOSWAG #LifeIsTooEasy #FBB
        \end{itemize}
    \item I am the first loser
    \item Just barely got bronze!
\end{enumerate}
```

## Tables
TODO: What's a good syntax we can use to make typesetting tables easy?

### Proposed Method #1
A good starting point could be http://en.wikipedia.org/wiki/Textile_%28markup_language%29#Tables where instead of using `_.` to denote boldface, we can change it up a little bit and use it to denote alignment. We can also double up on the pipe symbol (use `||` instead of `|`) to get a stronger vertical line separation. Similarly, we can use either `-` or `=` to specify the horizontal rules for our table.

An example describing this proposed method is demonstrated below. The following is the proposed method in Markdown.
```markdown
|. This || is | a | header .|
---------------------
| a1 | a2 | a3 | a4 |
| b1 | b2 | b3 | b4 |
```
This produces the following in LaTeX
```latex
\begin{table}
    \centering
    \begin{tabular}{| l || c | c | r |}
        \hline
        This & is & a  & header \\
        \hline
        a1   & a2 & a3 & a4 \\
        b1   & b2 & b3 & b4 \\
        \hline
    \end{tabular}
\end{table}
```
By default, the entire table is enclosed a single solid outline.

TODO: How do we handle table captions?

## Images
Images in Markdown are done as follows
```markdown
![alt text](dir/to/some/image.jpg)
```
This is equivalent to the following in LaTeX
```latex
\begin{figure}
    \centering
    \includegraphics{dir/to/some/image.jpg}
    \caption{alt text}
\end{figure}
```

A few things to think about:

1. The alt text is neglected

   We can drop the entire block for the alt text in Markdown as follows

   ```markdown
   !(dir/to/some/image.jpg)
   ```
   This translates to
   ```latex
   \begin{figure}
       \centering
       \includegraphics{dir/to/some/image.jpg}
   \end{figure}
   ```
2. An option to adjust the scale of the image

   ```latex
   \begin{figure}
       \centering
       \includegraphics[width=some_scale\textwidth]{dir/to/some/image.jpg}
   \end{figure}
   ```
   where `some_scale` can be set by the user via some optional syntax. As a default, `some_scale = 0.6`

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

### Math-Mode
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

### Quotes
In LaTeX, the orientation of quotes are handled manually. That is, we would normally have to write

    ``Lorem Ipsum'' dolor sit amet

In order to obtain double-quotes which wraps around the text "Lorem Ipsum". This is annoying. Instead, the compiler should be able to detect appropriate pairings of `"` and infer the orientation for you. Therefore, the above text in LaTeX should be equivalent to the following in markdown
```markdown
"Lorem Ipsum" dolor sit amet
```
