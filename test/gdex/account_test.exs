defmodule Gdex.AccountTest do
  use ExUnit.Case, async: true

  test "list" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/accounts",
    }
    assert expected == Gdex.Account.list
  end

  test "get" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/accounts/a1b2c3d4",
    }
    assert expected == Gdex.Account.get("a1b2c3d4")
  end

  test "history" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/accounts/a1b2c3d4/ledger",
      paginated: true,
    }
    assert expected == Gdex.Account.history("a1b2c3d4")
  end

  test "holds" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/accounts/a1b2c3d4/holds",
      paginated: true,
    }
    assert expected == Gdex.Account.holds("a1b2c3d4")
  end

  test "volume" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/users/self/trailing-volume",
    }
    assert expected == Gdex.Account.volume
  end
end
