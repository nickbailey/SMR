% SMR.cls
%  LaTeX 2e class for the Scottish Music Review

\ProvidesClass{SMR}[2016/06/06 version 1.01 Scottish Music Review]
\NeedsTeXFormat{LaTeX2e}

% Replace the proprietary Adobe InDesign template used to typeset
% the Scottish Music Review (which in any case has been lost by
% the PoMS).
%

%%% EDIT to set the volume displayed near the PDF footer.
\def\smr@volume{Volume 4 (2016)}

\PassOptionsToClass{a4paper,twoside}{article}
% The default point size option for SMR is 11.5pt (why??)
% We'll allow other point sizes through class options.
\def\@@ptsize{11.5pt}
\DeclareOption{10pt}{\def\@@ptsize{10pt}}
\DeclareOption{11pt}{\def\@@ptsize{11pt}}
\DeclareOption{12pt}{\def\@@ptsize{12pt}}
% For each option in the article, try to load option.smr.
% If that file doesn't exist, pass the current option to
% article which is the our default base clase.
\DeclareOption*{\InputIfFileExists{\CurrentOption.smr}{}{%
\PassOptionsToClass{\CurrentOption}{article}}}

% That's the end of the options section
\ProcessOptions \relax


% Invoke the base class
\LoadClass{article}

% font setup WE CAN FIND NICER LOOKING ONE
\RequirePackage{concrete}

% load all required packages
\RequirePackage[
 a4paper,
 twoside,
 total={6in, 8in},
 ignoreall = true,
% top = 5cm,
 top = 3.5cm,
 hmarginratio=1:1]{geometry}
\RequirePackage{graphicx} 
\RequirePackage[printwatermark]{xwatermark}
\RequirePackage{wallpaper}
\RequirePackage{ifthen}
%\RequirePackage[T1]{fontenc}
%\RequirePackage[utf8]{inputenc}
\RequirePackage{xcolor}
\RequirePackage[loadonly]{titlesec}
%\RequirePackage{titlesec}
%\RequirePackage{titling}
\RequirePackage{cabin}
\setlength{\headheight}{28pt}
\RequirePackage{fancyhdr}
\RequirePackage{fontspec}
\RequirePackage{lilyglyphs}

%
% Bibliography and citation styles
\RequirePackage[round,merge,sort&compress]{natbib}
%\bibliographystyle{plainnat}
\bibliographystyle{SMR}
\bibpunct[:]{(}{)}{;}{a}{}{,}
\renewcommand{\refname}{Bibliography}
\RequirePackage[backref=page]{hyperref}
%\RequirePackage{hypernat}   % Won't be necessary when hyperref is patched offically
% For simple page references after the bibliography entry:
%\renewcommand*{\backref}[1]{[#1]}
% More sophisticated with explanatory text for those not accustomed to back references
% Thanks: http://tex.stackexchange.com/questions/183702/formatting-back-references-in-bibliography-bibtex
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{{\footnotesize[%
    \ifcase #1 Not cited%
          \or Cited on page~#2%
          \else Cited on pages #2%
    \fi%
    ].}}

%
% We'd like to make media references visible only on-screen,
% and not print on the paper copy
%
\RequirePackage{ocg-p}
\RequirePackage{fontawesome}
\newcommand{\screenOnly}[1]{\begin{ocg}[printocg=never]{Notprinted}{noprint}{1}#1\end{ocg}}
% see http://mirrors.ctan.org/info/symbols/comprehensive/rawtables-a4.pdf
\newcommand{\audioLink}[2][]{\screenOnly{\href{#2}{\faVolumeUp\ifx#1\empty\relax\else~#1\fi}}}
\newcommand{\videoLink}[2][]{\screenOnly{\href{#2}{\faFilm\ifx#1\empty\relax\else~#1\fi}}}


%watermarks EDIT!!!!!
\newwatermark[%
  allpages,% show on all pages
  fontfamily=arialbold,% use Bookman font family
  angle=0,% rotate by 55 degrees
  scale=0.3,% scale by 2.75
  xpos= -7.5cm,% shift by 1cm to the left
  ypos= -14.3cm% shift up by 1cm
]{Scottish Music Review} %provide volume and year here 


\newwatermark[%
  allpages,% show on all pages
  fontfamily=arialbold,% use Bookman font family
  angle=0,% rotate by 55 degrees
  scale=0.3,% scale by 2.75
  xpos= 8.5cm,% shift by 1cm to the left
  ypos= -14.4cm% shift up by 1cm
]{\smr@volume} %provide volume and year here <- EDIT HERE!!!!!!

\fancyhead{}\fancyfoot{}

% author and institutional affiliation to use in the header
\newcommand{\smrtitle}[1]{\def\smr@title{#1}}
\newcommand{\smrauthor}[1]{\def\smr@author{#1}}
\newcommand{\smraffiliation}[1]{\def\smr@affiliation{#1}}
% Remember the document's title (\thetitle might get overwritten)
\fancyhead[LE]{\raggedright%
  \quad\\
  \ifdefined\smr@title\else%
    \message{LaTeX Warning: using main title for header. Change with \noexpand\smrtitle}%
    \def\smr@title{\@mydoctitle}\fi
  \textbf{\smr@title}
}
\fancyhead[RO]{\raggedleft%
  \ifdefined\smr@author\else%
    \message{LaTeX Warning: No \noexpand\smrauthor. Working around. Use \noexpand\smrauthor
             and \noexpand\smraffiliation to supress this message.}%
    \def\smr@author{}\def\smr@affiliation{\theauthor}\fi
  \textbf{\smr@author\\
    \smr@affiliation}%
}
\fancyfoot[LE,RO]{\thepage}

%logo of SMR to appear on first page only
\ThisLRCornerWallPaper{1.0}{SMR_00.pdf} 

%bottom graphic to appear on all pages
\LRCornerWallPaper{1.0}{SMR_01.pdf}

% titlesec package specs for sections, subsections etc.
% First the fonts:
\newcommand{\headingfont}{\cabincondensed}
\newcommand{\titlefont}{\cabin}

\titleclass{\section}[0]{straight}
%\renewcommand{\thesubsection}{\arabic{section}}
\titleformat{\section}
  {\headingfont\Large}           % The style of the section title
  {}                             % a prefix
  {0pt}                          % How much space exists between the prefix and the title
  {\makebox[1.2cm][l]{\thesection:}}            % How the section is represented
\titlespacing*{\section}{0pt}{*1.5}{*0.4}
% Starred variant
\titleformat{name=\section,numberless}
  {\headingfont\Large}
  {}
  {0pt}
  {}
\titlespacing*{name=\section,numberless}{0pt}{*1.0}{*0.4}

\titleclass{\subsection}{straight}[\section]
%\renewcommand{\thesubsection}{\arabic{subsection}}
\titleformat{\subsection}
  {\headingfont\large}           % The style of the section title
  {}                             % a prefix
  {0pt}                          % How much space exists between the prefix and the title
  {\makebox[1.2cm][l]{\thesubsection:}}    % How the section is represented

\titlespacing*{\subsection}{0pt}{*0.8}{*0.4}
% Starred variant
\titleformat{name=\subsection,numberless}
  {\headingfont\large}
  {}
  {0pt}
  {}
\titlespacing*{name=\subsection,numberless}{0pt}{*0.8}{*0.4}

\titleclass{\subsubsection}{straight}[\section]
%\renewcommand{\thesubsection}{\arabic{subsection}}
\titleformat{\subsubsection}
  {\headingfont}                 % The style of the section title
  {}                             % a prefix
  {0pt}                          % How much space exists between the prefix and the title
  {\makebox[1.2cm][l]{\thesubsubsection:}}    % How the section is represented

\titlespacing*{\subsubsection}{0pt}{*0.8}{*0.4}
% Starred variant
\titleformat{name=\subsubsection,numberless}
  {\headingfont}
  {}
  {0pt}
  {}
\titlespacing*{name=\subsubsection,numberless}{0pt}{*0.8}{*0.4}

\thispagestyle{empty}
\pagestyle{fancy}

% Make the abstract titling consistent with other headings
\renewenvironment{abstract}{
	\small
	\begin{center}%
		{\headingfont\abstractname\vspace{-.5em}}%
	\end{center}
	\quotation}
	{\endquotation}
%\thetitle gets corrupted on a new \section, so...
%\appendiargdef{\title}{\protected@xdef\@mydoctitle{\thetitle}}

% Customise apperance of links
\hypersetup{
    colorlinks,
    linkcolor={red!50!black},
    citecolor={blue!50!black},
    urlcolor={blue!80!black}
}
% Don't put the date on the individual papers.
\date{}

%\show\maketitle

% The job of typesetting the main title is performed
% by \@maketitle, called by \maketitle. The SMR class
% needs to modify the default fonts, so it's best just
% to copy the one inherited from the article class and
% modify it here.
%
% This needs to happen after the document begins, hence
% the use of the AtBeginDocument hook.
\AtBeginDocument{
\renewcommand\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\titlefont\LARGE Title: \@title \par}%
    \vskip 1.5em%
    {\titlefont\large
     \lineskip .5em%
     \begin{tabular}[t]{c}%
       \@author
     \end{tabular}\par}%
    \vskip 1em%
    {\titlefont\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}
}
