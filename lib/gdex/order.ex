defmodule Gdex.Order do
  alias Gdex.Request

  @type order_side :: :buy | :sell
  @type order_type :: :limit | :market | :stop
  @type self_trade_prevention :: :dc | :co | :cn | :cb
  @type time_in_force :: :gtc | :gtt | :ioc | :fok
  @type cancel_after :: :min | :hour | :day

  @type order_opt :: {:client_oid, binary}
    | {:type, order_type}
    | {:stp, self_trade_prevention}
    | {:price, Gdex.amount}
    | {:size, Gdex.amount}
    | {:time_in_force, time_in_force}
    | {:cancel_after, cancel_after}
    | {:post_only, boolean}
    | {:funds, Gdex.amount}

  @type order_status :: :open | :pending | :active
  @type list_opt :: {:status, order_status} | {:product_id, binary}

  @doc """
  Place order on the exchange.
  """
  @spec place(binary, order_side, [order_opt]) :: Request.t
  def place(product_id, side, opts \\ []) do
    body =
      [product_id: product_id, side: side]
      |> Keyword.merge(opts)
    Request.new(:POST, "/orders", body: body)
  end

  @doc """
  Cancell all open orders.
  """
  @spec cancel(binary | :all) :: Request.t
  def cancel(:all) do
    Request.new(:DELETE, "/orders")
  end

  @doc """
  Cancel a previously placed order.
  """
  def cancel(id) do
    Request.new(:DELETE, "/orders/#{id}")
  end

  @doc """
  List the currently open orders.

  Can be streamed.
  """
  @spec list([list_opt]) :: Request.t
  def list(opts \\ []) do
    Request.new(:GET, "/orders", params: opts, paginated: true)
  end

  @doc """
  Get a single order by `id`.
  """
  @spec get(binary) :: Request.t
  def get(id) do
    Request.new(:GET, "/orders/#{id}")
  end
end
