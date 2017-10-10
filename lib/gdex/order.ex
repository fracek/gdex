defmodule Gdex.Order do
  alias Gdex.Request

  @type order_side :: :buy | :sell
  @type order_type :: :limit | :market | :stop
  @type self_trade_prevention :: :dc | :decrease_and_cancel
    | :co | :cancel_oldest
    | :cn | :cancel_newest
    | :cb | :cancel_both
  @type time_in_force :: :gtc | :good_till_canceled
    | :gtt | :good_till_time
    | :ioc | :immediate_or_cancel
    | :fok | :fill_or_kill
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
      |> encode_time_in_force
      |> encode_self_trade_prevention
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

  defp encode_time_in_force(body) do
    if Keyword.has_key?(body, :time_in_force) do
      time_in_force_to_string = fn
	:good_till_canceled -> {nil, "GTC"}
	:good_till_time -> {nil, "GTT"}
	:immediate_or_cancel -> {nil, "IOC"}
	:fill_or_kill -> {nil, "FOK"}
	a -> {nil, a |> Atom.to_string |> String.upcase}
      end
      {_, new_body} = Keyword.get_and_update(body, :time_in_force, time_in_force_to_string)
      new_body
    else
      body
    end
  end

  defp encode_self_trade_prevention(body) do
    body = case Keyword.pop(body, :self_trade_prevention) do
      {nil, body} ->
	body
      {value, body} ->
	Keyword.put_new(body, :stp, value)
    end

    if Keyword.has_key?(body, :stp) do
      replace_stp = fn
        :decrease_and_cancel -> {nil, :dc}
	:cancel_oldest -> {nil, :co}
	:cancel_newest -> {nil, :cn}
	:cancel_both -> {nil, :cb}
	a -> {nil, a}
      end
      {_, new_body} = Keyword.get_and_update(body, :stp, replace_stp)
      new_body
    else
      body
    end
  end
end
