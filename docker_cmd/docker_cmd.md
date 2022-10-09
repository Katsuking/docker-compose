## docker 　イメージ

- イメージの全消し

ほんまに全消ししたい場合,

```
docker rmi $(docker images -a -q)
```

解説:
引数にしている`docker images -a -q`は
すべてのイメージの IMAGE ID のみを出力する
e.g. 5419862bdde6
よって、 `docker rmi`コマンドで引数に渡した IMAGE ID のイメージを削除できる

**ただし、イメージを使って起動しているコンテナが残っている場合は、削除できない**

- イメージを確認する

```
docker image ls
```

- イメージの prune

宙ぶらりんイメージ（dangling image）のみ削除
全部消せそうだけど、あくまで関連のないイメージだけ削除
-a オプションをつけることで、使われていないイメージを全消しできる。
でも、例えば、`docker container stop コンテナ名`のように停止させただけだと、
残ってしまう。

```
docker image prune -a
```
