%{
#include "../gen/numstr.tab.h"
#include "../src/utils.h"

extern int yylval;
#define log(text) puts(text)
%}

ones [0-9]
tens {ones}{ones}
huns {ones}{tens}

%%
"+"         { yylval=-1; /* reset yylval for new number */ return PLUS;  }
"-"         { yylval=-1; /* reset yylval for new number */ return MINUS; }
"*"         { yylval=-1; /* reset yylval for new number */ return MULT;  }
"/"         { yylval=-1; /* reset yylval for new number */ return DIV;   }
"("         { yylval=-1; /* reset yylval for new number */ return LPAR;  }
")"         { yylval=-1; /* reset yylval for new number */ return RPAR;  }

{ones}{huns}? {// process the last digit in thous or ones
    yylval--;
    int digit = yytext[0] - '0';
    yylval = concat(yylval, digit);
    
    if(yyleng == 1) {
        // accept as a number token
        return NUMBER;
    } 

    yylval = wrap(yylval);
    yylval = join(yylval, 12, -1);
    
    yylval++;
    yyless(1); // recursive to tens  
}
{tens}{huns}? { // process tens position
    yylval--;
    int digit = yytext[0] - '0';
    yylval = concat(yylval, digit);
    yylval = join(yylval, 10, -1);
    
    yylval++;
    yyless(1); // recursive to ones
}
{huns}{huns}? { // process hundreds position
    yylval--;
    int digit = yytext[0] - '0';
    yylval = concat(yylval, digit);
    yylval = join(yylval, 11, -1);
    
    yylval++;
    yyless(1); // recursive to tens
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
