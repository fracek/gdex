defmodule Gdex.AuthTest do
  use ExUnit.Case, async: true

  @secret "v25UWRskcjCkgzc+TbITV/iXtOwLXNXa82KYFM12QaSRzsq0bCyGDX84Z/GSCBJkDyuM/gYgSMAT566rnMJ5dw=="

  test "no auth key in config means no authentication" do
    config = Gdex.Config.new()
    assert Gdex.Auth.auth_headers(config, "GET", "/", "") == {:ok, []}
  end

  test "missing auth keys result in an error" do
    config = Gdex.Config.new(api_key: "abc")
    assert {:error, _} = Gdex.Auth.auth_headers(config, "GET", "/", "")
  end

  test "non string auth keys result in an error" do
    config = Gdex.Config.new(
      api_key: "abc",
      api_secret: 123,
      api_passphrase: "test"
    )
    assert {:error, _} = Gdex.Auth.auth_headers(config, "GET", "/", "")
  end

  test "valid auth keys add the authentication headers" do
    config = Gdex.Config.new(
      api_key: "xxxxxxxxxxxx",
      api_secret: @secret,
      api_passphrase: "passphrase"
    )
    {:ok, headers} = Gdex.Auth.auth_headers(config, "GET", "/accounts", "")

    required_headers = [
      :"CB-ACCESS-KEY", :"CB-ACCESS-SIGN", :"CB-ACCESS-TIMESTAMP",
      :"CB-ACCESS-PASSPHRASE"
    ]
    Enum.each(required_headers, fn h ->
      assert Keyword.has_key?(headers, h)
    end)
  end

  test "CB-ACCESS-SIGN for requests with no body" do
    timestamp = 1507484260
    sign = Gdex.Auth.sign_request(
      @secret, timestamp, "GET", "/orders/?product_id=BTC-EUR&", ""
    )
    assert sign == "jDFHgwR0RwOobLSG7NpS5I2ig4Mfe78aY8Dxf69CWjI="
  end

  test "CB-ACCESS-SIGN for requests with body" do
    timestamp = 1507484261
    body = ~s({"type": "fills", "start_date": "2017-08-01T00:00:00", "end_date": "2017-10-08T18:37:41", "product_id": "", "account_id": "", "format": "", "email": ""})
    sign = Gdex.Auth.sign_request(
      @secret, timestamp, "POST", "/reports", body
    )
    assert sign == "0LVPp01KdKwJ1O0rwr4wG/160KSgLbu4Z3s46moXpEI="
  end
end
