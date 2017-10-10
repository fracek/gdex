defmodule Gdex.HttpTest do
  use ExUnit.Case, async: false
  import Mock

  test "decode response body on success" do
    body = Poison.encode!(%{"test": "success"})
    response = %HTTPoison.Response{status_code: 200, body: body}
    with_mock(HTTPoison, [request: fn(_, _, _, _) -> {:ok, response} end]) do
      {:ok, {body, headers}} = Gdex.Http.request("GET", "https://example.org/test", "", [])
      assert %{"test" => "success"} == body
      assert [] == headers
    end
  end

  test "non 200 status code is an error" do
    body = Poison.encode!(%{"message": "error"})
    response = %HTTPoison.Response{status_code: 405, body: body}
    with_mock(HTTPoison, [request: fn(_, _, _, _) -> {:ok, response} end]) do
      {:error, {:gdax, error}} = Gdex.Http.request("GET", "https://example.org/test", "", [])
      assert "error" == error
    end
  end

  test "HTTPoison errors are forwarded" do
    response = %HTTPoison.Error{reason: "yes"}
    with_mock(HTTPoison, [request: fn(_, _, _, _) -> {:error, response} end]) do
      {:error, {:httpoison, error}} = Gdex.Http.request("GET", "https://example.org/test", "", [])
      assert "yes" == error
    end
  end
end
