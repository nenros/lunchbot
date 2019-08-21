# Lunchbot
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/f5b08f3b1b5347bd9491545857b9992d)](https://www.codacy.com/app/nenros/lunchbot?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=nenros/lunchbot&amp;utm_campaign=Badge_Grade)

[![CircleCI](https://circleci.com/gh/nenros/lunchbot.svg?style=svg)](https://circleci.com/gh/nenros/lunchbot)


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

