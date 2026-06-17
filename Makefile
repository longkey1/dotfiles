.DEFAULT_GOAL := help

ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
BIN := $(ROOT)/local/bin
CONFIG := $(ROOT)/config
SCRIPTS := $(ROOT)/scripts

ACTIONS := build clean update install uninstall

# $(1)=アクション名。該当する $(1).sh を持つ全パッケージ名のリスト。
_all_packages = $(notdir $(patsubst %/,%,$(dir $(wildcard $(SCRIPTS)/*/$(1).sh))))

# $(1)=パッケージ名。deps ファイルがあればその中身(=直接依存)、なければ空。
_deps = $(if $(wildcard $(SCRIPTS)/$(1)/deps),$(shell cat $(SCRIPTS)/$(1)/deps))

# $(1)=パッケージ名。system_deps ファイルがあればその中身(=必要なシステムコマンド)、なければ空。
_system_deps = $(if $(wildcard $(SCRIPTS)/$(1)/system_deps),$(shell cat $(SCRIPTS)/$(1)/system_deps))

define _execute_shell
	env ROOT=$(ROOT) LOCAL_BIN=$(BIN) LOCAL_CONFIG=$(CONFIG) REMOTE_BIN=$(HOME)/.local/bin REMOTE_CONFIG=$(HOME)/.config SCRIPTS=$(SCRIPTS) $(1)
endef

# $(1)=パッケージ名, $(2)=アクション名。実行可能な $(2).sh があれば実行。
define _run_task
	script="$(SCRIPTS)/$(1)/$(2).sh"; \
	if [ -x "$${script}" ]; then \
		$(call _execute_shell,$${script}); \
	fi
endef

# $(1)=コマンド名。PATH上に存在するかチェックする。
define _check_system_rule
check-system-$(1):
	@command -v $(1) >/dev/null 2>&1 || { echo "ERROR: '$(1)' is required but not found in PATH"; exit 1; }
.PHONY: check-system-$(1)
endef
$(foreach c,$(sort $(foreach p,$(call _all_packages,build),$(call _system_deps,$(p)))),$(eval $(call _check_system_rule,$(c))))

# <action>-<pkg> ターゲットを動的生成する。
# build のときだけ deps を build-<dep> として prerequisite に付与し、Make に順序を解決させる。
# (依存ツールは「ビルド済みであること」が必要なので prerequisite は常に build-<dep>)
define _task_rule
$(2)-$(1): $$(if $$(filter build,$(2)),$$(addprefix build-,$$(call _deps,$(1)))) $$(if $$(filter build,$(2)),$$(addprefix check-system-,$$(call _system_deps,$(1))))
	@$$(call _run_task,$(1),$(2))
.PHONY: $(2)-$(1)
endef
$(foreach a,$(ACTIONS),$(foreach p,$(call _all_packages,$(a)),$(eval $(call _task_rule,$(p),$(a)))))

# 集約ターゲット。<action> は全 <action>-<pkg> に依存する。
# build-<dep> は複数パッケージから要求されても Make が一度だけ実行する。
define _aggregate_rule
$(1): $$(addprefix $(1)-,$$(call _all_packages,$(1)))
.PHONY: $(1)
endef
$(foreach a,$(ACTIONS),$(eval $(call _aggregate_rule,$(a))))

.PHONY: help
help:
	@echo 'Usage: make <action>[-<package>]'
	@echo ''
	@echo 'Actions:'
	@echo '  build       build all packages (dependencies resolved automatically)'
	@echo '  clean       delete all built files'
	@echo '  update      update all built files'
	@echo '  install     create symlinks in home directory'
	@echo '  uninstall   delete created symlinks'
	@echo ''
	@echo 'Per-package: append -<package> to run a single package, e.g.'
	@echo '  make build-gopls    # builds go first, then gopls'
	@echo '  make install-zsh    # install zsh only'
	@echo ''
	@echo 'Dependencies are declared in scripts/<package>/deps (one per line).'
	@echo 'System command requirements are declared in scripts/<package>/system_deps (one per line).'
	@echo ''
	@echo 'Packages:'
	@echo '  $(sort $(foreach a,$(ACTIONS),$(call _all_packages,$(a))))' | fold -s -w 76 | sed 's/^/  /'
