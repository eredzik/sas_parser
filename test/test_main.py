import os
import sys
sys.path.append(".")
def setup():
    os.system("antlr4 -Dlanguage=Python3 sas_parser.g4 -o pyparsesas/antlr4_artifacts")
    from pyparsesas.pyparsesas import SASParser
    return SASParser
def test_parsing():
    SASParser = setup()
    test_paths = [
        "test/test_src/input.sas",
        "test/test_src/input.sas",
        "test/test_src/input_ds.sas",
        "test/test_src/input_macro.sas",
        "test/test_src/input_macro2.sas",
        "test/test_src/test_include.sas",
        "test/test_src/test_procsort.sas",
        "test/test_src/test_procsql.sas"
    ]
    for test_path in test_paths:
        SASParser(test_path)

    
