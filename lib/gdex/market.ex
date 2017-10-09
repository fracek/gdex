defmodule Gdex.Market do
  alias Gdex.Request

  @type orderbook_level :: 1 | 2 | 3

  @doc """
  Get a list of available currency pairs for trading.
  """
  @spec products :: Request.t
  def products do
    Request.new(:GET, "/products")
  end

  @doc """
  Get a list of open orders for a product.
  """
  @spec orderbook(binary, orderbook_level) :: Request.t
  def orderbook(product_id, level) do
    Request.new(:GET, "/products/#{product_id}/book", params: [level: level])
  end

  @doc """
  Get the last tick.
  """
  @spec ticker(binary) :: Request.t
  def ticker(product_id) do
    Request.new(:GET, "/products/#{product_id}/ticker")
  end

  @doc """
  List the latest trades for `product_id`.

  Can be streamed.
  """
  @spec trades(binary) :: Request.t
  def trades(product_id) do
    Request.new(:GET, "/products/#{product_id}/trades", paginated: true)
  end

  @doc """
  Get historic rates for `product_id`.
  """
  @spec historic_rates(binary, DateTime.t, DateTime.t, integer) :: Request.t
  def historic_rates(product_id, start_datetime, end_datetime, granularity) do
    params = [
      start: DateTime.to_iso8601(start_datetime),
      end: DateTime.to_iso8601(end_datetime),
      granularity: granularity,
    ]
    Request.new(:GET, "/products/#{product_id}/candles", params: params)
  end

  @doc """
  Get 24h stats for `product_id`.
  """
  @spec stats(binary) :: Request.t
  def stats(product_id) do
    Request.new(:GET, "/products/#{product_id}/stats")
  end
end
