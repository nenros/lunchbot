use Mix.Config

config :lunchbot,
       ecto_repos: [Lunchbot.Repo]

config :lunchbot, Lunchbot.Repo,
       # it can be overridden using the DATABASE_URL environment variable
       url: "ecto://kuoGfGzy:y_MiBPcpiDGsR2VHB_@localhost:6543/lunchbot?ssl=false&pool_size=10"

if Mix.env() == :prod do
  config :logger,
         level: :info

  config :lunchbot,
         Lunchbot.Repo,
         loggers: [{Ecto.LogEntry, :log, []},
           {ScoutApm.Instruments.EctoLogger, :log, []}]
end

if Mix.env() == :test do
  config :lunchbot, Lunchbot.Repo,
         # it can be overridden using the DATABASE_URL environment variable
         url: "ecto://kuoGfGzy:y_MiBPcpiDGsR2VHB_@localhost:6543/lunchbot_test?ssl=false&pool_size=10"

  config :lunchbot, Lunchbot.Repo, pool: Ecto.Adapters.SQL.Sandbox
end

if Mix.env() == :dev do
  config :exsync,
         extra_extensions: [".js", ".css"]
end
