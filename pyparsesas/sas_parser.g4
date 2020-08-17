grammar sas_parser;



parse:
    ((datastep
    | procsql
    | macro_declaration
    | macro_do
    | macro_if
    | macro_global
    | macro_local
    | let_stmnt 
    | put_stmnt
    | procappend
    | procsort
    | include_stmnt
    | libname_stmnt
    | macrocall
    ) ';'?)*
;

libname_stmnt: LIBNAME macro_identifier 
    (('(' macro_identifier ')') |
     string_const
    )
    ';';
include_stmnt: INCLUDE (string_const | macro_identifier) ( '/' macroargs)?';';

macrocall: '%' macro_identifier ('(' 
    macroargs
 ')')?
 ';'?;
 macroargs: (macro_string)? (',' (macro_string)*)*
    (','? macro_identifier '=' (macro_string)*?)* ;

functioncallsql  :macro_identifier ('(' (funcargssql ) ')') ;

funcargssql:
    (dotted_identifier | STAR | functioncallsql | macrocall | string_const)? (',' (dotted_identifier | STAR | functioncallsql | macrocall | string_const))*
    (','? macro_identifier '=' (dotted_identifier | STAR | functioncallsql | macrocall | string_const)?)* 
;
functioncall : macro_identifier ('(' funcargs ')') ;

funcargs:
    dotted_identifier? (',' (macro_string))*
    (','? macro_identifier '=' (macro_string)?)* 
;

procappend:
    PROC APPEND
    procappend_dsets*
    ';'
    RUN 
;


procsort:
    PROC SORT procsort_dsets* NODUPKEY?';'
    BY macro_identifier* ';'
    RUN 
;

datastep:
    data_stmnt
    ds_stmnts
    RUN
;

data_stmnt: DATA datastep_dset ('/' datastep_options)? ';';
datastep_options: VIEW '=' Identifier;
ds_set: SET (datastep_dset datastep_dataset_options?)+ ';';
ds_length: LENGTH ((macro_identifier | ds_allowed_keywords) ('$'? NUM_LITERAL)?)+ ';';
ds_merge: MERGE (dotted_identifier datastep_dataset_options?)+ ';';
ds_assign: 
    macro_identifier '=' (
    datastep_math | 
    macro_identifier | 
    functioncall |
    macrocall
    ) ';';
ds_stmnts: (ds_assign | ds_if_then_stmnt | ds_set | ds_merge | ds_do_block |macrocall | ds_length ';'*)*;
ds_if_then_stmnt: IF datastep_math THEN (ds_assign | ds_if_then_stmnt | ds_set | ds_merge | ds_do_block |macrocall) ;
ds_do_block: 
DO 
(
    (
      (Identifier) '=' (datastep_math) TO string_const (BY string_const)?)
    | ((WHILE | UNTIL) '(' datastep_math ')' )
)? ';'
 (ds_assign | ds_if_then_stmnt | ds_set | ds_merge | ds_do_block |macrocall)*
END ';'
;


datastep_dset: dotted_identifier ; 


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

datastep_math
    : '(' datastep_math ')'
    | datastep_math_col IN '(' (datastep_math (',' datastep_math)*) ')' operators (datastep_math_col | datastep_math)*
    | datastep_math_col (operators (datastep_math_col | datastep_math))*
;

datastep_math_col: macro_identifier | string_const;


procsql:
    procsql_stmnt
    (sqlselect_stmnt | sqlupdate_stmnt | sqlinsert_stmnt)
    ';'*
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
    order_stmnt?
    ';';



procsql_stmnt: PROC SQL NOPRINT? ';' ;
create_stmnt: CREATE (TABLE | VIEW) sqltable AS;
select_stmnt: SELECT sqlcolumns into_stmnt?;
into_stmnt: INTO (':' macro_identifier) (',' ':' macro_identifier)* ;
from_stmnt: FROM sqltable (',' sqltable)*;
join_stmnt: (LEFT | RIGHT)? JOIN sqltable ON sql_math;
where_stmnt: WHERE sql_math;
groupby_stmnt: GROUP BY sqlcolumns;
having_stmnt: HAVING sql_math;
order_stmnt: ORDER BY sql_math (',' sql_math)*;

sqlupdate_stmnt: 
    update_stmnt
    setsql_stmnt?
    where_stmnt?
    ';'
    
;

sqlinsert_stmnt:
    INSERT INTO sqltable
    (('(' sqlcolumns ')'
    VALUES
    '(' sqlcolumns ')' ';') | sqlselect_stmnt)
;
update_stmnt: UPDATE TABLE sqltable;
setsql_stmnt: SET sqlcolumns;

sql_col_macro
    : (sqlcol_prefix
    | NUM_LITERAL
    | string_const
    | macrocall
    | functioncallsql
    | ('(' sqlselect_stmnt ')'))*;
sql_math
    : ('(' sql_math ')')
    | sql_col_macro
    | (sql_col_macro (operators sql_col_macro)*)
;

sqlcolumns: (sql_math sqlalias?) (',' (sql_math sqlalias?))*;
sqlcol_prefix: (macro_identifier '.' )?(macro_identifier | STAR);

sqltable
    : ('(' sqltable')')
    | (dotted_identifier sqlalias? )
    | (sqlselect_stmnt)
;
sqlalias: (AS? macro_identifier) ;


dotted_identifier:
    ((macro_identifier | macrocall | Macrovar | NUM_LITERAL) '.')? 
    (macro_identifier | macrocall | Macrovar | NUM_LITERAL)
    ;


macro_identifier: 
    (Identifier | macrocall | Macrovar | any_keyword);
macro_string
    : '(' macro_string ')'
    |(macro_identifier | functioncall | '.' | '&' | string_const | '=' | ':' | '/' | '\\' | '$' | '!' | operators | AcceptableString)+;
macro_declaration: 
    Macro_begin macro_identifier ('(' funcargs ')')? ';'?';'
    parse
    Macro_mend macro_identifier? ';'
;

macro_global: Macro_global macro_identifier+ ';' ;
macro_local: Macro_local macro_identifier+ ';' ;
macro_if:
Macro_if datastep_math Macro_then (let_stmnt | put_stmnt | macro_do)
(Macro_else (let_stmnt | put_stmnt | macro_do | macro_if))*
;

macro_do:
Macro_do
    (Identifier '=' (macro_identifier | NUM_LITERAL) Macro_to ( macro_identifier | NUM_LITERAL) (Macro_by (macro_identifier | NUM_LITERAL))?)?
    
';'
parse
Macro_end ';'
;


procappend_dsets: (proc_base | proc_out | proc_data);
procsort_dsets: (proc_in | proc_out | proc_data | proc_dupout);

proc_dupout: DUPOUT '=' dotted_identifier;
proc_in: IN '=' dotted_identifier;
proc_base: BASE '=' dotted_identifier;
proc_out: OUT '=' dotted_identifier;
proc_data: DATA  '=' dotted_identifier;

operators: NOT_OP? (STAR | MATH_OP | LOGICAL_OP | COMPARISON_OP | '=' | NOT_OP | IN) ; 
let_stmnt: Macro_let macro_identifier '=' macro_string ';'?;
put_stmnt: Macro_put macro_string* ';';

ds_allowed_keywords
    : ORDER
    | SELECT 
    | FROM;
any_keyword
    : VIEW
    | CREATE
    | SELECT
    |INTO
    |FROM
    |INSERT
    |VALUES
    |LENGTH
    |LEFT
    |RIGHT
    |JOIN
    |ON
    |WHERE
    |GROUP
    |HAVING
    |ORDER
    |NOPRINT
    |PROC
    |SQL
    |RUN
    |QUIT
    |DATA
    |SET
    |MERGE
    |RENAME
    |UPDATE
    |TABLE
    |APPEND
    |SORT
    |OUT
    |BASE
    |IN
    |DUPOUT
    |NODUPKEY
    |LIBNAME
;
COLON: ':';
STAR: '*';
MATH_OP: '/' | '+' | '-' | '**';
LOGICAL_OP: AND | OR;
Macrovar: '&' Identifier '.'?;
Macro_begin: '%' M A C R O ' ';
Macro_mend: '%' M E N D;
Macro_let: '%' L E T;
Macro_put: '%' P U T;
Macro_do: '%' D O;
Macro_to: '%' T O;
Macro_by: '%' B Y ;
Macro_end: '%' E N D;
Macro_if: '%' I F;
Macro_else: '%' E L S E;
Macro_global: '%' G L O B A L ' ';
Macro_local: '%' L O C A L ' ';
Macro_then: '%' T H E N;
VIEW: V I E W;
CREATE: C R E A T E;
SELECT: S E L E C T ;
INTO: I N T O ;
FROM: F R O M;
AS: A S;
INSERT: I N S E R T;
VALUES: V A L U E S;
LENGTH: L E N G T H;
LEFT: L E F T;
RIGHT: R I G H T;
JOIN: J O I N;
ON: O N;
WHERE: W H E R E;
GROUP: G R O U P;
HAVING: H A V I N G;
ORDER: O R D E R ;
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
IF: I F;
THEN: T H E N;
DO: D O;
TO: T O;
BY: B Y;
WHILE: W H I L E ;
UNTIL: U N T I L ;
END: E N D;
TABLE: T A B L E ;
APPEND: A P P E N D ;
SORT: S O R T;
OUT: O U T ;
BASE: B A S E ;
IN: I N;
DUPOUT: D U P O U T;
NODUPKEY: N O D U P K E Y;
INCLUDE: '%' I N C L U D E;
LIBNAME: L I B N A M E;
SINGLE_Q: '\'';
DOUBLE_Q: '"';
string_const: (any_q macro_string* any_q) | NUM_LITERAL ;
any_q: SINGLE_Q | DOUBLE_Q;
NUM_LITERAL: [0-9]+ ('.' [0-9]+)* ;
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
AcceptableString: [a-zA-Z0-9\u0090-\u0200_]+;
COMMENT1: '/' '*' .*? '*' '/' -> channel(2);
COMMENT2: '%' '*' .*? ';' -> channel(2);

