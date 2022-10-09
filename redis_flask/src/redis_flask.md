## web service

web サービスは、現在のディレクトリ内にある Dockerfile から構築したイメージを使います。それから、コンテナのポートと、ホストマシン上に公開するポート 8000 を 結び付け ます。この例にあるサービスは、 Flask ウェブサーバのデフォルト ポート 5000 を使います。

```
version: "3.9"
services:
  web:
    build: .
    ports:
      - "8000:5000"
    volumes:
      - .:/code
    environment:
      - FLASK_ENV=development
  redis:
    image: "redis:alpine"
```

volumes キーは、ホスト上のプロジェクトがあるディレクトリ（現在のディレクトリ）を、コンテナ内の /code にマウントします。これにより、イメージを再構築しなくても、実行しながらコードを変更できるようになります。 environment キーは環境変数 FLASK_ENV を設定します。これは flask run に対し、開発モードでの実行と、コードに変更があれば再読込するように伝えます。このモードは開発環境下でのみ使うべきです。
