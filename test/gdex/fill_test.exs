defmodule Gdex.FillTest do
  use ExUnit.Case, async: true

  test "list by order id" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/fills",
      params: [order_id: "a1b2c3d4"],
      paginated: true,
    }
    assert expected == Gdex.Fill.list(order_id: "a1b2c3d4")
  end

  test "list by product id" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/fills",
      params: [product_id: "a1b2c3d4"],
      paginated: true,
    }
    assert expected == Gdex.Fill.list(product_id: "a1b2c3d4")
  end
end
