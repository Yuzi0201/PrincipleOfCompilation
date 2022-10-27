%{
#include "token.h"
void init_scanner();
void lex_error(char* msg, int line);
%}

%option noyywrap

SPACE       [ \t\n]+
DIGIT       [0-9]
LETTER      [a-zA-Z]
NUMBER      [1-9]{DIGIT}*|0
REAL        {NUMBER}(\.{NUMBER})+
IDENT       ({LETTER}|_)({LETTER}|{NUMBER}|_)*

%%
{SPACE}             ;
;                   { return T_SEMICOLON; }
,                   { return T_COMMA; }
\(                  { return T_LPARENT; }
\)                  { return T_RPARENT; }
\{                  { return T_LBRACE; }
\}                  { return T_RBRACE; }
\*                  { return T_MUL; }
\/                  { return T_DIV; }
\+                  { return T_PLUS; }
-                   { return T_MINUS; }
=                   { return T_ASSIGN; }
main                { return T_MAIN; }
let                 { return T_LET; }

print             { return FUNC_PRINT; }

{NUMBER}            { return V_INT; }
{REAL}              { return V_REAL; }
{IDENT}             { return IDENTIFIER; }

:int                { return TYPE_INT; }
:float              { return TYPE_REAL; }


%%
int main(int argc, char** argv) {
  if (argc > 1) {
    if (!(yyin = fopen(argv[1], "r"))) {
      perror(argv[1]);
      return 1;
    }
  }
  int token;
  init_scanner();
  while (token = yylex()) {
      print_token(token);
      puts(yytext);
  }
  return 0;
}

void init_scanner() {
    printf("%-20s%s\n", "TOKEN-TYPE", "TOKEN-VALUE");
    printf("-------------------------------------------------\n");
}

void lex_error(char* msg, int line) {
    printf("\nError at line %-3d: %s\n\n", line, msg);
}
