#! /bin/sh
template=`cat config/prod.secret.exs.tpl`
key=${SECRET_KEY_BASE}

echo "$template" | sed "s/SECRET_KEY_BASE/${SECRET_KEY_BASE}/" >> config/prod.secret.exs
