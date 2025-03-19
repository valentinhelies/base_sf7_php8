install:
	docker compose up -d --build
	docker compose run symfony composer install
	docker compose run symfony npm install
	docker compose run symfony npm run build
	docker compose run symfony chmod -R 777 var translations

start:
	docker compose up -d

stop:
	docker compose down --remove-orphans

console:
	docker compose exec symfony bash

prepare:
	bin/console doctrine:migrations:migrate --no-interaction --allow-no-migration
	bin/console doctrine:schema:validate
	bin/console cache:clear
	chmod -R 777 var translations

test:
	vendor/bin/phpcs
	bin/console lint:twig templates
	vendor/bin/phpstan analyse
	bin/phpunit tests/

cc:
	bin/console cache:clear
