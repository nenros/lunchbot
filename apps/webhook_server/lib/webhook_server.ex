defmodule WebhookServer do
  use Ace.HTTP.Service, port: 8080, cleartext: true
  use Raxx.SimpleServer

  @moduledoc """
  Webhook simple server, exposes one endpoint for webhook with post.
  """


  @impl Raxx.SimpleServer
  def handle_request(%{method: :POST, path: ["webhook"], body: body}, _state) do
    request_params = slack_request(body)
    case WebhookServer.Request.command_action(request_params) do
      {:ok, command_action, action_params} -> perform_action(command_action, action_params, request_params)
      _ -> send_message("Sorry you try to do somenthing wrong")
    end
  end

  defp send_message(message), do: response(:ok)
                                  |> set_header("content-type", "application/json")
                                  |> set_body(message)


  defp slack_request(body) do
    request_map = body
                  |> URI.query_decoder
                  |> Enum.reduce(
                       %{},
                       fn {k, v}, acc ->
                         Map.put(acc, String.to_atom(k), v)
                       end
                     )

    struct(WebhookServer.Request, request_map)
  end

  defp perform_action("magic_link", params, request) do
    case WebhookServer.MagicLink.perform(params, request) do
      {:ok, _} -> send_message("Magic link saved!")
      {:error, _} -> send_message("Something went wrong")
    end
  end

  defp perform_action("today", _, request) do
    case WebhookServer.FetchLunch.perform(:today, request) do
      {:ok, lunch} -> send_message(lunch)
      {:error, message} -> send_message(message)
    end
  end

end
