## docker network

7 つの種類のdocker networkの世界を旅してみる

### IPアドレスの確認

```
ip addr show
```
自分の環境では、
- 1: lo
- 2: wlp2s0
- 3: docker0

### コンテナの作成

軽量なイメージ `busybox`を使って thorという名前のコンテナを作成
```
do docker run -itd \
> --rm \
> --name thor \
> busybox
```
作成したコンテナの確認
```
docker ps
```
出力結果:
```
CONTAINER ID   IMAGE     COMMAND   CREATED         STATUS         PORTS     NAMES
664d510579e4   busybox   "sh"      2 minutes ago   Up 2 minutes             thor
```

同様に別の名前のコンテナを作成

nginxイメージのdonという名前のコンテナを作成
```
docker run -itd \
> --rm \
> --name don \
> nginx
```

ここで全くネットワークについて、記述してない
docker は自動的にbridgeにデフォルトで設定する

その証拠に、下記のコマンドを実行すると...
```
bridge link
```
出力結果:
```
5: vethf0f4c97@if4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master docker0 state forwarding priority 32 cost 2 
9: veth137100f@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master docker0 state forwarding priority 32 cost 2
```
これらはすべて`ip addr show`コマンドに出てきた`docker0`に接続されている
すごいのは、きちんとこれらには、DHCPが使われている

確認するには、
```
docker inspect bridge
```
`docker0`のサブネットが`"Subnet": "172.17.0.0/16"` ゲートウェイが`"Gateway": "172.17.0.1"`であるのに対して、
作成したコンテナ`thor`にも`don`にもそれぞれ、`"IPv4Address": "172.17.0.2/16"`, `"IPv4Address": "172.17.0.3/16"`と固有のIPアドレスが与えられている

DNSもデフォルトで用意されていて、ホストの`/etc/resolv.conf`を各コンテナにコピーしている

### 疎通確認
```
docker exec -it thor sh
```
さらに
自身のコンテナのIPアドレスとdonコンテナへの疎通確認
```
ip addr show
ping 172.17.0.3
ping google.com
```
もちろく各コンテナは、インターネットにも接続されている


## portの開放

もし、スイッチを使って、他のPCからホストのコンテナに接続するには、
`-p ホストポート:コンテナポート`を使わなくてはいけない。

起動中のコンテナdonを止めて、新たにport80を開放したコンテナを起動させる
```
docker container stop don
docker container rm don
docker run -itd --rm -p 80:80 --name don
```