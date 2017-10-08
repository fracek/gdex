defmodule Gdex.Account do
  alias Gdex.Request

  @doc """
  Get a list of trading accounts.
  """
  def list do
    Request.new(:GET, "/accounts")
  end

  @doc """
  Get information for the account with the specified `id`.
  """
  def get(id) do
    Request.new(:GET, "/accounts/#{id}")
  end

  @doc """
  Get the account `id` activity.

  Can be streamed.
  """
  def history(id) do
    Request.new(:GET, "/accounts/#{id}/ledger", paginated: true)
  end

  @doc """
  Get the account `id` holds.

  Can be streamed.
  """
  def holds(id) do
    Request.new(:GET, "/accounts/#{id}/holds", paginated: true)
  end
end
