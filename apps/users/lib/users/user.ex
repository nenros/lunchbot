defmodule Users.User do
  use Ecto.Schema
  @moduledoc "User db model"

  schema "users" do
    field :user_name, :string
    field :user_id, :string
    field :magic_link, :string
    field :session_id, :string

    timestamps()
  end
end
