defmodule Gdex.Payment do
  alias Gdex.Request

  @doc """
  Get a list of the account paymet methods.
  """
  @spec list :: Request.t
  def list do
    Request.new(:GET, "/payment-methods")
  end
end
