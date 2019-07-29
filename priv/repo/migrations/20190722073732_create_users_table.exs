defmodule Lunchbot.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    create table("users") do
      add :user_name, :string
      add :user_id, :string
      add :magiclink, :string
      add :session_id, :string

      timestamps()
    end
    end
end
