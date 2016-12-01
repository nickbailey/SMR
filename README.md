# SMR
Here are the XeLaTeX files associated with the
Scottish Music Review The class and decoration
pdfs are in the `LaTeX_Class` directory,
along with an example article which uses
lilypond-book for musical inclusions.
Instructions for building it are in the
.lytex file.

This folder also contains an "empty" article
as a sort of template.

##Installation
Make sure the .cls and .pdf files from the
LaTeX_Class folder are where XeLaTeX can see
them. You will also need to place the BibTeX
style file, `SMR.bst` somewhere it can be
accessed by BibTeX.

On my Debian Linux computer, this means

  * `$HOME/texmf/tex/` for the SMR directory, and
  * `$HOME/texmf/bibtex/bst/` for the bibliography style file.
