defmodule Metabase.ResponseTest do
  use ExUnit.Case, async: true

  alias Metabase.{HTTP, Opts, Response}

  describe "new/2" do
    test "decodes body when content-type is \"application/json\"" do
      headers = [{"content-type", "application/json"}]
      status_code = 200

      response = %HTTP.Response{}
      response = Map.put(response, :body, "{\"ok\": true}")
      response = Map.put(response, :headers, headers)
      response = Map.put(response, :status_code, status_code)

      opts = Opts.new([])

      expected = %Response{}
      expected = Map.put(expected, :body, %{"ok" => true})
      expected = Map.put(expected, :headers, headers)
      expected = Map.put(expected, :status_code, status_code)

      assert expected == Response.new(response, opts)
    end

    test "does not decode body for an unsupported content-type" do
      body = "nope"
      headers = [{"content-type", "text/plain"}]
      status_code = 200

      response = %HTTP.Response{}
      response = Map.put(response, :body, body)
      response = Map.put(response, :headers, headers)
      response = Map.put(response, :status_code, status_code)

      opts = Opts.new([])

      expected = %Response{}
      expected = Map.put(expected, :body, body)
      expected = Map.put(expected, :headers, headers)
      expected = Map.put(expected, :status_code, status_code)

      assert expected == Response.new(response, opts)
    end

    test "does not decode body when there is no content-type" do
      body = "nope"
      headers = [{"irrelevant-header", ""}]
      status_code = 200

      response = %HTTP.Response{}
      response = Map.put(response, :body, body)
      response = Map.put(response, :headers, headers)
      response = Map.put(response, :status_code, status_code)

      opts = Opts.new([])

      expected = %Response{}
      expected = Map.put(expected, :body, body)
      expected = Map.put(expected, :headers, headers)
      expected = Map.put(expected, :status_code, status_code)

      assert expected == Response.new(response, opts)
    end
  end
end
