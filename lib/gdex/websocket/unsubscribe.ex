defmodule Gdex.Websocket.Unsubscribe do
  alias Gdex.Websocket.Client
  import Gdex.Websocket, only: [is_channel: 1]

  def unsubscribe(gdax, channels, product_ids \\ []) do
    do_unsubscribe(gdax, channels, product_ids)
  end

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
