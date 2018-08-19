defmodule Gdex.Fill do
  alias Gdex.Request

  @type list_opt :: {:order_id, binary} | {:product_id, binary}


  @doc """
  Get a list of recent fills.

  Either `order_id` or `product_id` must be specified.

  Can be streamed.
  """
  @spec list([list_opt]) :: Request.t
  def list(opts) do
    Request.new(:GET, "/fills", params: opts, paginated: true)
  end
end
