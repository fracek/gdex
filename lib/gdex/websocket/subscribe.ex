defmodule Gdex.Websocket.Subscribe do
  alias Gdex.Websocket.Client
  alias Gdex.Auth
  import Gdex.Websocket, only: [is_channel: 1]

  @default_opts [authenticate: false]

  @auth_method "GET"
  @auth_path "/users/self/verify"
  @auth_body ""

  def subscribe(gdax, channels, product_ids, opts \\ []) do
    do_subscribe(gdax, channels, product_ids, opts)
  end

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
