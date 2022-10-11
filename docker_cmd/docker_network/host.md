## host

このネットワークまぁまぁ奇妙な動きをしてて、
dockerなのに、まるでhostの普通のアプリのように扱える

isolation(独立した状態)と真反対の挙動

`--network host`にするだけ
```
docker container stop don
docker run -itd --rm --network host --name don nginx
```
`ip addr show`でhostのIPアドレスを確認
自分の場合、`192.168.100.114`
ウェブで確認すると、nginxのウェルカムページが表示される