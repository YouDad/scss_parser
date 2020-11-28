%{
#include "header.h"
#include "modules/css_block.h"
%}

%token<str> SELECTOR
%token<str> ATTR
%token<str> VALUE
%token<str> UNIT
%token<str> BLOCK_COMMENT_TOKEN
%token<str> '{' '}' ';' '@' ',' '~' '+' '>'

%type<str> start
%type<str> statements
%type<str> scss_statement
%type<str> css_block css_block1 css_block2
%type<str> declare
%type<str> declare_block1 declare_block2
%type<str> selectors
%type<str> value_unit

%%

start: statements {
	log::info("start: statements");
}

statements: statements scss_statement {
	log::info("statements: statements scss_statement");
}

statements: statements css_block {
	log::info("statements: statements css_block");
}

statements: statements declare {
	log::info("statements: statements declare");
	css_block_module::add_declare($2);
}

statements: statements BLOCK_COMMENT_TOKEN {
	log::info("statements: statements BLOCK_COMMENT_TOKEN");
	css_block_module::add_comment($2);
}

statements: {
	log::info("statements:");
}

scss_statement: '@' {
	log::info("scss_statement: '@'");
}

css_block: css_block1 css_block2 {
	log::info("css_block: css_block1 css_block2");
}

css_block1: selectors '{' {
	log::info("css_block1: selectors '{'");
	css_block_module::enter_scope();
	std::string selectors = $1;
	do {
		int found = selectors.find(',');
		if (found == std::string::npos) {
			css_block_module::add_selector(selectors);
			selectors = "";
		} else {
			css_block_module::add_selector(selectors.substr(0, found));
			selectors = selectors.substr(found + 1);
		}
	} while (selectors.size());
}

css_block2: statements '}' {
	log::info("block2: statements '}'");
	css_block_module::exit_scope();
}

selectors: selectors SELECTOR {
	log::info("selectors: selectors SELECTOR");
	$$ = $1 + $2;
}

selectors: selectors ',' SELECTOR {
	log::info("selectors: selectors ',' SELECTOR");
	$$ = $1 + $2 + $3;
}

selectors: selectors '~' SELECTOR {
	log::info("selectors: selectors '~' SELECTOR");
	$$ = $1 + $2 + $3;
}

selectors: selectors '+' SELECTOR {
	log::info("selectors: selectors '+' SELECTOR");
	$$ = $1 + $2 + $3;
}

selectors: selectors '>' SELECTOR {
	log::info("selectors: selectors '>' SELECTOR");
	$$ = $1 + $2 + $3;
}

selectors: SELECTOR {
	log::info("selectors: SELECTOR");
	$$ = $1;
}

declare: ATTR value_unit ';' {
	log::info("declare: ATTR value_unit ';'");
	$$ = $1 + " " + $2 + $3;
}

declare: declare_block1 declare_block2 {
	log::info("declare: declare_block1 declare_block2");
	$$ = "";
}

declare_block1: ATTR value_unit '{' {
	log::info("declare_block1: ATTR value_unit '{'");
	css_block_module::add_declare($1 + " " + $2 + ";");
	css_block_module::enter_scope();
	css_block_module::add_declare_block_prefix($1);
}

declare_block1: ATTR '{' {
	log::info("declare_block1: ATTR '{'");
	css_block_module::enter_scope();
	css_block_module::add_declare_block_prefix($1);
}

declare_block2: statements '}' {
	log::info("declare_block2: statements '}'");
	css_block_module::exit_scope();
}

value_unit: VALUE {
	log::info("value_unit: VALUE");
	$$ = $1;
}

value_unit: VALUE UNIT {
	log::info("value_unit: VALUE UNIT");
	$$ = $1 + $2;
}

%%
