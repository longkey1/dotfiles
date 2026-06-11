.DEFAULT_GOAL := help

ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
BIN := $(ROOT)/local/bin
CONFIG := $(ROOT)/config
SCRIPTS := $(ROOT)/scripts

define _execute_task
	if [ "$(1)" != "" ]; then \
		script="$(SCRIPTS)/$(1)/$(2).sh"; \
		if [ -x "$${script}" ]; then \
			$(call _execute_shell,$(SCRIPTS)/$(1)/$(2).sh); \
		else \
			echo "not executable $(SCRIPTS)/$(1)/$(2).sh"; \
		fi \
	else \
		for target in $(call _task_packages,$(2)); do \
			script="$(SCRIPTS)/$${target}/$(2).sh"; \
			if [ -x "$${script}" ]; then \
				$(call _execute_shell,$${script}); \
			fi \
		done \
	fi
endef

define _execute_shell
	env ROOT=$(ROOT) LOCAL_BIN=$(BIN) LOCAL_CONFIG=$(CONFIG) REMOTE_BIN=$(HOME)/.local/bin REMOTE_CONFIG=$(HOME)/.config SCRIPTS=$(SCRIPTS) $(1)
endef

BUILD_INIT_TASKS := bin eget jq bitwarden

# $(1)=アクション名。該当する $(1).sh を持つ全パッケージ名のリスト。
_all_packages = $(notdir $(patsubst %/,%,$(dir $(wildcard $(SCRIPTS)/*/$(1).sh))))

# $(1)=アクション名。build のときは前提タスク(BUILD_INIT_TASKS)を除外する。
_task_packages = $(filter-out $(if $(filter build,$(1)),$(BUILD_INIT_TASKS)),$(call _all_packages,$(1)))

.PHONY: build-init
build-init: ## build prerequisites for build
	@$(foreach t,$(BUILD_INIT_TASKS),$(call _execute_task,$(t),build) ;)

target := ""
.PHONY: build
build: build-init ## build all files or target files
	@$(call _execute_task,$(target),build)

.PHONY: clean
clean: ## delete all builded files or target builded files
	@$(call _execute_task,$(target),clean)

.PHONY: update
update: ## update all builded files or target builded files
	@$(call _execute_task,$(target),update)

.PHONY: install
install: ## create target's symlink in home directory
	@$(call _execute_task,$(target),install)

.PHONY: uninstall
uninstall: ## delete created symlink
	@$(call _execute_task,$(target),uninstall)



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
