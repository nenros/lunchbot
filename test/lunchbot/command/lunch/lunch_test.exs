defmodule Lunchbot.Command.Lunch.LunchTest do
  use Lunchbot.RepoCase, async: true

  import Lunchbot.Factory

alias Lunchbot.Command.Lunch.Lunch
  describe "#run/1" do
    test "return {:ok, message} if everything went fine" do
      %{user_id: user_id} = user = insert(:user)
      params = string_params_for(:slack_params, user_id: user_id)


      assert {:ok, %{}} = Lunch.run(params)
    end

    test "return {:ok, message} if user wasn't found" do
      params = string_params_for(:slack_params)

      assert {:ok, %{}} = Lunch.run(params)
    end

  end

  describe "#get_user/1" do
    test "return {:ok, user} if exists" do
      %{user_id: user_id} = insert(:user)

      assert {:ok, user} = Lunch.get_user(user_id)
    end

    test "return {:error, :user_not_found} if not exists" do
      %{user_id: user_id} = build(:user)

      assert {:error, :user_not_found} = Lunch.get_user(user_id)
    end
  end

  describe "#read_date/1" do
    test "return {:ok, today} for text 'today'" do

    end

    test "return {:ok, tomorrow} for text 'tomorrow'" do

    end

    test "return {:ok, today} for empty text" do

    end
  end

end
