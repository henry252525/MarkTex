require_relative 'helpers'

class Document

  PREAMBLE = '''\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage[normalem]{ulem}
\usepackage[margin=1in]{geometry}
\usepackage{cancel}
\usepackage{enumerate}
\usepackage{hyperref}
\usepackage{titling}

\DeclareGraphicsExtensions{.pdf,.png,.jpg}

\let\Re\relax
\DeclareMathOperator{\Re}{\operatorname{Re}}
\let\Im\relax
\DeclareMathOperator{\Im}{\operatorname{Im}}

\setlength\parindent{0pt}
\setlength{\droptitle}{-7em}'''

  def initialize(title, blocks)
    @title = title
    @blocks = blocks
  end

  def body
    Helpers::blocks_to_s @blocks
  end

  def to_s
    ['\documentclass{article}',
     PREAMBLE,
     '\begin{document}',
     @title.to_s,
     self.body,
     '\end{document}'].flatten.join("\n")
  end
end
