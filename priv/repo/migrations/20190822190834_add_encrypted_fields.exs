defmodule Lunchbot.Repo.Migrations.AddEncryptedFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :encrypted_magiclink, :binary
      add :encrypted_session_id, :binary
    end
  end
end
