#!/bin/bash
set -eu

# shellcheck source=/dev/null
source "$(dirname $0)"/.env

az login
# identity x

# レジストリへログイン
az acr login --name $CONTAINEREGISTRYNAME

echo "Login Server Name:"
az acr show --name $CONTAINEREGISTRYNAME --query loginServer --output table

docker context use default
# docker tag aci-test $CONTAINEREGISTRYNAME.azurecr.io/$IMAGENAME:$imageVersion

# docker compose pwshのイメージをビルド
echo "building image..."
docker-compose build pwsh

# 作成したイメージをAzureにpush
echo "pushing the image to Azure Contaner Registry..."
docker push $CONTAINEREGISTRYNAME.azurecr.io/$IMAGENAME:$IMAGEVERSION

echo "list all images..."
az acr repository list --name $CONTAINEREGISTRYNAME --output table

docker context use $CONTEXTNAME
docker compose up
echo "chekc running containers..."
docker ps 