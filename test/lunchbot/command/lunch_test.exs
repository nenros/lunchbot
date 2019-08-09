defmodule Lunchbot.Command.LunchTest do
  use Lunchbot.RepoCase, async: true

  import Mox
  import Lunchbot.Factory

  alias Lunchbot.Command.Lunch

  doctest Lunchbot.Command.Lunch

  describe "help message" do
    setup [:set_help_message]

    test "it should run when text is help", %{help_message: help_message} do
      params = %{"response_url" => response_url} = string_params_for(:help_params)

      Lunchbot.SlackMock
      |> expect(
           :send_by_response_url,
           fn ^response_url, ^help_message ->
             {:ok, %{body: "ok"}}
           end
         )

      assert {:ok, :ok} = Lunch.run(params)
    end

    test "it should run when text not known", %{help_message: help_message} do
      params = %{"response_url" => response_url} = string_params_for(:help_params, text: "something not known")

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^help_message -> {:ok, %{body: "ok"}} end)

      assert {:ok, :ok} = Lunch.run(params)
    end
  end

  describe "runs magiclink command" do
    message = Lunchbot.Command.Lunch.Magiclink.response_json()
    params = %{"response_url" => response_url} = string_params_for(:slack_params, text: "magiclink #{build(:magiclink)}")

    Lunchbot.SlackMock
    |> expect(:send_by_response_url, fn ^response_url, ^message -> {:ok, %{body: "ok"}} end)
    Lunchbot.LunchroomMock
    |> expect(
         :get_session_from_magiclink,
         fn _link ->
           {:ok, "session"}
         end
       )

#    assert {:ok, :ok} = Lunch.run(params)
  end

  defp set_help_message(context) do
    {:ok, help_message} = Lunchbot.Command.Lunch.Help.get_message()
    Map.put(context, :help_message, help_message)
  end

end
