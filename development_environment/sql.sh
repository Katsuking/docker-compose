#!/bin/bash

##############################################
# mysql dump
##############################################
# docker内のmysqlに読み込ませる初期データとして
# test2からdumpします。
# TEST2接続
# mysql -u ${TEST2_USERNAME} -h ${TEST2_HOST} -p"${TEST2_PWD}" -P ${TEST2_PORT}
#---------------------------------------------

source $(dirname $0)/.env.local

DUMP_DATA=$(dirname $0)/initdb.d/dump.sql
[[ ! -d "$(dirname $0)/initdb.d" ]] && mkdir "$(dirname $0)/initdb.d"

[[ -z $(which mysql) ]] &&
  echo "Install msyql command line tool first" && exit 1

function export_data() {
  [[ -n ${DUMP_DATA} ]] && cat <<EOF && return
ダンプデータが既に存在しています。
新しいデータをエクスポートする場合は、/initdb.d/dump.sqlを削除して、
再度実行してください。
EOF
  # export dump file from test2
  mysqldump -u ${TEST2_USERNAME} \
    -h "${TEST2_HOST}" \
    -p"${TEST2_PWD}" \
    --databases ${TEST2_DB} >${DUMP_DATA}
  # --databases ${TEST2_DB} | gzip >${DUMP_DATA}.gz
}

function import_data() {
  # import data to docker
  ## 下記の方法ではうまくいかなかったので、要改修
  cat <<EOF
要改修 mysqlコマンドでのインポートは現状うまくいかない。
どちらにせよ時間がかかりそうなので、README.mdにあるように
mysql containerから実行した方がいいかも
EOF
  return
  # mysql -u ${MYSQL_USER} -p"${MYSQL_PW}" -P 3366 -h 127.0.0.1 <${DUMP_DATA}
  # gunzip dump.sql.gz | mysql -u ${MYSQL_USER} -p"${MYSQL_PW}" -P 3366 -h 127.0.0.1
}

function main() {
  local cmd=${1}
  [[ -z ${cmd} ]] && echo "choose export / import and give it as cmd arg" && exit 1

  [[ ${cmd} == "export" ]] && echo "fetching dump data..." && export_data
  [[ ${cmd} == "import" ]] && echo "import dump data to docker" && import_data
}

main "${@}"
