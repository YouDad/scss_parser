#include "modules/css_block.h"
#include "modules/log.h"

namespace css_block_module {

	struct css_block {
		strings selectors;
		strings declares;
		string declare_block_prefix;
		string block_comment;
		css_block *parent;
		css_block *first_child;
		css_block *next_sibling;
		css_block *prev_sibling;
	};

	static struct css_block *new_css_block() {
		struct css_block *cb = new struct css_block;
		cb->declare_block_prefix = "";
		cb->parent = NULL;
		cb->first_child = NULL;
		cb->next_sibling = NULL;
		cb->prev_sibling = NULL;
		return cb;
	}

	struct css_block *current_css_block = new_css_block();
	string global_block_comment;

	void add_selector(string selector) {
		$xx;
		assert(current_css_block != NULL);

		current_css_block->selectors.push_back(selector);
	}

	void add_declare(string declare) {
		$xx;
		assert(current_css_block != NULL);

		if (declare.size()) {
			current_css_block->declares.push_back(declare);
		}
	}

	void add_declare_block_prefix(string declare_block_prefix) {
		$xx;
		assert(current_css_block != NULL);

		current_css_block->declare_block_prefix = declare_block_prefix;
	}

	void add_comment(string comment) {
		assert(current_css_block != NULL);

		if (current_css_block->parent) {
			add_declare(comment);
		} else {
			global_block_comment += comment + "\n";
		}
	}

	void enter_scope() {
		$xx;
		if (current_css_block->first_child == NULL) {
			struct css_block *cb = new_css_block();
			cb->parent = current_css_block;
			cb->next_sibling = NULL;
			cb->prev_sibling = cb;
			current_css_block->first_child = cb;
			current_css_block = cb;

			if (global_block_comment.size()) {
				cb->block_comment = global_block_comment;
				global_block_comment = "";
			}
			return;
		}

		// current_css_block->first_child != NULL
		struct css_block *cb = new_css_block();
		struct css_block *next = current_css_block->first_child;
		struct css_block *prev = next->prev_sibling;
		cb->next_sibling = NULL;
		cb->prev_sibling = prev;
		cb->parent = current_css_block;
		next->prev_sibling = cb;
		prev->next_sibling = cb;
		current_css_block = cb;

		if (global_block_comment.size()) {
			cb->block_comment = global_block_comment;
			global_block_comment = "";
		}
	};

	void exit_scope() {
		$xx;
		current_css_block = current_css_block->parent;
	}

	struct css_block *itor_enter(struct css_block *itor) {
		assert(itor != NULL);
		return itor->first_child;
	}

	struct css_block *itor_next(struct css_block *itor) {
		assert(itor != NULL);
		return itor->next_sibling;
	}

	struct css_block *itor_parent(struct css_block *itor) {
		assert(itor != NULL);
		return itor->parent;
	}

	struct css_block *get_itor() {
		auto ret = current_css_block;
		while (itor_enter(ret)) {
			ret = itor_enter(ret);
		}

		while (itor_parent(itor_parent(ret))) {
			ret = itor_parent(ret);
		}
		return ret;
	}

	void get_itor_selectors(const struct css_block *itor, strings &selectors) {
		selectors = itor->selectors;
	}

	void get_itor_declares(const struct css_block *itor, strings &declares) {
		declares = itor->declares;
	}

	string get_itor_declare_block_prefix(const struct css_block *itor) {
		return itor->declare_block_prefix;
	}

	string get_itor_block_comment(const struct css_block *itor) {
		return itor->block_comment;
	}

	static void delete_node_dfs(struct css_block *itor) {
		while (itor_enter(itor)) {
			delete_node_dfs(itor_enter(itor));
		}

		auto pitor = itor_parent(itor);
		if (pitor->first_child == itor) {
			pitor->first_child = itor->next_sibling;
			if (itor->next_sibling) {
				itor->next_sibling->prev_sibling = itor->prev_sibling;
			}
		} else if (pitor->first_child->prev_sibling == itor) {
			pitor->first_child->prev_sibling = itor->prev_sibling;
			itor->prev_sibling->next_sibling = itor->next_sibling;
		} else {
			itor->next_sibling->prev_sibling = itor->prev_sibling;
			itor->prev_sibling->next_sibling = itor->next_sibling;
		}

		delete itor;
	}

	static void process_nested_prop_dfs(struct css_block *itor) {
		if (itor_enter(itor)) {
			process_nested_prop_dfs(itor_enter(itor));
		}

		if (itor_next(itor)) {
			process_nested_prop_dfs(itor_next(itor));
		}

		if (get_itor_declare_block_prefix(itor).size()) {
			string prefix = get_itor_declare_block_prefix(itor);
			prefix = prefix.substr(0, prefix.size() - 1) + "-";
			strings declares;
			get_itor_declares(itor, declares);
			auto pit = itor_parent(itor);

			for (int i = 0; i < declares.size(); i++) {
				pit->declares.push_back(prefix + declares[i]);
			}

			delete_node_dfs(itor);
		}
	}

	void process_nested_prop() {
		process_nested_prop_dfs(get_itor());
	}

};  // namespace css_block_module
