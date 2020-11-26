#include "modules/css_block.h"
#include "modules/log.h"

namespace css_block_module {

	struct css_block {
		strings selectors;
		strings declares;
		css_block *parent;
		css_block *first_child;
		css_block *next_sibling;
		css_block *prev_sibling;
	};

	static struct css_block *new_css_block() {
		struct css_block *cb = new struct css_block;
		cb->parent = NULL;
		cb->first_child = NULL;
		cb->next_sibling = NULL;
		cb->prev_sibling = NULL;
		return cb;
	}

	struct css_block *current_css_block = new_css_block();

	void add_selector(string selector) {
		$xx;
		assert(current_css_block != NULL);

		current_css_block->selectors.push_back(selector);
	}

	void add_declare(string declare) {
		$xx;
		assert(current_css_block != NULL);

		current_css_block->declares.push_back(declare);
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

};  // namespace css_block_module
