#include "header.h"
#include "modules/data.h"

int main(int argc, char **argv) {
	for (int i = 2; i < argc; i++) {
		if (strstr(argv[i], "-v")) {
			int level = 0;
			for (char *p = argv[i]; *p; p++) {
				if (*p == 'v') {
					level++;
				}
			}

			if (level > log::LL_DEBUG) {
				level = log::LL_DEBUG;
				yydebug = 1;
			}

			log::set_level((log::LOG_LEVEL)level);
		}
	}

	if (argc < 1) {
		return 1;
	}

	yyin = fopen(argv[1], "r");
	int parse_ret = yyparse();
	fclose(yyin);

	if (parse_ret == 1) {
		log::error("occur error!\n\n");
		return 1;
	} else {
		string ret = get_result();
		printf("%s", ret.c_str());
	}
	return 0;
}
