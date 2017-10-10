defmodule Gdex.TimeTest do
  use ExUnit.Case, async: true

  test "get" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/time",
    }
    assert expected == Gdex.Time.get
  end
end
