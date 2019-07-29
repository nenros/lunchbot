defmodule WebhookServer.MagicLink do
  def perform([magic_link | _ ], request_params) do
    %WebhookServer.Request{user_id: user_id} = request_params
    case Users.find_user_by_user_id(user_id) do
      user = %Users.User{} -> {:ok}
      nil -> request_params
             |> Map.take([:user_id, :user_name])
             |> Map.put(:magic_link, magic_link)
             |> Users.create_user
    end
  end
end
