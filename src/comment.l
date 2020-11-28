%{
std::string block_comment;
%}

%x LINE_COMMENT
%x BLOCK_COMMENT

%%

"//" {
	ENTER_STATE(LINE_COMMENT);
	log::debug("state: '%s'", yytext);
}

<LINE_COMMENT>\n {
	EXIT_STATE();
	log::debug("<LINE_COMMENT> exit");
}

<LINE_COMMENT>. {
	log::debug("<LINE_COMMENT> any: '%s'", yytext);
}

"/*" {
	ENTER_STATE(BLOCK_COMMENT);
	log::debug("state: '%s'", yytext);
	block_comment = yytext;
}

<BLOCK_COMMENT>"*/" {
	EXIT_STATE();
	log::debug("<BLOCK_COMMENT> exit");
	block_comment += yytext;
	yylval.str = block_comment;
	return BLOCK_COMMENT_TOKEN;
}

<BLOCK_COMMENT>(.|\n) {
	log::debug("<BLOCK_COMMENT> any: '%s'", yytext);
	block_comment += yytext;
}

%%
