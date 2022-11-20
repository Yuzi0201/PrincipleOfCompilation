**使用方法：**
---
### 词法分析器：
```bash
flex -o simple_lex.cpp simple_lex.l
g++ -o simple_lex simple_lex.cpp
./simple_lex example.yuzi
```
即可看到词法分析的结果

---
### 词法+语法分析：
```bash
flex -o lexical.cpp lexical.l
bison -d -o syntax.cpp syntax.y
g++ -o main syntax.cpp lexical.cpp main.cpp
./main example.yuzi
```
即可看到词法分析+语法分析的结果