defmodule Metabase.RequestOperationTest do
  use ExUnit.Case, async: true

  alias Metabase.{Opts, RequestOperation}

  test "to_url/2" do
    host = "heypigeon.co"
    path = "/endpoint"
    query = [a: 1]
    port = 4000

    operation = %RequestOperation{}
    operation = Map.put(operation, :path, path)
    operation = Map.put(operation, :query, query)

    opts = %Opts{}
    opts = Map.put(opts, :host, host)
    opts = Map.put(opts, :port, port)

    expected = "#{opts.protocol}://"
    expected = expected <> host
    expected = expected <> ":#{port}"
    expected = expected <> path
    expected = expected <> "?#{URI.encode_query(query)}"

    assert expected == RequestOperation.to_url(operation, opts)
  end
end
