export
CC := g++
CPPFLAGS := -g
CPPFLAGS += -DYYDEBUG
# CPPFLAGS += -O3
CPPFLAGS += -std=c++11
CPPFLAGS += -I$(CURDIR)/inc/
CPPFLAGS += -I$(CURDIR)/out/

OUTDIR := $(CURDIR)/out
objs := $(patsubst %.cpp, %.o, $(wildcard $(CURDIR)/src/*/*.cpp))
objs += $(patsubst %.cpp, %.o, $(wildcard $(CURDIR)/out/*.cpp))

.PHONY: default
default: tools src install
	make clean

.PHONY: tools
tools:
	make -C tools/
	make install -C tools/

.PHONY: src
src:
	[ -e $(OUTDIR) ] || mkdir -p $(OUTDIR)
	make -C src/
	make install -C src/

.PHONY: test
test:
	make -C test/
	make install -C test/

.PHONY: install
install:
	mv $(OUTDIR)/scss ./scss

.PHONY: clean
clean:
	-find -name "*.o" | xargs rm -f
