defmodule Gdex.Time do
  alias Gdex.Request

  @doc """
  Get the API server time.
  """
  @spec get :: Request.t
  def get do
    Request.new(:GET, "/time")
  end
end
