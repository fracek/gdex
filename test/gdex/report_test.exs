defmodule Gdex.ReportTest do
  use ExUnit.Case, async: true

  test "create" do
    expected = %Gdex.Request{
      method: "POST",
      path: "/reports",
      body: Poison.encode!(%{type: "fills",
			     start_date: "2014-11-01T00:00:00Z",
			     end_date: "2014-11-30T23:59:59Z",
			     product_id: "BTC-USD"})
    }
    {:ok, start_dt} = DateTime.from_unix(1414800000)
    {:ok, end_dt} = DateTime.from_unix(1417391999)
    assert expected == Gdex.Report.create(:fills, start_dt, end_dt, product_id: "BTC-USD")
  end

  test "status" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/reports/a1b2c3d4",
    }
    assert expected == Gdex.Report.status("a1b2c3d4")
  end
end
