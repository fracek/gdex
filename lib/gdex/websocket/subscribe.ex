defmodule Gdex.Websocket.Subscribe do
  @moduledoc "Functions to send subscribe messages to GDAX."

  alias Gdex.Websocket.Client
  alias Gdex.Auth
  import Gdex.Websocket, only: [is_channel: 1]

  @type channels :: Gdex.Websocket.channel | [Gdex.Websocket.channel]
  @type product_ids :: binary | [binary]
  @type subscribe_opt :: {:authenticate, boolean}

  @default_opts [authenticate: false]

  @auth_method "GET"
  @auth_path "/users/self/verify"
  @auth_body ""

  @doc """
  Subscribe to `channels` for the given `product_ids`.

  ## Options

  * `:authenticate` - wheter to send an authenticated subscribe message or not.
  """
  @spec subscribe(Gdex.Websocket.State.t, channels, product_ids, [subscribe_opt]) :: :ok
  def subscribe(gdax, channels, product_ids, opts \\ []) do
    do_subscribe(gdax, channels, product_ids, opts)
  end

  @doc """
  Send the `request` to `gdax`. Use this if you want more control on channels and products

  ## Options

  Same as `subscribe/4`.

  ## Examples

      subscribe_raw(gdax, %{
        type: "subscribe",
        product_ids: ["ETH-USD", "ETH-EUR"],
        channels: [
          "level2",
          "heartbeat",
          %{name: "ticker", product_ids: ["ETH-BTC", "ETH-GBP"]}
        ]
      })

  ## See Also

  Check the official [GDAX API Documentation](https://docs.gdax.com/#subscribe) for
  the correct request format.
  """
  @spec subscribe_raw(Gdex.Websocket.State.t, Map.t, [subscribe_opt]) :: :ok
  def subscribe_raw(gdax, request, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)
    request = if opts[:authenticate] do
      {:ok, auth} = Auth.auth_map(
	gdax[:config], @auth_method, @auth_path, @auth_body
      )
      Map.merge(request, auth)
    else
      request
    end
    Client.send_request(gdax, request)
  end

  # Private stuff

  defp do_subscribe(gdax, channels, product_id, opts) when is_binary(product_id) do
    do_subscribe(gdax, channels, [product_id], opts)
  end

  defp do_subscribe(gdax, channel, product_ids, opts) when is_channel(channel) do
    do_subscribe(gdax, [channel], product_ids, opts)
  end

  defp do_subscribe(gdax, channels, product_ids, opts)
  when is_list(product_ids) and is_list(channels) do
    request = %{
      "type" => "subscribe",
      "product_ids" => product_ids,
      "channels" => channels,
    }
    subscribe_raw(gdax, request, opts)
  end
end
