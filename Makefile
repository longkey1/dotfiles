.DEFAULT_GOAL := help

_BUILD := \
build-diary \
build-direnv \
build-eget \
build-envsubst \
build-fzf \
build-gcal \
build-gh \
build-ghq \
build-gitlint \
build-go \
build-godl \
build-jira \
build-gojq \
build-just \
build-lf \
build-mark \
build-rg \
build-tmpl \
build-usql \
build-vim \
build-yq \
build-xh \
build-zsh

_TARGETS := \
"config/composer" \
"config/diary" \
"config/direnv" \
"config/gcal" \
"config/gh" \
"config/git" \
"config/godl" \
"config/ideavim" \
"config/lf" \
"config/nvim" \
"config/tmpl" \
"config/tmux" \
"config/zsh" \
"vim" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"config/fontconfig" \
"config/systemd" \
"config/ulauncher" \
"pam_environment"

_ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
_OPT := opt
_CONFIG := config
_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
_LOCAL_BIN := $(HOME)/.local/bin
_BIN_TARGETS := $(shell find $(_OPT) -type f -print0 | xargs -0 -n1 basename | grep -v .gitignore)

define _executable
	@if ! type $(1) &> /dev/null; then \
		echo "not found $(1) command."; \
		exit 1; \
	fi
endef

define _encrypt
	@[ ! -e "$(1).encrypted" ] && openssl enc -aes-256-cbc -e -salt -pbkdf2 -in $(1) -out $(1).encrypted || true
endef

define _decrypt
	@[ ! -e "$(1)" ] && openssl enc -aes-256-cbc -d -salt -pbkdf2 -in $(1).encrypted -out $(1) || true
endef

define _clone_github_repo
	@[ ! -d "$(2)" ] && git clone https://github.com/$(1).git $(2) || true
endef

define _build_go_binary
	curl -sf https://gobinaries.com/$(1) | PREFIX=$(_OPT) sh
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

define _create_local_bin_symlink
	if test -e "$(_LOCAL_BIN)/$(1)"; then \
		echo "already exists $(_LOCAL_BIN)/$(1)"; \
	else \
		ln -s $(CURDIR)/$(_OPT)/$(1) $(_LOCAL_BIN) && echo "created $(_LOCAL_BIN)/$(1)"; \
	fi
endef

define _delete_local_bin_symlink
	if test -h "$(_LOCAL_BIN)/$(1)"; then \
		unlink $(_LOCAL_BIN)/$(1) && echo "deleted $(_LOCAL_BIN)/$(1)"; \
	elif test -e "$(_LOCAL_BIN)/$(1)"; then \
		echo "no deleted $(_LOCAL_BIN)/$(1), not a symlink"; \
	else \
		echo "no exists $(_LOCAL_BIN)/$(1)"; \
	fi
endef

.PHONY: build
build: $(_BUILD) ## build all

.PHONY: clean
clean: ## delete all builded files
	@find $(_OPT) -type f -o -type l | grep -v .gitignore | xargs rm -rf
	@rm -f $(_CONFIG)/composer/auth.json
	@rm -f $(_CONFIG)/diary/config.toml
	@rm -f $(_CONFIG)/gcal/config.toml
	@rm -f $(_CONFIG)/git/config.local
	@rm -f $(_CONFIG)/godl/config.toml
	@rm -f $(_CONFIG)/ideavim/ideavimrc
	@rm -rf $(_CONFIG)/zsh/antigen
	@rm -f $(_CONFIG)/zsh/.zshrc
	@rm -f $(_CONFIG)/zsh/zshrc.local
	@find $(_CONFIG)/godl/goroots -mindepth 1 -maxdepth 1 -type d | xargs rm -rf
	@rm -rf vim/pack/bundle/start/*
	@rm -f $(_CONFIG)/zsh/functions/_diary
	@rm -f $(_CONFIG)/zsh/functions/_gcal
	@rm -f $(_CONFIG)/zsh/functions/_godl
	@rm -f $(_CONFIG)/zsh/functions/_just
	@rm -f $(_CONFIG)/zsh/functions/_tmpl

.PHONY: install
install: ## create target's symlink in home directory
	@for TARGET in $(_TARGETS); do \
		$(call _create_home_symlink,"$$TARGET"); \
	done
	@for TARGET in $(_BIN_TARGETS); do \
		$(call _create_local_bin_symlink,"$$TARGET"); \
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
	@for TARGET in $(_BIN_TARGETS); do \
		$(call _delete_local_bin_symlink,"$$TARGET"); \
	done
	@if test "$(shell uname -s)" = "Linux"; then \
		if test -f /opt/trackpoint-adjuster/apply.sh; then \
			systemctl --user disable trackpoint-adjuster.service; \
		fi; \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _delete_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: encrypt
encrypt: ## encrypt files
	$(call _encrypt,$(_CONFIG)/composer/auth.json)
	$(call _encrypt,$(_CONFIG)/gcal/credentials.json)
	$(call _encrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: decrypt
decrypt: ## decrypt files
	$(call _decrypt,$(_CONFIG)/composer/auth.json)
	$(call _decrypt,$(_CONFIG)/gcal/credentials.json)
	$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-diary
build-diary: build-eget build-envsubst
	@[ ! -e $(_OPT)/diary ] && ./builders/diary "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/diary/config.toml ] && $(_OPT)/envsubst '$$HOME $$EDITOR' < $(_CONFIG)/diary/config.toml.dist > $(_CONFIG)/diary/config.toml || true

.PHONY: build-direnv
build-direnv: build-eget
	@[ ! -f $(_OPT)/direnv ] && ./builders/direnv "$(_ROOT)/$(_OPT)" || true

.PHONY: build-eget
build-eget:
	@[ ! -e $(_OPT)/eget ] && ./builders/eget "$(_ROOT)/$(_OPT)" || true

.PHONY: build-envsubst
build-envsubst: build-eget
	@[ ! -e $(_OPT)/envsubst ] && ./builders/envsubst "$(_ROOT)/$(_OPT)" || true

.PHONY: build-fzf
build-fzf: build-eget
	@[ ! -e $(_OPT)/fzf ] && ./builders/fzf "$(_ROOT)/$(_OPT)" || true

.PHONY: build-gcal
build-gcal: build-eget build-envsubst
	@[ ! -f $(_OPT)/gcal ] && ./builders/gcal "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/gcal/config.toml ] && $(_OPT)/envsubst '$$HOME' < $(_CONFIG)/gcal/config.toml.dist > $(_CONFIG)/gcal/config.toml || true
	@$(call _decrypt,$(_CONFIG)/gcal/credentials.json)

.PHONY: build-gh
build-gh: build-eget
	@[ ! -e $(_OPT)/gh ] && ./builders/gh "$(_ROOT)/$(_OPT)" || true
	@$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-ghq
build-ghq: build-eget
	@[ ! -f $(_OPT)/ghq ] && ./builders/ghq "$(_ROOT)/$(_OPT)" || true

.PHONY: build-gitlint
build-gitlint: build-eget
	@[ ! -f $(_OPT)/gitlint ] && ./builders/gitlint "$(_ROOT)/$(_OPT)" || true

.PHONY: build-go
build-go: build-godl
	$(_OPT)/godl install

.PHONY: build-godl
build-godl: build-eget build-envsubst
	@[ ! -f $(_OPT)/godl ] && ./builders/godl "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/godl/config.toml ] && $(_OPT)/envsubst '$$HOME' < $(_CONFIG)/godl/config.toml.dist > $(_CONFIG)/godl/config.toml || true

.PHONY: build-ideavim
build-ideavim:
	@[ ! -f $(_CONFIG)/ideavim/ideavimrc ] && cd $(_CONFIG)/ideavim && ln -s ideavimrc.$(_OS) ideavimrc || true

.PHONY: build-jira
build-jira: build-eget
	@[ ! -f $(_OPT)/jira ] && ./builders/jira "$(_ROOT)/$(_OPT)" || true

.PHONY: build-just
build-just: build-eget
	@[ ! -f $(_OPT)/just ] && ./builders/just "$(_ROOT)/$(_OPT)" || true

.PHONY: build-gojq
build-gojq: build-eget
	@[ ! -e $(_OPT)/gojq ] && ./builders/gojq "$(_ROOT)/$(_OPT)" || true

.PHONY: build-lf
build-lf: build-eget
	@[ ! -e $(_OPT)/lf ] && ./builders/lf "$(_ROOT)/$(_OPT)" || true

.PHONY: build-mark
build-mark: build-eget
	@[ ! -e $(_OPT)/mark ] && ./builders/mark "$(_ROOT)/$(_OPT)" || true

.PHONY: build-rg
build-rg: build-eget
	@[ ! -e $(_OPT)/rg ] && ./builders/rg "$(_ROOT)/$(_OPT)" || true

.PHONY: build-tmpl
build-tmpl: build-eget build-envsubst
	@[ ! -f $(_OPT)/tmpl ] && ./builders/tmpl "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/tmpl/config.toml ] && $(_OPT)/envsubst '$$HOME' < $(_CONFIG)/tmpl/config.toml.dist > $(_CONFIG)/tmpl/config.toml || true

.PHONY: build-usql
build-usql: build-eget
	@[ ! -e $(_OPT)/usql ] && ./builders/usql "$(_ROOT)/$(_OPT)" || true

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
	@[ ! -e $(_OPT)/xh ] && ./builders/xh "$(_ROOT)/$(_OPT)" || true

.PHONY: build-yq
build-yq: build-eget
	@[ ! -e $(_OPT)/yq ] && ./builders/yq "$(_ROOT)/$(_OPT)" || true

.PHONY: build-zsh
build-zsh:  build-diary build-gcal build-godl build-just build-tmpl
	@[ ! -f $(_CONFIG)/zsh/.zshrc ] && cd $(_CONFIG)/zsh && ln -s zshrc .zshrc || true
	$(call _clone_github_repo,zsh-users/antigen,config/zsh/antigen)
	@$(_OPT)/diary --config $(_CONFIG)/diary/config.toml completion zsh > $(_CONFIG)/zsh/functions/_diary
	@$(_OPT)/gcal --config $(_CONFIG)/gcal/config.toml completion zsh > $(_CONFIG)/zsh/functions/_gcal
	@$(_OPT)/godl completion zsh > $(_CONFIG)/zsh/functions/_godl
	@$(_OPT)/just --completions zsh > $(_CONFIG)/zsh/functions/_just
	@$(_OPT)/tmpl --config $(_CONFIG)/tmpl/config.toml completion zsh > $(_CONFIG)/zsh/functions/_tmpl



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
