defmodule Lunchbot.API.Actions.Webhook do
  use Raxx.SimpleServer
  alias Lunchbot.API

  @impl Raxx.SimpleServer
  def handle_request(request = %{method: :POST}, _state) do
    Task.async(fn -> Lunchbot.Webhook.run_webhook(request) end)

    response(:ok)
  end
end
