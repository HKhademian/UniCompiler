%{
#include "../gen/numstr.tab.h"
#include "../src/utils.h"

extern int yylval;
#define log(text) puts(text)
%}

%%
"*"         { return MULT; }
"/"         { return DIV; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"("         { return LPAR; }
")"         { return RPAR; }

[0-9]+      { // lex is nor recursive, to make it recursive I use yyless grabe one digit a time and forward remaining
    static int prev = -1;
    yylval = concat(prev, yytext[0] - '0');

    if(yyleng==4)
        yylval = join(wrap(yylval), 12, -1);
    else if(yyleng==3 || yyleng==6)
        yylval = join(yylval, 11, -1);
    else if(yyleng==2 || yyleng==5)
        yylval = join(yylval, 10, -1);
    else if(yyleng==1)
        yylval = yylval;
    else /*err*/
        exit(1);

    if(yyleng<=1){
        prev = -1;
        // printf("lex: %s\n", get_str(yylval));
        return NUMBER;
    }

    prev = yylval;
    yyless(1);
}

[ \r\n\t]*      { continue; /* Skip blanks. */ }

.               { continue; /* Skip other, assume all is true. */ /*return yytext[0];*/ }

%%

int yywrap() {
    return 1;
}

int yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
		exit(1);
    return 1;
}
