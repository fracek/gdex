defmodule Gdex.Auth do
  @moduledoc """
  This module handles authentication on GDAX.
  """

  @doc """
  Returns a `Map` containing the fields needed to authenticate on GDAX.

  ## Examples

      auth_map(config, :GET, "/", "")
      #=> %{"key" => "...", "signature" => "...", "timestamp" => "...", "passphrase" => "..."}
  """
  def auth_map(config, method, path, body) do
    case auth_fields(config, method, path, body) do
      {:ok, nil} ->
	{:ok, %{}}
      {:ok, {key, sign, timestamp, passphrase}} ->
	{:ok, %{"key" => key, "signature" => sign, "timestamp" => timestamp,
		"passphrase" => passphrase}}
      {:error, error} ->
	{:error, error}
    end
  end

  @doc """
  Returns the headers needed to authenticate on GDAX.

  ## Examples

      auth_headers(config, :GET, "/", "")
      #=> ["CB-ACCESS-KEY": "...", "CB-ACCESS-SIGN": "...", "CB-ACCESS-TIMESTAMP": "...",
      #..  "CB-ACCESS-PASSPHRASE": "..."]

  """
  def auth_headers(config, method, path, body) do
    case auth_fields(config, method, path, body) do
      {:ok, nil} ->
	{:ok, []}
      {:ok, {key, sign, timestamp, passphrase}} ->
	headers = [
	  "CB-ACCESS-KEY": key,
	  "CB-ACCESS-SIGN": sign,
	  "CB-ACCESS-TIMESTAMP": timestamp,
	  "CB-ACCESS-PASSPHRASE": passphrase
	]
	{:ok, headers}
      {:error, error} ->
	{:error, error}
    end
  end

  @doc false
  def sign_request(secret_key, timestamp, method, path, body) do
    hmac_key = Base.decode64!(secret_key)
    message = "#{timestamp}#{method}#{path}#{body}"

    :crypto.hmac(:sha256, hmac_key, message)
    |> Base.encode64
  end

  @doc false
  def validate_config(config) do
    api_key = Map.get(config, :api_key)
    api_secret = Map.get(config, :api_secret)
    api_pass = Map.get(config, :api_passphrase)
    do_validate_config(api_key, api_secret, api_pass)
  end

  defp do_validate_config(nil, nil, nil), do: {:ok, nil}
  defp do_validate_config(key, secret, pass) do
    with :ok <- validate_field(key),
         :ok <- validate_field(secret),
           :ok <- validate_field(pass) do
      {:ok, %{
	  api_key: key,
	  api_secret: secret,
	  api_passphrase: pass}}
    else
      :error -> {:error, "Authentication Config: Missing or invalid key"}
    end
  end

  defp validate_field(f) when is_binary(f), do: :ok
  defp validate_field(_), do: :error

  defp auth_fields(config, method, path, body) do
    case validate_config(config) do
      {:ok, nil} ->
	{:ok, nil}
      {:ok, auth} ->
	timestamp = System.system_time(:second)
	method = String.upcase(method)
	signature = sign_request(auth.api_secret, timestamp, method, path, body)
	{:ok, {auth.api_key, signature, timestamp, auth.api_passphrase}}
      {:error, reason} ->
	{:error, reason}
    end
  end
end
