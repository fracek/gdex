defmodule Gdex.PositionTest do
  use ExUnit.Case, async: true

  test "get" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/position",
    }
    assert expected == Gdex.Position.get
  end

  test "close" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/position/close",
      body: Poison.encode!(%{repay_only: false})
    }
    assert expected == Gdex.Position.close(false)
  end
end
