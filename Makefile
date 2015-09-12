.PHONY: all bin default

all: bin dotfiles etc init

default: install

install: all

bin:
	# add aliases for things in bin

dotfiles:
	# add aliases for dotfiles
	
etc:

init:
	# install init scripts
	# of course systemd hates aliases or some bullshit
