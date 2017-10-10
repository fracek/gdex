defmodule Gdex.CoinbaseTest do
  use ExUnit.Case, async: true

  test "list" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/coinbase-accounts",
    }
    assert expected == Gdex.Coinbase.list
  end
end
