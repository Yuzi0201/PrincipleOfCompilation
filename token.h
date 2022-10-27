#ifndef TOKEN_H
#define TOKEN_H

#include <stdio.h>

typedef enum
{
  T_SEMICOLON = 256,
  T_COMMA,
  T_LPARENT,
  T_RPARENT,
  T_LBRACE,
  T_RBRACE,
  T_MUL,
  T_DIV,
  T_PLUS,
  T_MINUS,
  T_ASSIGN,
  T_MAIN,
  T_LET,
  FUNC_PRINT,
  V_INT,
  V_REAL,
  IDENTIFIER,
  TYPE_INT,
  TYPE_REAL,
} TokenType;

static void print_token(int token)
{
  static char *token_strs[] = {
      "T_SEMICOLON",
      "T_COMMA",
      "T_LPARENT",
      "T_RPARENT",
      "T_LBRACE",
      "T_RBRACE",
      "T_MUL",
      "T_DIV",
      "T_PLUS",
      "T_MINUS",
      "T_ASSIGN",
      "T_MAIN",
      "T_LET",
      "FUNC_PRINT",
      "V_INT",
      "V_REAL",
      "IDENTIFIER",
      "TYPE_INT",
      "TYPE_REAL",
  };

  if (token < 256)
  {
    printf("%-20c", token);
  }
  else
  {
    printf("%-20s", token_strs[token - 256]);
  }
}

#endif