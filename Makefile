# ============================================
# WINDOWS-COMPATIBLE MAKEFILE
# ============================================

SHELL := cmd
.ONESHELL:

# ============================================
# CONFIGURATION
# ============================================

REGISTRY ?= docker.io
REGISTRY_NAMESPACE ?= %USERNAME%
IMAGE_NAME ?= demo-app
IMAGE_TAG ?= latest
FULL_IMAGE = $(REGISTRY)/$(REGISTRY_NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG)

COMPOSE_FILE ?= docker-compose.yml
COMPOSE_DEV ?= docker-compose.override.yml
COMPOSE_PROD ?= docker-compose.prod.yml

ENVIRONMENT ?= development

# ============================================
# HELPERS (NO COLORS - WINDOWS SAFE)
# ============================================

define print_header
	@echo.
	@echo ========================================
	@echo $(1)
	@echo ========================================
endef

define print_success
	@echo [OK] $(1)
endef

define print_error
	@echo [ERROR] $(1)
endef

define print_warning
	@echo [WARNING] $(1)
endef

# ============================================
# CHECKS
# ============================================

.PHONY: check-docker
check-docker:
	@docker --version >nul 2>&1 || (echo Docker not installed & exit /b 1)
	@docker info >nul 2>&1 || (echo Docker not running & exit /b 1)

.PHONY: check-compose
check-compose:
	@docker compose version >nul 2>&1 || (echo Docker Compose not found & exit /b 1)

.PHONY: setup-env
setup-env:
	@if not exist .env (
		echo Creating .env file...
		if exist .env.example (copy .env.example .env) else (type nul > .env)
	)

# ============================================
# BUILD
# ============================================

.PHONY: build
build: check-docker check-compose
	$(call print_header,Building images)
	docker compose -f $(COMPOSE_FILE) build
	$(call print_success,Build complete)

.PHONY: build-no-cache
build-no-cache: check-docker check-compose
	docker compose -f $(COMPOSE_FILE) build --no-cache

.PHONY: build-service
build-service:
	@if "$(SERVICE)"=="" (
		echo SERVICE required. Example: make build-service SERVICE=api
		exit /b 1
	)
	docker compose -f $(COMPOSE_FILE) build $(SERVICE)

# ============================================
# DEV
# ============================================

.PHONY: up
up: setup-env
	docker compose -f $(COMPOSE_FILE) up -d

.PHONY: up-dev
up-dev:
	docker compose -f $(COMPOSE_FILE) -f $(COMPOSE_DEV) up -d

.PHONY: down
down:
	docker compose -f $(COMPOSE_FILE) down

.PHONY: down-volumes
down-volumes:
	@set /p confirm=Delete volumes? (y/N): 
	@if /I "%confirm%"=="y" (
		docker compose -f $(COMPOSE_FILE) down -v
	) else (
		echo Cancelled
	)

.PHONY: restart
restart:
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) up -d

.PHONY: logs
logs:
	docker compose -f $(COMPOSE_FILE) logs -f --tail=100

.PHONY: logs-service
logs-service:
	@if "$(SERVICE)"=="" (
		echo SERVICE required
		exit /b 1
	)
	docker compose -f $(COMPOSE_FILE) logs -f $(SERVICE)

.PHONY: ps
ps:
	docker compose -f $(COMPOSE_FILE) ps

.PHONY: shell
shell:
	@if "$(SERVICE)"=="" (
		echo SERVICE required
		exit /b 1
	)
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) cmd

.PHONY: exec
exec:
	@if "$(SERVICE)"=="" (
		echo SERVICE required
		exit /b 1
	)
	docker compose -f $(COMPOSE_FILE) exec $(SERVICE) $(CMD)

# ============================================
# REGISTRY
# ============================================

.PHONY: login
login:
	docker login $(REGISTRY)

.PHONY: logout
logout:
	docker logout $(REGISTRY)

.PHONY: tag
tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(FULL_IMAGE)

.PHONY: push
push:
	docker push $(FULL_IMAGE)

.PHONY: pull
pull:
	docker pull $(FULL_IMAGE)

# ============================================
# CLEANUP
# ============================================

.PHONY: clean
clean:
	docker compose -f $(COMPOSE_FILE) down
	docker system prune -f

.PHONY: clean-all
clean-all:
	docker compose -f $(COMPOSE_FILE) down -v
	docker system prune -a --volumes -f

# ============================================
# UTIL
# ============================================

.PHONY: info
info:
	@echo Project: $(IMAGE_NAME)
	@echo Registry: $(REGISTRY)
	@echo Image: $(FULL_IMAGE)

# ============================================
# DEFAULT
# ============================================

.DEFAULT_GOAL := info