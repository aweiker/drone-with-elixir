# Getting Started
This is a brief tour on what is required to make a Phoenix application
buildable through Drone and published as a minimal docker image.

### .drone.sec.yml template

```yaml
environment:
  SECRET_KEY_BASE: <phoenix application key>
  DOCKER_USERNAME: <docker username>
  DOCKER_EMAIL: <docker email address>
  DOCKER_PASS: <docker password>
```
If you need to generate a new phoenix secret, use the command
`mix phoenix.gen.secret` from the application root.

### Dockerfile template

```Dockerfile
FROM aweiker/alpine-elixir:1.2.1
ENV PORT=4000 MIX_ENV=prod

ENV APP_NAME=<app_name> APP_VERSION="<app_version>"

WORKDIR /$APP_NAME
ADD rel/$APP_NAME .
EXPOSE $PORT
CMD trap exit TERM; /$APP_NAME/bin/$APP_NAME foreground & wait
```

## config/prod.exs
Update the config so that phoenix will run the server on startup, this can be
accomplished by adding `server: true` to the call to `config`

For example:
```elixir
config :hello_phoenix, HelloPhoenix.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true
```

## config/prod.secret.exs.tpl
This file will need to be automatically generated during image build time as
this key is used to protect your production instance.

- [ ]  Is it possible to use an environment variable for this? #1

Here is an example of the template for generating this file. Refer to the build
steps in [.drone.yml](https://github.com/drone-demos/drone-with-elixir/blob/master/.drone.yml)
in particular the [scripts/ci/generate\_secrets.sh](https://github.com/drone-demos/drone-with-elixir/blob/master/scripts/ci/generate_secrets.sh) file.

```elixir
use Mix.Config
config :hello_phoenix, HelloPhoenix.Endpoint,
  secret_key_base: "SECRET_KEY_BASE"
```

## mix.exs
In order to bulid the release, `exrm` will need to be added as a dependency.
With a default Phoenix application the dependencies will look like:

```elixir
  defp deps do
    [
      {:phoenix, "~> 1.1.4"},
      {:phoenix_html, "~> 2.4"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:exrm, "~> 0.19.9"}
    ]
  end
```

## .drone.yml
Drone allows you to run your build on one type of image and then publish
against a different image. In this exmaple I am using 
`bitwalker/alpine-elixir-phoenix` to generate the build output.
The reason for this is that this image is based on Alpine 3.3 and also
has _node_ installed on it. Since _node_ is only needed at compile time
the base image for our docker image does not have it and will be kept as
minimal as possible. In addition to creating this `.drone.yml` file, the
supporting script files will need to be copied over.

**ANYTIME THIS FILE IS CHANGED, YOU WILL NEED TO REGENERATE `.drone.sec.yml`**

```yaml
build:
  image: bitwalker/alpine-elixir-phoenix:2.0
  commands:
    - scripts/ci/install_local_dependencies.sh
    - scripts/ci/execute_tests.sh
    - scripts/ci/generate_secrets.sh
    - scripts/ci/build_release.sh
  environment:
    - SECRET_KEY_BASE=$$SECRET_KEY_BASE

cache:
  mount:
    - deps
    - node_modules

publish:
  docker:
    username: $$DOCKER_USERNAME
    password: $$DOCKER_PASS
    email: $$DOCKER_EMAIL
    repo: drone-demos/drone-with-elixir
    tag:
      - latest
      - "0.0.$$BUILD_NUMBER"
```

# Common Issues
All scripts need the execute permission in order to run
```bash
chmod +x scripts/ci/*.sh
```



