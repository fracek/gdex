defmodule Gdex.DepositTest do
  use ExUnit.Case, async: true

  test "from_payment_method" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/deposits/payment-method",
      body: Poison.encode!(%{amount: "123.4", currency: "USD", payment_method_id: "a1b2c3d4"}),
    }
    assert expected == Gdex.Deposit.from_payment_method("a1b2c3d4", "123.4", "USD")
  end

  test "from_coinbase" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/deposits/coinbase-account",
      body: Poison.encode!(%{amount: "123.4", currency: "USD", coinbase_account_id: "a1b2c3d4"}),
    }
    assert expected == Gdex.Deposit.from_coinbase("a1b2c3d4", "123.4", "USD")
  end
end
