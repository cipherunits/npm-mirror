.PHONY: help up down restart logs ps build pull clean reset shell

DOCKER_COMPOSE = docker compose

help:
	@echo "Available commands:"
	@echo "  make up        - Start Verdaccio"
	@echo "  make down      - Stop Verdaccio"
	@echo "  make restart   - Restart Verdaccio"
	@echo "  make logs      - Follow logs"
	@echo "  make ps        - Show container status"
	@echo "  make build     - Recreate container"
	@echo "  make pull      - Pull latest image"
	@echo "  make clean     - Remove container"
	@echo "  make reset     - Remove container and storage"
	@echo "  make shell     - Open shell inside container"
	@echo "  make preload  - Start install package"

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

preload:
	chmod +x preload/install-packages.sh
	./preload/install-packages.sh