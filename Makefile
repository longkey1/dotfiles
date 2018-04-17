TARGETS := \
"bin" \
"bundle" \
"gitconfig" \
"gitignore" \
"git-hooks" \
"git-commit-message" \
"config/nvim" \
"ocamlinit" \
"tmux" \
"tmux.conf" \
"vim" \
"vimrc" \
"Xmodmap" \
"xprofile" \
"zshrc" \
"zshrc.zgen"

LINUX_ONLY_TARGETS := \
"Xmodmap" \
"xprofile" \

COMPOSER := "https://getcomposer.org/download/1.6.3/composer.phar"

ESAMPO_Darwin := "https://github.com/longkey1/esampo/releases/download/v0.0.3/esampo_darwin_amd64"
ESAMPO_Linux := "https://github.com/longkey1/esampo/releases/download/v0.0.3/esampo_linux_amd64"

DEP_Darwin := "https://github.com/monochromegane/the_platinum_searcher/releases/download/v2.1.5/pt_darwin_amd64.zip"
DEP_Linux := "https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64"

DIRENV_Darwin := "https://github.com/direnv/direnv/releases/download/v2.15.2/direnv.darwin-amd64"
DIRENV_Linux := "https://github.com/direnv/direnv/releases/download/v2.15.2/direnv.linux-amd64"

.PHONY: all
all: decript-netrc ## submodule update init and decrypt netrc
	git submodule update --init --recursive
	wget $(COMPOSER) -O ./bin/composer && chmod +x ./bin/composer
	$(eval UNAME := $(shell uname -s))
	wget $(ESAMPO_$(UNAME)) -O ./bin/esampo && chmod +x ./bin/esampo
	wget $(DEP_$(UNAME)) -O ./bin/dep && chmod +x ./bin/dep
	wget $(DIRENV_$(UNAME)) -O ./bin/direnv && chmod +x ./bin/direnv

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
	@if [ "$(UNAME)" = "Linux" ]; then \
		for TARGET in $(LINUX_ONLY_TARGETS); do \
			if [ -h "$(HOME)/.$$TARGET" ]; then \
				rm $(HOME)/.$$TARGET; \
			fi \
		done \
	fi
	@if [ -e "$(HOME)/.zgen" ]; then \
		echo "already exists $(HOME)/.zgen"; \
	else \
		git clone https://github.com/tarjoilija/zgen.git "$(HOME)/.zgen"; \
	fi

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
	@if [ -e "$(HOME)/.zgen" ]; then \
		rm -rf "${HOME}/.zgen"; \
		echo "deleted $(HOME)/.zgen"; \
	else \
		echo "no exists $(HOME)/.zgen"; \
	fi

.PHONY: encript-netrc
encript-netrc: ## encript netrc
	openssl aes-256-cbc -e -md sha256 -in netrc -out netrc.encrypted

.PHONY: decript-netrc
decript-netrc: ## decript netrc
	openssl aes-256-cbc -d -md sha256 -in netrc.encrypted -out netrc

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
