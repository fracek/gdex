defmodule Gdex.Websocket.Unsubscribe do
  @moduledoc "Functions to send unsubscribe messages to GDAX."

  alias Gdex.Websocket.Client
  import Gdex.Websocket, only: [is_channel: 1]

  @type channels :: Gdex.Websocket.channel | [Gdex.Websocket.channel]
  @type product_ids :: binary | [binary]

  @doc """
  Unsubscribe from `channels` for the given `product_ids`.

  If `products_ids` is empty, unsubscribe from `channels` for all subscribed
  products.
  """
  @spec unsubscribe(Gdex.Websocket.State.t, channels, product_ids) :: :ok
  def unsubscribe(gdax, channels, product_ids \\ []) do
    do_unsubscribe(gdax, channels, product_ids)
  end

  @doc """
  Send the `request` to `gdax`.
  """
  @spec unsubscribe_raw(Gdex.Websocket.State.t, Map.t) :: :ok
  def unsubscribe_raw(gdax, request) do
    Client.send_request(gdax, request)
  end

  # Private stuff

  defp do_unsubscribe(gdax, channels, product_id) when is_binary(product_id) do
    do_unsubscribe(gdax, channels, [product_id])
  end

  defp do_unsubscribe(gdax, channel, product_ids) when is_channel(channel) do
    do_unsubscribe(gdax, [channel], product_ids)
  end

  defp do_unsubscribe(gdax, channels, product_ids)
  when is_list(channels) and is_list(product_ids) do
    request = %{
      "type" => "unsubscribe",
      "channels" => channels,
    }
    request = if length(product_ids) > 0 do
      Map.put(request, "product_ids", product_ids)
    else
      request
    end
    unsubscribe_raw(gdax, request)
  end
end
