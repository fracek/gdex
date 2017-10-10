defmodule Gdex.FundingTest do
  use ExUnit.Case, async: true

  test "list with no filter" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/funding",
      paginated: true,
    }
    assert expected == Gdex.Funding.list
  end

  test "list with filter" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/funding",
      params: [status: :outstanding],
      paginated: true,
    }
    assert expected == Gdex.Funding.list(:outstanding)
  end

  test "repay" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/funding/repay",
      body: Poison.encode!(%{amount: "123.4", currency: "USD"}),
    }
    assert expected == Gdex.Funding.repay("123.4", "USD")
  end
end
