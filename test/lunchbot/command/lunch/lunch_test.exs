defmodule Lunchbot.Command.Lunch.LunchTest do
  use Lunchbot.RepoCase

  import Lunchbot.Factory
  import Mox

  alias Lunchbot.Command.Lunch.Lunch

  describe "#run/1" do
    test "return {:ok, message} if everything went fine" do
      session = "session"

      today_date =
        Date.utc_today()
        |> Date.to_iso8601()

      no_lunch_response = [Lunchbot.Lunchroom.Lunch.no_lunches()]

      Lunchbot.LunchroomMock
      |> expect(
        :get_lunch_for_date,
        fn ^session, ^today_date -> {:ok, %{body: ""}} end
      )

      %{user_id: user_id} = user = insert(:user, session_id: session)
      params = string_params_for(:slack_params, user_id: user_id)

      assert {:ok, no_lunch_response} = Lunch.run(params)
    end

    test "return {:ok, message} if user wasn't found" do
      params = string_params_for(:slack_params)

      response = [Lunch.get_error_message(:user_not_found)]

      assert {:ok, response} = Lunch.run(params)
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
      assert {:ok, _date} = Lunch.read_date("today")
    end

    test "return {:ok, tomorrow} for text 'tomorrow'" do
      assert {:ok, _date} = Lunch.read_date("tomorrow")
    end

    test "return {:ok, today} for empty text" do
      assert {:ok, _date} = Lunch.read_date("")
    end

    test "return {:error, :wrong_day} for wrong date" do
      assert {:error, :wrong_day} = Lunch.read_date("unknown day")
    end
  end

  describe "#get_iso_date/2" do
    test "return iso date for today" do
      date = ~D[2019-08-16]

      assert "2019-08-16" = Lunch.get_iso_date(:today, date)
    end

    test "return iso date for tomorrow" do
      date = ~D[2019-08-15]

      assert "2019-08-16" = Lunch.get_iso_date(:next_working_day, date)
    end

    test "return iso date for tomorrow when it is friday" do
      date = ~D[2019-08-16]

      assert "2019-08-19" = Lunch.get_iso_date(:next_working_day, date)
    end

    test "return iso date for tomorrow when it is saturday" do
      date = ~D[2019-08-17]

      assert "2019-08-19" = Lunch.get_iso_date(:next_working_day, date)
    end

    test "return iso date for tomorrow when it is sunday" do
      date = ~D[2019-08-18]

      assert "2019-08-19" = Lunch.get_iso_date(:next_working_day, date)
    end
  end
end
