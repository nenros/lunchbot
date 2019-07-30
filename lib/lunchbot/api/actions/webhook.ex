defmodule Lunchbot.API.Actions.Webhook do
  use Raxx.SimpleServer
  alias Lunchbot.API

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    case Lunchbot.Webhook.run_webhook(request) do
      {:ok, :webhook_async} ->
        response(:ok)
      {:ok, message} ->
        response(:ok)
        |> API.set_json_payload(%{text: message})
    end
  end
end
