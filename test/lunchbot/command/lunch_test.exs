defmodule Lunchbot.Command.LunchTest do
  use Lunchbot.RepoCase, async: true

  import Mox
  import Lunchbot.Factory

  alias Lunchbot.Command.Lunch

  doctest Lunchbot.Command.Lunch

  describe "help message" do
    test "it should run when text is help" do
      params = %{"response_url" => response_url} = string_params_for(:help_params)
      {:ok, message} = Lunchbot.Command.Lunch.Help.run(params)

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^message -> {:ok, %{body: "ok"}} end)

      assert {:ok, :ok} = Lunch.run(params)
    end

    test "it should run when text not known" do
      params =
        %{"response_url" => response_url} =
        string_params_for(:help_params, text: "something not known")

      {:ok, message} = Lunchbot.Command.Lunch.Help.run(params)

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^message -> {:ok, %{body: "ok"}} end)

      assert {:ok, :ok} = Lunch.run(params)
    end
  end

  describe "runs magiclink command" do
    test "it should run correctly" do
      message = [Lunchbot.Command.Lunch.Magiclink.response_json()]

      params =
        %{"response_url" => response_url} =
        string_params_for(:slack_params, text: "magiclink #{build(:magiclink)}")

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^message -> {:ok, %{body: "ok"}} end)

      Lunchbot.LunchroomMock
      |> expect(
        :get_session_from_magiclink,
        fn _link ->
          {:ok, "session"}
        end
      )

      assert {:ok, :ok} = Lunch.run(params)
    end
  end

  describe "runs lunch command" do
    test "it should run correctly" do
      session_id = "session_id"
      user = insert(:user, session_id: session_id)

      params =
        %{"response_url" => response_url} =
        string_params_for(:slack_params, text: "today", user_id: user.user_id)

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, message -> {:ok, %{body: "ok"}} end)

      Lunchbot.LunchroomMock
      |> expect(
        :get_lunch_for_date,
        fn ^session_id, date ->
          {:ok, %{body: "", headers: []}}
        end
      )

      assert {:ok, :ok} = Lunch.run(params)
    end
  end
end
