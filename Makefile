.DEFAULT_GOAL := help

ROOT := $(patsubst %/,%,$(dir $(realpath $(firstword $(MAKEFILE_LIST)))))
BIN := $(ROOT)/bin
CONFIG := $(ROOT)/config
SCRIPTS := $(ROOT)/.scripts

define _execute_task
	@if [ "$(1)" != "" ]; then \
		if [ -x "$(SCRIPTS)/$(1)/$(2).sh" ]; then \
			$(call _execute_shell,$(SCRIPTS)/$(1)/$(2).sh); \
		else \
			echo "not executable $(SCRIPTS)/$(1)/$(2).sh"; \
		fi \
	else \
		for target in $(wildcard $(SCRIPTS)/*/$(2).sh); do \
			if [ -x "$${target}" ]; then \
				$(call _execute_shell,$${target}); \
			fi \
		done \
	fi
endef

define _execute_shell
	env ROOT=$(ROOT) LOCAL_BIN=$(BIN) LOCAL_CONFIG=$(CONFIG) REMOTE_BIN=$(HOME)/.bin REMOTE_CONFIG=$(HOME)/.config SCRIPTS=$(SCRIPTS) $(1)
endef

.PHONY: init
init: ## initilize
	$(call _execute_task,bin,build)
	$(call _execute_task,eget,build)
	$(call _execute_task,gojq,build)
	$(call _execute_task,bitwarden,build)

target := ""
.PHONY: build
build: init ## build all files or target files
	$(call _execute_task,$(target),build)

.PHONY: clean
clean: ## delete all builded files or target builded files
	$(call _execute_task,$(target),clean)

.PHONY: update
update: ## update all builded files or target builded files
	$(call _execute_task,$(target),update)

.PHONY: install
install: ## create target's symlink in home directory
	$(call _execute_task,$(target),install)

.PHONY: uninstall
uninstall: ## delete created symlink
	$(call _execute_task,$(target),uninstall)



.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
