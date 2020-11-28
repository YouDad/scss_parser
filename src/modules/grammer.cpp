#include "header.h"

std::string result;

void yyerror(const char *s) {
	printf("error: %s\n", s);
}
