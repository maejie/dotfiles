RSYNC_OPTS = --exclude ".git/" --exclude ".DS_Store" --exclude "README.md" --exclude="Makefile" -avh --no-perms
DOTFILES_DIR = $(PWD)
FILES_TO_BE_LINKED = .??* bin
DOTFILES_FILE = $(addprefix $(DOTFILES_DIR)/, $(FILES_TO_BE_LINKED))

all:
	help

help:
	@echo "make list             #=> list the files"
	@echo "make deploy           #=> create symlink"
	@echo "make update           #=> fetch changes"
	@echo "make install          #=> setup environment"
	@echo "make clean            #=> remove the files"

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(val);)

deploy:
	@echo 'Start deploy dotfiles current directory.'
	@echo 'If this is "dotdir", curretly it is ignored and copy your hand.'
	@echo ''
	@$(foreach var, $(DOTFILES_FILES), ln -sfnv $(abspath $(var)) $(HOME)/$(val);)

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install:
	@for x in $(wildcard ./etc/init/*.sh); \
		do \
		echo "Makefile: $$x"; \
		bash $$x 2>/dev/null; \
		done
ifeq ($(shell uname), Darwin)
	@for x in $(wildcard ./etc/osx/*.sh); \
		do \
		echo "Makefile: $$x"; \
		bash $$x 2>/dev/null; \
		done
endif

clean:
	@echo "rm -rf files..."
	@for f in .??* ; do \
		rm -v -rf ~/"$${f}" ; \
	done ; true
	rm -rf ~/.vim
	rm -rf ~/.vital
	rm -rf $(DOTFILES_DIR)
