defmodule Gdex.Withdraw do
  alias Gdex.Request

  @doc """
  Withdraw funds to a payment method.

  Use `Gdex.Payment.list/0` to retrieve a list of your payment methods.
  """
  @spec to_payment_method(binary, Gdex.amount, binary) :: Request.t
  def to_payment_method(payment_method_id, amount, currency) do
    body = [
      amount: amount,
      currency: currency,
      payment_method_id: payment_method_id,
    ]
    Request.new(:POST, "/withdrawals/payment-method", body: body)
  end

  @doc """
  Withdraw funds to a Coinbase account.
  """
  @spec to_coinbase(binary, Gdex.amount, binary) :: Request.t
  def to_coinbase(coinbase_account_id, amount, currency) do
    body = [
      amount: amount,
      currency: currency,
      coinbase_account_id: coinbase_account_id,
    ]
    Request.new(:POST, "/withdrawals/coinbase-account", body: body)
  end

end
