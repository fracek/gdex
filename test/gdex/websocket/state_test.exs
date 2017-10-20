defmodule Gdex.Websocket.StateTest do
  use ExUnit.Case
  alias Gdex.Websocket.State
  alias Gdex.Config

  setup do
    state = State.new(self(), Config.new())
    %{state: state}
  end

  test "update subscriptions", %{state: state} do
    message = %{
      "type" => "subscriptions",
      "channels" => [
	%{"name" => "heartbeat",
	  "product_ids" => ["BTC-USD", "BTC-EUR"]},
	%{"name" => "full",
	  "product_ids" => ["BTC-USD", "ETH-BTC"]},
      ]
    }
    new_state = State.update(state, message)
    expected_channels = %{
      heartbeat: ["BTC-USD", "BTC-EUR"],
      full: ["BTC-USD", "ETH-BTC"],
    }
    assert expected_channels == new_state.channels

    message = %{
      "type" => "subscriptions",
      "channels" => [],
    }
    final_state = State.update(new_state, message)
    assert %{} == final_state.channels
  end

  test "update ignored message", %{state: state} do
    message = %{"type" => "ignored"}
    new_state = State.update(state, message)
    assert new_state == state
  end

  test "Access behaviour", %{state: state} do
    assert :error = Access.fetch(state, :foo)
  end
end
