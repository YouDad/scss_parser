#include <assert.h>
#include <string>
#include <vector>

namespace css_block_module {

using std::vector;
using std::string;

struct css_block;
typedef vector<string> strings;

void add_selector(string selector);
void add_declare(string declare);
void enter_scope();
void exit_scope();

struct css_block *get_itor();
struct css_block *itor_enter(struct css_block *itor);
struct css_block *itor_next(struct css_block *itor);
struct css_block *itor_parent(struct css_block *itor);
void get_itor_selectors(const struct css_block *itor, strings &selectors);
void get_itor_declares(const struct css_block *itor, strings &declares);

};  // namespace css_block_module
