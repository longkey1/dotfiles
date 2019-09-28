.DEFAULT_GOAL := help

_TARGETS := \
"bin" \
"config/diary" \
"config/direnv" \
"config/git" \
"config/lf" \
"config/nvim" \
"config/zsh" \
"ideavimrc" \
"netrc" \
"ocamlinit" \
"slack-term" \
"tmux.conf" \
"vim" \
"vimrc" \
"zshenv"

_LINUX_ONLY_TARGETS := \
"xprofile"

_OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
_ARCH := amd64

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
	@if test ! -d "$(2)"; then \
		git clone https://github.com/$(1).git $(2); \
	fi
endef

define _get_github_download_url
	$(shell curl -s https://api.github.com/repos/$(1)/releases/latest | jq -r ".assets[] | select(.name | contains(\"$(_OS)\") and contains(\"$(_ARCH)\") and (contains(\".sha256\") | not) and (contains(\".deb\") | not) and (contains(\".rpm\") | not)) | .browser_download_url")
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
	$(MAKE) build-dep
	$(MAKE) build-diary
	$(MAKE) build-direnv
	$(MAKE) build-ghq
	$(MAKE) build-pt
	$(MAKE) build-robo
	$(MAKE) build-slack-term
	$(MAKE) build-lf
	$(MAKE) build-boilr
	$(MAKE) build-zsh
	$(MAKE) build-vim
	$(MAKE) decrypt

.PHONY: clean
clean: ## delete all builded files
	@find ./bin -type f | grep -v .gitignore | xargs rm -rf
	@rm -f config/diary/config.toml
	@rm -f config/git/config.local
	@rm -f config/zsh/.zshrc.
	@rm -f config/zsh/zshrc.local
	@rm -rf config/zsh/.antigen
	@rm -f config/memo/config.toml
	@rm -f netrc
	@rm -f slack-term
	@rm -rf config/zsh/antigen
	@rm -rf vim/pack/bundle/start/*

.PHONY: install
install: ## create target's symlink in home directory
	@for TARGET in $(_TARGETS); do \
		$(call _create_home_symlink,"$$TARGET"); \
	done
	@if test "$(_OS)" = "linux"; then \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _create_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: uninstall
uninstall: ## delete created symlink
	@for TARGET in $(_TARGETS); do \
		$(call _delete_home_symlink,"$$TARGET"); \
	done
	@if test "$(_OS)" = "linux"; then \
		for TARGET in $(_LINUX_ONLY_TARGETS); do \
			$(call _delete_home_symlink,"$$TARGET"); \
		done \
	fi

.PHONY: encrypt
encrypt: ## encrypt files
	$(call _encrypt,"netrc")
	$(call _encrypt,"slack-term")

.PHONY: decrypt
decrypt: ## decrypt files
	$(call _decrypt,"netrc")
	$(call _decrypt,"slack-term")

.PHONY: _require-bsdtar
_require-bsdtar:
	@$(call _executable,"bsdtar")

.PHONY: _require-jq
_require-jq:
	@$(call _executable,"jq")

.PHONY: _require-envsubst
_require-envsubst:
	@$(call _executable,"envsubst")

.PHONY: build-zsh
build-zsh: _require-jq
	@if test ! -f ./config/zsh/.zshrc; then \
		cd ./config/zsh && ln -s zshrc .zshrc; \
	fi
	$(call _clone_github_repo,zsh-users/antigen,config/zsh/antigen)

.PHONY: build-vim
build-vim: _require-jq
	$(call _clone_github_repo,thinca/vim-quickrun,vim/pack/bundle/start/vim-quickrun)
	$(call _clone_github_repo,vim-scripts/sudo.vim,vim/pack/bundle/start/sudo.vim)
	$(call _clone_github_repo,longkey1/vim-lf,vim/pack/bundle/start/vim-lf)
	$(call _clone_github_repo,nanotech/jellybeans.vim,vim/pack/bundle/start/jellybeans.vim)
	$(call _clone_github_repo,ConradIrwin/vim-bracketed-paste,vim/pack/bundle/start/vim-bracketed-paste)

.PHONY: build-dep
build-dep: _require-jq
	@if test ! -f ./bin/dep; then \
		wget $(call _get_github_download_url,"golang/dep") -O ./bin/dep && chmod +x ./bin/dep; \
	fi

.PHONY: build-diary
build-diary: _require-jq
	@if test ! -f ./bin/diary; then \
		wget $(call _get_github_download_url,"longkey1/diary") -O ./bin/diary && chmod +x ./bin/diary; \
	fi
	@if test ! -f ./config/diary/config.toml; then \
		envsubst '$$HOME $$EDITOR' < config/diary/config.toml.dist > config/diary/config.toml; \
	fi

.PHONY: build-direnv
build-direnv: _require-jq
	@if test ! -f ./bin/direnv; then \
		wget $(call _get_github_download_url,"direnv/direnv") -O ./bin/direnv && chmod +x ./bin/direnv; \
	fi

.PHONY: build-ghq
build-ghq: _require-jq _require-bsdtar
	@if test ! -f ./bin/ghq; then \
		wget $(call _get_github_download_url,"motemen/ghq") -O- | bsdtar -xvf- -C ./bin --strip=1 '*/ghq' && chmod +x ./bin/ghq; \
	fi

.PHONY: build-peco
build-peco: _require-jq _require-bsdtar
	@if test ! -f ./bin/peco; then \
		wget $(call _get_github_download_url,"peco/peco") -O- | bsdtar -xvf- -C ./bin --strip=1 '*/peco' && chmod +x ./bin/peco; \
	fi

.PHONY: build-pt
build-pt: _require-jq _require-bsdtar
	@if test ! -f ./bin/pt; then \
		wget $(call _get_github_download_url,"monochromegane/the_platinum_searcher") -O- | bsdtar -xvf- -C ./bin --strip=1 '*/pt' && chmod +x ./bin/pt; \
	fi

.PHONY: build-robo
build-robo: _require-jq
	@if test ! -f ./bin/robo; then \
		wget $(call _get_github_download_url,"tj/robo") -O ./bin/robo && chmod +x ./bin/robo; \
	fi

.PHONY: build-slack-term
build-slack-term: _require-jq
	@if test ! -f ./bin/slack-term; then \
		wget $(call _get_github_download_url,"erroneousboat/slack-term") -O ./bin/slack-term && chmod +x ./bin/slack-term; \
	fi

.PHONY: build-lf
build-lf: _require-jq _require-bsdtar
	@if test ! -f ./bin/lf; then \
		wget $(call _get_github_download_url,"gokcehan/lf") -O- | bsdtar -xvf- -C ./bin 'lf' && chmod +x ./bin/lf; \
	fi

.PHONY: build-boilr
build-boilr: _require-jq _require-bsdtar
	@if test ! -f ./bin/boilr; then \
		wget $(call _get_github_download_url,"tmrts/boilr") -O- | bsdtar -xvf- -C ./bin 'boilr' && chmod +x ./bin/boilr; \
	fi



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
