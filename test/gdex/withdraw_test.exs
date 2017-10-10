defmodule Gdex.WithdrawTest do
  use ExUnit.Case, async: true

  test "to payment method" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/withdrawals/payment-method",
      body: Poison.encode!(%{amount: "10.0", currency: "USD", payment_method_id: "a1b2c3d4"})
    }
    assert expected == Gdex.Withdraw.to_payment_method("a1b2c3d4", "10.0", "USD")
  end

  test "to coinbase" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/withdrawals/coinbase",
      body: Poison.encode!(%{amount: "10.0", currency: "USD", coinbase_account_id: "a1b2c3d4"})
    }
    assert expected == Gdex.Withdraw.to_coinbase("a1b2c3d4", "10.0", "USD")
  end
end
