defmodule Lunchbot.Repo.Migrations.AddIndexOnUserId do
  use Ecto.Migration

  def change do
    unique_index(:users, :user_id)
  end
end
