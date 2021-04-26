expr4
   : expr4 'to' expr5
   | expr4 'to' expr5 'by' expr5
   | expr5
   ;

expr5
   : expr5 '|' expr6
   | expr6
   ;

expr6
   : expr6 '<' expr7
   | expr6 '<=' expr7
   | expr6 '=' expr7
   | expr6 '>=' expr7
   | expr6 '>' expr7
   | expr6 '~=' expr7
   | expr6 '<<' expr7
   | expr6 '<<=' expr7
   | expr6 '==' expr7
   | expr6 '>>=' expr7
   | expr6 '>>' expr7
   | expr6 '~==' expr7
   | expr6 '===' expr7
   | expr6 '~===' expr7
   | expr7
   ;

expr7
   : expr7 '||' expr8
   | expr7 '|||' expr8
   | expr8
   ;

expr8
   : expr8 '+' expr9
   | expr8 '-' expr9
   | expr8 '++' expr9
   | expr8 '--' expr9
   | expr9
   ;

expr9
   : expr9 '*' expr10
   | expr9 '/' expr10
   | expr9 '%' expr10
   | expr9 '**' expr10
   | expr10
   ;

expr10
   : expr11 '^' expr10
   | expr11
   ;

expr11
   : expr11 '\\' expr12
   | expr11 '@' expr12
   | expr11 '!' expr12
   | expr12
   ;

expr12
   : 'not' expr12
   | '|' expr12
   | '!' expr12
   | '*' expr12
   | '+' expr12
   | '-' expr12
   | '.' expr12
   | '/' expr12
   | '\\' expr12
   | '=' expr12
   | '?' expr12
   | '~' expr12
   | '@' expr12
   | '^' expr12
   | expr13
   ;

expr13
   : '(' expression_list ')'
   | '{' expression_sequence '}'
   | '[' expression_list ']'
   | expr13 '.' field_name
   | expr13 '(' expression_list ')'
   | expr13 '{' expression_list '}'
   | expr13 '[' subscript_list ']'
   | identifier
   | keyword
   | literal
   ;

expression_list
   : expression_opt
   | expression_list ',' expression_opt
   ;

subscript_list
   : subscript_
   | subscript_list ',' subscript_
   ;

subscript_
   : expression
   | expression ':' expression
   | expression '+:' expression
   | expression '-:' expression
   ;

keyword
   : '&' identifier
   ;

identifier
   : IDENTIFIER
   ;

literal
   : string_literal
   | integer_literal
   | real_literal
   ;

string_literal
   : STRING_LITERAL
   ;

real_literal
   : REAL_LITERAL
   ;

integer_literal
   : INTEGER_LITERAL
   ;


IDENTIFIER
   : [a-zA-Z] [a-zA-Z0-9]*
   ;


INTEGER_LITERAL
   : ('0' .. '9') +
   ;


REAL_LITERAL
   : ('0' .. '9')* '.' ('0' .. '9') + (('e' | 'E') ('0' .. '9') +)*
   ;


STRING_LITERAL
   : '"' ~ ["]* '"'
   ;


WS
   : [ \t\r\n] -> skip
   ;
