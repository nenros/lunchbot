defmodule Users.Application do
  @moduledoc false



  use Application

  def start(_type, args) do
    children = [
      # Starts a worker by calling: Users.Worker.start_link(arg)
      Users.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Users.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
