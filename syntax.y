/* Bison语法分析器生成定义。与lexical.l保持一致。 仅为调试版，测试语法规则规约有效性，无AST节点代码生成模块；对语法规则做了重构，进一步层次化细分 */

%{
	#include "node.h"
    #include <cstdio>
    #include <cstdlib>

    using namespace std;

	ClsProgram *prg; /* 抽象语法树的根节点 */

	extern int yylex();
	void yyerror(const char *s) { cout<<"Error: "<<s<<endl; exit(1); }
    int YYDEBUG = 1;
%}

/*  定义节点的存储和访问类，每个类对应一种节点。
    */
%union {
	Formula * forPtr;
	Node * nodePtr;

	int typeID;

	string * strPtr;
	int tokenID;
}

/*  定义终结符节点。
    此处的定义与lexical.l中的匹配规则动作中的引用保持一致。
    */
%token <strPtr> V_INT V_REAL IDENTIFIER
%token <tokenID> T_PLUS T_MINUS T_MUL T_DIV T_ASSIGN T_MAIN T_SEMICOLON T_COMMA T_LPARENT T_RPARENT T_LBRACE T_RBRACE FUNC_PRINT T_LET TYPE_INT TYPE_REAL

/*  定义非终结符节点，每个非终结符与上面的%union定义相对应。
    */
%type <nodePtr> type_def var_def factor value
%type <forPtr> formula

/*  定义计算符的结合顺序和优先级。高优先级的在后面。
    */
%right      T_ASSIGN
%left       T_PLUS T_MINUS
%left       T_MUL T_DIV

%start program

%%
program         : T_MAIN T_LPARENT T_RPARENT T_LBRACE stmts T_RBRACE    {
                                                    cout<<"BISON Reduction @ program"<<endl;
                                                }
                ;

stmts           : stmt  {
                            cout<<"BISON Reduction @ stmts-stmt"<<endl;
                        }
                | stmts stmt    {
                                    cout<<"BISON Reduction @ stmts-stmts"<<endl;
                                }
                ;

stmt            : var_def T_SEMICOLON    {
                                        cout<<"BISON Reduction @ stmt-var_def"<<endl;
                                        delete $1;
                                    }
                | formula T_SEMICOLON    {
                                        prg->AddFormula(*($1));
                                        cout<<"BISON Reduction @ stmt-expr"<<endl;
                                    }
                ;

var_def         : T_LET IDENTIFIER type_def         {
                                                $$ = $3;
                                                prg->AddIdent(*(new Node(*($2), $3->iNodeID)));

                                                cout<<"BISON Reduction @ var_def-type_def :"<<*($2)<<endl;
                                            }
                | var_def T_COMMA IDENTIFIER type_def   {
                                                $$ = $4;
                                                prg->AddIdent(*(new Node(*($3), $4->iNodeID)));

                                                cout<<"BISON Reduction @ var_def-var_def :"<<*($3)<<endl;
                                            }
                | T_LET IDENTIFIER type_def T_ASSIGN value        {
                                                            $$ = $3;
                                                            prg->AddIdent(*(new Node(*($2), $3->iNodeID)));

                                                            Node *le = new Node(*($2), $3->iNodeID);
                                                            Formula *re = new Formula(NULL, 0, $5);
                                                            prg->AddFormula(*(new Formula(le, T_ASSIGN, re)));

                                                            cout<<"BISON Reduction @ var_def-type_def IDENTIF TASSIGN"<<endl;
                                                        }

                | var_def T_COMMA IDENTIFIER type_def T_ASSIGN value  {
                                                            $$ = $4;
                                                            prg->AddIdent(*(new Node(*($3), $4->iNodeID)));

                                                            Node *le = new Node(*($3), $4->iNodeID);
                                                            Formula *re = new Formula(NULL, 0, $6);
                                                            prg->AddFormula(*(new Formula(le, T_ASSIGN, re)));

                                                            cout<<"BISON Reduction @ var_def-TCOMMA IDENTIF TASSIGN"<<endl;
                                                        }
                | FUNC_PRINT T_LPARENT formula T_RPARENT {
                                                            $$= new Formula(NULL, FUNC_PRINT, (Node *)$3);
                                                            cout<<"BISON Reduction @ formula-PRINTFUNC"<<endl;
                }
                ;

type_def        : TYPE_INT       {
                                    $$ = new Node(TYPE_INT);
                                    cout<<"BISON Reduction @ type_def-TYPEINT:"<<$$->iNodeID<<endl;
                                }
                | TYPE_REAL    {
                                    $$ = new Node(TYPE_REAL);
                                    cout<<"BISON Reduction @ type_def-TYPEREAL:"<<$$->iNodeID<<endl;
                                }
                ;

formula         : factor                {
                                            $$= new Formula(NULL, 0, $1);
                                            cout<<"BISON Reduction @ formula-factor : "<< ($1)->iNodeID<<endl;
                                        }
                | IDENTIFIER T_ASSIGN formula       {
                                                    int typeID = prg->WhatsType(*($1));
                                                    for(auto i=prg->lstIdents.begin();i!=prg->lstIdents.end();i++){
                                                        cout<<(*i).name<<" "<<(*i).iNodeID<<endl;
                                                    }
                                                    if(typeID < 0) yyerror((($1)->append(" - Nondefined identifier")).c_str());

                                                    $$= new Formula(new Node(*($1), typeID), T_ASSIGN, (Node *)$3);
                                                    cout<<"BISON Reduction @ formula-IDENTIF TASSIGN to :"<<*($1)<<endl;
                                                }

                | T_LPARENT formula T_RPARENT     {
                                                    $$ = $2;
                                                    cout<<"BISON Reduction @ formula-TLPARENT"<<endl;
                                                }
                | formula T_MUL formula      {
                                                $$= new Formula((Node *)$1, T_MUL, $3);
                                                cout<<"BISON Reduction @ formula-formula-TMUL"<<endl;
                                            }
                | formula T_DIV formula      {
                                                $$= new Formula((Node *)$1, T_DIV, $3);
                                                cout<<"BISON Reduction @ formula-formula-TDIV"<<endl;
                                            }
                | formula T_PLUS formula     {
                                                $$= new Formula((Node *)$1, T_PLUS, $3);
                                                cout<<"BISON Reduction @ formula-formula-TPLUS"<<endl;
                                            }
                | formula T_MINUS formula    {
                                                $$= new Formula((Node *)$1, T_MINUS, $3);
                                                cout<<"BISON Reduction @ formula-formula-TMINUS"<<endl;
                                            }
                ;

factor          : IDENTIFIER       {
                                    int typeID = prg->WhatsType(*($1));
                                    if(typeID < 0) yyerror((($1)->append(" - Nondefined identifier")).c_str());

                                    $$ = new Node(*($1), typeID);
                                    cout<<"BISON Reduction @ factor-IDENTIF :"<< *($1) <<endl;
                                }
                | value         {
                                    $$ = $1;
                                    cout<<"BISON Reduction @ factor-value"<<endl;
                                }
                ;

value           : V_REAL   {
                                    $$ = new Node(stod(*($1)), V_REAL);
                                    cout<<"BISON Reduction @ value-REALVALUE :"<<*($1)<<endl;
                                }
                | V_INT      {
                                    $$ = new Node(stoi(*($1)), V_INT);
                                    cout<<"BISON Reduction @ value-INTVALUE :"<<*($1)<<endl;
                                }
                ;
%%

