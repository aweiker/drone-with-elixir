FROM bitwalker/alpine-elixir-phoenix:2.0
LABEL Description="Simple Hello World example of Drone.IO creating a Phoenix Application"

ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=hello_phoenix APP_VERSION="0.0.1"

WORKDIR /$APP_NAME
ADD rel/$APP_NAME .

EXPOSE $PORT

CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
