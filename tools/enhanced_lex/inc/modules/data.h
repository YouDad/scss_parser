#include <string>
#include <vector>

using std::string;
using std::vector;

void append_part(int part_id, string content);
void push_include(string filename);
string pop_include();
string get_result();
