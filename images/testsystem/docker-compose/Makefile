#
# Simple helper to call docker compose commands

.PHONY: testsystem ubuntubase mailserver

run:
ifndef PATCHLEVEL
	@echo "ERROR: Please call: make PATCHLEVEL=<julia-patchlevel>"
	@echo "Example: make PATCHLEVEL=lua1"
	@exit 1
endif

	docker compose up

shell:
	docker compose exec julia_test /bin/bash

show:
	docker compose ps

stop:
	docker compose stop

down:
	docker compose down
