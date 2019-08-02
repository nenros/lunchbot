defmodule Lunchbot.Lunchroom do
  def refresh_session_for_user(user) do
    with {:ok, session} <- Lunchbot.Lunchroom.Session.get_session_for_user(user),
         {:ok, user} <- Lunchbot.Repo.Users.save_session_id(user, session),
         do: {:ok, user}
  end
end
