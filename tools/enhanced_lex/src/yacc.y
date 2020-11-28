%{
#include "header.h"
#include "modules/data.h"
%}

%token<str> INCLUDE
%token<str> YACC_PART_1
%token<str> YACC_PART_2
%token<str> YACC_PART_3

%type<str> start
%type<str> includes

%%

start: {
}

start: start includes YACC_PART_1 YACC_PART_2 YACC_PART_3 {
	log::trace("(%s:%d): %s", __FILE__, __LINE__, __func__);
	log::info("%s\n%s\n%s\n%s", $2.c_str(), $3.c_str(), $4.c_str(), $5.c_str());
	append_part(1, $3);
	append_part(2, $4);
	append_part(3, $5);
	string filename = pop_include();
	log::info("%s", filename.c_str());
	if (filename.size()) {
		FILE *fp = fopen(filename.c_str(), "r");
		if (fp) {
			fclose(yyin);
			yyin = fp;
			yyrestart(yyin);
		} else {
			perror("fopen");
		}
	}
}

includes: {
}

includes: includes INCLUDE {
	$$ = $1 + $2;
	string filename = $2;
	filename = filename.substr(filename.find('"') + 1);
	filename = filename.substr(0, filename.size() - 2);

	push_include(filename);
}

%%
