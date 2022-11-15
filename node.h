#ifndef NODE_H_INCLUDED
#define NODE_H_INCLUDED

#include <iostream>
#include <list>
#include <algorithm>

using namespace std;

class Node
{
public:
    int iNodeID = -1;
    int iValue = 0;
    double dValue = 0.0;
    string name = "";

    void *vbuf = NULL; //作为分配的数据区域指针；演示版未用
    bool operator()(const Node &ident) const
    {
        // cout << name.compare(ident.name);
        return !name.compare(ident.name); // compare函数相等返回0，不相等返回-1
    }

    virtual ~Node() {}
    Node(int id = -1) : iNodeID(id) {}
    Node(const string &name) : name(name) {}
    Node(const string &name, int id) : name(name), iNodeID(id) {}
    Node(int v, int id) : iValue(v), iNodeID(id) {}
    Node(double v, int id) : dValue(v), iNodeID(id) {}
};

class Formula : public Node
{
public:
    int op = -1;
    Node *le = NULL, *re = NULL;

    Formula(Node *l, int op, Node *r) : le(l), op(op), re(r) { cout << "CODE FormulaFactor Created. OPERATR:" << op << endl; }
};

class ClsProgram
{
public:
    list<Node> lstIdents;      //相当于符号表。由Bison在文法规约时生成成员变量，符号表删除时，逐个释放成员变量
    list<Formula> lstFormulas; //相当于程序的功能主体语句列表。由Bison在文法规约时生成成员变量，主类对象删除时，逐个释放成员变量

    ~ClsProgram()
    {
        cout << "CODE ClsProgram deleted!" << endl;
    }
    ClsProgram()
    {
        cout << "CODE ClsProgram created!" << endl;
    }

    void AddIdent(Node &t) { lstIdents.push_back(t); }
    void AddFormula(Formula &o) { lstFormulas.push_back(o); }
    int WhatsType(const string &s)
    {
        list<Node>::iterator it = find_if(lstIdents.begin(), lstIdents.end(), Node(s));
        if (it != lstIdents.end())
            return it->iNodeID;
        return -1;
    }
};

// class NodeProgram
//{
// public:
//     list<NodeStmt *> lstStmts;
//
//     ~NodeProgram() { while(!(lstStmts.empty())) delete *(lstStmts.erase(lstStmts.end())); }
//     NodeProgram() { cout<<"CODE NodeProgram created!"<<endl; }
//     void AddStmt(NodeStmt *n) { lstStmts.push_back(n); }
// };

#endif // NODE_H_INCLUDED
