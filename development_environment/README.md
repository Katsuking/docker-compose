## 開発環境用意

本来、vagrant + vscode の remote development でいい。
container の方が個人的に扱いやすいと思ったので、
docker を使って構築

メリット

1. コンテナとローカルの tool ディレクトリが同期
2. 壊れてもすぐに作り直せる
3. リソースの管理が楽
4. virtualbox がいらない
5. 各種プロジェクト直下に自由にテストする環境を保持できる
6. MySQL が裏で動く必要がないので、リソースの削減

### セットアップ

### /tool を Dockerfile があるディレクトリにコピー

[Issues-operation の Tool](https://github.com/plusmedi/issues-operation/tree/main/tool)

下記のように/tool ディレクトリをまるまるコピーします。

```
.
├── .env.local
├── .environment.local
├── .gitignore
├── Dockerfile
├── Makefile
├── README.md
├── cleanup.sh
├── db.local.cnf
├── doc2unix.py
├── docker-compose.yaml
├── init.sh
├── initdb.d
├── playground
├── sql.sh
└── tool

```

本来, tool ディレクトリにある開発環境設定ファイルを親ディレクトリで管理して、
親ディレクトリの設定ファイルの変更を tool/以下の設定ファイルに反映させるようにしました。
tool/をまるまる変更しても開発環境設定ファイルには影響がないようになっています。

### 環境変数

下記を参考に`.env.local`を作成
ローカルだから特に気にしなくてもいい?

```sh
MYSQL_ROOT_PW="パスワード"
MYSQL_DB="データベース名"
MYSQL_USER="docker"
MYSQL_PW="docker"
```

```sh
PMA_USER="パスワード"
PMA_PW="パスワード"

# test2
TEST2_USERNAME="ユーザー名"
TEST2_PORT="ポート番号"
TEST2_HOST='ホスト名.mysql.database.azure.com'
TEST2_PWD='パスワード'
TEST2_DB="DB の名前"

```

### 作業開始と終了

`make devup`で作業開始
`make devdown`で作業終了

※もう二度と使うことがない場合や環境を作り直す場合は、`make cleanup`

### docker mysql に dump ファイルをインポート

TEST2 から dump ファイルをエキスポート

```sh
bash sql.sh export
```

- docker mysql にインポート

```sh
make devup # mysql containerが動いていることを確認
# ほかのターミナルを開く
make mysql
```

docker mysql に docker ユーザーで入った後は、
source を使って、mysql container 内にある dump.sql を実行する

```sql
source /docker-entrypoint-initdb.d/dump.sql
```

テーブルを確認

### ローカルから DB 接続

```sh
source .env.local
mysql -u ${MYSQL_USER} -p"${MYSQL_PW}" -P 3366 -h 127.0.0.1
```

### 余談

快適に使う方法

ディレクトリ移動とかが面倒なので、
自分は簡単に立ち上げれるようにエイリアスを作ってます。
docker ファイルがある場所にパスを書き換え必要

```sh

dev_v1=Dockerfileがあるディレクトリのパス

function devup() {
        cd ${dev_v1} 2>/dev/null
        make devup
}


function devdown() {
cd ${dev_v1} 2>/dev/null
make devdown
}

alias devup=devup
alias devdown=devdown
```
