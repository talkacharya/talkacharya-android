# TalkAcharya — Customer app (com.talkacharya.customer)
# Run from Git Bash:  make <target>   (see `make help`)
#
# Common overrides:
#   make run FLAVOR=staging
#   make run API_BASE_URL=http://192.168.1.5:8000/api/v1
#   make run DEVICE=emulator-5554
#   make test ARGS='--name login'

SHELL      := bash
.ONESHELL:
.DEFAULT_GOAL := help

FLUTTER    ?= flutter
DART       ?= dart

# dev | staging | prod  — picks the flavor and the matching lib/main_<flavor>.dart
FLAVOR     ?= dev
TARGET     ?= lib/main_$(FLAVOR).dart

# optional: override the backend URL baked in by the flavor
API_BASE_URL ?=
# optional: target a specific device id (see `flutter devices`)
DEVICE     ?=
# extra args passed straight through to the underlying flutter/dart command
ARGS       ?=

DEFINES    := $(if $(API_BASE_URL),--dart-define=API_BASE_URL=$(API_BASE_URL),)
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)
RUN_ARGS   := --flavor $(FLAVOR) -t $(TARGET) $(DEFINES) $(DEVICE_ARG) $(ARGS)

BACKEND    := ../../../backend

.PHONY: help
help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "  vars: FLAVOR=$(FLAVOR)  API_BASE_URL=$(API_BASE_URL)  DEVICE=$(DEVICE)"

# --- setup -----------------------------------------------------------

.PHONY: setup
setup: get gen ## pub get + code generation (run once after cloning / dep changes)

.PHONY: get
get: ## flutter pub get
	$(FLUTTER) pub get

.PHONY: gen
gen: ## Generate *.freezed.dart / *.g.dart
	$(DART) run build_runner build

.PHONY: gen-watch
gen-watch: ## Regenerate on change
	$(DART) run build_runner watch

.PHONY: outdated
outdated: ## Show dependency upgrades
	$(FLUTTER) pub outdated

.PHONY: doctor
doctor: ## flutter doctor -v
	$(FLUTTER) doctor -v

# --- quality --------------------------------------------------------

.PHONY: format
format: ## Apply dart format
	$(DART) format lib test

.PHONY: format-check
format-check: ## Fail if code is not formatted
	$(DART) format --output=none --set-exit-if-changed lib test

.PHONY: analyze
analyze: ## Static analysis
	$(FLUTTER) analyze

.PHONY: test
test: ## Run unit/widget tests
	$(FLUTTER) test $(ARGS)

.PHONY: check
check: format-check analyze test ## format-check + analyze + test

.PHONY: ci
ci: get gen format-check analyze test ## Full CI sequence (what the workflow runs)

# --- run / build ---------------------------------------------------

.PHONY: run
run: ## Run on a device/emulator (FLAVOR, API_BASE_URL, DEVICE overridable)
	$(FLUTTER) run $(RUN_ARGS)

.PHONY: run-staging
run-staging: ## Shortcut for FLAVOR=staging
	$(MAKE) run FLAVOR=staging

.PHONY: run-prod
run-prod: ## Shortcut for FLAVOR=prod
	$(MAKE) run FLAVOR=prod

.PHONY: apk
apk: ## Debug APK for $(FLAVOR)
	$(FLUTTER) build apk --debug --flavor $(FLAVOR) -t $(TARGET) $(DEFINES)

.PHONY: apk-release
apk-release: ## Release APK for $(FLAVOR)
	$(FLUTTER) build apk --release --flavor $(FLAVOR) -t $(TARGET) $(DEFINES)

.PHONY: appbundle
appbundle: ## Release AAB for prod (Play upload)
	$(FLUTTER) build appbundle --release --flavor prod -t lib/main_prod.dart

# --- housekeeping -------------------------------------------------

.PHONY: clean
clean: ## flutter clean + drop generated files
	$(FLUTTER) clean
	find lib test \( -name '*.freezed.dart' -o -name '*.g.dart' \) -delete
	@echo "cleaned. run 'make setup' to rebuild."

.PHONY: reset
reset: clean setup ## clean + setup

# --- backend convenience ----------------------------------------

.PHONY: backend-seed
backend-seed: ## Seed the demo accounts in the backend (needs its venv active)
	cd $(BACKEND) && python manage.py seed_dev_accounts

.PHONY: backend-run
backend-run: ## Start the Django dev server on 0.0.0.0:8000
	cd $(BACKEND) && python manage.py runserver 0.0.0.0:8000
