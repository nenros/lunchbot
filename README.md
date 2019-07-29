# Lunchbot

- Start your service with `docker-compose up`
- Run project test suite with `docker-compose run lunchbot mix test`
- Start IEx session in running service
      # Find a container id using docker ps
      docker exec -it <container-id> bash

      # In container
      iex --sname debug --remsh app@$(hostname)

Alternatively, you can still run the project directly, without docker:

- Start just the database service with `docker-compose up db`
- Install dependencies with `mix deps.get`
- prepare the database using `mix do ecto.create, ecto.migrate`
- Start your service with `iex -S mix`

## Learn more

- Raxx documentation: https://hexdocs.pm/raxx
- Slack channel: https://elixir-lang.slack.com/messages/C56H3TBH8/
