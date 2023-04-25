.DEFAULT_GOAL := help

_BUILD := \
build-checkexec \
build-composer \
build-direnv \
build-eget \
build-fzf \
build-gcal \
build-gh \
build-git \
build-ghq \
build-gitlint \
build-go \
build-godl \
build-jnal \
build-gojq \
build-just \
build-lf \
build-rg \
build-starship \
build-sws \
build-tmpl \
build-usql \
build-vim \
build-xh \
build-yq \
build-zsh

_TARGETS := \
"bin" \
"config/composer" \
"config/direnv" \
"config/gcal" \
"config/gh" \
"config/git" \
"config/godl" \
"config/ideavim" \
"config/jnal" \
"config/lf" \
"config/nvim" \
"config/starship" \
"config/sws" \
"config/tmpl" \
"config/tmux" \
"config/zsh" \
"gnupg/gpg-agent.conf" \
"gnupg/gpg.conf" \
"vim" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"config/systemd" \
"config/ulauncher" \
"pam_environment"

ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
BIN := $(ROOT)/bin
CONFIG := $(ROOT)/config
OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')

define _clone_github_repo
	@[ ! -d "$(2)" ] && git clone https://github.com/$(1).git $(2) || true
endef

define _create_home_symlink
	if test -e "$(HOME)/.$(1)"; then \
		echo "already exists $(HOME)/.$(1)"; \
	else \
		ln -s $(CURDIR)/$(1) $(HOME)/.$(1) && echo "created $(HOME)/.$(1)"; \
	fi
endef

define _delete_home_symlink
	if test -h "$(HOME)/.$(1)"; then \
		unlink $(HOME)/.$(1) && echo "deleted $(HOME)/.$(1)"; \
	elif test -e "$(HOME)/.$(1)"; then \
		echo "no deleted $(HOME)/.$(1), not a symlink"; \
	else \
		echo "no exists $(HOME)/.$(1)"; \
	fi
endef

.PHONY: init
init: ## initilize
	mkdir -p $(BIN)

.PHONY: build
build: $(_BUILD) ## build all

.PHONY: clean
clean: ## delete all builded files
	@rm -rf $(BIN)
	@rm -f $(CONFIG)/composer/auth.json
	@rm -f $(CONFIG)/gcal/config.toml
	@rm -f $(CONFIG)/gcal/credentials.json
	@rm -f $(CONFIG)/gh/credentials.json
	@rm -f $(CONFIG)/gh/hosts.yml
	@rm -f $(CONFIG)/git/config
	@rm -f $(CONFIG)/godl/config.toml
	@rm -f $(CONFIG)/ideavim/ideavimrc
	@rm -f $(CONFIG)/jnal/config.toml
	@rm -f $(CONFIG)/tmpl/config.toml
	@rm -rf $(CONFIG)/zsh/antigen
	@rm -f $(CONFIG)/zsh/.zshrc
	@rm -f $(CONFIG)/zsh/.zlogin
	@rm -f $(CONFIG)/zsh/zlogin
	@rm -f $(CONFIG)/zsh/functions/_gcal
	@rm -f $(CONFIG)/zsh/functions/_godl
	@rm -f $(CONFIG)/zsh/functions/_jnal
	@rm -f $(CONFIG)/zsh/functions/_just
	@rm -f $(CONFIG)/zsh/functions/_tmpl
	@find $(CONFIG)/godl/goroots -mindepth 1 -maxdepth 1 -type d | xargs rm -rf
	@rm -rf $(ROOT)/vim/pack/bundle/start/*
	@rm -f $(ROOT)/dotfiles/secrets.env

.PHONY: install
install: ## create target's symlink in home directory
	@for TARGET in $(_TARGETS); do \
		$(call _create_home_symlink,"$$TARGET"); \
	done
	@if test "$(shell uname -s)" = "Linux"; then \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _create_home_symlink,"$$TARGET"); \
		done; \
		if test -f /opt/trackpoint-adjuster/apply.sh; then \
			systemctl --user enable trackpoint-adjuster.service; \
		fi; \
	fi

.PHONY: uninstall
uninstall: ## delete created symlink
	@for TARGET in $(_TARGETS); do \
		$(call _delete_home_symlink,"$$TARGET"); \
	done
	@if test "$(shell uname -s)" = "Linux"; then \
		if test -f /opt/trackpoint-adjuster/apply.sh; then \
			systemctl --user disable trackpoint-adjuster.service; \
		fi; \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _delete_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: build-bitwarden
build-bitwarden:
	@[ ! -f $(BIN)/bw ] && ./dotfiles/installer/bitwarden "$(BIN)" || true

.PHONY: build-checkexec
build-checkexec: build-eget
	@[ ! -f $(BIN)/checkexec ] && ./dotfiles/installer/checkexec "$(BIN)" || true

.PHONY: build-composer
build-composer:
	@env GITHUB_PERSONAL_ACCESS_TOKEN=$(shell $(BIN)/bw get password afcc443a-6d28-4950-b83b-afeb004c167b) envsubst '$${GITHUB_PERSONAL_ACCESS_TOKEN}' < $(CONFIG)/composer/auth.json.dist > $(CONFIG)/composer/auth.json

.PHONY: build-direnv
build-direnv: build-eget
	@[ ! -f $(BIN)/direnv ] && ./dotfiles/installer/direnv "$(BIN)" || true

.PHONY: build-eget
build-eget:
	@[ ! -e $(BIN)/eget ] && ./dotfiles/installer/eget "$(BIN)" || true

.PHONY: build-fzf
build-fzf: build-eget
	@[ ! -e $(BIN)/fzf ] && ./dotfiles/installer/fzf "$(BIN)" || true

.PHONY: build-gcal
build-gcal: build-checkexec build-eget
	@[ ! -f $(BIN)/gcal ] && ./dotfiles/installer/gcal "$(BIN)" || true
	@$(BIN)/bw get notes 8dbf52a0-9ca9-41ec-8750-afeb004ce918 > $(CONFIG)/gcal/credentials.json
	@$(BIN)/checkexec gcal/config.toml $(CONFIG)/gcal/config.toml.dist -- envsubst '$${HOME}' < $(CONFIG)/gcal/config.toml.dist > $(CONFIG)/gcal/config.toml

.PHONY: build-gh
build-gh: build-eget
	@[ ! -e $(BIN)/gh ] && ./dotfiles/installer/gh "$(BIN)" || true
	@env GITHUB_PERSONAL_ACCESS_TOKEN=$(shell $(BIN)/bw get password afcc443a-6d28-4950-b83b-afeb004c167b) envsubst '$${GITHUB_PERSONAL_ACCESS_TOKEN}' < $(CONFIG)/gh/hosts.yml.dist > $(CONFIG)/gh/hosts.yml

.PHONY: build-ghq
build-ghq: build-eget
	@[ ! -f $(BIN)/ghq ] && ./dotfiles/installer/ghq "$(BIN)" || true

.PHONY: build-git
build-git:
	@set -a && . ./dotfiles/secrets.env && set +a && envsubst '$${GPG_KEYID}' < $(CONFIG)/git/config.dist > $(CONFIG)/git/config

.PHONY: build-gitlint
build-gitlint: build-eget
	@[ ! -f $(BIN)/gitlint ] && ./dotfiles/installer/gitlint "$(BIN)" || true

.PHONY: build-go
build-go: build-godl
	@$(BIN)/godl install

.PHONY: build-godl
build-godl: build-checkexec build-eget
	@[ ! -f $(BIN)/godl ] && ./dotfiles/installer/godl "$(BIN)" || true
	@$(BIN)/checkexec godl/config.toml $(CONFIG)/godl/config.toml.dist -- envsubst '$${HOME}' < $(CONFIG)/godl/config.toml.dist > $(CONFIG)/godl/config.toml

.PHONY: build-ideavim
build-ideavim:
	@[ ! -f $(CONFIG)/ideavim/ideavimrc ] && cd $(CONFIG)/ideavim && ln -s ideavimrc.$(OS) ideavimrc || true

.PHONY: build-just
build-just: build-eget
	@[ ! -f $(BIN)/just ] && ./dotfiles/installer/just "$(BIN)" || true

.PHONY: build-gojq
build-gojq: build-eget
	@[ ! -e $(BIN)/gojq ] && ./dotfiles/installer/gojq "$(BIN)" || true
	@[ ! -e $(BIN)/jq ] && ln $(BIN)/gojq $(BIN)/jq || true

.PHONY: build-jnal
build-jnal: build-checkexec build-eget
	@[ ! -e $(BIN)/jnal ] && ./dotfiles/installer/jnal "$(BIN)" || true
	@$(BIN)/checkexec jnal/config.toml $(CONFIG)/jnal/config.toml.dist -- envsubst '$${HOME}' < $(CONFIG)/jnal/config.toml.dist > $(CONFIG)/jnal/config.toml

.PHONY: build-lf
build-lf: build-eget
	@[ ! -e $(BIN)/lf ] && ./dotfiles/installer/lf "$(BIN)" || true

.PHONY: build-rg
build-rg: build-eget
	@[ ! -e $(BIN)/rg ] && ./dotfiles/installer/rg "$(BIN)" || true

.PHONY: build-starship
build-starship:
	@[ ! -e $(BIN)/starship ] && ./dotfiles/installer/starship "$(BIN)" || true
	@[ ! -e $(CONFIG)/starship/config.toml ] && $(BIN)/starship preset pure-preset -o $(CONFIG)/starship/config.toml || true

.PHONY: build-sws
build-sws: build-eget
	@[ ! -e $(BIN)/sws ] && ./dotfiles/installer/sws "$(BIN)" || true

.PHONY: build-tmpl
build-tmpl: build-eget
	@[ ! -f $(BIN)/tmpl ] && ./dotfiles/installer/tmpl "$(BIN)" || true
	@$(BIN)/checkexec tmpl/config.toml $(CONFIG)/tmpl/config.toml.dist -- envsubst '$${HOME}' < $(CONFIG)/tmpl/config.toml.dist > $(CONFIG)/tmpl/config.toml

.PHONY: build-usql
build-usql: build-eget
	@[ ! -e $(BIN)/usql ] && ./dotfiles/installer/usql "$(BIN)" || true

.PHONY: build-vim
build-vim:
	$(call _clone_github_repo,thinca/vim-quickrun,vim/pack/bundle/start/vim-quickrun)
	$(call _clone_github_repo,vim-scripts/sudo.vim,vim/pack/bundle/start/sudo.vim)
	$(call _clone_github_repo,longkey1/vim-lf,vim/pack/bundle/start/vim-lf)
	$(call _clone_github_repo,nanotech/jellybeans.vim,vim/pack/bundle/start/jellybeans.vim)
	$(call _clone_github_repo,ConradIrwin/vim-bracketed-paste,vim/pack/bundle/start/vim-bracketed-paste)
	$(call _clone_github_repo,tyru/open-browser.vim,vim/pack/bundle/start/open-browser.vim)

.PHONY: build-xh
build-xh: build-eget
	@[ ! -e $(BIN)/xh ] && ./dotfiles/installer/xh "$(BIN)" || true

.PHONY: build-yq
build-yq: build-eget
	@[ ! -e $(BIN)/yq ] && ./dotfiles/installer/yq "$(BIN)" || true

.PHONY: build-zsh
build-zsh:  build-jnal build-gcal build-godl build-just build-tmpl build-starship
	@set -a && . ./dotfiles/secrets.env && set +a && envsubst '$${GPG_KEYGRIP}' < $(CONFIG)/zsh/zlogin.dist > $(CONFIG)/zsh/zlogin
	@[ ! -f $(CONFIG)/zsh/.zshrc ] && cd $(CONFIG)/zsh && ln -s zshrc .zshrc || true
	@[ ! -f $(CONFIG)/zsh/.zlogin ] && cd $(CONFIG)/zsh && ln -s zlogin .zlogin || true
	@mkdir -p $(CONFIG)/zsh/plugins
	$(call _clone_github_repo,zsh-users/zsh-completions,$(CONFIG)/zsh/plugins/zsh-users/zsh-completions)
	$(call _clone_github_repo,zsh-users/zsh-history-substring-search,$(CONFIG)/zsh/plugins/zsh-users/zsh-history-substring-search)
	$(call _clone_github_repo,zsh-users/zsh-syntax-highlighting,$(CONFIG)/zsh/plugins/zsh-users/zsh-syntax-highlighting)
	$(call _clone_github_repo,mollifier/anyframe,$(CONFIG)/zsh/plugins/mollifier/anyframe)
	$(call _clone_github_repo,olets/zsh-abbr,$(CONFIG)/zsh/plugins/olets/zsh-abbr)
	@$(BIN)/gcal --config $(CONFIG)/gcal/config.toml completion zsh > $(CONFIG)/zsh/functions/_gcal
	@$(BIN)/godl completion zsh > $(CONFIG)/zsh/functions/_godl
	@$(BIN)/jnal --config $(CONFIG)/jnal/config.toml completion zsh > $(CONFIG)/zsh/functions/_jnal
	@$(BIN)/just --completions zsh > $(CONFIG)/zsh/functions/_just
	@$(BIN)/tmpl --config $(CONFIG)/tmpl/config.toml completion zsh > $(CONFIG)/zsh/functions/_tmpl



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
