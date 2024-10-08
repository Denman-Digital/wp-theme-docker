#!/usr/bin/env bash

file=$1
if [ -z "$file" ]; then
    echo "USAGE: restore-db <filename>"
    exit 1;
fi
if [ ! -f "$file" ]; then
    echo "$file is not an existing file."
    echo "USAGE: restore-db <filename>"
    exit 1;
fi

# Restore database to db container
cmd='exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" -v -v -v -T'
docker exec -i $(docker ps -q -f name=-db) sh -c "$cmd" < $file

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
docker compose exec wp sh -c "$cmd"
