#!/usr/bin/env bash


# Replace PROD_URL using WP-CLI in wp container
# * Also replace JSON encoded URLs such as in Gutenberg comments
cmd='
JSON_ENCODED_HTTP=$(php -r "echo json_encode(\"http://\");")
JSON_ENCODED_HTTPS=$(php -r "echo json_encode(\"https://\");")
wp --allow-root search-replace "https://" "http://" --skip-columns=guid
wp --allow-root search-replace "$JSON_ENCODED_HTTPS" "$JSON_ENCODED_HTTP" --skip-columns=guid
wp --allow-root --skip-themes plugin deactivate really-simple-ssl
wp --allow-root config set FORCE_SSL false --raw
wp --allow-root config set FORCE_SSL_LOGIN false --raw
wp --allow-root config set FORCE_SSL_ADMIN false --raw
'
docker-compose exec wp sh -c "$cmd"
