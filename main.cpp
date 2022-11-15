#include <iostream>
#include "node.h"
#include "syntax.hpp"

extern ClsProgram *prg;
extern int yyparse();
extern FILE *yyin;

using namespace std;

void printRecursive(const Formula &f)
{
  switch (f.op)
  {
  case 0: //叶子节点，直接输出右子树，也即操作“数”或变量
    switch ((f.re->iNodeID))
    {
    case V_REAL:
      cout << (f.re->dValue);
      break; //这里应该输出该双精度数值所在的内存地址
    case V_INT:
      cout << (f.re->iValue);
      break; //这里应该输出该整型数值所在的内存地址
    default:
      cout << (f.re->name);
      break;
    } //应该应该输出该变量所在的内存地址
    break;
  case FUNC_PRINT: //输出函数，递归处理右操作数
    cout << "(" << FUNC_PRINT << ",#,";
    printRecursive((Formula &)*(f.re));
    cout << ")";
    break;
  case T_ASSIGN: //赋值和计算语句，递归处理左右操作数
    cout << "(" << f.op << ",";
    cout << f.le->name << ",";
    printRecursive((Formula &)*(f.re));
    cout << ")";
    break;
  case T_PLUS:
  case T_MINUS:
  case T_MUL:
  case T_DIV:
    cout << "(" << f.op << ",";
    printRecursive((Formula &)*(f.le));
    cout << ",";
    printRecursive((Formula &)*(f.re));
    cout << ")";
    break;
  default:
    cout << "ERROR in Current Formula!!!";
    break;
  }
};

int main(int argc, char **argv)
{

  cout << "=============== Set Compiler Param ===============" << endl
       << endl;
  if (argc == 2)
  {
    if ((yyin = fopen(argv[1], "r")) == NULL)
    {
      cout << "Cannot open the parameter File: " << argv[1] << endl
           << endl;

      cout << "Compiler Error and Exit..." << endl
           << endl;

      return 0;
    }
    else
    {
      cout << "Source code file : " << argv[1] << endl
           << endl;
    }
  }
  else
  {
    cout << "ERROR - There is NO Source file." << endl
         << endl;
    ;
    cout << "Usage: $cmd sourcefiledir/sourcefilename.yuzi" << endl
         << endl;

    return 0;
  }

  cout << "================ Begin to COMPILE ================" << endl
       << endl;

  prg = new ClsProgram();

  yyparse();

  cout << "================ End COMPILATION ================" << endl
       << endl;

  fclose(yyin);

  cout << "====== The Symbol and Statements as Follow =======" << endl
       << endl;

  cout << "---------- Symbols ----------" << endl;
  cout << "No.    Name            Type    " << endl;
  int iNo = 1;
  for (list<Node>::iterator it = prg->lstIdents.begin(); it != prg->lstIdents.end(); it++)
  {
    cout << iNo << "\t" << it->name << "\t\t" << it->iNodeID << endl;
    iNo++;
  }

  cout << endl;
  cout << "--------- Statements ---------" << endl;
  iNo = 1;
  for (list<Formula>::iterator it = prg->lstFormulas.begin(); it != prg->lstFormulas.end(); it++)
  {
    cout << "No." << iNo << " : ";
    printRecursive((Formula &)*it);
    cout << endl;

    iNo++;
  }

  cout << "============= End Information Show ==============" << endl
       << endl;

  // Do something for LLVM and Then Call it codeGenerate

  delete prg;

  return 0;
}
