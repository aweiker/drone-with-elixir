#! /bin/sh

mix local.hex --force && mix local.rebar --force
npm install -g brunch
npm install -g coffee-script
npm install
mix do deps.get, deps.compile
