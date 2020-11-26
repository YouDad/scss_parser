#include "header.h"
#include "modules/css_block.h"

void print_node(struct css_block_module::css_block *itor) {
	css_block_module::strings selectors;
	css_block_module::get_itor_selectors(itor, selectors);

	// splice_selectors
	css_block_module::strings ss;
	for (int i = 0; i < selectors.size(); i++) {
		ss.push_back(selectors[i]);
	}

	auto it = itor;
	while (css_block_module::itor_parent(css_block_module::itor_parent(it))) {
		it = css_block_module::itor_parent(it);
		css_block_module::get_itor_selectors(it, selectors);
		// new_splice_selectors
		css_block_module::strings nss;

		for (int i = 0; i < selectors.size(); i++) {
			for (int j = 0; j < ss.size(); j++) {
				if (ss[j].find('&') != std::string::npos) {
					int found = ss[j].find('&');
					std::string str = ss[j].substr(0, found);
					str += selectors[i];
					str += ss[j].substr(found + 1);
					nss.push_back(str);
				} else {
					nss.push_back(selectors[i] + " " + ss[j]);
				}
			}
		}

		ss = nss;
	}

	css_block_module::strings declares;
	css_block_module::get_itor_declares(itor, declares);

	if (declares.size()) {
		for (int i = 0; i < ss.size(); i++) {
			bool is_end = i == ss.size() - 1;
			printf("%s%s ", ss[i].c_str(), is_end ? "" : ",");
		}

		printf("{\n");

		for (int i = 0; i < declares.size(); i++) {
			printf("  %s\n", declares[i].c_str());
		}

		printf("}\n");
	}
}

void dfs(struct css_block_module::css_block *itor) {
	print_node(itor);

	if (css_block_module::itor_enter(itor)) {
		dfs(css_block_module::itor_enter(itor));
	}

	if (css_block_module::itor_next(itor)) {
		dfs(css_block_module::itor_next(itor));
	}
};

void dfs_print() {
	auto itor = css_block_module::get_itor();
	do {
		print_node(itor);

		if (css_block_module::itor_enter(itor)) {
			dfs(css_block_module::itor_enter(itor));
		}
		itor = css_block_module::itor_next(itor);
		if (itor) {
			printf("\n");
		}
	} while (itor);
}

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
		dfs_print();
	}
	return 0;
}
