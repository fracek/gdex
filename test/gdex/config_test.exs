defmodule Gdex.ConfigTest do
  use ExUnit.Case, async: true

  test "default config has auth keys" do
    config = Gdex.Config.new()
    assert Map.has_key? config, :api_key
    assert Map.has_key? config, :api_secret
    assert Map.has_key? config, :api_passphrase
  end

  test "can override default config" do
    config = Gdex.Config.new(
      api_key: "abc",
      api_secret: "secret",
      api_passphrase: "pass",
    )
    assert (Map.get config, :api_key) == "abc"
    assert (Map.get config, :api_secret) == "secret"
    assert (Map.get config, :api_passphrase) == "pass"
  end
end
