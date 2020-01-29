defmodule Lunchbot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lunchbot,
      version: "0.1.0",
      elixir: "~> 1.9.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test]
    ]
    |> Keyword.merge(custom_artifacts_directory_opts())
  end

  def application do
    [extra_applications: [:logger], mod: {Lunchbot.Application, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:plug_cowboy, "~> 2.1"},
      {:jason, "~> 1.0"},
      {:exsync, "~> 0.2.3", only: :dev},
      {:postgrex, ">= 0.0.0"},
      {:ecto_sql, "~> 3.3.3"},
      {:scout_apm, "~> 1.0.0"},
      {:httpoison, "~> 1.4"},
      {:floki, "~> 0.23.0"},
      {:ex_machina, "~> 2.3", only: :test},
      {:mox, "~> 0.5", only: :test},
      {:faker, "~> 0.12", only: :test},
      {:credo, "~> 1.1.3", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:junit_formatter, "~> 3.0", only: [:test]},
      {:excoveralls, "~> 0.11", only: :test},
      {:inch_ex, only: [:dev, :test]},
      {:ex_doc, "~> 0.21", only: [:dev, :test], runtime: false},
      {:cloak_ecto, "~> 1.0.1"}
    ]
  end

  defp aliases() do
    [
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # makes sure that if the project is run by docker-compose inside a container,
  # its artifacts won't pollute the host's project directory
  defp custom_artifacts_directory_opts() do
    case System.get_env("MIX_ARTIFACTS_DIRECTORY") do
      unset when unset in [nil, ""] ->
        []

      directory ->
        [
          build_path: Path.join(directory, "_build"),
          deps_path: Path.join(directory, "deps")
        ]
    end
  end
end
