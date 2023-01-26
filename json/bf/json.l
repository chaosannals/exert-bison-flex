%option noyywrap nodefault yylineno

%{
    #include "json.h"
    #include "json.tab.h"
%}

DIGIT [0-9]
DIGITS DIGIT DIGITS*

%%

"" { return EMPTY; }
"," { return COMMA; }
":" { return COLON; }
";" { return SEMICOLON; }
"true" { return B_TRUE; }
"false" { return B_FALSE; }

%%
