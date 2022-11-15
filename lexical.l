/* flex词法分析器生成定义。与syntax.y保持一致。 */

%{
#include <string>
#include "node.h"
#include "syntax.hpp"

using namespace std;

#define SAVE_TOKEN  (yylval.strPtr = new string(yytext, yyleng))
#define TOKEN(t)    (yylval.tokenID = t)
%}

%option noyywrap
%option case-sensitive
%option nodefault
%option debug

SPACE       [ \t\n]+
DIGIT       [0-9]
LETTER      [a-zA-Z]
NUMBER      [1-9]{DIGIT}*|0
DATA        {NUMBER}(\.{NUMBER})+
IDENT       ({LETTER}|_)({LETTER}|{NUMBER}|_)*

%%
{SPACE}             ;
;                   { return TOKEN(T_SEMICOLON); }
,                   { return TOKEN(T_COMMA); }
\*                  { return TOKEN(T_MUL); }
\/                  { return TOKEN(T_DIV); }
\+                  { return TOKEN(T_PLUS); }
-                   { return TOKEN(T_MINUS); }
=                   { return TOKEN(T_ASSIGN); }
\(                  { return TOKEN(T_LPARENT); }
\)                  { return TOKEN(T_RPARENT); }

\{                  { return TOKEN(T_LBRACE); }
\}                  { return TOKEN(T_RBRACE); }
main                { return TOKEN(T_MAIN); }
print               { return TOKEN(FUNC_PRINT); }
let                 { return TOKEN(T_LET);}

{NUMBER}            { SAVE_TOKEN; return V_INT; }     /* 整型常量，需要通过union的tMsg返回数值，用SAVE_TOKEN宏给yylval中的msgPtr变量赋值（不使用TOKEN宏干预yylval中的tID变量） */
{DATA}              { SAVE_TOKEN; return V_REAL; }    /* 实数常量，需要通过union的tMsg返回数值，用SAVE_TOKEN宏给yylval中的msgPtr变量赋值（不使用TOKEN宏干预yylval中的tID变量） */
{IDENT}             { SAVE_TOKEN; return IDENTIFIER; }     /* 标识符，需要通过union的tMsg返回变量名，用SAVE_TOKEN宏给yylval中的msgPtr变量赋值（不使用TOKEN宏干预yylval中的tID变量） */

:int         { return TOKEN(TYPE_INT); }
:float       { return TOKEN(TYPE_REAL); }

.                   { cout<<yytext<<"   --- Unknown"<<endl; }
%%
