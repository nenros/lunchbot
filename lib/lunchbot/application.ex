defmodule Lunchbot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [

      Lunchbot.Repo,
      Plug.Cowboy.child_spec(scheme: :http, plug: Lunchbot.Server.Router, options: [port: port()])

    ]

    opts = [strategy: :one_for_one, name: Lunchbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port() do
    with raw when is_binary(raw) <- System.get_env("PORT"), {port, ""} = Integer.parse(raw) do
      port
    else
      _ -> 8080
    end
  end
end
