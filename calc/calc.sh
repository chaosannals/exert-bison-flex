bison -d calc.y
flex calc.l
gcc calc.tab.c lex.yy.c calc.c -o calc -lm
