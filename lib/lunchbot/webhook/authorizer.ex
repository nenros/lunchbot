defmodule Lunchbot.Webhook.Authorizer do
  def authorize_user(webhook = %{slack_data: slack_data}) do
    case Lunchbot.Repo.Users.find_user_by_user_id(slack_data.user_id) do
      user = %Lunchbot.Repo.Users.User{} -> {:ok, Map.put(webhook, :user, user)}
      _ -> {:ok, webhook}
    end
  end
end
