defmodule Gdex.Order do
  def place(_), do: :ok
  def cancel(id), do: :ok
  def cancel(:all), do: :ok
  def list(opts \\ []), do: :ok
  def get(id), do: :ok
end
