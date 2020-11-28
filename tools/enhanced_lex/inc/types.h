#include <string>

struct compile_type {
	std::string str;
};

extern std::string result;

#define YYSTYPE struct compile_type
