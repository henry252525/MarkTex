# Proposed Grammar
MarkTeX uses the grammar of Markdown as its base. There were slight modifications to the grammar in order to make the syntax both more readable and easier to type.

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

LaTeX, however, only has three different levels for sections. There are additional levels in LaTeX, namely `\part{}`, `\chapter{}`, `\paragraph{}`, and `\subparagraph{}`, but these don't really fit in with the styling of the `\section{}` constructs. Therefore, the proposed grammar is to support only three levels and to drop the rest. The above should compile into
```latex
\section{Header 1}
\subsection{Header 2}
\subsubsection{Header 3}
% TODO: Header 4 not implemented
% TODO: Header 5 not implemented
% TODO: Header 6 not implemented
```
Currently, all headers will be rendered as numbered sections. The proposed grammar for unnumbered sections is to append a `*` after the `#` as follows
```
#* Header 1
##* Header 2
###* Header 3
```
which compiles into
```latex
\section*{Header 1}
\subsection*{Header 2}
\subsubsection*{Header 3}
```

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
There is official support for tables in Markdown. Various flavours of Markdown introduced their own support for tables each with their own grammar. In almost all cases, the solutions that these various flavours chose focused more on readability with little consideration on ease of typing. The proposed grammar for tables in MarkTeX aims to address the latter case.

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
The caption for the image is optional. The following in MarkTeX
```markdown
  !(dir/to/some/image.jpg)
```
is also valid and translates to the following in LaTeX
```latex
\begin{figure}
   \centering
   \includegraphics{dir/to/some/image.jpg}
\end{figure}
```
A few things to think about:

1. Referencing tables
2. Adjusting the scale of the image

The proposed grammar to address the above two is
```
![alt text](dir/to/some/image.jpg)<table_id>{scale}
```
which compiles into
```latex
\begin{figure}
   \centering
   \includegraphics[width=scale\textwidth]{dir/to/some/image.jpg}
   \caption{alt text}
   \label{table_id}
\end{figure}
```
where `scale = 0.6` is the default and the `table_id` can be referenced elsewhere in the document via `~ref{table_id}`.

## Math-Mode
Similarly to LaTeX, inline math-mode can be entered via `$`. To enter block-level math-mode, the proposed grammar is to use `~math{}` or the short-hand `~m{}`. By default, the block-level math environment is the `begin{align*}` and `\end{align*}` in LaTeX. For example, the following in MarkTeX
```
Given an equation in the form of $0 = ax^2 + bx + c$, we can solve for $x$ using the quadratic formula as follows
~math{
  x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
}
```
should compile into the following in LaTeX
```latex
Given an equation in the form of $0 = ax^2 + bx + c$, we can solve for $x$ using the quadratic formula as follows
\begin{align*}
  x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\end{align*}
```
As mentioned earlier, the short-hand `~m{}` should also work. That is,
```
~m{
  x & = 1 + 1 \\
    & = 2
}
```
should result to
```latex
\begin{align*}
  x & = 1 + 1 \\
    & = 2
\end{align*}
```

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

## LaTeX Mode
Any more powerful typesetting can be done in native LaTeX via the `~latex{}` environment.
```
~latex{
  blah
}
```
compiles to
```latex
blah
```
where `blah` can be anything.

### Quotes
In LaTeX, the orientation of quotes are handled manually. That is, we would normally have to write

    ``Lorem Ipsum'' dolor sit amet

In order to obtain double-quotes which wraps around the text "Lorem Ipsum". This is annoying. Instead, the compiler should be able to detect appropriate pairings of `"` and infer the orientation for you. Therefore, the above text in LaTeX should be equivalent to the following in markdown
```markdown
"Lorem Ipsum" dolor sit amet
```
