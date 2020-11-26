objs := $(patsubst %.scss, %.css, $(wildcard $(CURDIR)/*.scss))

.PHONY: default
default: $(objs)
	echo $(objs)

%.css: %.scss
	sass --no-source-map $< $@

.PHONY: install
install:
	mv *.css $(OUTDIR)/
