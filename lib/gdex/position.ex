defmodule Gdex.Position do
  alias Gdex.Request

  @doc """
  An overview of your profile.
  """
  @spec get :: Request.t
  def get do
    Request.new(:GET, "/position")
  end

  @doc """
  Close position.
  """
  @spec close(boolean) :: Request.t
  def close(repay_only) do
    Request.new(:POST, "/position/close", body: [repay_only: repay_only])
  end
end
