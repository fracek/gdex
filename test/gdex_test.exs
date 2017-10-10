defmodule GdexTest do
  use ExUnit.Case
  import Mock

  test "request should delegate to Request.request" do
    request = Gdex.Account.list
    with_mock Gdex.Request, [request: fn(_, _) -> nil end] do
      Gdex.request(request)
      assert called Gdex.Request.request(request, :_)
    end
  end

  test "request! returns just the response" do
    request = Gdex.Account.list
    with_mock Gdex.Request, [request: fn(_, _) -> {:ok, "body"} end] do
      assert "body" == Gdex.request!(request)
    end
  end

  test "request! should raise on error" do
    request = Gdex.Account.list
    assert_raise Gdex.Error, fn ->
      with_mock Gdex.Request, [request: fn(_, _) -> {:error, "test"} end] do
	Gdex.request!(request)
      end
    end
  end

  test "stream! should delegate to Request.steam!" do
    request = Gdex.Market.trades("BTC-USD")
    with_mock Gdex.Request, [stream!: fn(_, _) -> [] end] do
      Gdex.stream!(request)
      assert called Gdex.Request.stream!(request, :_)
    end
  end
end
