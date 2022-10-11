## macvlan

このパターンでは、それぞれのコンテナはまるでVMであるかのように
スイッチでホストと同じLANポートに接続されているかのような挙動になる

`wlp2s0`はホストのインターフェース名
これは、各自環境によって異なる
下記の通り、subnetとgatewayを決めて、今回は`newasgard`という名前のネットワークにしてみる
```
docker network create -d macvlan --subnet 10.7.1.0/24 --gateway 10.7.1.3 -o parent=wlp2s0 newasgard
```
`docker network ls`で確認
`DRIVER`もきちんと、`macvlan`になっているはず

このネットワークに`don`と`thor`コンテナを紐付ける
`--ip`では、自分で考えて、IPアドレスを割り当てる必要がある
```
docker run -tid --rm --network newasgard --ip 10.7.1.92 --name thor busybox
```

確認してみる
```
docker exec -it thor sh
ping 10.7.1.3
```
あれ? gatewayへの疎通確認がとれない。
これが普通のmacvlanの欠点
`promiscuous mode`を有効にしない限り、無理なんすよねぇ