
import os
import sys
sys.path.append(".")
def setup():
    from pyparsesas.pyparsesas import SASParser
    return SASParser
def test_parsing():
    SASParser = setup()
    test_paths = {
        "test/test_src/input.sas": 11,
        "test/test_src/input_ds.sas":1,
        "test/test_src/input_macro.sas":2,
        "test/test_src/input_macro2.sas":2,
        "test/test_src/test_include.sas":9,
        "test/test_src/test_procsort.sas":1,
        "test/test_src/test_procsql.sas":3,
        "test/test_src/quoted_macro_ds.sas":1,
        "test/test_src/test_procsql_insert.sas":1,
    }
    for test_path, expected_length in test_paths.items():
        with open(test_path) as f:
            parsed = SASParser(f.read())       
        assert len(parsed.code_steps) == expected_length
