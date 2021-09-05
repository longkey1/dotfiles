.DEFAULT_GOAL := help

_BUILD := \
build-archiver \
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
build-just \
build-lf \
build-ran \
build-ripgrep \
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
"config/lf" \
"config/nvim" \
"config/tmpl" \
"config/tmux" \
"config/zsh" \
"ideavimrc" \
"vim" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"config/fontconfig" \
"config/systemd" \
"config/ulauncher" \
"pam_environment"

_ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
_BIN := bin
_CONFIG := config

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
	curl -sf https://gobinaries.com/$(1) | PREFIX=$(_BIN) sh
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
build: $(_BUILD);

.PHONY: clean
clean: ## delete all builded files
	@find $(_BIN) -type f -o -type l | grep -v .gitignore | xargs rm -rf
	@rm -f $(_CONFIG)/composer/auth.json
	@rm -f $(_CONFIG)/diary/config.toml
	@rm -f $(_CONFIG)/gcal/config.toml
	@rm -f $(_CONFIG)/git/config.local
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

.PHONY: build-archiver
build-archiver:
	@[ ! -f $(_BIN)/arc ] && ./builders/archiver "$(_ROOT)/$(_BIN)" || true

.PHONY: build-bat
build-bat: build-archiver
	@[ ! -f $(_BIN)/bat ] && ./builders/bat "$(_ROOT)/$(_BIN)" || true

.PHONY: build-diary
build-diary: build-envsubst
	@[ ! -f $(_BIN)/diary ] && ./builders/diary "$(_ROOT)/$(_BIN)" || true
	@[ ! -f $(_CONFIG)/diary/config.toml ] && envsubst '$$HOME $$EDITOR' < $(_CONFIG)/diary/config.toml.dist > $(_CONFIG)/diary/config.toml || true

.PHONY: build-direnv
build-direnv:
	@[ ! -f $(_BIN)/direnv ] && ./builders/direnv "$(_ROOT)/$(_BIN)" || true

.PHONY: build-envsubst
build-envsubst:
	@[ ! -f $(_BIN)/envsubst ] && ./builders/envsubst "$(_ROOT)/$(_BIN)" || true

.PHONY: build-fzf
build-fzf: build-archiver
	@[ ! -f $(_BIN)/fzf ] && ./builders/fzf "$(_ROOT)/$(_BIN)" || true

.PHONY: build-gcal
build-gcal:
	@[ ! -f $(_BIN)/gcal ] && ./builders/gcal "$(_ROOT)/$(_BIN)" || true
	@[ ! -f $(_CONFIG)/gcal/config.toml ] && envsubst '$$HOME' < $(_CONFIG)/gcal/config.toml.dist > $(_CONFIG)/gcal/config.toml || true
	@$(call _decrypt,$(_CONFIG)/gcal/credentials.json)

.PHONY: build-gh
build-gh: build-archiver
	@[ ! -f $(_BIN)/gh ] && ./builders/gh "$(_ROOT)/$(_BIN)" || true
	@$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-ghq
build-ghq: build-archiver
	@[ ! -f $(_BIN)/ghq ] && ./builders/ghq "$(_ROOT)/$(_BIN)" || true

.PHONY: build-gitlint
build-gitlint:
	@[ ! -f $(_BIN)/gitlint ] && ./builders/gitlint "$(_ROOT)/$(_BIN)" || true

.PHONY: build-go
build-go: build-godl
	@for GOVERSION in $(_GOVERSIONS); do \
		$(_BIN)/godl --goroots $(_CONFIG)/godl/goroots --temp $(_CONFIG)/godl/tmp install $$GOVERSION || true; \
	done

.PHONY: build-godl
build-godl:
	@[ ! -f $(_BIN)/godl ] && ./builders/godl "$(_ROOT)/$(_BIN)" || true

.PHONY: build-just
build-just: build-archiver
	@[ ! -f $(_BIN)/just ] && ./builders/just "$(_ROOT)/$(_BIN)" || true

.PHONY: build-lf
build-lf: build-archiver
	@[ ! -f $(_BIN)/lf ] && ./builders/lf "$(_ROOT)/$(_BIN)" || true

.PHONY: build-ran
build-ran:
	@[ ! -f $(_BIN)/ran ] && ./builders/ran "$(_ROOT)/$(_BIN)" || true

.PHONY: build-ripgrep
build-ripgrep:
	@[ ! -f $(_BIN)/rg ] && ./builders/ripgrep "$(_ROOT)/$(_BIN)" || true

.PHONY: build-tmpl
build-tmpl: build-envsubst
	@[ ! -f $(_BIN)/tmpl ] && ./builders/tmpl "$(_ROOT)/$(_BIN)" || true
	@[ ! -f $(_CONFIG)/tmpl/config.toml ] && envsubst '$$HOME' < $(_CONFIG)/tmpl/config.toml.dist > $(_CONFIG)/tmpl/config.toml || true

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
	@[ ! -f $(_BIN)/yq ] && ./builders/yq "$(_ROOT)/$(_BIN)" || true

.PHONY: build-zsh
build-zsh:  build-diary build-gcal build-godl build-just build-tmpl
	@[ ! -f $(_CONFIG)/zsh/.zshrc ] && cd $(_CONFIG)/zsh && ln -s zshrc .zshrc || true
	$(call _clone_github_repo,zsh-users/antigen,config/zsh/antigen)
	@$(_BIN)/diary --config $(_CONFIG)/diary/config.toml completion zsh > $(_CONFIG)/zsh/functions/_diary
	@$(_BIN)/gcal --config $(_CONFIG)/gcal/config.toml completion zsh > $(_CONFIG)/zsh/functions/_gcal
	@$(_BIN)/godl completion zsh > $(_CONFIG)/zsh/functions/_godl
	@$(_BIN)/just --completions zsh > $(_CONFIG)/zsh/functions/_just
	@$(_BIN)/tmpl --config $(_CONFIG)/tmpl/config.toml completion zsh > $(_CONFIG)/zsh/functions/_tmpl



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
