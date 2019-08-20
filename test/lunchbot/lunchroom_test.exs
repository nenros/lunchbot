defmodule Lunchbot.LunchroomTest do
  use ExUnit.Case

  alias Lunchbot.Lunchroom

  @moduletag :capture_log

  doctest Lunchroom

  describe "#get_session_from_magiclink/1" do
    test "return {:ok, session_id} if magiclink is correct"
    test "return {:error, :magiclink_wrong} if magiclink isn't correct"
    test "return {:error, :connection_error} if magiclink isn't correct"
  end

  describe "#get_lunch_for_date/2" do
    test "return {:error, :needs_revalidate} if session is wrong"
    test "return {:ok, lunches, headers} with lunches if everything is correct if list"
    test "return {:ok, lunches, headers} with empty list of lunches if user didn't choose"
    test "return {:error, :connection_error} if connection had error"
  end
end
