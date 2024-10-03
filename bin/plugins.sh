#!/usr/bin/env bash

# uninstall dummy plugin hello-dolly
# install and activate dev plugins as defined by DEV_PLUGINS env variable
# deactivate prod plugins as defined by PROD_PLUGINS env variable

cmd='
wp --allow-root --skip-themes plugin uninstall hello-dolly
[ ! -z "$DEV_PLUGINS"] && wp --allow-root --skip-themes plugin install $DEV_PLUGINS --activate
[ ! -z "$PROD_PLUGINS" ] && wp --allow-root --skip-themes plugin deactivate $PROD_PLUGINS
'
docker compose exec wp sh -c "$cmd"