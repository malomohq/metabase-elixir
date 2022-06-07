defmodule Metabase.EmbedTest do
  use ExUnit.Case, async: true

  alias Metabase.{Embed}

  describe "token/2" do
    test "requires :expire_in embed option" do
      assert_raise ArgumentError, ":expire_in embed option is required", fn ->
        Embed.token(%{}, secret_key: "fakesecret")
      end
    end

    test "requires :secret_key embed option" do
      assert_raise ArgumentError, ":secret_key embed option is required", fn ->
        Embed.token(%{}, expire_in: 1)
      end
    end

    test "creates a token" do
      assert Embed.token(%{}, expire_in: 1, secret_key: "fakesecret")
    end

    test "token has the provided claims" do
      secret_key = "fakesecret"

      token = Embed.token(%{key: "value"}, expire_in: 1, secret_key: secret_key)

      signer = Joken.Signer.create("HS256", secret_key)

      claims = Joken.verify_and_validate!(%{}, token, signer)

      assert "value" == Map.get(claims, "key")
    end

    test "token has an exp claim" do
      secret_key = "fakesecret"

      token = Embed.token(%{key: "value"}, expire_in: 1, secret_key: secret_key)

      signer = Joken.Signer.create("HS256", secret_key)

      claims = Joken.verify_and_validate!(%{}, token, signer)

      assert Map.get(claims, "exp")
    end
  end
end
