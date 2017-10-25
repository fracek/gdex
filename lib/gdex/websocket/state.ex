defmodule Gdex.Websocket.State do
  @moduledoc """
  State of a Gdex websocket connection.
  """
  @behaviour Access

  defstruct [:pid, :config, :websocket_client, :channels]

  def new(pid, config, websocket_client) do
    %__MODULE__{
      pid: pid,
      config: config,
      websocket_client: websocket_client,
      channels: %{}
    }
  end

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
end
