SHELL := /bin/bash

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
"xprofile" \
"zshrc" \
"zshrc.zgen"

LINUX_ONLY_TARGETS := \
"Xmodmap" \
"xprofile" \

COMPOSER := "https://getcomposer.org/composer.phar"

DEP_Darwin := $(shell curl -s https://api.github.com/repos/golang/dep/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin-amd64\")) | .browser_download_url")
DEP_Linux := $(shell curl -s https://api.github.com/repos/golang/dep/releases/latest | jq -r ".assets[] | select(.name | test(\"linux-amd64\")) | .browser_download_url")

DIRENV_Darwin := $(shell curl -s https://api.github.com/repos/direnv/direnv/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin-amd64\")) | .browser_download_url")
DIRENV_Linux := $(shell curl -s https://api.github.com/repos/direnv/direnv/releases/latest | jq -r ".assets[] | select(.name | test(\"linux-amd64\")) | .browser_download_url")

ESAMPO_Darwin := $(shell curl -s https://api.github.com/repos/longkey1/esampo/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin_amd64\")) | .browser_download_url")
ESAMPO_Linux := $(shell curl -s https://api.github.com/repos/longkey1/esampo/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_amd64\")) | .browser_download_url")

GHQ_Darwin := $(shell curl -s https://api.github.com/repos/motemen/ghq/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin_amd64\")) | .browser_download_url")
GHQ_Linux := $(shell curl -s https://api.github.com/repos/motemen/ghq/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_amd64\")) | .browser_download_url")

PECO_Darwin := $(shell curl -s https://api.github.com/repos/peco/peco/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin_amd64\")) | .browser_download_url")
PECO_Linux := $(shell curl -s https://api.github.com/repos/peco/peco/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_amd64\")) | .browser_download_url")

PT_Darwin := $(shell curl -s https://api.github.com/repos/monochromegane/the_platinum_searcher/releases/latest | jq -r ".assets[] | select(.name | test(\"darwin_amd64\")) | .browser_download_url")
PT_Linux := $(shell curl -s https://api.github.com/repos/monochromegane/the_platinum_searcher/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_amd64\")) | .browser_download_url")

.PHONY: build
build: decript-netrc ## submodule update init and decrypt netrc
	@if ! type bsdtar &> /dev/null ; then \
		echo "not found basdtar command." && exit 1; \
	fi
	@if ! type jq &> /dev/null ; then \
		echo "not found jq command." && exit 1; \
	fi
	git submodule update --init --recursive
	wget $(COMPOSER) -O ./bin/composer && chmod +x ./bin/composer
	$(eval UNAME := $(shell uname -s))
	wget $(DEP_$(UNAME)) -O ./bin/dep && chmod +x ./bin/dep
	wget $(DIRENV_$(UNAME)) -O ./bin/direnv && chmod +x ./bin/direnv
	wget $(ESAMPO_$(UNAME)) -O ./bin/esampo && chmod +x ./bin/esampo
	wget $(GHQ_$(UNAME)) -O- | bsdtar -xvf- -C ./bin 'ghq' && chmod +x ./bin/ghq
	wget $(PECO_$(UNAME)) -O- | bsdtar -xvf- -C ./bin --strip=1 '*/peco' && chmod +x ./bin/peco
	wget $(PT_$(UNAME)) -O- | bsdtar -xvf- -C ./bin --strip=1 '*/pt' && chmod +x ./bin/pt

.PHONY: clean
clean: ## delete builded files
	@find ./bin -type f | grep -v .gitignore | xargs rm -rf

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
			unlink $(HOME)/.$$TARGET; \
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

.PHONY: rebuild
rebuild: clean build ## clean and build

.PHONY: reinstall
reinstall: uninstall install ## uninstall and install

.PHONY: encript-netrc
encript-netrc: ## encript netrc
	openssl aes-256-cbc -e -md sha256 -in netrc -out netrc.encrypted

.PHONY: decript-netrc
decript-netrc: ## decript netrc
	openssl aes-256-cbc -d -md sha256 -in netrc.encrypted -out netrc


.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
