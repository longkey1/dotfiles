.DEFAULT_GOAL := help

_BUILD := \
build-archiver \
build-bat \
build-countdown \
build-diary \
build-direnv \
build-envsubst \
build-esampo \
build-fzf \
build-gcal \
build-gh \
build-ghq \
build-glow \
build-gitlint \
build-gobump \
build-go \
build-gojq \
build-just \
build-lf \
build-peco \
build-ran \
build-ripgrep \
build-robo \
build-tmpl \
build-vim \
build-yq \
build-zsh

_TARGETS := \
"bin" \
"config/composer" \
"config/diary" \
"config/direnv" \
"config/gh" \
"config/git" \
"config/lf" \
"config/nvim" \
"config/rofi" \
"config/tmpl" \
"config/tmux" \
"config/zsh" \
"goroots" \
"ideavimrc" \
"vim" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"config/fontconfig" \
"config/rofi" \
"xprofile"

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
	@[ ! -e "$(1).encrypted" ] && openssl aes-256-cbc -e -salt -pbkdf2 -in $(1) -out $(1).encrypted || true
endef

define _decrypt
	@[ ! -e "$(1)" ] && openssl aes-256-cbc -d -salt -pbkdf2 -in $(1).encrypted -out $(1) || true
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
	@rm -f $(_CONFIG)/git/config.local
	@rm -rf $(_CONFIG)/zsh/antigen
	@rm -f $(_CONFIG)/zsh/.zshrc
	@rm -f $(_CONFIG)/zsh/zshrc.local
	@find $(_GOROOTS) -mindepth 1 -maxdepth 1 -type d | xargs rm -rf
	@rm -rf vim/pack/bundle/start/*
	@$(_CONFIG)/zsh/functions/_just

.PHONY: install
install: ## create target's symlink in home directory
	@for TARGET in $(_TARGETS); do \
		$(call _create_home_symlink,"$$TARGET"); \
	done
	@if test "$(shell uname -s)" = "Linux"; then \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _create_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: uninstall
uninstall: ## delete created symlink
	@for TARGET in $(_TARGETS); do \
		$(call _delete_home_symlink,"$$TARGET"); \
	done
	@if test "$(shell uname -s)" = "Linux"; then \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _delete_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: encrypt
encrypt: ## encrypt files
	$(call _encrypt,$(_CONFIG)/composer/auth.json)
	$(call _encrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: decrypt
decrypt: ## decrypt files
	$(call _decrypt,$(_CONFIG)/composer/auth.json)
	$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-archiver
build-archiver:
	@[ ! -f $(_BIN)/arc ] && $(call _build_go_binary,mholt/archiver/cmd/arc) || true

.PHONY: build-bat
build-bat:
	@[ ! -f $(_BIN)/bat ] && $(call _build_go_binary,astaxie/bat) || true

.PHONY: build-countdown
build-countdown:
	@[ ! -f $(_BIN)/countdown ] && $(call _build_go_binary,antonmedv/countdown) || true

.PHONY: build-diary
build-diary: build-envsubst
	@[ ! -f $(_BIN)/diary ] && $(call _build_go_binary,longkey1/diary) || true
	@[ ! -f $(_CONFIG)/diary/config.toml ] && envsubst '$$HOME $$EDITOR' < $(_CONFIG)/diary/config.toml.dist > $(_CONFIG)/diary/config.toml || true

.PHONY: build-direnv
build-direnv:
	@[ ! -f $(_BIN)/direnv ] && $(call _build_go_binary,direnv/direnv) || true

.PHONY: build-envsubst
build-envsubst:
	@[ ! -f $(_BIN)/envsubst ] && $(call _build_go_binary,a8m/envsubst/cmd/envsubst) || true

.PHONY: build-esampo
build-esampo:
	@[ ! -f $(_BIN)/esampo ] && $(call _build_go_binary,longkey1/esampo) || true

.PHONY: build-fzf
build-fzf:
	@[ ! -f $(_BIN)/fzf ] && $(call _build_go_binary,junegunn/fzf) || true

.PHONY: build-gcal
build-gcal:
	@[ ! -f $(_BIN)/gcal ] && $(call _build_go_binary,longkey1/gcal) || true

.PHONY: build-gh
build-gh: build-gojq
	@[ ! -f $(_BIN)/gh ] && ./builders/gh "$(_ROOT)/$(_BIN)" || true
	@$(call _decrypt,$(_CONFIG)/gh/hosts.yml)

.PHONY: build-ghq
build-ghq:
	@[ ! -f $(_BIN)/ghq ] && $(call _build_go_binary,x-motemen/ghq) || true

.PHONY: build-glow
build-glow:
	@[ ! -f $(_BIN)/glow ] && $(call _build_go_binary,charmbracelet/glow) || true

.PHONY: build-gitlint
build-gitlint:
	@[ ! -f $(_BIN)/go-gitlint ] && $(call _build_go_binary,llorllale/go-gitlint/cmd/go-gitlint) || true
	@[ ! -e $(_BIN)/gitlint ] && cd $(_BIN) && ln -s go-gitlint gitlint || true

.PHONY: build-gobump
build-gobump:
	@[ ! -f $(_BIN)/gobump ] && $(call _build_go_binary,x-motemen/gobump/cmd/gobump) || true

.PHONY: build-go
build-go: build-archiver
	@for GOVERSION in $(_GOVERSIONS); do \
		[ ! -d $(_GOROOTS)/$$GOVERSION ] && ./builders/go "$(_ROOT)/$(_BIN)" "$(_ROOT)/$(_GOROOTS)" "$$GOVERSION" || true; \
	done

.PHONY: build-gojq
build-gojq:
	@[ ! -f $(_BIN)/gojq ] && $(call _build_go_binary,itchyny/gojq/cmd/gojq) || true
	@[ ! -e $(_BIN)/jq ] && cd $(_BIN) && ln -s gojq jq || true

.PHONY: build-just
build-just: build-gojq build-archiver
	@[ ! -f $(_BIN)/just ] && ./builders/just "$(_ROOT)/$(_BIN)" || true

.PHONY: build-lf
build-lf: build-gojq build-archiver
	@[ ! -f $(_BIN)/lf ] && ./builders/lf "$(_ROOT)/$(_BIN)" || true

.PHONY: build-peco
build-peco:
	@[ ! -f $(_BIN)/peco ] && $(call _build_go_binary,peco/peco/cmd/peco) || true

.PHONY: build-ran
build-ran:
	@[ ! -f $(_BIN)/ran ] && $(call _build_go_binary,m3ng9i/ran) || true

.PHONY: build-ripgrep
build-ripgrep: build-gojq
	@[ ! -f $(_BIN)/rg ] && ./builders/ripgrep "$(_ROOT)/$(_BIN)" || true

.PHONY: build-robo
build-robo:
	@[ ! -f $(_BIN)/robo ] && $(call _build_go_binary,tj/robo) || true

.PHONY: build-tmpl
build-tmpl: build-envsubst
	@[ ! -f $(_BIN)/tmpl ] && $(call _build_go_binary,longkey1/tmpl) || true
	@[ ! -f $(_CONFIG)/tmpl/config.toml ] && envsubst '$$HOME' < $(_CONFIG)/tmpl/config.toml.dist > $(_CONFIG)/tmpl/config.toml || true

.PHONY: build-vim
build-vim:  build-gojq
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
	@[ ! -f $(_BIN)/yq ] && $(call _build_go_binary,mikefarah/yq) || true

.PHONY: build-zsh
build-zsh: build-just
	@[ ! -f $(_CONFIG)/zsh/.zshrc ] && cd $(_CONFIG)/zsh && ln -s zshrc .zshrc || true
	$(call _clone_github_repo,zsh-users/antigen,config/zsh/antigen)
	$(_BIN)/just --completions zsh > $(_CONFIG)/zsh/functions/_just



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
