defmodule Metabase.RequestTest do
  use ExUnit.Case, async: true

  alias Metabase.{Opts, Request, RequestOperation}

  describe "new/2" do
    test "builds a Request struct" do
      body = %{ok: true}
      headers = [{"content-type", "application/json"}]
      host = "mymetabase.com"
      method = :get
      path = "/endpoint"
      port = 4000
      query = [a: 1]

      operation = %RequestOperation{}
      operation = Map.put(operation, :body, body)
      operation = Map.put(operation, :method, method)
      operation = Map.put(operation, :path, path)
      operation = Map.put(operation, :query, query)

      opts = %Opts{}
      opts = Map.put(opts, :host, host)
      opts = Map.put(opts, :port, port)

      url = RequestOperation.to_url(operation, opts)

      expected = %Request{}
      expected = Map.put(expected, :body, opts.json_codec.encode!(body))
      expected = Map.put(expected, :headers, headers)
      expected = Map.put(expected, :method, method)
      expected = Map.put(expected, :url, url)

      assert expected == Request.new(operation, opts)
    end

    test "adds a session header if provided" do
      body = %{ok: true}
      host = "mymetabase.com"
      method = :get
      path = "/endpoint"
      port = 4000
      query = [a: 1]
      session = "fakesession"

      operation = %RequestOperation{}
      operation = Map.put(operation, :body, body)
      operation = Map.put(operation, :method, method)
      operation = Map.put(operation, :path, path)
      operation = Map.put(operation, :query, query)

      opts = %Opts{}
      opts = Map.put(opts, :host, host)
      opts = Map.put(opts, :port, port)
      opts = Map.put(opts, :session, session)

      request = Request.new(operation, opts)

      assert {"x-metabase-session", session} in request.headers
    end

    test "does not add a session header if not provided" do
      body = %{ok: true}
      host = "mymetabase.com"
      method = :get
      path = "/endpoint"
      port = 4000
      query = [a: 1]

      operation = %RequestOperation{}
      operation = Map.put(operation, :body, body)
      operation = Map.put(operation, :method, method)
      operation = Map.put(operation, :path, path)
      operation = Map.put(operation, :query, query)

      opts = %Opts{}
      opts = Map.put(opts, :host, host)
      opts = Map.put(opts, :port, port)

      request = Request.new(operation, opts)

      refute Enum.any?(request.headers, fn {k, _} -> k == "x-metabase-session" end)
    end
  end
end
