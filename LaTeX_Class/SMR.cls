% SMR.cls
%  LaTeX 2e class for the Scottish Music Review

\ProvidesClass{SMR}[2016/06/06 version 1.00 Scottish Music Review]
\NeedsTeXFormat{LaTeX2e}

% Replace the proprietary Adobe InDesign template used to typeset
% the Scottish Music Review (which in any case has been lost by
% the PoMS).
%
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


% load all required packages
\RequirePackage[
 a4paper,
 total={6in, 8in},
 ignoreall = true,
% top = 5cm,
 margin = 3.5cm]{geometry}
\RequirePackage{graphicx} 
\RequirePackage[printwatermark]{xwatermark}
\RequirePackage{wallpaper}
\RequirePackage{ifthen}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{xcolor}
\RequirePackage[loadonly]{titlesec}
\setlength{\headheight}{28pt}
\RequirePackage{fancyhdr}

% font setup WE CAN FIND NICER LOOKING ONE
\RequirePackage{concmath}

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
]{Volume 4 (2016)} %provide volume and year here <- EDIT HERE!!!!!!


% %footer and header format
% Clear both header and footer
\fancyhead{}\fancyfoot{}

%author and institutional affiliation to use in the header
\newcommand{\smrtitle}[1]{\def\smr@title{#1}}
\newcommand{\smrauthor}[1]{\def\smr@author{#1}}
\newcommand{\smraffiliation}[1]{\def\smr@affiliation{#1}}
%Remember the documents title (\thetitle might get overwritten)
\fancyhead[LE]{\raggedright%
  \quad\\
  \ifdefined\smr@title\else%
    \message{LaTeX Warning: using main title for header. Change with \noexpand\smrtitle}%
    \def\smr@title{\thetitle}\fi
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


% Invoke the base class
\LoadClass{article}
% Can't require this class before \if@titlepage is defined
%  (which amsart does)
\RequirePackage{titling}
%\thetitle gets corrupted on a new \section, so...
\appendiargdef{\title}{\protected@xdef\@mydoctitle{\thetitle}}

\titleclass{\section}[0]{straight}
%\renewcommand{\thesubsection}{\arabic{section}}
\titleformat{\section}
  {\normalfont\Large\bfseries}   % The style of the section title
  {}                             % a prefix
  {0pt}                          % How much space exists between the prefix and the title
  {\makebox[1.2cm][l]{\thesection:}}            % How the section is represented
\titlespacing*{\section}{0pt}{*1.5}{*0.4}
% Starred variant
\titleformat{name=\section,numberless}
  {\normalfont\Large\bfseries}
  {}
  {0pt}
  {}
\titlespacing*{name=\section,numberless}{0pt}{*1.0}{*0.4}

\titleclass{\subsection}{straight}[\section]
%\renewcommand{\thesubsection}{\arabic{subsection}}
\titleformat{\subsection}
  {\normalfont\large\bfseries}   % The style of the section title
  {}                             % a prefix
  {0pt}                          % How much space exists between the prefix and the title
  {\makebox[1.2cm][l]{\thesubsection:}}    % How the section is represented

\titlespacing*{\subsection}{0pt}{*0.8}{*0.4}
% Starred variant
\titleformat{name=\subsection,numberless}
  {\normalfont\large\bfseries}
  {}
  {0pt}
  {}
\titlespacing*{name=\subsection,numberless}{0pt}{*0.8}{*0.4}

\thispagestyle{empty}
\pagestyle{fancy}
\AtBeginDocument{
}
% \par
% \vspace*{0.5ex plus 0.3ex minus 0.2ex}
% \begin{center}
%  {\Huge\smr@title}\\[1.5ex plus 1ex minus 0.5ex]
%  {\huge\smr@author, \smr@affiliation}
% \end{center}
% \vspace*{0.8ex plus 0.2ex minus 0.1ex}
% }
