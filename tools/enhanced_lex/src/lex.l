%{
#include "header.h"
#include <stack>
std::stack<int> state_stack;
int curstate = 0; // INITIAL
std::string part;

#define ENTER_STATE(state)          \
	do {                            \
		state_stack.push(curstate); \
		curstate = state;           \
		BEGIN curstate;             \
	} while (0)

#define EXIT_STATE()                  \
	do {                              \
		curstate = state_stack.top(); \
		state_stack.pop();            \
		BEGIN curstate;               \
	} while (0)

%}

%x PART1
%x PART2
%x PART3

include (\"[^\"]*\")
part    "%%"
left    ((.|"\n")*)

%%

<INITIAL>"// %include "{include}"\n" {
	log::debug("{include}:\n%s", yytext);
	yylval.str = yytext;
	return INCLUDE;
}

<INITIAL>"%{" {
	ENTER_STATE(PART1);
	part += yytext;
}

<PART1>{part} {
	ENTER_STATE(PART2);
	yylval.str = part;
	part = "";
	log::debug("{part1}:\n%s", yylval.str.c_str());
	return YACC_PART_1;
}

<PART2>{part} {
	ENTER_STATE(PART3);
	yylval.str = part;
	part = "";
	log::debug("{part2}:\n%s", yylval.str.c_str());
	return YACC_PART_2;
}

<PART3>{left} {
	ENTER_STATE(INITIAL);
	yylval.str = part + yytext;
	part = "";
	log::debug("{left}:\n%s", yylval.str.c_str());
	return YACC_PART_3;
}

<INITIAL,PART1,PART2>(.|"\n") {
	part += yytext;
}

%%
