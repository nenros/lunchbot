defmodule Lunchbot.RepoCase do
  use ExUnit.CaseTemplate
  # SEE https://hexdocs.pm/ecto/testing-with-ecto.html for more information

  using do
    quote do
      alias Lunchbot.Repo

      import Ecto
      import Ecto.Query
      import Lunchbot.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Lunchbot.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Lunchbot.Repo, {:shared, self()})
    end

    :ok
  end
end
