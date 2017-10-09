defmodule Gdex.Currency do
  alias Gdex.Request

  @doc """
  Get list of known currencies.
  """
  @spec list :: Request.t
  def list do
    Request.new(:GET, "/currencies")
  end
end
