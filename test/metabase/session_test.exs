defmodule Metabase.SessionTest do
  use ExUnit.Case, async: true

  alias Metabase.{RequestOperation, Session}

  test "create/1" do
    username = "person@mymetabase.com"

    password = "fakepassword"

    params = [username: username, password: password]

    expected =
      %RequestOperation{}
      |> Map.put(:body, params)
      |> Map.put(:method, :post)
      |> Map.put(:path, "/session")

    assert expected == Session.create(params)
  end
end
