defmodule Users do
  require Ecto.Query

  def create_user(user_data), do: %Users.User{}
                                  |> Ecto.Changeset.cast(user_data, [:user_name, :user_id, :magic_link])
                                  |> Users.Repo.insert

  def find_user_by_user_id(user_id), do: Users.User
                                         |> Ecto.Query.where(user_id: ^user_id)
                                         |> Users.Repo.one

  def update_magic_link(), do: nil

  def save_session_id(session_id, user), do: user
                                             |> Ecto.Changeset.change(session_id: session_id)
                                             |> Users.Repo.update
end
