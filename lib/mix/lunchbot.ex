defmodule Mix.Tasks.Lunchbot.Cloak do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    Mix.Task.run "app.start"

   Lunchbot.Repo.Users.User
    |> Lunchbot.Repo.all()
    |> Enum.map(fn user ->
      user
      |> Ecto.Changeset.change(%{
        encrypted_magiclink: user.magiclink,
        encrypted_session_id: user.session_id
      })
      |> Lunchbot.Repo.update!()
    end)
  end

end
