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
end
