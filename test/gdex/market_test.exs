defmodule Gdex.MarketTest do
  use ExUnit.Case, async: true

  test "products" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products",
    }
    assert expected == Gdex.Market.products
  end

  test "orderbook default level 1" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/book",
      params: [level: 1],
    }
    assert expected == Gdex.Market.orderbook("BTC-USD")
  end

  test "orderbook level 3" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/book",
      params: [level: 3],
    }
    assert expected == Gdex.Market.orderbook("BTC-USD", 3)
  end

  test "ticker" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/ticker",
    }
    assert expected == Gdex.Market.ticker("BTC-USD")
  end

  test "trades" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/trades",
      paginated: true,
    }
    assert expected == Gdex.Market.trades("BTC-USD")

  end

  test "historic rates" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/candles",
      params: [start: "2010-09-30T23:00:00Z", end: "2017-10-10T10:36:22Z", granularity: 3600],
    }
    {:ok, start_dt} = DateTime.from_unix(1285887600)
    {:ok, end_dt} = DateTime.from_unix(1507631782)
    assert expected == Gdex.Market.historic_rates("BTC-USD", start_dt, end_dt, 3600)
  end

  test "stats" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/products/BTC-USD/stats",
    }
    assert expected == Gdex.Market.stats("BTC-USD")
  end
end
