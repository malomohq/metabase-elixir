defmodule Metabase.RequestTest do
  use ExUnit.Case, async: true

  alias Metabase.{Opts, Request, RequestOperation}

  test "new/2" do
    body = %{ok: true}
    headers = [{"content-type", "application/json"}]
    host = "metabase.com"
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
    opts = Map.put(opts, :headers, headers)
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
end
