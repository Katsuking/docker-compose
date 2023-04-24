### Ubuntu 53portがすでに使われている

pi-holeをdockerで用意して、docker compose up で立ち上げると、下記のように53ポート番号はすでに使用されているらしい。
```
Attaching to pihole
Error response from daemon: driver failed programming external connectivity on endpoint pihole (44c7074706c23c45cdf77dbd3b00d468cd3a8d1a18e7c9eb5de5c2dfc86d75bf): Error starting userland proxy: listen tcp4 0.0.0.0:53: bind: address already in use
```
#### 53ポートが何に使われているか確認する
`sudo lsof -i -P | grep "LISTEN"`
結果:`systemd-r     969 systemd-resolve   14u  IPv4    21692      0t0  TCP localhost:53 (LISTEN)`
systemd-resolveってのが、すでに53ポートを使っているっぽい。

#### systemd-resolveとはなんぞや??
systemd-resolveがデフォルトのDNSリゾルバーとなっている


#### 対策
resolve.confの設定を変更する
`sudo vim /etc/systemd/resolved.conf`
コメントアウトして、`NSStubListener=no`に設定する

backup作成
`sudo cp /etc/resolv.conf /etc/resolv.conf.backup`

/etc/resolve.confの削除
`sudo rm /etc/resolve.conf`

シンボリックリンクの作成

シンボリックリンクとは、OSのファイルシステムの機能の一つで、特定のファイルやディレクトリを指し示す別のファイルを作成し、それを通じて本体を参照 できるようにする仕組み。リンクは本体と同じディレクトリに置いても良いが、通常は別の場所から参照できるようにするために作成される。
削除を指示するとシンボリックリンクが削除され、本体は影響を受けない。
存在しない（存在するかわからない）ファイルに対しても作成できるが、本体が移動したり改名すると参照できなくなる。

`sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf`
※ 必ずフルパスでつなげること cd で/resolve/まで移動してから、
`sudo ln -s ./resolv.conf /etc/resolve.conf`のようにするとエラーになる

#### docker compose up -d
`docker compose up -d`

`http://localhost/admin/login.php`に接続する