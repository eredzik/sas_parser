import os
from antlr4 import InputStream, CommonTokenStream
from antlr4.tree.Tree import TerminalNodeImpl

class SASParser():
    def __init__(self):
        self.inputs_map = {
            'from_stmnt':
                {'sqltable':
                    {'dotted_identifier':
                        'input'}},
            'join_stmnt':
                {'sqltable':{
                    'dotted_identifier':
                        'input'}},
            'data_stmnt':
                {'datastep_dset':
                    'output'},
            'set_stmnt': 
                {'datastep_dset':
                    'input'},
            'create_stmnt':
                {'sqltable':
                    'output'},
            'procappend':
                {'appendinput':{'macro_identifier':'input'},
                'appendoutput':{'macro_identifier':'output'}}
        }
        
        
        os.system("antlr4 -Dlanguage=Python3 sas_parser.g4 -o tmp")
        from tmp.sas_parserLexer import sas_parserLexer
        from tmp.sas_parserParser import sas_parserParser
        with open("input.sas") as f:
            self.lines = f.read()
        # print(lines)
        self.lexer = sas_parserLexer(InputStream(self.lines))
        self.parser = sas_parserParser(CommonTokenStream(self.lexer))
        self.tree = self.parser.parse()
        self.parsed_steps = []
        self.code_steps = []
        self.get_code_steps()
        self.traverse(self.tree, self.parser.ruleNames, self.inputs_map)

    def get_code_steps(self):
        for child in self.tree.children:
            self.code_steps.append((child.start.start, child.stop.stop, child.getText()))

    def traverse(self, tree, rule_names, rule_dict):
        
        if tree.getText() == "<EOF>" or isinstance(tree, TerminalNodeImpl):
            return
        else:
            rule_matched = rule_dict.get(rule_names[tree.getRuleIndex()])
            if rule_matched:
                if type(rule_matched) == dict:
                    for child in tree.children:
                        self.traverse(child, rule_names, rule_matched)
                else:
                    # print(rule_matched, '->', tree.getText(), tree.start.start, tree.start.stop, tree.stop.start, tree.stop.stop)
                    self.parsed_steps.append((tree.start.start, tree.stop.stop, tree.getText()))
                    # print(self.lines[tree.start.start: tree.stop.stop+1])
            else:
                for child in tree.children:
                    self.traverse(child, rule_names, rule_dict)
            
if __name__ == '__main__':
    sasparser = SASParser()
    x=1
    pass