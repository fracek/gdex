defmodule Gdex.Funding do
  alias Gdex.Request

  def list(status) do
    Request.new(:GET, "/funding")
  end

  def repay(amount, currency), do: :ok
end
