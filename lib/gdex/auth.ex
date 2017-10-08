defmodule Gdex.Auth do
  def auth_headers(config, method, path, body) do
    case validate_config(config) do
      {:ok, nil} ->
	{:ok, []}
      {:ok, auth} ->
	{:ok, make_auth_headers(auth, method, path, body)}
      {:error, error} ->
	{:error, error}
    end
  end

  def sign_request(secret_key, timestamp, method, path, body) do
    hmac_key = Base.decode64!(secret_key)
    message = "#{timestamp}#{method}#{path}#{body}"

    :crypto.hmac(:sha256, hmac_key, message)
    |> Base.encode64
  end

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

  defp make_auth_headers(auth, method, path, body) do
    timestamp = :os.system_time(:second)
    method = String.upcase(method)
    signature = sign_request(auth.api_secret, timestamp, method, path, body)


    ["CB-ACCESS-KEY": auth.api_key,
     "CB-ACCESS-SIGN": signature,
     "CB-ACCESS-TIMESTAMP": timestamp,
     "CB-ACCESS-PASSPHRASE": auth.api_passphrase
    ]
  end

end
