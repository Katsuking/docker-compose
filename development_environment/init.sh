#!/bin/bash

ROOT_PATH=$(dirname $0)/playground
TOOL_PATH=$(dirname $0)/tool
ENV_PATH=$(dirname $0)/.env.local

[[ ! -f ${ENV_PATH} ]] && echo "Create .env.local file" && exit 1
source "${ENV_PATH}"

[[ -z $(which route) ]] && sudo apt update -y && sudo apt install net-tools -y
export DOCKER_HOST_IP=$(route -n | awk '/UG[ \t]/{print $2}')

# test dir (テストスクリプトを配置するディレクトリ)を作成したい場合、追加
# 要 docker-compose 追記
prjs=(
  "management"
  "mon"
)

[[ ! -d ${ROOT_PATH} ]] && echo "playground dir not found." && exit 1

function create_test_dir() {
  for ((i = 0; i < ${#prjs[@]}; i++)); do
    [[ ! -d "${TOOL_PATH}/${prjs[${i}]}/test" ]] &&
      [[ -d ${ROOT_PATH}/${prjs[${i}]} ]] &&
      mkdir ${TOOL_PATH}/${prjs[${i}]}/test
  done
}

function delete_test_dir() {
  for ((i = 0; i < ${#prjs[@]}; i++)); do
    [[ -d "${TOOL_PATH}/${prjs[${i}]}/test" ]] &&
      rm -rf ${TOOL_PATH}/${prjs[${i}]}/test
  done
}

##############################################
# main
##############################################
# test dirのコピー
# docker compose 起動/停止の処理
#---------------------------------------------

function main() {
  local action=${1}

  [[ -z ${action} ]] && exit 1
  if [[ ${action} == "create" ]]; then
    create_test_dir
    docker compose --env-file ${ENV_PATH} down
    docker compose --env-file ${ENV_PATH} up -d
    docker compose --env-file ${ENV_PATH} exec dev bash

  elif [[ ${action} == "delete" ]]; then
    delete_test_dir
    docker compose --env-file ${ENV_PATH} down && docker ps -a
  fi
}

main "${1}"
