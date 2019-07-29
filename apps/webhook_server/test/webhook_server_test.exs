defmodule WebhookServerTest do
  use ExUnit.Case
  doctest WebhookServer

  test "greets the world" do
    assert WebhookServer.hello() == :world
  end
end
