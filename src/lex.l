%{
#include "header.h"
%}

%x COMMENT

digit           ([0-9])
hex_digit       ({digit}|[a-fA-F])
alpha           ([A-Za-z_])

hex_or_selector (#[a-fA-F]({hex_digit}{2}|{hex_digit}{5}))
selector        ([#.]?{alpha}({alpha}|{digit})*)
hex3            (#{hex_digit}{3})
hex6            (#{hex_digit}{6})
value           ({hex3}|{hex6}|{digit}+|bold)

attr            ((color|width|background-color|font-size|font-weight):)
unit            (%|px|em)

%%

{attr} {
	log::debug("attr: '%s'", yytext);
	yylval.str = yytext;
	return ATTR;
}

{unit} {
	log::debug("unit: '%s'", yytext);
	yylval.str = yytext;
	return UNIT;
}

{hex_or_selector} {
	log::debug("hex_or_selector: %s", yytext);
	yylval.str = yytext;
	return HEX_OR_SELECTOR;
}

{value} {
	log::debug("value: '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

{selector} {
	log::debug("selector: %s", yytext);
	yylval.str = yytext;
	return SELECTOR;
}

"\n" {}

([{};@,]) {
	log::debug("single: '%s'", yytext);
	yylval.str = yytext;
	return yytext[0];
}

. {
	log::debug("any: '%s'", yytext);
}

"//" {
	BEGIN COMMENT;
}

<COMMENT>\n {
	BEGIN INITIAL;
}

<COMMENT>. {}

%%
