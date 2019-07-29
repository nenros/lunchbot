defmodule Users.Repo.Migrations.CreatUsersTable do
  use Ecto.Migration

  def up do
    create table("users") do
      add :user_name, :string
      add :user_id, :string
      add :magic_link, :string
      add :session_id, :string

      timestamps()
    end
  end
end
