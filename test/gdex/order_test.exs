defmodule Gdex.OrderTest do
  use ExUnit.Case, async: true

  test "place limit order" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     product_id: "BTC-USD",
			     size: "0.01",
			     price: "0.100"})
    }
    assert expected == Gdex.Order.place("BTC-USD", :buy, size: "0.01", price: "0.100")
  end

  test "place market order" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     type: :market,
			     product_id: "BTC-USD",
			     funds: "100"})
    }
    assert expected == Gdex.Order.place("BTC-USD", :buy, type: :market, funds: "100")
  end

  test "encode extended time in force" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     product_id: "BTC-USD",
			     size: "0.01",
			     price: "0.100",
			     time_in_force: "FOK"})
    }
    opts = [
      size: "0.01",
      price: "0.100",
      time_in_force: :fill_or_kill,
    ]
    assert expected == Gdex.Order.place("BTC-USD", :buy, opts)
  end

  test "encode short time in force" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     product_id: "BTC-USD",
			     size: "0.01",
			     price: "0.100",
			     time_in_force: "FOK"})
    }
    opts = [
      size: "0.01",
      price: "0.100",
      time_in_force: :fok,
    ]
    assert expected == Gdex.Order.place("BTC-USD", :buy, opts)
  end

  test "encode extended self trade prevention" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     product_id: "BTC-USD",
			     size: "0.01",
			     price: "0.100",
			     stp: "cb"})
    }
    opts = [
      size: "0.01",
      price: "0.100",
      self_trade_prevention: :cancel_both
    ]
    assert expected == Gdex.Order.place("BTC-USD", :buy, opts)
  end

  test "encode short self trade prevention" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/orders",
      body: Poison.encode!(%{side: :buy,
			     product_id: "BTC-USD",
			     size: "0.01",
			     price: "0.100",
			     stp: "co"})
    }
    opts = [
      size: "0.01",
      price: "0.100",
      stp: :co
    ]
    assert expected == Gdex.Order.place("BTC-USD", :buy, opts)
  end

  test "cancel" do
    expected = %Gdex.Request{
      method: "DELETE",
      path: "/orders/a1b2c3d4",
    }
    assert expected == Gdex.Order.cancel("a1b2c3d4")
  end

  test "cancell all" do
    expected = %Gdex.Request{
      method: "DELETE",
      path: "/orders",
    }
    assert expected == Gdex.Order.cancel_all
  end

  test "cancell all and filter by product" do
    expected = %Gdex.Request{
      method: "DELETE",
      path: "/orders",
      params: [product_id: "BTC-USD"],
    }
    assert expected == Gdex.Order.cancel_all("BTC-USD")
  end

  test "list orders without filters" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/orders",
      paginated: true,
    }
    assert expected == Gdex.Order.list
  end

  test "list orders with filters" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/orders",
      params: [status: :open, product_id: "BTC-USD"],
      paginated: true,
    }
    assert expected == Gdex.Order.list(status: :open, product_id: "BTC-USD")
  end

  test "get" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/orders/a1b2c3d4",
    }
    assert expected == Gdex.Order.get("a1b2c3d4")
  end
end
