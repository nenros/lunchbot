defmodule Lunchbot.Lunchroom.SessionTest do
  use ExUnit.Case

  alias Lunchbot.Lunchroom.Session

  doctest Session

  describe "read_session_id/1" do

  end

  describe "check_required_data/1" do
    test "returns {:ok, session} if it contains all needed cookies" do
      cookie = "O2L=bartosz.markowski%40airhelp.com; O2P=df32ba5195jfhdfc9e611a64bjjfhgj;"
      assert {:ok, cookie} = Session.check_required_data(cookie)
    end

    test "returns {:error, } if header is missin" do
      cookies = ["test", "O2L=bartosz.markowski%40airhelp.com;", "O2P=df32ba5195jfhdfc9e611a64bjjfhgj;", "other=test"]

      Enum.each(cookies, fn cookie -> assert {:error, :session_not_correct} = Session.check_required_data(cookie) end)
    end
  end

  describe "session_header_reducer/2" do
    test "add header value if it is `Set-Cookie` header" do
      header = {
        "Set-Cookie",
        "O2L=test.test%40airhelp.com; expires=Sun, 14-Jun-2020 21:33:11 GMT; Max-Age=25920000; path=/"
      }

      assert "O2L=test.test%40airhelp.com; " = Session.session_header_reducer(header, "")
    end

    test "don't add value for other headers" do
      headers = [
        {"Date", "Mon, 19 Aug 2019 21:33:11 GMT"},
        {"Server", "Apache/2.4.6 (CentOS) OpenSSL/1.0.2k-fips"},
        {"X-Powered-By", "PHP/5.6.40"},
        {"Expires", "Thu, 19 Nov 1981 08:52:00 GMT"},
        {
          "Cache-Control",
          "no-store, no-cache, must-revalidate, post-check=0, pre-check=0"
        },
        {"Pragma", "no-cache"},
        {"Transfer-Encoding", "chunked"},
        {"Content-Type", "text/html; charset=UTF-8"}
      ]
      Enum.each(headers, fn header -> assert "" = Session.session_header_reducer(header, "") end)
    end

  end
end
