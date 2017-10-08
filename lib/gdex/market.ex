defmodule Gdex.Market do
  alias Gdex.Request

  def list_trades(product_id) do
    Request.new(:GET, "/products/#{product_id}/trades")
  end
end
