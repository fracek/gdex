defmodule Gdex.RequestTest do
  use ExUnit.Case, async: false
  import TestHelper


  test "new should return the module struct" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/abc/def",
      body: "",
      params: [],
      headers: [],
      paginated: false,
    }
    assert expected == Gdex.Request.new(:GET, "/abc/def")
  end

  test "new should encode the body to json" do
    expected = %Gdex.Request{
      method: "GET",
      path: "/abc/def",
      body: ~s({"abc":2}),
    }
    assert expected == Gdex.Request.new(:GET, "/abc/def", body: %{abc: 2})
  end

  test "non paginated request returns the response" do
    config = Gdex.Config.new
    request = Gdex.Request.new(:GET, "/path")
    response_body = Poison.encode!(%{test: "ok"})

    with_http_response "GET", "https://api.gdax.com/path", {response_body, []}, fn ->
      {:ok, body} = Gdex.Request.request(request, config)
      assert %{"test" => "ok"} == Poison.decode!(body)
    end
  end

  test "paginated request delegates to stream!" do
    config = Gdex.Config.new
    request = Gdex.Request.new(:GET, "/path", paginated: true)
    response_body = Poison.encode!(%{page: "ok"})

    with_http_response "GET", "https://api.gdax.com/path", {response_body, []}, fn ->
      {:ok, _} = Gdex.Request.request(request, config)
    end
  end

  test "make_url ignores trailing / in the config rest_url" do
    config = Gdex.Config.new(rest_url: "https://api.gdax.com/")
    request = Gdex.Request.new(:GET, "/path")
    assert "https://api.gdax.com/path" == Gdex.Request.make_url(request, config)
  end

  test "make_url adds missing / to url" do
    config = Gdex.Config.new(rest_url: "https://api.gdax.com")
    request = Gdex.Request.new(:GET, "/path")
    assert "https://api.gdax.com/path" == Gdex.Request.make_url(request, config)
  end

  test "make_path doesn't add any query parameter for empty params" do
    request = Gdex.Request.new(:GET, "/path")
    assert "/path" == Gdex.Request.make_path(request)
  end

  test "make_path does url encoding when params are present" do
    request = Gdex.Request.new(:GET, "/path", params: [a: 1, b: "test"])
    assert "/path?a=1&b=test" == Gdex.Request.make_path(request)
  end

  test "make_headers adds specified headers" do
    request = Gdex.Request.new(:GET, "/path", headers: ["test-header": "yes"])
    config = Gdex.Config.new()
    expected = [
      "Content-Type": "application/json",
      "test-header": "yes",
    ]
    assert expected == Gdex.Request.make_headers(request, config)
  end

  test "make_headers adds authentication headers" do
    request = Gdex.Request.new(:GET, "/path", headers: ["test-header": "yes"])
    config = Gdex.Config.new(
      api_key: "key",
      api_secret: "v25UWRskcjCkgzc+TbITV/iXtOwLXNXa82KYFM12QaSRzsq0bCyGDX84Z/GSCBJkDyuM/gYgSMAT566rnMJ5dw==",
      api_passphrase: "pass"
    )
    headers = Gdex.Request.make_headers(request, config)
    expected = [:"CB-ACCESS-KEY", :"CB-ACCESS-SIGN", :"CB-ACCESS-TIMESTAMP", :"CB-ACCESS-PASSPHRASE"]
    Enum.each(expected, fn h ->
      assert Keyword.has_key?(headers, h)
    end)
  end
end
