defmodule Lunchbot.Repo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  @moduledoc "User db model"

  schema "users" do
    field(:user_name, :string)
    field(:user_id, :string)
    field(:magiclink, :string)
    field(:encrypted_magiclink, Lunchbot.Repo.Vault.String)
    field(:session_id, :string)
    field(:encrypted_session_id, Lunchbot.Repo.Vault.String)

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:user_name, :user_id, :magiclink, :session_id])
    |> validate_required([:user_name, :user_id])
    |> put_encrypted_fields()
    |> unique_constraint(:user_id)
  end

  defp put_encrypted_fields(changeset) do
    changeset
    |> put_change(:encrypted_magiclink, get_field(changeset, :magiclink))
    |> put_change(:encrypted_session_id, get_field(changeset, :session_id))
  end
end
