FROM matteosister/elixir:1.0.5

# app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
ADD mix.* /app/
RUN mix deps.get
