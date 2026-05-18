.PHONY: setup start stop test console migrate logs reset

setup: ## First-time setup: build image, install gems, create and migrate DB
	docker-compose build
	docker-compose run --rm web bundle install
	docker-compose run --rm web bin/rails db:create db:migrate

start: ## Start the app (web + worker + db)
	docker-compose up

stop: ## Stop all containers
	docker-compose down

test: ## Run the test suite
	docker-compose run --rm -e RAILS_ENV=test web bin/rails db:create db:migrate test

console: ## Open a Rails console
	docker-compose run --rm web bin/rails console

migrate: ## Run pending migrations
	docker-compose run --rm web bin/rails db:migrate

logs: ## Tail container logs
	docker-compose logs -f

reset: ## Wipe the dev database and start fresh
	docker-compose down -v
	$(MAKE) setup
