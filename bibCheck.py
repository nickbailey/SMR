#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import re

class bibCheck():
    ''' Parse a .bib file, add commas where they are missing from the end of a 
        line.
        
        Print lines (and line numbers) which will be altered.
    
        Parameters:
            
            bibFile: .bib file to check for missing commas
            
            outFile (optional): .bib file to write to. If None, the input .bib 
                                file will be overwritten
    '''
    
    def __init__(self, sysArgv):
        
        self.bibFile = sysArgv[1]

        if len(sysArgv) == 2:
            self.outFile = sysArgv[1]
    
        else:
            self.outFile = sysArgv[2]

        # read file, note missing commas
        self.readBibFile()
        
        # if commas have been missed, write new .bib file
        if len(self.addComma) > 0:
            self.writeBibFile()
            
        else:
            print('No changes made')
            

    def readBibFile(self):
        
        f = open(self.bibFile, 'r')
        
        self.bib = f.read()
        
        f.close()

        # find the beginning of each entry
        bibEntries = re.finditer(r'(@\w+\{)', self.bib)
        
        # indices of beginning of each entry
        indices = list(b.span()[0] for b in bibEntries)
        
        indices.append(len(self.bib))
        
        self.addComma = []
        
        for i in range(len(indices)-1):
            
            # create string for each entry
            s = self.bib[indices[i]:indices[i+1]]

            # ignore comments
            if s[:8] != '@comment':
                
                # look for @thing{ID
                bibEntry = re.search(r'(@\w+\{\w+)', s)

                # if not terminated with a comma, add index to list
                if s[bibEntry.span()[1]] != ',':
                
                    index = indices[i]+bibEntry.span()[1]
                    
                    self.addComma.append(index)
                    
                    lineNum = len(re.findall(r'\n', self.bib[:index])) + 1
                    
                    print('----- line {} -----\n{}\n'.format(lineNum, 
                          s[bibEntry.span()[0]:bibEntry.span()[1]+1]))
                
                # look for each thing = {} in the entry
                fields = re.finditer(r'\w+ *= *\{.+\}', s)
                
                for f in fields:
                    
                    # if not terminated with a comma, add index to list
                    if s[f.span()[1]] != ',':
                        
                        index = indices[i]+f.span()[1]
                        
                        self.addComma.append(index)
                        
                        lineNum = len(re.findall(r'\n', self.bib[:index])) + 1
                        
                        print('----- line {} -----\n{}\n'.format(lineNum, 
                              s[f.span()[0]:f.span()[1]+1]))


    def writeBibFile(self):

        for n in reversed(self.addComma):

            self.bib = ''.join([self.bib[:n], ',', self.bib[n:]])
        
        # write new .bib file
        f = open(self.outFile, 'w')
            
        f.write(self.bib)
        
        f.close()  
                
                
if __name__ == '__main__':
        
    bibCheck(sys.argv)
