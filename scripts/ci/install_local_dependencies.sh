#! /bin/sh

mix local.hex --force && mix local.rebar --force
npm install -g brunch
npm install -g coffee-script
mix do deps.get, deps.compile
npm install
