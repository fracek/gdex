defmodule Gdex.Funding do
  alias Gdex.Request

  @type status_filter :: :outstanding | :settled | :rejected

  @doc """
  List every order placed with a margin profile that draws funding.

  Can be streamed.
  """
  @spec list :: Request.t
  def list do
    Request.new(:GET, "/funding", paginated: true)
  end

  @doc """
  List every order placed with a margin profile that draws funding, filter by status.

  Can be streamed.
  """
  @spec list(status_filter) :: Request.t
  def list(status) do
    Request.new(:GET, "/funding", params: [status: status], paginated: true)
  end

  @doc """
  Repay funding.
  """
  @spec repay(Gdex.amount, binary) :: Request.t
  def repay(amount, currency) do
    body = [amount: amount, currency: currency]
    Request.new(:POST, "/funding/repay", body: body)
  end
end
