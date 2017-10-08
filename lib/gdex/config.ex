defmodule Gdex.Config do
  @moduledoc """
  Configuration used when connecting to GDAX. \

  If the configuration contains `:api_key`, `:api_secret` and `:api_passphrase`
  requests will be authenticated.
  """
  @type t :: %{} | Map.t

  @defaults %{
    rest_url: "https://api.gdax.com/",
    websocket_url: "wss://ws-feed.gdax.com/",
    api_key: nil,
    api_secret: nil,
    api_passphrase: nil,
  }

  @default_keys (Map.keys @defaults)

  @doc """
  Build a set of config.

  The config is built by merging `opts` with `config :gdex` with a
  set of defaults, in this order of precedence.
  """
  @spec new(Keyword.t) :: Gdex.Config.t
  def new(opts \\ []) do
    overrides = Map.new(opts)
    config = Application.get_all_env(:gdex) |> Map.new

    @defaults
    |> Map.merge(config)
    |> Map.merge(overrides)
    |> Map.take(@default_keys)
  end
end
