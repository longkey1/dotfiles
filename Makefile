.DEFAULT_GOAL := help
SHELL := /bin/bash

TARGETS := \
"bin" \
"bundle" \
"gitconfig" \
"gitignore" \
"git-hooks" \
"git-commit-message" \
"config/memo" \
"config/nvim" \
"netrc" \
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

OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH := amd64

define _get_github_download_url
	$(shell curl -s https://api.github.com/repos/$(1)/releases/latest | jq -r ".assets[] | select(.name | contains(\"$(OS)\") and contains(\"$(ARCH)\") and (contains(\".sha256\") | not)) | .browser_download_url")
endef

.PHONY: build
build: decript-netrc ## submodule update init and decrypt netrc
	git submodule update --init --recursive
	@if ! type bsdtar &> /dev/null; then \
		echo "not found bsdtar command." && exit 1; \
	fi
	@if ! type jq &> /dev/null; then \
		echo "not found jq command." && exit 1; \
	fi
	@if ! type envsubst &> /dev/null ; then \
		echo "not found envsubst command." && exit 1; \
	fi
	@if test ! -f ./bin/composer; then \
		wget "https://getcomposer.org/composer.phar" -O ./bin/composer && chmod +x ./bin/composer; \
	fi
	@if test ! -f ./bin/dep; then \
		wget $(call _get_github_download_url,"golang/dep") -O ./bin/dep && chmod +x ./bin/dep; \
	fi
	@if test ! -f ./bin/direnv; then \
		wget $(call _get_github_download_url,"direnv/direnv") -O ./bin/direnv && chmod +x ./bin/direnv; \
	fi
	@if test ! -f ./bin/esampo; then \
		wget $(call _get_github_download_url,"longkey1/esampo") -O ./bin/esampo && chmod +x ./bin/esampo; \
	fi
	@if test ! -f ./bin/ghq; then \
		wget $(call _get_github_download_url,"motemen/ghq") -O- | bsdtar -xvf- -C ./bin 'ghq' && chmod +x ./bin/ghq; \
	fi
	@if test ! -f ./bin/peco; then \
		wget $(call _get_github_download_url,"peco/peco") -O- | bsdtar -xvf- -C ./bin --strip=1 '*/peco' && chmod +x ./bin/peco; \
	fi
	@if test ! -f ./bin/pt; then \
		wget $(call _get_github_download_url,"monochromegane/the_platinum_searcher") -O- | bsdtar -xvf- -C ./bin --strip=1 '*/pt' && chmod +x ./bin/pt; \
	fi
	@if test ! -f ./bin/memo; then \
		wget $(call _get_github_download_url,"mattn/memo") -O- | bsdtar -xvf- -C ./bin 'memo' && chmod +x ./bin/memo; \
		envsubst < config/memo/config.toml.dist > config/memo/config.toml
	fi

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
