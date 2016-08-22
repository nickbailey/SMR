#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import re

class bibCite():
    ''' Replace citations in a .tex file with the \citep{} command for natbib.
    
        It will look for citations of the form 'Author Year', 
        'Author1 & Author2 Year' or 'Author1 et al. Year' (where '&' may be 
        '\&' or 'and' and 'et al.' may or may not have a full stop.)
        
        The authors in the bibtex file should be listed in the form 'Surname,
        Forename'.
    
        Parameters:
            
            bibFile: .bib file
            
            texFile: .tex document
            
            outFile (optional): .tex file to write to. If None, the input .tex 
                                file will be overwritten
    '''
    
    def __init__(self, sysArgv):
        
        self.bibFile = sysArgv[1]

        self.texFile = sysArgv[2]
    
        if len(sysArgv) == 4:
            self.outFile = sysArgv[3]
    
        else:
            self.outFile = sysArgv[2]

        # fill dictionary of citations and citeIDs
        self.readBibFile()

        # replace citations
        self.replaceCitations()
            

    def readBibFile(self):
        
        f = open(self.bibFile, 'r')
        
        self.bib = f.read()
        
        f.close()
        
        # dictionary of strings to look for in the text (keys) and the bibtex
        # IDs (values) with which to replace them
        self.citations = {}

        # find the beginning of each entry
        bibEntries = re.finditer(r'(@\w+\{)', self.bib)
        
        # indices of beginning of each entry
        indices = list(b.span()[0] for b in bibEntries)
        
        indices.append(len(self.bib))
                
        for i in range(len(indices)-1):
            
            # create string for each entry
            s = self.bib[indices[i]:indices[i+1]]

            # ignore comments
            if s[:8] != '@comment':

                # find the ID
                citeID = s[s.index('{')+1:s.index(',')]

                # find the year
                yr = re.search(r'(year *= *\{.+\})', s)
                if yr is None:
                    year = ""
                else:    
                    year = s[s.index('{', yr.span()[0])+1:yr.span()[1]-1]

                # find the author
                athr = re.search(r'(author *= *\{.+\})', s)
                # if there is no author, lok for an editor
                if athr is None:
                    athr = re.search(r'(editor *= *\{.+\})', s)
                    authorStr = "UNKNOWN"
                else:
                    authorStr = s[s.index('{', athr.span()[0]):athr.span()[1]-1]

                # find the number of authors
                authorCount = authorStr.split().count('and') + 1

                # create correct author list to look for in the text
                if authorCount == 1:
                    commaIdx = authorStr.find(',')
                    author = [authorStr[1:commaIdx]]

                elif authorCount == 2:
                    commaIdx = authorStr.find(',')
                    author1 = authorStr[1:commaIdx]

                    andIdx = authorStr.find(' and ') + 5
                    commaIdx = authorStr.find(',', andIdx)
                    author2 = authorStr[andIdx:commaIdx]

                    author = ['{} \& {}'.format(author1, author2),
                              '{} & {}'.format(author1, author2),
                              '{} and {}'.format(author1, author2)]
                    
                elif authorCount > 2:
                    commaIdx = authorStr.find(',',)
                    author1 = authorStr[1:commaIdx]
                    author = ['{} et al.'.format(author1), 
                              '{} et al'.format(author1)]

                for a in author:
                    # create citation
                    citation = '{} {}'.format(a, year)
                    
                    # if this citation is already in the dictionary, add 'a'  
                    # and 'b' to the citations
                    if citation in self.citations.keys():
                        
                        # rename first instance
                        rename = ''.join([citation, 'a'])
                        
                        self.citations[rename] = self.citations[citation]
                        
                        # remove old citation
                        self.citations.pop(citation)
                        
                        # create new citation
                        citation = ''.join([citation, 'b'])
                        
                    # add citation and ID to dictionary
                    self.citations[citation] = citeID


    def replaceCitations(self):
        
        f = open(self.texFile, 'r')
        
        tex = f.read()
        
        f.close()
        
        for k in self.citations.keys():
            # replacement string
            cite = '\citep{{{}}}'.format(self.citations[k])
            
            replace = re.finditer(k, tex)
            
            indices = list(r.span() for r in replace)
            
            # go backwards through indices list, as altering the tex file will
            # change positions of characters later in the file
            for i in reversed(indices):
                # replace citation with \cite{ID}
                tex = ''.join([tex[:i[0]], cite, tex[i[1]:]])
                
        # write new .tex file
        f = open(self.outFile, 'w')
            
        f.write(tex)
        
        f.close()  


if __name__ == '__main__':

    bibCite(sys.argv)
