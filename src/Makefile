.PHONY: default
default: compile

.PHONY: compile
compile: lex yacc $(objs)
	$(CC) $(CPPFLAGS) main.cpp $(objs) -o scss

.PHONY: lex
lex:
	$(OUTDIR)/elex lex.l > .lex.l
	flex .lex.l
	mv lex.yy.c $(OUTDIR)/lex.yy.cpp

.PHONY: yacc
yacc:
	bison -d yacc.y
	mv yacc.tab.c $(OUTDIR)/yacc.tab.cpp
	mv yacc.tab.h $(OUTDIR)/

.PHONY: install
install:
	mv scss $(OUTDIR)/
