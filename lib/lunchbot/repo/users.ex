defmodule Lunchbot.Repo.Users do
  @moduledoc false
  alias Lunchbot.Repo.Users.User
  require Ecto.Query

  def create_user(user_data),
    do:
      %User{}
      |> User.changeset(user_data)
      |> Lunchbot.Repo.insert()

  def find_user_by_user_id(user_id),
    do:
      User
      |> Ecto.Query.where(user_id: ^user_id)
      |> Lunchbot.Repo.one()

  def update_magic_link(user, magiclink),
    do:
      user
      |> Ecto.Changeset.change(magiclink: magiclink)
      |> Lunchbot.Repo.update()

  def save_session_id(user, session_id),
    do:
      user
      |> Ecto.Changeset.change(session_id: session_id)
      |> Lunchbot.Repo.update()
end
