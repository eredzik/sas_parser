<h1> SAS 4GL parser in antlr4 </h1>

Purpose of this project is to create a working SAS 4GL parser that can handle regular syntax as well as macro syntax. <br>
Project requires antlr4 and python 3.

<h1> How to run </h1>

    antlr4 -Dlanguage=Python3 sas_parser.g4 -o pyparsesas/antlr4_artifacts
    python ./pyparsesas
