defmodule Lunchbot.Command.Lunch.MagiclinkTest do
  use Lunchbot.RepoCase, async: true

  import Mox
  import Lunchbot.Factory

  alias Lunchbot.Command.Lunch.Magiclink
  alias Lunchbot.Repo.Users
  alias Lunchbot.Repo.Users.User

  doctest Magiclink

  test "user don't exists" do
    magiclink = build(:magiclink)
    params = string_params_for(
      :slack_params,
      text: "magiclink #{magiclink}"
    )
    <<"https://airhelp.lunchroom.pl", rest::binary>> = magiclink
    session_id = "expected_session_id"

    Lunchbot.LunchroomMock
    |> expect(
         :get_session_from_magiclink,
         fn ^rest ->
           {:ok, session_id}
         end
       )

    response_json = Magiclink.response_json

    assert {:ok, ^response_json} = Magiclink.perform(params)

    assert user = %User{} = Users.find_user_by_user_id(params["user_id"])
    assert user.user_id == params["user_id"]
    assert user.user_name == params["user_name"]
    assert user.magiclink == magiclink
    assert user.session_id == session_id
  end

  test "user exists" do
    magiclink = build(:magiclink)
    %{user_id: user_id, user_name: user_name} = insert(:user)
    response_json = Magiclink.response_json
    params = string_params_for(
      :slack_params,
      user_id: user_id,
      user_name: user_name,
      text: "magiclink #{magiclink}"
    )

    <<"https://airhelp.lunchroom.pl", rest::binary>> = magiclink
    session_id = "expected_session_id"

    Lunchbot.LunchroomMock
    |> expect(
         :get_session_from_magiclink,
         fn ^rest ->
           {:ok, session_id}
         end
       )

    assert {:ok, ^response_json} = Magiclink.perform(params)

    assert user = %User{user_id: ^user_id, user_name: ^user_name} = Users.find_user_by_user_id(params["user_id"])
    assert user.user_id == user_id
    assert user.user_name == user_name
    assert user.magiclink == magiclink
  end

  test "magiclink has wrong format" do
    params = string_params_for(
      :slack_params,
      text: "magiclink notcorrectlink"
    )
    response_json = Magiclink.error_json(:no_magic_link)
    assert {:ok, ^response_json} = Magiclink.perform(params)
  end
  test "magiclink expired"

end
