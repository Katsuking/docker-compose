SHELL=/bin/bash
TIME := time -p
ENV_PATH := ./.env.local
include ./.env.local

.PHONY: devup devdown cleanup vm db localdb

devup: # 作業開始
	${TIME} ./init.sh create

devdown: # 作業終了
	${TIME} ./init.sh delete

cleanup: # 完全削除 DBの中身も消える
	./cleanup.sh
	docker images

build:
	docker compose --env-file ${ENV_PATH} up --build -d

vm: # ubuntuに接続
	docker compose --env-file ${ENV_PATH} exec dev bash

db: # docker
	docker compose --env-file ${ENV_PATH} exec db bash

mysql: # docker mysqlに接続
	docker compose --env-file ${ENV_PATH} exec db  mysql -u ${MYSQL_USER} -P 3306 -p${MYSQL_PW}

# if you have one...
localdb: ./.env.local
	mysql -u ${MYSQL_USER} -p${MYSQL_PW} -P 3366 -h 127.0.0.1

config: # mysqlに接続
	docker compose --env-file ${ENV_PATH} config

# db data
.PHONY: import_data export_data
	export_data:
	$(shell bash ./sql.sh export)

