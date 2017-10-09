defmodule Gdex.Deposit do
  alias Gdex.Request


  @doc """
  Deposit funds from a payment method.

  Use `Gdex.Payment.list/0` to retrieve a list of your payment methods.mk
  """
  @spec from_payment_method(binary, Gdex.amount, binary) :: Request.t
  def from_payment_method(payment_method_id, amount, currency) do
    body = [
      amount: amount,
      currency: currency,
      payment_method_id: payment_method_id,
    ]
    Request.new(:POST, "/deposits/payment-method", body: body)
  end

  @doc """
  Deposit funds from a Coinbase account.
  """
  @spec from_coinbase(binary, Gdex.amount, binary) :: Request.t
  def from_coinbase(coinbase_account_id, amount, currency) do
    body = [
      amount: amount,
      currency: currency,
      coinbase_account_id: coinbase_account_id,
    ]
    Request.new(:POST, "/deposits/coinbase-account", body: body)
  end
end
