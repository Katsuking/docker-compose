### baseブランチ
baseブランチに環境構築時のファイルを残しとくぜ

### ディレクトリ構造

環境準備 `tree -L 2`
```
.
├── README.md
├── backend
│   ├── Dockerfile
│   ├── app
│   └── requirements.txt
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
CREATE TABLE users (
  id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  hashed_password VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE
);
CREATE TABLE items (
  id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  description VARCHAR(255),
  owner_id INTEGER,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);
```

### 確認
docker compose up --buildで特にエラーがないことを確認。
まずは、バックエンドのFastAPIが動いていることを確認
`http://localhost:8000/users`

Reactの確認
`docker compose exec frontend bash`
`npm start`
`http://localhost:3000/`


#### 確認したら 一旦テーブル削除する(念の為)
`docker compose exec frontend bash`
コンテナー内で`mysql -u myuser -p`
パスワードは、docker-compose.ymlにあるように`mypassword`
`drop table items, users;`

### マイグレーション
マイグレーション用のスクリプトを作成する
`alembic revision --autogenerate -m "create users table"`
`alembic upgrade head`でマイグレーション実行

alembicの設定は, alembic/env.pyで確認
参考) [Github](https://github.com/tiangolo/full-stack-fastapi-postgresql/blob/master/%7B%7Bcookiecutter.project_slug%7D%7D/backend/app/alembic/env.py)
