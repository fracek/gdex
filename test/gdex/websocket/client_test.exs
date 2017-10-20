defmodule Gdex.Websocket.ClientTest do
  use ExUnit.Case, async: false
  alias Gdex.Config
  alias Gdex.Websocket.State

  defmodule MyHandler do
    use Gdex.Websocket

    def handle_connect(_gdax, state) do
      send self(), :handle_connect_called
      {:ok, state}
    end

    def handle_disconnect(reason, _gdax, state) do
      send self(), {:handle_disconnect_called, reason}
      {:ok, state}
    end

    def handle_info(message, _gdax, state) do
      send self(), {:handle_info_called, message}
      {:ok, state}
    end

    def handle_message(_message, _gdax, state) do
      send self(), :handle_message_called
      {:ok, state}
    end
  end

  defmodule MyReconnectHandler do
    use Gdex.Websocket

    def handle_disconnect(reason, _gdax, state) do
      send self(), {:handle_disconnect_called, reason}
      {:reconnect, state}
    end
  end

  defmodule MyReconnectWithIntervalHandler do
    use Gdex.Websocket

    def handle_disconnect(reason, _gdax, state) do
      send self(), {:handle_disconnect_called, reason}
      {:reconnect, 5_000, state}
    end
  end

  defmodule MyCloseHandler do
    use Gdex.Websocket

    def handle_disconnect(reason, _gdax, state) do
      send self(), {:handle_disconnect_called, reason}
      {:close, reason, state}
    end
  end

  setup do
    state = %{
      gdax: State.new(self(), Config.new()),
      handler: MyHandler,
      handler_state: :initial_state,
    }
    %{state: state}
  end

  test "send request to websocket" do
    Gdex.Websocket.Client.send_request(%{pid: self()}, %{"test" => "abc"})
    assert_received _
  end

  test "call handler callback on connect", %{state: state} do
    {:ok, _} = Gdex.Websocket.Client.onconnect(nil, state)
    assert_received :handle_connect_called
  end

  test "call handler callback on disconnect", %{state: state} do
    {:ok, _} = Gdex.Websocket.Client.ondisconnect(:reason, state)
    assert_received {:handle_disconnect_called, :reason}
  end

  test "handler can reconnect on disconnect", %{state: state} do
    state = %{state | handler: MyReconnectHandler}
    {:reconnect, _} = Gdex.Websocket.Client.ondisconnect(:reason, state)
    assert_received {:handle_disconnect_called, :reason}
  end

  test "handler can reconnect with interval on disconnect", %{state: state} do
    state = %{state | handler: MyReconnectWithIntervalHandler}
    {:reconnect, 5_000, _} = Gdex.Websocket.Client.ondisconnect(:reason, state)
    assert_received {:handle_disconnect_called, :reason}
  end

  test "handler can close on disconnect", %{state: state} do
    state = %{state | handler: MyCloseHandler}
    {:close, :reason,  _} = Gdex.Websocket.Client.ondisconnect(:reason, state)
    assert_received {:handle_disconnect_called, :reason}
  end

  test "call handler callback on info", %{state: state} do
    {:ok, _} = Gdex.Websocket.Client.websocket_info(:message, nil, state)
    assert_received {:handle_info_called, :message}
  end

  test "update gdax state when receiving message", %{state: state} do
    message = ~s({"type": "subscriptions", "channels": [{"name": "level2", "product_ids": ["BTC-USD"]}]})
    {:ok, %{gdax: new_gdax}} = Gdex.Websocket.Client.websocket_handle({:text, message}, nil, state)
    assert_received :handle_message_called
    assert new_gdax[:channels] == %{level2: ["BTC-USD"]}
  end
end
