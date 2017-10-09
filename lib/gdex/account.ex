defmodule Gdex.Account do
  alias Gdex.Request

  @doc """
  Get a list of trading accounts.
  """
  @spec list :: Request.t
  def list do
    Request.new(:GET, "/accounts")
  end

  @doc """
  Get information for the account with the specified `id`.
  """
  @spec get(binary) :: Request.t
  def get(id) do
    Request.new(:GET, "/accounts/#{id}")
  end

  @doc """
  Get the account `id` activity.

  Can be streamed.
  """
  @spec history(binary) :: Request.t
  def history(id) do
    Request.new(:GET, "/accounts/#{id}/ledger", paginated: true)
  end

  @doc """
  Get the account `id` holds.

  Can be streamed.
  """
  @spec holds(binary) :: Request.t
  def holds(id) do
    Request.new(:GET, "/accounts/#{id}/holds", paginated: true)
  end

  @doc """
  Get the 30-day trailing volume for all products.
  """
  @spec volume :: Request.t
  def volume do
    Request.new(:GET, "/users/self/trailing-volume")
  end
end
