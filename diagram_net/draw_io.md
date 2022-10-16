## diagram.net
旧称 draw.io
がDockerで使えるっぽいので、ローカル環境で使えるようにしてみる

portは好きなもの使えばええけど、デフォルトで下記のようにする
```
docker run -it --rm --name="draw" -p 8080:8080 -p 8443:8443 fjudith/draw.io
```