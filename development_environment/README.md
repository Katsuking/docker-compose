
## 開発環境用意

本来、virtualbox + vagrant + vscodeのremote developmentでいい。
しかし, containerの方が個人的に扱いやすいと思ったので、
dockerを使って構築

メリット
1. コンテナとローカルのtool ディレクトリが同期

    一番は、個人の設定ファイルを分離しつつ、簡単にGithubのリモートから
    最新バージョに更新できること

2. 環境が壊れてもすぐに作り直せる

    Makefileとか、エイリアスを作ってれば一つのコマンドで作業に移行できる

3. リソースの管理が楽 

    自分が会社で使っているPCのメモリが8GBしかないので、
    使うときと使わないときでしっかり起動/停止させたい

4. 動作が軽い 

    メモリの問題だろうけど、virtualbox x vagrantでは `vagrant up`時
    結構時間がかかる

### セットアップ

#### 作業ディレクトをDockerfileがあるディレクトリにコピー

[Issues-operationのTool](https://github.com/plusmedi/issues-operation/tree/main/tool)

下記のように`/tool`(作業・開発ディレクト)ディレクトリをまるまるコピーします。
```
.
├── .env
├── .environment.local
├── .gitignore
├── Dockerfile
├── README.md
├── cleanup.sh
├── db.local.cnf
├── doc2unix.py
├── docker-compose.yaml
└── tool

1 directory, 9 files
```
本来, toolディレクトリにある開発環境設定ファイルを親ディレクトリで管理して、
親ディレクトリの設定ファイルの変更をtool/以下の設定ファイルに反映させるようにしました。
tool/をまるまる変更しても開発環境設定ファイルには影響がないようになっています。

#### 開発用の個人ファイル

.environment.local: tool/以下にある設定ファイル

```sh
case `hostname` in
    "<production環境のhostname>" ) source ~/tool/.environment.production ;;
    * ) source ~/tool/.environment.local ;;
esac
```
開発環境でのエラー発報は個人のSlackへ送ったり、
個人の開発用のSharepoint IDを使ったり等々
こんな感じで開発環境には、各個人の設定ファイルを読み込んでいます。

そんな各個人の設定ファイルはGit管理されていないので、Dockerfileのあるディレクトに
置いて、container起動時に作業ディレクトに飛ばすようにしています。
なので、要変更以下は適宜修正してください。

docker-compose.ymlのvolume
```
    volumes:
      - v1_dev:/home/ops/
      - ./tool:/home/ops/tool
      # 開発環境用の設定ファイルはtoolの外で管理 (tool内の設定ファイルを上書き)
      # 要変更
      - ./.environment.local:/home/ops/tool/.environment.local # 開発環境設定ファイル
      - ./db.local.cnf:/home/ops/tool/db.local.cnf # mysql db 接続情報
```

### 作業開始時

コンテナ立ち上げ + ターミナル操作
```sh
docker compose up -d && docker compose exec dev bash
```

停止
```sh
docker compose down
```

### image, volumeの削除

環境がうまくいかなかったり、もういらないとき。
```sh
bash cleanup.sh
```

### 快適に使う(任意)

Makefileで立ち上げとか削除とか色々やった方がいい気もしますが、
自分は簡単に立ち上げれるようにエイリアスを作ってます。

```sh

dev_v1=Dockerfileがあるディレクトリのパス

function devup() {
        cd ${dev_v1} 2>/dev/null
        docker compose down && docker compose up -d && docker compose exec dev bash
}

function devdown() {
        cd ${dev_v1} 2>/dev/null
        docker compose down
}

alias devup=devup
alias devdown=devdown
```



