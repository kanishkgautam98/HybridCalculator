lex HybridCalCL.l
yacc HybridCalCG.y
cc y.tab.c -ly -ll -lm
./a.out
