ExUnit.start()

defmodule TestHelper do
  use ExUnit.Case
  import Mock

  def with_http_response(method, url, response, fun) do
    mocks = [request: fn
	      (m_method, m_url, _, _) when method == m_method and url == m_url ->
     	        {:ok, response}
	    end]

    with_mock(Gdex.Http, mocks) do
      fun.()
    end
  end

  defmacro with_send_request(req, do: body) do
    quote do
      with_mock(Gdex.Websocket.Client, [
	    send_request: fn (_, unquote(req)) -> :ok end]) do
	unquote(body)
	assert called Gdex.Websocket.Client.send_request(:_, :_)
      end
    end
  end


  defmodule MockWebsocketClient do
    def cast(pid, {:text, message}) do
      send pid, {:text, message}
    end
  end
end
