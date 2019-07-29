defmodule WebhookServer.Request do
  defstruct channel: nil,
            channel_name: nil,
            command: nil,
            response: nil,
            team_domain: nil,
            text: nil,
            token: nil,
            trigger_id: nil,
            user_id: nil,
            user_name: nil


  def command_action(request = %WebhookServer.Request{text: text}) do
    [action | params] = String.split(text, " ")
    {:ok, action, params}
  end
end
