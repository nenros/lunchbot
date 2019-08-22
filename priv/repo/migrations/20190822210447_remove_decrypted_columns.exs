defmodule Lunchbot.Repo.Migrations.RemoveDecryptedColumns do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :magiclink
      remove :session_id
    end

    rename table(:users), :encrypted_magiclink, to: :magiclink
    rename table(:users), :encrypted_session_id, to: :session_id
  end
end
