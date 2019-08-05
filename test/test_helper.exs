ExUnit.start()
{:ok, _} = Application.ensure_all_started(:ex_machina)
Faker.start()

Mox.defmock(Lunchbot.SlackMock, for: Lunchbot.Slack)

Ecto.Adapters.SQL.Sandbox.mode(Lunchbot.Repo, :manual)
