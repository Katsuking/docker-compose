## Excelより使いやすい図を作りたい 

旧称 draw.ioがローカル環境(docker)で使えるようにしてみる。
portは好きなもの使えばOK

```
docker run -it --rm --name="draw" -p 8080:8080 -p 8443:8443 fjudith/draw.io
```
