
ちょうきまぐれでつくったやつ

### ディレクトリ構造

環境準備 `tree -L 2`
```
.
├── README.md
├── backend
│   ├── Dockerfile
│   ├── app
│   └── requirements.txt
├── docker-compose.yml
└── frontend
    ├── Dockerfile
    ├── README.md
    ├── app
    ├── node_modules
    ├── package-lock.json
    ├── package.json
    ├── public
    ├── src
    └── tsconfig.json
```


### Reactの用意

frontendディレクトリで普通に
`npx create-react-app . --template typescript`
Conflict的なエラーが出たら、Dockerfileを `mv Dockerfile ../`的な感じで移動させてからもう一度試す。

ホットリロードの設定は, package.jsonかも?
```
  "scripts": {
    "start": "WATCHPACK_POLLING=true react-scripts start",
    ...
```

### DBにデータを用意(テスト)
`docker compose exec frontend bash`
コンテナー内で`mysql -u myuser -p`
パスワードは、docker-compose.ymlにあるように`mypassword`

実際にmysqlにテーブルを作成して、FastAPIで確認する
```
use database;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255),
  age INT
);

INSERT INTO users (name, email, age) VALUES ('Tay Keith', 'Tay.Keith@example.com', 26);
```

### 確認
docker compose up --buildで特にエラーがないことを確認。
まずは、バックエンドのFastAPIが動いていることを確認
`http://localhost:8000/users`

Reactの確認
`docker compose exec frontend bash`
`npm start`
`http://localhost:3000/`


