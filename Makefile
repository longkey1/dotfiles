.DEFAULT_GOAL := help

_TARGETS := \
"bin" \
"config/diary" \
"config/direnv" \
"config/git" \
"config/lf" \
"config/nvim" \
"config/tmux" \
"config/zsh" \
"goroots" \
"ideavimrc" \
"ocamlinit" \
"vim" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"config/fontconfig" \
"config/rofi" \
"xprofile"

_OS := ($(shell uname -s)|$(shell uname -s | tr '[:upper:]' '[:lower:]'))
_ARCH := (amd64|x86_64)
_BIN := ./bin
_CONFIG := ./config

_GOROOTS := ./goroots
_GOVERSIONS := \
"1.15.3" \
"1.14.9" \
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
	@if test -e "$(1).encrypted"; then \
		echo "already exists $(1).encrypted."; \
	else \
		openssl aes-256-cbc -e -salt -pbkdf2 -in $(1) -out $(1).encrypted; \
	fi
endef

define _decrypt
	@if test -e "$(1)"; then \
		echo "already exists $(1)"; \
	else \
		openssl aes-256-cbc -d -salt -pbkdf2 -in $(1).encrypted -out $(1); \
	fi
endef

define _clone_github_repo
	@[ ! -d "$(2)" ] && git clone https://github.com/$(1).git $(2) || true
endef

define _get_github_download_url
	$(shell curl -s https://api.github.com/repos/$(1)/releases/latest | jq -r ".assets[] | select(.name | test(\"$(_OS)\") and test(\"$(_ARCH)\") and (contains(\".sha256\") | not) and (contains(\".deb\") | not) and (contains(\".rpm\") | not)) | .browser_download_url")
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
build: ## build all packages
	$(MAKE) build-bat
	$(MAKE) build-boilr
	$(MAKE) build-countdown
	$(MAKE) build-diary
	$(MAKE) build-direnv
	$(MAKE) build-fzf
	$(MAKE) build-ghq
	$(MAKE) build-glow
	$(MAKE) build-gobump
	$(MAKE) build-gitlint
	$(MAKE) build-just
	$(MAKE) build-lf
	$(MAKE) build-pt
	$(MAKE) build-robo
	$(MAKE) build-ran
	$(MAKE) build-vim
	$(MAKE) build-yq
	$(MAKE) build-zsh
	$(MAKE) decrypt

.PHONY: clean
clean: ## delete all builded files
	@find $(_BIN) -type f | grep -v .gitignore | xargs rm -rf
	@rm -f $(_CONFIG)/diary/config.toml
	@rm -f $(_CONFIG)/git/config.local
	@rm -rf $(_CONFIG)/zsh/antigen
	@rm -f $(_CONFIG)/zsh/.zshrc
	@rm -f $(_CONFIG)/zsh/zshrc.local
	@find $(_GOROOTS) -type f | grep -v .gitignore | xargs rm -rf
	@rm -f netrc
	@rm -rf vim/pack/bundle/start/*

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
#	$(call _encrypt,"netrc")

.PHONY: decrypt
decrypt: ## decrypt files
#	$(call _decrypt,"netrc")

.PHONY: _require-bsdtar
_require-bsdtar:
	@$(call _executable,"bsdtar")

.PHONY: _require-jq
_require-jq:
	@$(call _executable,"jq")

.PHONY: _require-envsubst
_require-envsubst:
	@$(call _executable,"envsubst")

.PHONY: build-bat
build-bat:
	@[ ! -f $(_BIN)/bat ] && $(call _build_go_binary,"astaxie/bat") || true

.PHONY: build-boilr
build-boilr: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/boilr ] && wget $(call _get_github_download_url,"tmrts/boilr") -O- | bsdtar -xvf- -C $(_BIN) 'boilr' && chmod +x $(_BIN)/boilr || true

.PHONY: build-countdown
build-countdown:
	@[ ! -f $(_BIN)/countdown ] && $(call _build_go_binary,"antonmedv/countdown") || true

.PHONY: build-diary
build-diary: _require-jq
	@[ ! -f $(_BIN)/diary ] && $(call _build_go_binary,"longkey1/diary") || true
	@[ ! -f $(_CONFIG)/diary/config.toml ] && envsubst '$$HOME $$EDITOR' < $(_CONFIG)/diary/config.toml.dist > $(_CONFIG)/diary/config.toml || true

.PHONY: build-direnv
build-direnv: _require-jq
	@[ ! -f $(_BIN)/direnv ] && wget $(call _get_github_download_url,"direnv/direnv") -O $(_BIN)/direnv && chmod +x $(_BIN)/direnv || true

.PHONY: build-fzf
build-fzf:
	@[ ! -f $(_BIN)/fzf ] && $(call _build_go_binary,"junegunn/fzf") || true

.PHONY: build-ghq
build-ghq:
	@[ ! -f $(_BIN)/ghq ] && $(call _build_go_binary,"x-motemen/ghq") || true

.PHONY: build-glow
build-glow:
	@[ ! -f $(_BIN)/glow ] && $(call _build_go_binary,"charmbracelet/glow") || true

.PHONY: build-gitlint
build-gitlint:
	@[ ! -f $(_BIN)/gitlint ] && $(call _build_go_binary,"llorllale/go-gitlint/cmd/go-gitlint") && mv $(_BIN)/go-gitlint $(_BIN)/gitlint || true

.PHONY: build-gobump
build-gobump: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/gobump ] && wget $(call _get_github_download_url,"x-motemen/gobump") -O- | bsdtar -xvf- -C $(_BIN) --strip=1 '*/gobump' && chmod +x $(_BIN)/gobump || true

.PHONY: build-go
build-go: _require-bsdtar
	@for GOVERSION in $(_GOVERSIONS); do \
		$(eval __OS := $(shell uname -s | tr "[:upper:]" "[:lower:]")) \
		$(eval __ARCH := $(shell [ "$(shell uname -m)" = "x86_64" ] && echo "amd64" || echo "386")) \
		[ ! -d $(_GOROOTS)/$$GOVERSION ] && mkdir $(_GOROOTS)/$$GOVERSION && wget https://golang.org/dl/go$$GOVERSION.$(__OS)-$(__ARCH).tar.gz -O- | bsdtar -xvf- -C $(_GOROOTS)/$$GOVERSION --strip=1 || true; \
	done

.PHONY: build-just
build-just: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/just ] && wget $(call _get_github_download_url,"casey/just") -O- | bsdtar -xvf- -C $(_BIN) 'just' && chmod +x $(_BIN)/just || true

.PHONY: build-lf
build-lf: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/lf ] && wget $(call _get_github_download_url,"gokcehan/lf") -O- | bsdtar -xvf- -C $(_BIN) 'lf' && chmod +x $(_BIN)/lf || true

.PHONY: build-peco
build-peco: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/peco ] && wget $(call _get_github_download_url,"peco/peco") -O- | bsdtar -xvf- -C $(_BIN) --strip=1 '*/peco' && chmod +x $(_BIN)/peco || true

.PHONY: build-pt
build-pt: _require-jq _require-bsdtar
	@[ ! -f $(_BIN)/pt ] && wget $(call _get_github_download_url,"monochromegane/the_platinum_searcher") -O- | bsdtar -xvf- -C $(_BIN) --strip=1 '*/pt' && chmod +x $(_BIN)/pt || true

.PHONY: build-ran
build-ran:
	@[ ! -f $(_BIN)/ran ] && $(call _build_go_binary,"m3ng9i/ran") || true

.PHONY: build-robo
build-robo:
	@[ ! -f $(_BIN)/robo ] && $(call _build_go_binary,"tj/robo") || true

.PHONY: build-vim
build-vim: _require-jq
	$(call _clone_github_repo,thinca/vim-quickrun,vim/pack/bundle/start/vim-quickrun)
	$(call _clone_github_repo,vim-scripts/sudo.vim,vim/pack/bundle/start/sudo.vim)
	$(call _clone_github_repo,longkey1/vim-lf,vim/pack/bundle/start/vim-lf)
	$(call _clone_github_repo,nanotech/jellybeans.vim,vim/pack/bundle/start/jellybeans.vim)
	$(call _clone_github_repo,ConradIrwin/vim-bracketed-paste,vim/pack/bundle/start/vim-bracketed-paste)

.PHONY: build-yq
build-yq: _require-jq
	@[ ! -f $(_BIN)/yq ] && wget $(call _get_github_download_url,"mikefarah/yq") -O $(_BIN)/yq && chmod +x $(_BIN)/yq || true

.PHONY: build-zsh
build-zsh: _require-jq
	@[ ! -f $(_CONFIG)/zsh/.zshrc ] && cd $(_CONFIG)/zsh && ln -s zshrc .zshrc || true
	$(call _clone_github_repo,zsh-users/antigen,config/zsh/antigen)



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
