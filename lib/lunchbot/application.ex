defmodule Lunchbot.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Lunchbot.Repo
    ]

    children = if Mix.env() != :test do
      children ++
      [
        Plug.Cowboy.child_spec(
          scheme: :http,
          plug: Lunchbot.Server.Router,
          options: [
            port: port()
          ]
        )
      ]
    else
      children
    end

    if Mix.env() == :prod do
      :ok = ScoutApm.Instruments.EctoTelemetry.attach(Lunchbot.Repo)
    end

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
