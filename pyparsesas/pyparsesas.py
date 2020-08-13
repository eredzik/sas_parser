import os
from antlr4 import InputStream, CommonTokenStream
from antlr4.tree.Tree import TerminalNodeImpl

class SASParser():
    def __init__(self, sascode):
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
            'ds_set':{
                'datastep_dset':{
                    'dotted_identifier':'input'
                }
            },
            'create_stmnt':
                {'sqltable':
                    'output'},
            'procappend':
                {'appendinput':{'macro_identifier':'input'},
                'appendoutput':{'macro_identifier':'output'}}
        }
        this_folder = os.path.dirname(__file__)
        grammar_file = os.path.join(this_folder, "sas_parser.g4")
        pyparantlr4_artifacts = os.path.join(this_folder, "antlr4_artifacts")
        os.system(f"antlr4 -Dlanguage=Python3 {grammar_file} -o {pyparantlr4_artifacts}")
        from .antlr4_artifacts.sas_parserLexer import sas_parserLexer
        from .antlr4_artifacts.sas_parserParser import sas_parserParser
        self.lines = sascode
        self.lexer = sas_parserLexer(InputStream(self.lines))
        self.parser = sas_parserParser(CommonTokenStream(self.lexer))
        self.tree = self.parser.parse()
        self.parsed_steps = []
        self.code_steps = []
        self.get_code_steps()
        self.traverse(self.tree, self.parser.ruleNames, self.inputs_map)
        self.code_split = self.build_output_dict()
    def get_code_steps(self):
        for child in self.tree.children:
            if hasattr(child, "symbol"):
                print(child.getText())
            else:
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
                    self.parsed_steps.append((tree.start.start, tree.stop.stop, tree.getText(), rule_matched))
                    # print(self.lines[tree.start.start: tree.stop.stop+1])
            else:
                for child in tree.children:
                    self.traverse(child, rule_names, rule_dict)
    def build_output_dict(self):
        result={"input":{}, "output":{}}
        for start_point, stop_point, dataset_name, type_of_step in self.parsed_steps:
            for step_start, step_stop, code in self.code_steps:
                if start_point >= step_start and stop_point <= step_stop:
                    if result[type_of_step].get(code):
                        result[type_of_step][code].append(dataset_name)
                    else:
                        result[type_of_step][code] = [dataset_name]
        return result