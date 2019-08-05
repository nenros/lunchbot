defmodule Lunchbot.Lunchroom do
  def refresh_session_for_user(user) do
    with {:ok, session} <- Lunchbot.Lunchroom.Session.get_session_for_user(user),
         {:ok, user} <- Lunchbot.Repo.Users.save_session_id(user, session),
         do: {:ok, user}
  end

  def get_session_from_magiclink(_magiclink), do: nil
  def get_lunch_for_date(session, day), do: nil
end
