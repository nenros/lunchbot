defmodule LunchbotTest do
  use ExUnit.Case
  doctest Lunchbot

  setup %{} do
    # OS will assign a free port when service is started with port 0.
    {:ok, service} = Lunchbot.API.start_link(port: 0, cleartext: true)
    {:ok, port} = Ace.HTTP.Service.port(service)

    {:ok, port: port}
  end

  @tag :skip
  test "Serves homepage", %{port: port} do
    assert {:ok, response} = :httpc.request('http://localhost:#{port}')
    assert {{_, 200, 'OK'}, _headers, _body} = response
  end
end
