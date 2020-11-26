%{
#include "header.h"
#include "modules/css_block.h"
%}

%token<str> HEX_OR_SELECTOR
%token<str> SELECTOR
%token<str> ATTR
%token<str> VALUE
%token<str> UNIT
%token<str> '{' '}' ';' '@' ','

%type<str> start
%type<str> statements
%type<str> scss_statement
%type<str> css_block css_block1 css_block2
%type<str> declare
%type<str> selector
%type<str> selectors
%type<str> value
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

selector: SELECTOR {
	log::info("selector: SELECTOR");
	$$ = $1;
}

selector: HEX_OR_SELECTOR {
	log::info("selector: HEX_OR_SELECTOR");
	$$ = $1;
}

selectors: selectors selector {
	log::info("selectors: selectors selector");
	$$ = $1 + " " + $2;
}

selectors: selectors ',' selector {
	log::info("selectors: selectors ',' selector");
	$$ = $1 + $2 + $3;
}

selectors: selector {
	log::info("selectors: selector");
	$$ = $1;
}

declare: ATTR value_unit ';' {
	log::info("declare: ATTR value_unit ';'");
	$$ = $1 + " " + $2 + $3;
}

value: VALUE {
	log::info("value: VALUE");
	$$ = $1;
}

value: HEX_OR_SELECTOR {
	log::info("value: HEX_OR_SELECTOR");
	$$ = $1;
}

value_unit: value {
	log::info("value_unit: value");
	$$ = $1;
}

value_unit: value UNIT {
	log::info("value_unit: value UNIT");
	$$ = $1 + $2;
}

%%
