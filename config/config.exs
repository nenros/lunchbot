use Mix.Config

config :lunchbot,
  ecto_repos: [Lunchbot.Repo]

config :lunchbot, Lunchbot.Repo,
  # it can be overridden using the DATABASE_URL environment variable
  url: "ecto://kuoGfGzy:y_MiBPcpiDGsR2VHB_@localhost:6543/lunchbot?ssl=false&pool_size=10"

config :logger, :console,
  format: "\n$time $metadata[$level] $levelpad$message\n",
  metadata: [:user_name, :text, :action]

config :lunchbot,
  slack_client: Lunchbot.Slack.Client,
  lunchroom_client: Lunchbot.Lunchroom.Client

if Mix.env() == :prod do
  config :logger,
    level: :info

  config :scout_apm,
    name: System.get_env("SCOUT_APP_NAME"),
    key: System.get_env("SCOUT_KEY"),
    ignore: ["/"]
end

if Mix.env() == :test do
  config :lunchbot, Lunchbot.Repo,
    # it can be overridden using the DATABASE_URL environment variable
    url: "ecto://kuoGfGzy:y_MiBPcpiDGsR2VHB_@localhost:6543/lunchbot_test?ssl=false&pool_size=10",
    pool: Ecto.Adapters.SQL.Sandbox

  config :lunchbot,
    slack_client: Lunchbot.SlackMock,
    lunchroom_client: Lunchbot.LunchroomMock

  config :junit_formatter,
    report_dir: 'test-results/mix'
end

if Mix.env() == :dev do
  config :exsync,
    extra_extensions: [".js", ".css"]
end
