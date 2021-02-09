%{
#include <stdio.h>
#include <stdlib.h>
#include "../src/utils.h"

extern int yylval;
extern int yy_flex_debug;

int yyerror(const char *msg);
int yylex();
int evaled = 0;
%}

%start s

%token NUMBER
%token MULT
%token DIV
%token PLUS
%token MINUS
%token LPAR
%token RPAR

%left PLUS MINUS
%left MULT DIV

%%

s
    : expr {
        if(!evaled)
          $1 = eval($1); // eval the non-evaled value to print
        printf("Print %s\n",get_str($1));
        YYACCEPT;
    }
;

expr
    : NUMBER					{ evaled = 0;                             /* this prod returns a non-evaled value , need to eval later */ }
    | expr PLUS  expr	{ $$ = eval(mix($1, 15, $3)); evaled = 1; /* this prod returns an evaled value */ }
    | expr MINUS expr	{ $$ = eval(mix($1, 16, $3)); evaled = 1; /* this prod returns an evaled value */ }
		| expr MULT  expr	{ $$ = eval(mix($1, 17, $3)); evaled = 1; /* this prod returns an evaled value */ }
		| expr DIV   expr	{ $$ = eval(mix($1, 18, $3)); evaled = 1; /* this prod returns an evaled value */ }
    | LPAR expr  RPAR	{ $$ = $2;                                /* this prod returns what inner expr returns */ }
;

%%

int main() {
	yy_flex_debug=0;
	return yyparse();
}
