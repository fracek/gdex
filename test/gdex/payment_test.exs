defmodule Gdex.PaymentTest do
  use ExUnit.Case, async: true

  test "list" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/payment-methods",
    }
    assert expected == Gdex.Payment.list
  end
end
