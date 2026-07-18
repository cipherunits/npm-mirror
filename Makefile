.PHONY: help up down restart logs ps build pull clean reset shell preload status backup restore

DOCKER_COMPOSE = docker compose
BACKUP_DIR = backups
PROFILE ?= all
INCREMENTAL ?= 0

help:
	@echo "Available commands:"
	@echo "  make up                        - Start Verdaccio"
	@echo "  make down                      - Stop Verdaccio"
	@echo "  make restart                   - Restart Verdaccio"
	@echo "  make logs                      - Follow logs"
	@echo "  make ps                        - Show container status"
	@echo "  make status                    - Health check (container, registry, disk usage)"
	@echo "  make build                     - Recreate container"
	@echo "  make pull                      - Pull latest image"
	@echo "  make clean                     - Remove container"
	@echo "  make reset                     - Remove container and storage"
	@echo "  make shell                     - Open shell inside container"
	@echo "  make preload                   - Preload all packages (see preload/packages.conf)"
	@echo "  make preload PROFILE=frontend  - Preload only packages tagged 'frontend'"
	@echo "  make preload INCREMENTAL=1     - Skip packages preloaded in a previous run"
	@echo "  make backup                    - Backup storage/ into $(BACKUP_DIR)/"
	@echo "  make restore FILE=<path>       - Restore storage/ from a backup archive"

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps

build:
	$(DOCKER_COMPOSE) up -d --force-recreate

pull:
	$(DOCKER_COMPOSE) pull

clean:
	$(DOCKER_COMPOSE) down --remove-orphans

reset:
	$(DOCKER_COMPOSE) down -v --remove-orphans
	rm -rf storage/*

shell:
	docker exec -it npm-mirror sh

status:
	@echo "--- Container ---"
	@$(DOCKER_COMPOSE) ps
	@echo "--- Registry health ---"
	@curl -s -o /dev/null -w "http://localhost:4873 -> HTTP %{http_code}\n" http://localhost:4873 || echo "Registry is not reachable"
	@echo "--- Storage usage ---"
	@du -sh storage 2>/dev/null || echo "storage/ not found"

preload:
	chmod +x preload/install-packages.sh
	cd preload && PROFILE=$(PROFILE) INCREMENTAL=$(INCREMENTAL) ./install-packages.sh

backup:
	mkdir -p $(BACKUP_DIR)
	tar -czf $(BACKUP_DIR)/storage-$$(date +%Y%m%d-%H%M%S).tar.gz storage
	@echo "Backup created in $(BACKUP_DIR)/"

restore:
	@if [ -z "$(FILE)" ]; then echo "Usage: make restore FILE=backups/storage-XXXX.tar.gz"; exit 1; fi
	$(DOCKER_COMPOSE) down
	rm -rf storage
	tar -xzf $(FILE)
	$(DOCKER_COMPOSE) up -d
	@echo "Restored from $(FILE)"