defmodule Lunchbot.Webhook.MagiclinkTest do
  use Lunchbot.RepoCase

  alias Lunchbot.Webhook.Magiclink

  @moduletag :capture_log

  doctest Magiclink

  #  test "for wrong magic link reponse with info about that" do
  #    given = %Lunchbot.Webhook{
  #    params: "not magic link",
  #
  #    }
  #  end

  describe "#get_or_create_user" do
    @slack_data %{user_id: "UL5MEDGN7", user_name: "nenros"}

    test "return user from struct if exists" do
      {:ok, user} = Lunchbot.Repo.Users.create_user(@slack_data)
      given = %Lunchbot.Webhook{
        slack_data: @slack_data,
        user: user
      }

      assert {:ok, user} == Magiclink.get_or_create_user(given)
    end

    test "create user if user not exists" do
      given = %Lunchbot.Webhook{
        slack_data: @slack_data,
        user: nil
      }

      assert {:ok, user = %Lunchbot.Repo.Users.User{}} = Magiclink.get_or_create_user(given)
      assert user.user_id == @slack_data.user_id
      assert user.user_name == @slack_data.user_name
    end

  end
end
