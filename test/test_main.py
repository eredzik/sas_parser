
import os
import sys
sys.path.append(".")
def setup():
    from pyparsesas.pyparsesas import SASParser
    return SASParser

SASParser = setup()

def run_parsing(test_path, expected_length):
    with open(test_path) as f:
        try:
            parsed = SASParser(f.read())       
        except:
            raise Exception(test_path)
        assert len(parsed.code_steps) == expected_length

def test_macro():
    test_paths = {
        "test/test_src/input_macro.sas":2,
        "test/test_src/input_macro2.sas":2,
        "test/test_src/input_macro3.sas":1,
        "test/test_src/macro_let_recursive.sas":5,
    }
    for test_path, expected_length in test_paths.items():
        run_parsing(test_path, expected_length)

def test_sql():
    test_paths = {
        "test/test_src/test_procsql.sas":3,
        "test/test_src/test_procsql_insert.sas":1,
    }
    for test_path, expected_length in test_paths.items():
        run_parsing(test_path, expected_length)

def test_other():
    test_paths = {
        "test/test_src/input.sas": 11,
        "test/test_src/input_ds.sas":1,
        "test/test_src/test_include.sas":9,
        "test/test_src/test_procsort.sas":1,
        "test/test_src/quoted_macro_ds.sas":1,
    }
    for test_path, expected_length in test_paths.items():
        run_parsing(test_path, expected_length)
