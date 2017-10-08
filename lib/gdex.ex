defmodule Gdex do
  @doc """
  Performs a request to GDAX.

  If the request executes successfully then `{:ok, value}` is returned,
  otherwise `{:error, reason}` is returned.

  ## Examples

      iex> Gdex.Account.list |> Gdex.request
      {:ok,
       [%{"available" => "0.0000000000000000", "balance" => "0.0000000000000000",
          "currency" => "USD", "default_amount" => "0", "funded_amount" => "0",
          "hold" => "0.0000000000000000",
          "id" => "eb935c0b-b2d1-4cfe-9e1b-7b2d5dd4118c", "margin_enabled" => true,
          "profile_id" => "64c220f4-0652-40cd-a709-f9d198991219"},
        %{"available" => "0.0000000000000000", "balance" => "0.0000000000000000",
          "currency" => "BTC", "default_amount" => "0", "funded_amount" => "0",
          "hold" => "0.0000000000000000",
          "id" => "641bb286-5706-459e-b24b-c36a1bc264f3", "margin_enabled" => true,
          "profile_id" => "4b28919c-91c5-4ee2-a7d3-be8621bdb558"}]

  """
  @spec request(Gdex.Request.t, Keyword.t) :: {:ok, term} | {:error, term}
  def request(req, config \\ []) do
    Gdex.Request.request(req, Gdex.Config.new(config))
  end

  @doc """
  Performs a request to GDAX, raise if it fails.

  Same as `request/2` except it will raise `Gdex.Error` if it fails.
  """
  @spec request!(Gdex.Request.t, Keyword.t) :: term | no_return
  def request!(req, config \\ []) do
    case request(req, config) do
      {:ok, result} ->
	result
      {:error, reason} ->
	raise Gdex.Error, "Gdex Request error: #{inspect reason}"
    end
  end

  @doc """
  Returns a `Stream` for the GDAX request.
  """
  @spec stream!(Gdex.Request.t, Keyword.t) :: Enumerable.t
  def stream!(req, config \\ []) do
    Gdex.Request.stream!(req, Gdex.Config.new(config))
  end
end
