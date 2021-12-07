.DEFAULT_GOAL := help

_BUILD := \
build-arc \
build-bat \
build-diary \
build-direnv \
build-envsubst \
build-fzf \
build-gcal \
build-gh \
build-ghq \
build-gitlint \
build-go \
build-godl \
build-jira \
build-jq \
build-just \
build-lf \
build-mark \
build-ran \
build-rg \
build-tmpl \
build-vim \
build-yq \
build-zsh

_TARGETS := \
"bin" \
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

_GOROOTS := goroots
_GOVERSIONS := \
"1.16.5" \
"1.15.13" \
"1.14.15" \
"1.13.15" \
"1.12.17" \
"1.11.13"

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

.PHONY: build
build: $(_BUILD) ## build all

.PHONY: clean
clean: ## delete all builded files
	@find $(_OPT) -type f -o -type l | grep -v .gitignore | xargs rm -rf
	@rm -f $(_CONFIG)/composer/auth.json
	@rm -f $(_CONFIG)/diary/config.toml
	@rm -f $(_CONFIG)/gcal/config.toml
	@rm -f $(_CONFIG)/git/config.local
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

.PHONY: build-arc
build-arc:
	@[ ! -e $(_LOCAL_BIN)/arc ] && ./builders/arc || true

.PHONY: build-bat
build-bat:
	@[ ! -e $(_LOCAL_BIN)/bat ] && ./builders/bat || true

.PHONY: build-diary
build-diary: build-jq build-envsubst
	@[ ! -e $(_OPT)/diary ] && ./builders/diary "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/diary/config.toml ] && $(_OPT)/envsubst '$$HOME $$EDITOR' < $(_CONFIG)/diary/config.toml.dist > $(_CONFIG)/diary/config.toml || true

.PHONY: build-direnv
build-direnv: build-jq
	@[ ! -f $(_OPT)/direnv ] && ./builders/direnv "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-envsubst
build-envsubst: build-jq
	@[ ! -e $(_OPT)/envsubst ] && ./builders/envsubst "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-fzf
build-fzf:
	@[ ! -e $(_LOCAL_BIN)/fzf ] && ./builders/fzf || true

.PHONY: build-gcal
build-gcal: build-jq build-envsubst
	@[ ! -f $(_OPT)/gcal ] && ./builders/gcal "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/gcal/config.toml ] && $(_OPT)/envsubst '$$HOME' < $(_CONFIG)/gcal/config.toml.dist > $(_CONFIG)/gcal/config.toml || true
	@$(call _decrypt,$(_CONFIG)/gcal/credentials.json)

.PHONY: build-gh
build-gh:
	@[ ! -e $(_LOCAL_BIN)/gh ] && ./builders/gh || true
	@$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-ghq
build-ghq: build-jq build-arc
	@[ ! -f $(_OPT)/ghq ] && ./builders/ghq "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-gitlint
build-gitlint: build-jq
	@[ ! -f $(_OPT)/gitlint ] && ./builders/gitlint "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-go
build-go: build-godl
	@for GOVERSION in $(_GOVERSIONS); do \
		$(_OPT)/godl --goroots $(_CONFIG)/godl/goroots --temp $(_CONFIG)/godl/tmp install $$GOVERSION || true; \
	done

.PHONY: build-godl
build-godl: build-jq
	@[ ! -f $(_OPT)/godl ] && ./builders/godl "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-ideavim
build-ideavim:
	@[ ! -f $(_CONFIG)/ideavim/ideavimrc ] && cd $(_CONFIG)/ideavim && ln -s ideavimrc.$(_OS) ideavimrc || true

.PHONY: build-jira
build-jira: build-jq
	@[ ! -f $(_OPT)/jira ] && ./builders/jira "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-just
build-just: build-jq build-arc
	@[ ! -f $(_OPT)/just ] && ./builders/just "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-jq
build-jq:
	@[ ! -e $(_LOCAL_BIN)/jq ] && ./builders/jq || true

.PHONY: build-lf
build-lf:
	@[ ! -e $(_LOCAL_BIN)/lf ] && ./builders/lf || true

.PHONY: build-mark
build-mark:
	@[ ! -e $(_OPT)/mark ] && ./builders/mark "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-ran
build-ran: build-jq
	@[ ! -f $(_OPT)/ran ] && ./builders/ran "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true

.PHONY: build-rg
build-rg:
	@[ ! -e $(_LOCAL_BIN)/rg ] && ./builders/rg || true

.PHONY: build-tmpl
build-tmpl: build-jq build-envsubst
	@[ ! -f $(_OPT)/tmpl ] && ./builders/tmpl "$(_LOCAL_BIN)" "$(_ROOT)/$(_OPT)" || true
	@[ ! -f $(_CONFIG)/tmpl/config.toml ] && $(_OPT)/envsubst '$$HOME' < $(_CONFIG)/tmpl/config.toml.dist > $(_CONFIG)/tmpl/config.toml || true

.PHONY: build-vim
build-vim:
	$(call _clone_github_repo,thinca/vim-quickrun,vim/pack/bundle/start/vim-quickrun)
	$(call _clone_github_repo,vim-scripts/sudo.vim,vim/pack/bundle/start/sudo.vim)
	$(call _clone_github_repo,longkey1/vim-lf,vim/pack/bundle/start/vim-lf)
	$(call _clone_github_repo,nanotech/jellybeans.vim,vim/pack/bundle/start/jellybeans.vim)
	$(call _clone_github_repo,ConradIrwin/vim-bracketed-paste,vim/pack/bundle/start/vim-bracketed-paste)
	$(call _clone_github_repo,prabirshrestha/vim-lsp,vim/pack/bundle/start/vim-lsp)
	$(call _clone_github_repo,mattn/vim-lsp-settings,vim/pack/bundle/start/vim-lsp-settings)
	$(call _clone_github_repo,prabirshrestha/asyncomplete.vim,vim/pack/bundle/start/asyncomplete.vim)
	$(call _clone_github_repo,prabirshrestha/asyncomplete-lsp.vim,vim/pack/bundle/start/asyncomplete-lsp.vim)
	$(call _clone_github_repo,tyru/open-browser.vim,vim/pack/bundle/start/open-browser.vim)

.PHONY: build-yq
build-yq:
	@[ ! -e $(_LOCAL_BIN)/yq ] && ./builders/yq || true

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
