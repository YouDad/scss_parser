%{
%}

%x ATTR__font
%x VALUE__font_family
%x VALUE__font_size
%x VALUE__font_weight

font_size           (smaller|xx-small|x-small|small|medium|large|x-large|xx-large|xxx-large|larger)
weight_value        (lighter|normal|bold|bolder)
one_to_thousand     ([1-9]|[1-9]{digit}{1,2}|1000)

%%
<ATTR__font>family: {
	ENTER_STATE(VALUE__font_family);
	log::debug("<ATTR__font>attr: '%s'", yytext);
	yylval.str = yytext;
	return ATTR;
}

<ATTR__font>size: {
	ENTER_STATE(VALUE__font_size);
	log::debug("<ATTR__font>attr: '%s'", yytext);
	yylval.str = yytext;
	return ATTR;
}

<ATTR__font>weight: {
	ENTER_STATE(VALUE__font_weight);
	log::debug("<ATTR__font>attr: '%s'", yytext);
	yylval.str = yytext;
	return ATTR;
}

<ATTR__font>";" {
	log::debug("<ATTR__font>single: '%s'", yytext);
	yylval.str = yytext;
	return yytext[0];
}

<ATTR__font>"}" {
	log::debug("<ATTR__font>single: '%s'", yytext);
	if (attr_prefix.size()) {
		EXIT_STATE();
	}
	attr_prefix = "";
	yylval.str = yytext;
	return yytext[0];
}

<ATTR__font>\n {}

<ATTR__font>. {
	log::debug("<ATTR__font>any: '%s'", yytext);
}

<VALUE__font_family>({identifier}([ ]{identifier})*|{string}) {
	EXIT_STATE();
	log::debug("<VALUE__font_family>: '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

<VALUE__font_family>\n {}

<VALUE__font_family>. {
	log::debug("<VALUE__font_family>any: '%s'", yytext);
}

<VALUE__font_size>({font_size}|{length}|{percentage}) {
	EXIT_STATE();
	log::debug("<VALUE__font_size>: '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

<VALUE__font_size>\n {}
<VALUE__font_size>. {
	log::debug("<VALUE__font_size>any: '%s'", yytext);
}

<VALUE__font_weight>({weight_value}|{one_to_thousand}) {
	EXIT_STATE();
	log::debug("<VALUE__font_weight>: '%s'", yytext);
	yylval.str = yytext;
	return VALUE;
}

<VALUE__font_weight>\n {}
<VALUE__font_weight>. {
	log::debug("<VALUE__font_weight>any: '%s'", yytext);
}

%%
