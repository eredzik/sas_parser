grammar sas_parser;



parse:
    (datastep
    | procsql
    | macro_declaration
    | let_stmnt 
    | procappend
    | macrocall)*
;


procappend:
    PROC APPEND
    procappend_dsets*
    ';'
    RUN 
;

datastep:
    data_stmnt
    (
        set_stmnt
        |merge_stmnt
    )*
    RUN
;

data_stmnt: DATA datastep_dset ('/' datastep_options)? ';';
datastep_options: VIEW '=' Identifier;
set_stmnt: SET (datastep_dset datastep_dataset_options?)+ ';';
merge_stmnt: MERGE (dotted_identifier datastep_dataset_options?)+ ';';
datastep_dset: dotted_identifier; 


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
    (sqlselect_stmnt | sqlupdate_stmnt)
    
    (QUIT | RUN)
;

sqlselect_stmnt:
    create_stmnt?
    select_stmnt
    from_stmnt
    join_stmnt*
    where_stmnt?
    groupby_stmnt?
    having_stmnt?
    ';';



procsql_stmnt: PROC SQL NOPRINT? ';' ;
create_stmnt: CREATE (TABLE | VIEW) sqltable AS;
select_stmnt: SELECT sqlcolumns;
from_stmnt: FROM sqltable (',' sqltable)*;
join_stmnt: (LEFT | RIGHT)? JOIN sqltable ON sql_math;
where_stmnt: WHERE sql_math;
groupby_stmnt: GROUPBY sqlcolumns;
having_stmnt: HAVING sql_math;

sqlupdate_stmnt: 
    update_stmnt
    setsql_stmnt?
    where_stmnt?
    ';'
    
;
update_stmnt: UPDATE TABLE sqltable;
setsql_stmnt: SET sqlcolumns;

sql_col_macro: (sqlcol_prefix | CONST | macrocall | ('(' sqlselect_stmnt ')'));
sql_math: (sql_col_macro (operators sql_col_macro)*) ;

sqlcolumns: (sql_math sqlalias?) (',' (sql_math sqlalias?))*;
sqlcol_prefix: (macro_identifier '.' )?(macro_identifier | STAR);

sqltable: dotted_identifier sqlalias?;
sqlalias: (AS? macro_identifier) ;


dotted_identifier:
    ((Identifier | macrocall | Macrovar) '.')? 
    (Identifier | macrocall | Macrovar)
    ;

macro_identifier: 
    (Identifier | macrocall | Macrovar);

macro_declaration: 
    Macro_begin functioncall';'
    parse
    Macro_end macro_identifier? ';'
;

macrocall: '%' functioncall;
functioncall : macro_identifier ('(' funcargs ')')? ';'?;
funcargs:
    macro_identifier? (',' macro_identifier)*
    (','? macro_identifier '=' (macro_identifier | CONST))* 
    
;
procappend_dsets:
    (appendinput | appendoutput)
     
;

appendoutput: (OUT | BASE ) '=' macro_identifier;
appendinput: DATA  '=' macro_identifier;

Macrovar: '&' Identifier '.'?;
operators: NOT_OP? (STAR | MATH_OP | LOGICAL_OP | COMPARISON_OP | '=') ; 
let_stmnt: Macro_let macro_identifier '=' macro_identifier ';';
STAR: '*';
MATH_OP: '/' | '+' | '-' | '**';
LOGICAL_OP: AND | OR;
Macro_begin: '%' M A C R O;
Macro_end: '%' M E N D;
Macro_let: '%' L E T;
VIEW: V I E W;
CREATE: C R E A T E;
SELECT: S E L E C T;
FROM: F R O M;
AS: A S;
LEFT: L E F T;
RIGHT: R I G H T;
JOIN: J O I N;
ON: O N;
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
UPDATE: U P D A T E ;
TABLE: T A B L E ;
APPEND: A P P E N D ;
OUT: O U T ;
BASE: B A S E ;
IN: I N;
SINGLE_Q: '\'';
DOUBLE_Q: '"';
CHAR_LITERAL: ANY_Q .+? ANY_Q; 
ANY_Q: SINGLE_Q | DOUBLE_Q;
CONST: CHAR_LITERAL | NUM_LITERAL;
NUM_LITERAL: [0-9]+ ('.')?  ([0-9])* ;
NOT_OP: '^' | 'not';
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
Identifier : [a-zA-Z_] [a-zA-Z0-9_]*;
COMMENT1: '/' '*' .*? '*' '/' -> channel(2);
COMMENT2: '%' '*' .*? ';' -> channel(2);

