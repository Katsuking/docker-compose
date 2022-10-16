## wordpressとmysql

全体の構成
```
version: "3"
services:
  wordpress:
    image: wordpress
    ports:
      - "8089:80"
    depends_on:
      - mysql
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: root
      WORDPRESS_DB_PASSWORD: "wordpress"
      WORDPRESS_DB_NAME: wordpress

  mysql:
    image: "mysql:5.7"
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_ROOT_PASSWORD: "wordpress"
    volumes:
      - ./mysql:/var/lib/mysql
```

wordpressには、既存でDBがついてるはずだけど、
あえてMysqlとつなげてみる

wordpressの方の環境変数
```
      WORDPRESS_DB_HOST: mysql
```
がサービス名`mysql`と一致
```　
  mysql:
    image: "mysql:5.7"
```

同様に、wordpressの`WORDPRESS_DB_PASSWORD: "wordpress"`とmysql側のパスワード設定が一致`MYSQL_ROOT_PASSWORD: "wordpress"`

ここで、wordpress側で、`depends_on:`パラメータを設定すれば、通信してくれる
```
depends_on:
      - mysql
```