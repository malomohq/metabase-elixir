defmodule Metabase.HTTP.Hackneytest do
  use ExUnit.Case, async: true

  alias Metabase.{HTTP, RequestOperation, Response}

  setup do
    bypass = Bypass.open()

    http_opts = Keyword.new()
    http_opts = Keyword.put(http_opts, :client, HTTP.Hackney)
    http_opts = Keyword.put(http_opts, :host, "localhost")
    http_opts = Keyword.put(http_opts, :port, bypass.port)
    http_opts = Keyword.put(http_opts, :protocol, "http")

    {:ok, bypass: bypass, http_opts: http_opts}
  end

  describe "send/2" do
    test "returns :ok if the response was successful", %{bypass: bypass, http_opts: http_opts} do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn
        conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(200, ~s<{"ok":true}>)
      end)

      operation = %RequestOperation{}
      operation = Map.put(operation, :body, [])
      operation = Map.put(operation, :method, :post)
      operation = Map.put(operation, :path, "/endpoint")

      result = Metabase.send(operation, http_opts)

      assert {:ok, %Response{} = response} = result
      assert %{"ok" => true} == response.body
      assert {"content-type", "application/json"} in response.headers
      assert 200 == response.status_code
    end

    test "returns :error if the response was not successful", %{
      bypass: bypass,
      http_opts: http_opts
    } do
      Bypass.expect_once(bypass, "POST", "/endpoint", fn
        conn ->
          conn
          |> Plug.Conn.put_resp_header("content-type", "application/json")
          |> Plug.Conn.resp(400, ~s<{"ok":false}>)
      end)

      operation = %RequestOperation{}
      operation = Map.put(operation, :body, [])
      operation = Map.put(operation, :method, :post)
      operation = Map.put(operation, :path, "/endpoint")

      result = Metabase.send(operation, http_opts)

      assert {:error, %Response{} = response} = result
      assert %{"ok" => false} == response.body
      assert {"content-type", "application/json"} in response.headers
      assert 400 == response.status_code
    end
  end
end
