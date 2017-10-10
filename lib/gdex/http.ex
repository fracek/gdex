defmodule Gdex.Http do
  @moduledoc false

  def request(method, url, body, headers) do
    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
	body = Poison.decode!(body)
	{:ok, {body, headers}}
      {:ok, %HTTPoison.Response{body: body}} ->
	body = Poison.decode!(body)
	{:error, {:gdax, body["message"]}}
      {:error, %HTTPoison.Error{reason: reason}} ->
	{:error, {:httpoison, reason}}
    end
  end
end
