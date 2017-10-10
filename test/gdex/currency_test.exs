defmodule Gdex.CurrencyTest do
  use ExUnit.Case, async: true

  test "list" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/currencies",
    }
    assert expected == Gdex.Currency.list
  end
end
