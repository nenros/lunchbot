defmodule Lunchbot.Repo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc "User db model"

  schema "users" do
    field(:user_name, :string)
    field(:user_id, :string)
    field(:magiclink, Lunchbot.Repo.Vault.String)
    field(:session_id, Lunchbot.Repo.Vault.String)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:user_name, :user_id, :magiclink, :session_id])
    |> validate_required([:user_name, :user_id])
    |> unique_constraint(:user_id)
  end
end
