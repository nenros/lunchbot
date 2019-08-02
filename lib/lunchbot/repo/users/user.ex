defmodule Lunchbot.Repo.Users.User do
  use Ecto.Schema
  @moduledoc "User db model"

  schema "users" do
    field(:user_name, :string)
    field(:user_id, :string)
    field(:magiclink, :string)
    field(:session_id, :string)

    timestamps()
  end
end
