defmodule Lunchbot.WebhookAction.Test do
  @moduledoc false

  def perform(webhook) do
    [body | _] = webhook.params

    response = %{
      status_code: 200,
      type: "application/json",
      body: body
    }

    {:ok, Map.put(webhook, :response, response)}
  end
end
