defmodule Gdex.Websocket.UnsubscribeTest do
  use ExUnit.Case, async: false
  import Mock
  import TestHelper
  alias Gdex.Websocket.Unsubscribe
  alias Gdex.Websocket.State
  alias Gdex.Config
  use ExUnit.Case, async: false

  setup do
    gdax = State.new(self(), Config.new(), TestHelper.MockWebsocketClient)
    %{gdax: gdax}
  end

  test "unsubscribe from single channel and product_id", %{gdax: gdax} do
    with_send_request(%{"type" => "unsubscribe",
			"product_ids" => ["BTC-USD"],
                	 "channels" => [_]}) do
      Unsubscribe.unsubscribe(gdax, :heartbeat, "BTC-USD")
    end
  end


  test "unsubscribe from all channel products", %{gdax: gdax} do
    with_send_request(%{"type" => "unsubscribe",
                	 "channels" => [_]}) do
      Unsubscribe.unsubscribe(gdax, :heartbeat)
    end
  end
end
