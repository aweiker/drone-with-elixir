#! /bin/sh
template=`cat config/prod.secret.exs.tpl`
key=$SECRET_KEY_BASE

echo "$template" | awk -v KEY="$key" '{gsub(/SECRET_KEY_BASE/, KEY); print}' > config/prod.secret.exs
