grammar sas_parser;



parse:
    (datastep
    | procsql
    | macro_declaration
    | let_stmnt )*
;

datastep:
    data_stmnt
    (
        set_stmnt
        |merge_stmnt
    )*
    RUN
;

data_stmnt: DATA dotted_identifier ';';
set_stmnt: SET (dotted_identifier datastep_dataset_options?)+ ';';
merge_stmnt: MERGE (dotted_identifier datastep_dataset_options?)+ ';';


datastep_dataset_options:
    '('
      (datastep_where
    | datastep_rename
    | datastep_in)*
    
    ')'
;
datastep_where:
    WHERE '=' '(' datastep_math ')';
datastep_rename: 
    RENAME '=' '('
    macro_identifier '=' macro_identifier
    ')'
;
datastep_in:
    IN '=' macro_identifier
;

datastep_math:
    datastep_math_col (operators (datastep_math_col)+)?
;
datastep_math_col: macro_identifier | CONST;

procsql:
    procsql_stmnt
    select_stmnt
    from_stmnt
    where_stmnt?
    groupby_stmnt?
    having_stmnt?
    ';'
    QUIT
;
procsql_stmnt:
    PROC SQL NOPRINT? ';'
    
;

select_stmnt:
    SELECT sqlcolumns
;


sqlcolumns: (sql_math sqlalias?) (',' (sql_math sqlalias?))*;
sqlcol_prefix: (macro_identifier '.' )*(macro_identifier | STAR);

from_stmnt:
    FROM sqltables
;

sqltables: sqltable (',' sqltable)*;
sqltable: dotted_identifier sqlalias?;
sqlalias: (AS? macro_identifier) ;
where_stmnt:
    WHERE sql_math
;

sql_math: ((sqlcol_prefix | CONST ) (operators (sqlcol_prefix | CONST ))*)*;
groupby_stmnt:
    GROUPBY sqlcolumns
;
having_stmnt:
    HAVING sql_math
;

dotted_identifier:
    ((Identifier | macrocall | Macrovar) '.')? 
    (Identifier | macrocall | Macrovar)
    ;

macro_identifier: 
    (Identifier | macrocall | Macrovar);

Macrovar: '&' Identifier '.'?;
functioncall : macro_identifier ( '(' arguments ')')?;
macrocall: '%' functioncall;
arguments: (macro_identifier (',' macro_identifier)* (',' macro_identifier '=' macro_identifier?)*)* ;
macro_declaration: 
    Macro_begin macro_identifier 
    ('(' arguments ')')? ';'
    parse
    Macro_end macro_identifier? ';'
;
operators: not_op? (MATH_OP | LOGICAL_OP | COMPARISON_OP | '=') ; 
let_stmnt: Macro_let macro_identifier '=' macro_identifier ';';
STAR: '*';
MATH_OP: STAR | '/' | '+' | '-' | '**';
LOGICAL_OP: AND | OR;
Macro_begin: '%' M A C R O;
Macro_end: '%' M E N D;
Macro_let: '%' L E T;
SELECT: S E L E C T;
FROM: F R O M;
AS: A S;
WHERE: W H E R E;
GROUPBY: G R O U P B Y;
HAVING: H A V I N G;
NOPRINT: N O P R I N T;
PROC: P R O C;
SQL: S Q L;
RUN: R U N ';';
QUIT: Q U I T ';';
DATA: D A T A;
SET: S E T;
MERGE: M E R G E;
RENAME: R E N A M E ;
IN: I N;
SINGLE_Q: '\'';
DOUBLE_Q: '"';
CHAR_LITERAL: ANY_Q .+? ANY_Q; 
ANY_Q: SINGLE_Q | DOUBLE_Q;
CONST: CHAR_LITERAL | NUM_LITERAL;
NUM_LITERAL: [0-9] ('.')?  ([0-9])* ;
not_op: '^' | 'not';
COMPARISON_OP: 
    '>'
    |'<'
    |'<='
    |'>='
    |'ge'
    |'ne'
    |'gt'
    |'lt'
    |'le'
    |'eq'
;
AND: A N D;
OR: O R;

NUMBER: [0-9] ('.' [0-9])*;

fragment A : [aA]; // match either an 'a' or 'A'
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];
WS : [ \t\r\n]+ -> skip ;
Identifier : [a-zA-Z] [a-zA-Z0-9]*;
COMMENT1: '/' '*' .*? '*' '/' -> channel(2);
COMMENT2: '%' '*' .*? ';' -> channel(2);

