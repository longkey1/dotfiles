TARGETS := \
"bundle" \
"gitconfig" \
"gitignore" \
"git-template" \
"git-commit-message" \
"config/nvim" \
"tmux" \
"tmux.conf" \
"vim" \
"vimrc" \
"xprofile" \
"zprezto" \
"zlogin" \
"zlogout" \
"zpreztorc" \
"zprofile" \
"zshenv" \
"zshrc" \
"zshrc.prezto"

.PHONY: all
all: ## submodule update init
	git submodule update --init --recursive

.PHONY: install
install: ## create target's symlink in home directory
	@for TARGET in $(TARGETS); do \
		if [ -e "$(HOME)/.$$TARGET" ]; then \
			echo "already exists $$TARGET"; \
		else \
			ln -s $(CURDIR)/$$TARGET $(HOME)/.$$TARGET; \
			echo "created $$TARGET"; \
		fi \
	done

.PHONY: uninstall
uninstall: ## delete created symlink
	@for TARGET in $(TARGETS); do \
		if [ -h "$(HOME)/.$$TARGET" ]; then \
			rm $(HOME)/.$$TARGET; \
			echo "deleted .$$TARGET"; \
  	elif [ -e "$(HOME)/.$$TARGET" ]; then \
			echo "no symlink $$TARGET"; \
		else \
			echo "no exists $$TARGET"; \
		fi \
	done

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
