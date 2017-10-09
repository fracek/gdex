defmodule Gdex.Coinbase do
  alias Gdex.Request

  @doc """
  Get a list of coinbase accounts.
  """
  @spec list :: Request.t
  def list do
    Request.new(:GET, "/coinbase-accounts")
  end
end
