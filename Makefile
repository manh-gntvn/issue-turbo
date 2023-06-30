TURBO_VERSION?=1.10.4
SHELL=bash

index:
	@echo "Node version - $(shell node --version)"
	@echo "NPM version - $(shell npm --version)"
	@echo "Turbo version - ${TURBO_VERSION}"

reset-content:
	rm -fr content && mkdir content
	echo "1" > content/a.md

turbo-cleanup-cache:
	@echo -e "\n\n Cleanup \n -------------------------------\n\n\n"
	rm -fr node_modules
	rm -fr .turbo
	rm -fr dist && mkdir dist
	make reset-content
	find . -type f

test-turbo:
	@make turbo-cleanup-cache
	@echo -e "\n\n First time - Turbo v(${TURBO_VERSION}) \n -------------------------------\n\n\n"
	CI=true npx turbo@${TURBO_VERSION} run foo
	@echo -e "\n\n\n\n\n Second time - Turbo v(${TURBO_VERSION}) \n -------------------------------\n\n\n"
	CI=true npx turbo@${TURBO_VERSION} run foo
	@echo -e "\n\n\n\n\n Third time - Turbo v(${TURBO_VERSION}) \n -------------------------------\n\n\n"
	echo "update content folder"
	echo "2" > content/a.md
	echo "2" > content/b.md
	CI=true npx turbo@${TURBO_VERSION} run foo

test-turbo-docker-1.10.4:
	docker run --rm -it -v $(PWD):/app -e 'TURBO_VERSION=1.10.4' -w /app node:18-bullseye make test-turbo


test-turbo-docker-1.9.9:
	docker run --rm -it -v $(PWD):/app -e 'TURBO_VERSION=1.9.9' -w /app node:18-bullseye make test-turbo


