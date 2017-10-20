defmodule Gdex.WebsocketTest do
  use ExUnit.Case

  test "can start the websocket client correctly" do
    {:ok, _} = Gdex.Websocket.start_link(MyTest, [])
  end
end
