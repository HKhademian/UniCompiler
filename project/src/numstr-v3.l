%{
#include "../gen/numstr.tab.h"
#include "../src/utils.h"

extern int yylval;
#define log(text) puts(text)
int group = -1, all = -1;
%}

ones [0-9]
tens {ones}{ones}
huns {ones}{tens}

%%
"+"         { group=all=-1; /* reset yylval for new number */ return PLUS;  }
"-"         { group=all=-1; /* reset yylval for new number */ return MINUS; }
"*"         { group=all=-1; /* reset yylval for new number */ return MULT;  }
"/"         { group=all=-1; /* reset yylval for new number */ return DIV;   }
"("         { group=all=-1; /* reset yylval for new number */ return LPAR;  }
")"         { group=all=-1; /* reset yylval for new number */ return RPAR;  }

{ones}{huns}* { // process ones position, like: 12(3) or 123,45(6) , ...
    int digit = yytext[0] - '0';
    int lvl = yyleng / 3; // find group order ones|thu|mil|bil
    
    group =  concat(group, digit); // add digit as ones to local group
    
    if(lvl == 0) { // if lvl is ones then just return result
        yylval = concat(all, group);
    
        // accept as a number token
        return NUMBER;
    }
    
    // else we have another groups to process
    group = wrap(group); // wrap prantesis around local group
    all = concat(all, join(group, 11 + lvl, -1)); // add local group to global result
    
    yyless(1); // recursive to process remaining groups
}
{tens}{huns}* { // process tens position, like: 1(2)3 or 123,4(5)6 , ...
    int digit = yytext[0] - '0';
    group =  concat(group, join(digit, 10, -1));
    
    yyless(1); // recursive to ones
}
{huns}{huns}* { // process hundreds position, like: (1)23 or 123,(4)56 , ...
    int digit = yytext[0] - '0';
    group =  join(digit, 11, -1);
    
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
