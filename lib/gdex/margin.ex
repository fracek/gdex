defmodule Gdex.Margin do
  alias Gdex.Request

  @type transfer_type :: :deposit | :withdraw

  @doc """
  Transfer funds between default profile and margin profile.
  """
  @spec transfer(binary, transfer_type, binary, Gdex.amount) :: Request.t
  def transfer(margin_profile_id, type, currency, amount) do
    body = [
      margin_profile_id: margin_profile_id,
      type: type,
      currency: currency,
      amount: amount
    ]
    Request.new(:POST, "/profiles/margin-transfer", body: body)
  end
end
