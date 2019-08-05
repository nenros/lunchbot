defmodule Lunchbot.Command.LunchTest do
  use Lunchbot.RepoCase, async: true

  import Mox
  import Lunchbot.Factory

  alias Lunchbot.Command.Lunch
  alias Lunchbot.Repo.Users.User

  @moduletag :capture_log

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

  describe "magiclink message" do
    test "user don't exists" do
      magiclink = build(:magiclink)
      params = %{"response_url" => response_url} = string_params_for(
        :slack_params,
        text: "magiclink #{magiclink}"
      )
      response_json = Lunchbot.Command.Lunch.Magiclink.response_json

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^response_json -> {:ok, %{body: "ok"}} end)

      assert {:ok, :ok} = Lunch.run(params)
      assert user = %User{} = Lunchbot.Repo.Users.find_user_by_user_id(params["user_id"])
      assert user.user_id == params["user_id"]
      assert user.user_name == params["user_name"]
      assert user.magiclink == magiclink
    end

    test "user exists" do
      magiclink = build(:magiclink)
      %{user_id: user_id, user_name: user_name} = user = insert(:user)
      response_json = Lunchbot.Command.Lunch.Magiclink.response_json
      params = %{"response_url" => response_url} =  string_params_for(
        :slack_params,
        user_id: user_id,
        user_name: user_name,
        text: "magiclink #{magiclink}"
      )

      Lunchbot.SlackMock
      |> expect(:send_by_response_url, fn ^response_url, ^response_json -> {:ok, %{body: "ok"}} end)

      assert {:ok, :ok} = Lunch.run(params)

      assert user = %User{user_id: user_id, user_name: user_name} = Lunchbot.Repo.Users.find_user_by_user_id(params["user_id"])
      assert user.user_id == params["user_id"]
      assert user.user_name == params["user_name"]
      assert user.magiclink == magiclink
    end

    test "magiclink has wrong format"
    test "magiclink expired"

  end

  defp set_help_message(context) do
    {:ok, help_message} = Lunchbot.Command.Lunch.Help.get_message()
    Map.put(context, :help_message, help_message)
  end

end
