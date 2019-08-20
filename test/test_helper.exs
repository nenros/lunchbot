ExUnit.start()
{:ok, _} = Application.ensure_all_started(:ex_machina)
Faker.start()

formatters =
  case System.get_env("CI") do
    "true" -> [JUnitFormatter, ExUnit.CLIFormatter]
    _ -> [ExUnit.CLIFormatter]
  end

ExUnit.configure(formatters: formatters)

Mox.defmock(Lunchbot.SlackMock, for: Lunchbot.Slack)
Mox.defmock(Lunchbot.LunchroomMock, for: Lunchbot.Lunchroom)

Ecto.Adapters.SQL.Sandbox.mode(Lunchbot.Repo, :manual)
