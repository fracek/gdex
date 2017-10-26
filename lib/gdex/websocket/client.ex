defmodule Gdex.Websocket.Client do
  @moduledoc ~S"""
  This module handles the connection to the GDAX Websocket endpoint, while
  delegating events to the specified websocket handler.
  """

  alias Gdex.Config
  alias Gdex.Websocket.State

  @behaviour :websocket_client

  @default_opts [keepalive: 10_000, websocket_client: :websocket_client]

  @doc """
  Connect to GDAX and delegate event handling to `message_handler`.

  ## Options

  * `:config` - the config to use, see `Gdex.Config`

  ## Examples

      defmodule MyHandler do
        use Gdex.Websocket
      end

      {:ok, pid} = Gdex.Websocket.Client.start_link(MyHandler, [])
  """
  @spec start_link(any, any, Keyword.t) :: any
  def start_link(message_handler, initial_state, opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)

    config = Keyword.get(opts, :config, []) |> Config.new

    state = %{
      handler: message_handler,
      handler_state: initial_state,
      config: config,
      websocket_client: opts[:websocket_client],
    }
    state.websocket_client.start_link(config[:websocket_url], __MODULE__, [state], keeyalive: opts[:keepalive])
  end

  @doc """
  Send json request to gdax.
  """
  @spec send_request(Gdex.Websocket.State.t, Map.t) :: :ok
  def send_request(%{pid: pid, websocket_client: client} = _gdax, request) do
    message = Poison.encode!(request)
    client.cast(pid, {:text, message})
  end

  # Callbacks

  @doc false
  def init([%{handler: handler, handler_state: handler_state, config: config, websocket_client: websocket_client}]) do
    gdax = State.new(self(), config, websocket_client)
    {:reconnect, %{gdax: gdax, handler: handler, handler_state: handler_state}}
  end

  @doc false
  def onconnect(_req, %{gdax: gdax, handler: handler, handler_state: handler_state} = state) do
    {:ok, new_handler_state} = handler.handle_connect(gdax, handler_state)
    {:ok, %{state | handler_state: new_handler_state}}
  end

  @doc false
  def ondisconnect(reason, %{gdax: gdax, handler: handler, handler_state: handler_state} = state) do
    case handler.handle_disconnect(reason, gdax, handler_state) do
      {:ok, new_handler_state} ->
	{:ok, %{state | handler_state: new_handler_state}}
      {:reconnect, new_handler_state} ->
	{:reconnect, %{state | handler_state: new_handler_state}}
      {:reconnect, interval, new_handler_state} ->
	{:reconnect, interval, %{state | handler_state: new_handler_state}}
      {:close, reason, new_handler_state} ->
	{:close, reason, %{state | handler_state: new_handler_state}}
    end
  end

  @doc false
  def websocket_info(message, _conn, %{gdax: gdax, handler: handler, handler_state: handler_state} = state) do
    {:ok, new_handler_state} = handler.handle_info(message, gdax, handler_state)
    {:ok, %{state | handler_state: new_handler_state}}
  end

  @doc false
  def websocket_terminate(_reason, _conn, _state), do: :ok

  @doc false
  def websocket_handle({:text, message}, _conn, %{gdax: gdax, handler: handler, handler_state: handler_state} = state) do
    message = Poison.decode!(message)
    new_gdax = State.update(gdax, message)
    {:ok, new_handler_state} = handler.handle_message(message, new_gdax, handler_state)
    {:ok, %{state | handler_state: new_handler_state, gdax: new_gdax}}
  end

  def websocket_handle(_message, _conn, state) do
    {:ok, state}
  end
end
