**使用方法：**
---
### 词法分析器：
```bash
flex -o simple_lex.cpp simple_lex.l
g++ -o simple_lex simple_lex.cpp
./simple_lex example.yuzi
```
即可看到词法分析的结果
