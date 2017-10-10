defmodule Gdex.MarginTest do
  use ExUnit.Case, async: true

  test "transfer" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/profiles/margin-transfer",
      body: Poison.encode!(%{margin_profile_id: "a1b2c3d4", type: :deposit, currency: "USD", amount: "123.4"}),
    }
    assert expected == Gdex.Margin.transfer("a1b2c3d4", :deposit, "USD", "123.4")
  end
end
