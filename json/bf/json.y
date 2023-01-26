%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "json.h"
%}

%token EMPTY COMMA COLON SEMICOLON B_TRUE B_FALSE

%%

json: B_TRUE;

%%
