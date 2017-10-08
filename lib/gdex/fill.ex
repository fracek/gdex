defmodule Gdex.Fill do
  alias Gdex.Request

  def list(opts \\ []) do
    Request.new(:GET, "/fills", params: opts)
  end
end
