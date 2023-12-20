COMPOSE:=docker-compose.yaml

.PHONY: dev
dev: ${COMPOSE} down
	docker compose up -d
	docker ps

.PHONY: shell
shell: ${COMPOSE}
	docker compose exec nextjs bash

.PHONY: up
up: ${COMPOSE} down
	docker compose up -d
	docker ps

.PHONY: down
down: ${COMPOSE}
	docker compose down >/dev/null 2>&1

.PHONY: build
build: ${COMPOSE} down
	docker compose build --no-cache
	docker compose up -d
	docker ps

