.PHONY: all bin default

all: bin dotfiles etc 

default: install

install: all

bin:
	# add aliases for things in bin

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".git"); do \
            f=$$(basename $$file); \
            ln -sfn $$file $(HOME)/$$f; \
    done;
	
etc:

