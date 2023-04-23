#!/bin/bash
set -eu

# shellcheck source=/dev/null
source "$(dirname $0)"/.env

docker login azure --tenant-id $TENANTID

docker context create aci $CONTEXTNAME \
--resource-group $RESOURCEGROUPENAME \
--subscription-id $SUBSCRIPTIONID \
--location $LOCATION

docker context use $CONTEXTNAME 