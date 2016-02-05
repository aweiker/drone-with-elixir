FROM aweiker/alpine-elixir:1.2.1
LABEL Description="Simple Hello World example of Drone.IO creating a Phoenix Application"

ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=hello_phoenix APP_VERSION="0.0.1"
ENV SECRET_KEY_BASE=HS0sTaDOPB0cpGL/wPYYWLy3/R6hJdvqNK+FndiJzhvAtHC2B0E70HSXu9qqwhhH

WORKDIR /$APP_NAME
ADD rel/$APP_NAME .

EXPOSE $PORT

CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
