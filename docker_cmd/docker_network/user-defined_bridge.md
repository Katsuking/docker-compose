## user-defined_bridge

名前の通り、自分でネットワークを作る
コマンドは下記の通り
```
docker network create asgard
```
確認
```
docker network ls
ip address show
```
`172.18.0.1/16`全く新しいbridgeが作成されている

では、新たなコンテナを作成して、このnetworkに紐付ける

`loki`と`ordin`を作る

loki
```
docker run \
> -itd \
> --rm \
> --network asgard \
> --name loki \
> busybox
```
ordin
```
docker run \
> -itd \
> --rm \
> --network asgard \
> --name ordin \
> busybox
```

`ip addr show`で新たに作成されたコンテナは、きちんと`asgard`ネットワークに紐付いていることがわかる

```
docker inspect asgard
```
`loki`と`ordin`コンテナのIPアドレスを確認

この自作したネットワーク`asgard`とデフォルトのbridgeネットワークの疎通を確認してみる
`bridge`と`asgard`はそれぞれ独立したネットワークであるため、疎通はできないはず
```
docker ps
docker exec -it thor sh
ping 172.18.0.3
```

## メリット

- コンテナ名で名前解決できる

```
docker exec -it loki sh
ping ordin
```