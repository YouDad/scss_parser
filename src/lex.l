// %include "color.l"
// %include "font.l"
// %include "comment.l"
%{
#include "header.h"
#include <stack>
std::string attr_prefix;
std::stack<int> state_stack;
int curstate = 0; // INITIAL
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
		BEGIN curstate;             \
	} while (0)

%}

digit               ([0-9])
hex_digit           ({digit}|[a-fA-F])
alpha               ([A-Za-z_])
id_all              (({alpha}|{digit}|-)*)
blanks              ([ \t]*)

number              ({digit}+)
identifier          ({alpha}{id_all}|-{alpha}{id_all}|--{id_all})
string              (\"[^\"]*\")
language            (zh|en)
units               (cap|ch|em|ex|ic|lh|rem|rlh|vh|vw|vi|vb|vmin|vmax|px|cm|mm|Q|in|pc|pt)
length              (0|{number}{units})
percentage          ([+-]?{number}%)

class_sor           ([.]{identifier})
id_sor              (#{identifier})
element_sor         ({identifier})
attr_sor1           (\[{identifier}\])
attr_sor2           (\[{identifier}{blanks}={blanks}{identifier}\])
attr_sor3           (\[{identifier}{blanks}~={blanks}{identifier}\])
attr_sor4           (\[{identifier}{blanks}\|={blanks}{identifier}\])
attr_sor5           (\[{identifier}{blanks}\^={blanks}{identifier}\])
attr_sor6           (\[{identifier}{blanks}\$={blanks}{identifier}\])
attr_sor7           (\[{identifier}{blanks}\*={blanks}{identifier}\])
attr_ss             ({attr_sor1}|{attr_sor2}|{attr_sor3}|{attr_sor4}|{attr_sor5}|{attr_sor6}|{attr_sor7})
pseudo_sor1         (:(link|visited|active|hover|focus|first-letter|first-line))
pseudo_sor2         (:(first-child|before|after|lang\({language}\)|first-of-type))
pseudo_sor3         (:(last-of-type|only-of-type|only-child|nth-child\({number}\)))
pseudo_sor4         (:(nth-last-child\({number}\)|nth-of-type\({number}\)|nth-last-of-type\({number}\)))
pseudo_sor5         (:(last-child|root|empty|target|enabled|disabled|checked|selection|not\({identifier}\)))
pseudo_ss           ({pseudo_sor1}|{pseudo_sor2}|{pseudo_sor3}|{pseudo_sor4}|{pseudo_sor5})

sor                 ({class_sor}|{id_sor}|\*|{element_sor}|{attr_ss}|{pseudo_ss}|&)
selector            ({sor}|{sor}{blanks}{sor})+

hex3                (#{hex_digit}{3})
hex6                (#{hex_digit}{6})
value               ({number}|bold|none|underline|normal)

global_value        (inherit|initial|unset)

attr                ((width|height|font-size|font-weight|text-decoration|font):)
unit                (%|px|em)

%%

{attr} {
	log::debug("attr: '%s'", yytext);
	yylval.str = yytext;
	attr_prefix = yytext;
	return ATTR;
}

{unit} {
	log::debug("unit: '%s'", yytext);
	yylval.str = yytext;
	return UNIT;
}

{value} {
	log::debug("value: '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

{selector} {
	log::debug("selector: '%s'", yytext);
	yylval.str = yytext;
	return SELECTOR;
}

"\n" {}

"{" {
	log::debug("single: '%s'", yytext);
	if (attr_prefix.size()) {
		if ("font:" == attr_prefix) {
			ENTER_STATE(ATTR__font);
		} else {
			log::warn("unrecognized attr_prefix %s", attr_prefix.c_str());
		}
	}
	yylval.str = yytext;
	return yytext[0];
}

"}" {
	log::debug("single: '%s'", yytext);
	if (attr_prefix.size()) {
		EXIT_STATE();
	}
	attr_prefix = "";
	yylval.str = yytext;
	return yytext[0];
}

";" {
	log::debug("single: '%s'", yytext);
	attr_prefix = "";
	yylval.str = yytext;
	return yytext[0];
}

([@,]) {
	log::debug("single: '%s'", yytext);
	yylval.str = yytext;
	return yytext[0];
}

. {
	log::debug("any: '%s'", yytext);
}

%%
