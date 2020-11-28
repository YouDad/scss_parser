#ifndef HEADER_H_
#define HEADER_H_

#include <stdio.h>
#include <string.h>

#include "types.h"
#include "yacc.tab.h"
#include "modules/log.h"

extern "C" {
	void yyerror(const char *s);
	int yylex(void);
	int yywrap();
}
void yyrestart(FILE * input_file);

extern FILE *yyin;
extern int yydebug;

#endif
