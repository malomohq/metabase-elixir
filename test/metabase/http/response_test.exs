defmodule Metabase.HTTP.ResponseTest do
  use ExUnit.Case, async: true

  alias Metabase.HTTP.{Response}

  describe "get_header/2" do
    test "returns a header value if found" do
      body = "{\"ok\": true}"
      headers = [{"content-type", "application/json"}]
      status_code = 200

      response = %Response{}
      response = Map.put(response, :body, body)
      response = Map.put(response, :headers, headers)
      response = Map.put(response, :status_code, status_code)

      assert "application/json" == Response.get_header(response, "content-type")
    end

    test "returns nil if not found" do
      body = "{\"ok\": true}"
      headers = [{"content-type", "application/json"}]
      status_code = 200

      response = %Response{}
      response = Map.put(response, :body, body)
      response = Map.put(response, :headers, headers)
      response = Map.put(response, :status_code, status_code)

      assert nil == Response.get_header(response, "nope")
    end
  end
end
