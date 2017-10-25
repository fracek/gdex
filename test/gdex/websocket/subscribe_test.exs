defmodule Gdex.Websocket.SubscribeTest do
  use ExUnit.Case, async: false
  import Mock
  import TestHelper
  alias Gdex.Websocket.Subscribe
  alias Gdex.Websocket.State
  alias Gdex.Config

  @secret "v25UWRskcjCkgzc+TbITV/iXtOwLXNXa82KYFM12QaSRzsq0bCyGDX84Z/GSCBJkDyuM/gYgSMAT566rnMJ5dw=="

  setup do
    gdax = State.new(self(), Config.new(), TestHelper.MockWebsocketClient)
    %{gdax: gdax}
  end

  test "subscribe to channel and product_id", %{gdax: gdax} do
    with_send_request(%{"type" => "subscribe",
			"product_ids" => ["BTC-USD"],
                	 "channels" => [_]}) do
      Subscribe.subscribe(gdax, :heartbeat, "BTC-USD")
    end
  end

  test "authenticated subscribe", %{gdax: gdax} do
    with_send_request(%{"type" => "subscribe",
			"product_ids" => [_],
			"channels" => [_],
			"signature" => _,
			"key" => _,
			"passphrase" => _,
			"timestamp" => _}) do
      opts = [
	authenticate: true,
	config: Config.new(
	  api_key: "a1b2c3d4",
	  api_secret: @secret,
	  api_passphrase: "passphrase"
	)
      ]
      Subscribe.subscribe(gdax, :heartbeat, "BTC-USD", opts)
    end
  end
end
