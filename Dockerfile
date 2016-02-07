FROM aweiker/alpine-elixir:1.2.1
LABEL Description="Simple Hello World example of Drone.IO creating a Phoenix Application"

ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=hello_phoenix APP_VERSION="0.0.1"

RUN mkdir -p /$APP_NAME
ADD rel/$APP_NAME/bin /$APP_NAME/bin
ADD rel/$APP_NAME/lib /$APP_NAME/lib
ADD rel/$APP_NAME/releases/start_erl.data                 /$APP_NAME/releases/start_erl.data
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.sh      /$APP_NAME/releases/$APP_VERSION/$APP_NAME.sh
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.boot    /$APP_NAME/releases/$APP_VERSION/$APP_NAME.boot
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.rel     /$APP_NAME/releases/$APP_VERSION/$APP_NAME.rel
ADD rel/$APP_NAME/releases/$APP_VERSION/$APP_NAME.script  /$APP_NAME/releases/$APP_VERSION/$APP_NAME.script
ADD rel/$APP_NAME/releases/$APP_VERSION/start.boot        /$APP_NAME/releases/$APP_VERSION/start.boot
ADD rel/$APP_NAME/releases/$APP_VERSION/sys.config        /$APP_NAME/releases/$APP_VERSION/sys.config
ADD rel/$APP_NAME/releases/$APP_VERSION/vm.args           /$APP_NAME/releases/$APP_VERSION/vm.args

EXPOSE $PORT

CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
