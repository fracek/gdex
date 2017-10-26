defmodule Gdex.Websocket.State do
  @moduledoc """
  State of a Gdex websocket connection.
  """
  @behaviour Access

  defstruct [:pid, :config, :websocket_client, :channels]

  @type t :: %__MODULE__{}

  @doc """
  Create a new `State`.
  """
  @spec new(pid, Config.t, any) :: State.t
  def new(pid, config, websocket_client) do
    %__MODULE__{
      pid: pid,
      config: config,
      websocket_client: websocket_client,
      channels: %{}
    }
  end

  @doc """
  Update `state` with the information contained in the message.
  """
  @spec update(Gdex.Websocket.State.t, Map.t) :: Gdex.Websocket.State.t
  def update(state, %{"type" => "subscriptions", "channels" => channels}) do
    new_channels = Enum.reduce(channels, %{}, fn (ch, channels) ->
      name = ch["name"] |> String.to_atom
      product_ids = ch["product_ids"]
      Map.put(channels, name, product_ids)
    end)
    %{state | channels: new_channels}
  end

  def update(state, _message) do
    state
  end

  # Access stuff

  def fetch(state, key)
  defdelegate fetch(state, key), to: Map

  def get(state, key, default)
  defdelegate get(state, key, default), to: Map

  def get_and_update(state, key, fun)
  defdelegate get_and_update(state, key, fun), to: Map

  def pop(state, key)
  defdelegate pop(state, key), to: Map
end
