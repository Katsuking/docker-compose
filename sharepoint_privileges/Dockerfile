# docker run --rm -it m365pnp/powershell 👈お試し
FROM m365pnp/cli-microsoft365:latest

USER root
RUN apk update && \
    apk add --no-cache py3-pip
RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo make
RUN pip install --upgrade pip
RUN pip install azure-cli --use-pep517

# pip3 install --no-cache-dir azure-cli

CMD ["/bin/sh"]

COPY ./src/* /usr/src
VOLUME ["/output"]
WORKDIR /usr/src
ENV TZ=Asia/Tokyo 