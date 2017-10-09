defmodule Gdex do

  @typedoc """
  Type that represents an amount of currency. If you wish to not lose precision,
  use a binary string to hold the currency amount.
  """
  @type amount :: number | binary

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

  ## Examples

      iex> Gdex.Market.trades("BTC-USD") |> Gdex.stream! |> Enum.take(10)
      [%{"price" => "4608.99000000", "side" => "sell", "size" => "0.00043285",
         "time" => "2017-10-09T14:05:15.747Z", "trade_id" => 1236},
       %{"price" => "4608.99000000", "side" => "sell", "size" => "0.02164262",
         "time" => "2017-10-09T13:33:41.363Z", "trade_id" => 1235},
       %{"price" => "4608.99000000", "side" => "sell", "size" => "1.00000000",
         "time" => "2017-10-09T03:12:25.024Z", "trade_id" => 1234},
       %{"price" => "4608.99000000", "side" => "sell", "size" => "0.02164262",
         "time" => "2017-10-09T03:03:39.72Z", "trade_id" => 1233},
       %{"price" => "4608.99000000", "side" => "sell", "size" => "0.21642620",
         "time" => "2017-10-09T02:46:22.721Z", "trade_id" => 1232},
       %{"price" => "4608.99000000", "side" => "sell", "size" => "0.10000000",
         "time" => "2017-10-09T02:42:21.843Z", "trade_id" => 1231},
       %{"price" => "6100.00000000", "side" => "sell", "size" => "0.96355230",
         "time" => "2017-10-08T23:45:07.821Z", "trade_id" => 1230},
       %{"price" => "99.99000000", "side" => "buy", "size" => "59.11504702",
         "time" => "2017-10-08T23:44:14.153Z", "trade_id" => 1229},
       %{"price" => "6100.00000000", "side" => "sell", "size" => "0.00163525",
         "time" => "2017-10-08T22:23:17.799Z", "trade_id" => 1228},
       %{"price" => "102.00000000", "side" => "sell", "size" => "0.09779473",
         "time" => "2017-10-08T22:21:22.548Z", "trade_id" => 1227}]
  """
  @spec stream!(Gdex.Request.t, Keyword.t) :: Enumerable.t
  def stream!(req, config \\ []) do
    Gdex.Request.stream!(req, Gdex.Config.new(config))
  end
end
