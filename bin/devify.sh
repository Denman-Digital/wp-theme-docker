#!/usr/bin/env bash

# Replace PROD_URL using WP-CLI in wp container
# * Also replace JSON encoded URLs such as in Gutenberg comments
cmd='
JSON_PROD_URL=$(php -r "echo json_encode(getenv(\"PROD_URL\"));")
JSON_DEV_URL=$(php -r "echo json_encode(getenv(\"DEV_URL\"));")
echo "\n$PROD_URL -> $DEV_URL\n"
wp --allow-root search-replace "$PROD_URL" "$DEV_URL" --skip-columns=guid
echo "\n$JSON_PROD_URL -> $JSON_DEV_URL\n"
wp --allow-root search-replace "$JSON_PROD_URL" "$JSON_DEV_URL" --skip-columns=guid
'
docker-compose exec wp sh -c "$cmd"
