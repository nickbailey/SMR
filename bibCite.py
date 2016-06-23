#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 23 11:41:55 2016

@author: keziah
"""

import sys

class bibCite():
    ''' Replace citations in a .tex file with the correct \cite{} command.
    
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

        # dictionary of strings to look for in the text (keys) and the bibtex
        # IDs (values) with which to replace them
        self.citations = {}

        # fill dictionary
        self.readBibFile()    
        
        # replace citations
        self.replaceCitations()


    def _lookForClosedBrackets(self, nCurrent):
        
        m = nCurrent
        
        # ignore '}' where there have been other '{'s
        # start at -1 as it will find the initial '{'
        ignore = -1

        while True:
            
            if self.bib[m] == '{':
                ignore += 1
                
            if self.bib[m] == '}' and ignore != 0:
                ignore -= 1
                
            elif self.bib[m] == '}' and ignore == 0:
                return m

            m += 1
            

    def readBibFile(self):
        
        f = open(self.bibFile, 'r')
        
        self.bib = f.read()
        
        f.close()
        
        idx = 0
        
        while True:
            
            idx = self.bib.find('@', idx)
            if idx == -1:
                break
            
            if self.bib[idx+1:idx+8] != 'comment':
                # index of end of entry
                endIdx = self._lookForClosedBrackets(idx)

                # find citation ID
                idx0 = self.bib.find('{', idx) + 1
                idx1 = self.bib.find(',', idx0)
                citeID = self.bib[idx0:idx1]

                authorIdx = self.bib.find('author', idx, endIdx)
                
                # if there is no author field, look for editor
                if authorIdx == -1:
                    authorIdx = self.bib.find('editor', idx, endIdx)
                
                idx0 = self.bib.find('{', authorIdx)
                idx1 = self._lookForClosedBrackets(idx0)
                
                authorStr = self.bib[idx0:idx1]

                # find the number of authors
                authorCount = authorStr.split().count('and') + 1

                # create correct author list to look for in the text
                if authorCount == 1:
                    commaIdx = authorStr.find(',')
                    author = authorStr[1:commaIdx]

                elif authorCount == 2:
                    commaIdx = authorStr.find(',')
                    author1 = authorStr[1:commaIdx]

                    andIdx = authorStr.find(' and ') + 5
                    commaIdx = authorStr.find(',', andIdx)
                    author2 = authorStr[andIdx:commaIdx]

                    author = '{} & {}'.format(author1, author2)
                    
                elif authorCount > 2:
                    commaIdx = authorStr.find(',',)
                    author1 = authorStr[1:commaIdx]
                    author = '{} et al.'.format(author1)
                    
                yearIdx = self.bib.find('year', idx, endIdx)

                idx0 = self.bib.find('{', yearIdx)
                idx1 = self._lookForClosedBrackets(idx0)
                
                year = self.bib[idx0+1:idx1]

                # create citation
                citation = '{} {}'.format(author, year)
                
                if citation in self.citations.keys():
                    
                    rename = ''.join([citation, 'a'])
                    
                    self.citations[rename] = self.citations[citation]
                    
                    self.citations.pop(citation)
                    
                    citation = ''.join([citation, 'b'])
                    
                self.citations[citation] = citeID

            idx += 1

            
    def replaceCitations(self):
        
        f = open(self.texFile, 'r')
        
        tex = f.read()
        
        f.close()
        
        for k in self.citations.keys():
            
            idx = 0
            
            # replacement string
            cite = '\cite{{{}}}'.format(self.citations[k])
            
            while True:
            
                idx = tex.find(k, idx)
                
                if idx == -1:
                    break
                
                else: 
                    tex = ''.join([tex[:idx], cite, tex[idx+len(k):]])
                    
                idx += 1
                
        # write new .tex file
        f = open(self.outFile, 'w')
            
        f.write(tex)
        
        f.close()  


if __name__ == '__main__':

    bibCite(sys.argv)