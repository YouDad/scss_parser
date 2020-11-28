#include "header.h"
#include "modules/log.h"
#include "modules/data.h"

static vector<string> include_files;
static int ifcnt;
static string yacc_part_1 = "";
static string yacc_part_2 = "";
static string yacc_part_3 = "";

void append_part(int part_id, string content) {
	switch (part_id) {
		case 1:
			yacc_part_1 += content;
			break;
		case 2:
			yacc_part_2 += content;
			break;
		case 3:
			yacc_part_3 += content;
			break;
	}
}

void push_include(string filename) {
	for (int i = 0; i < include_files.size(); i++) {
		if (include_files[i] == filename) {
			return;
		}
	}
	log::info("%s", filename.c_str());
	include_files.push_back(filename);
}

string pop_include() {
	if (ifcnt < include_files.size()) {
		return include_files[ifcnt++];
	}
	return "";
}

string get_result() {
	return yacc_part_1 + "%%\n" + yacc_part_2 + "%%\n" + yacc_part_3;
}
