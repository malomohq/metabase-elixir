defmodule Metabase.UserTest do
  use ExUnit.Case, async: true

  alias Metabase.{RequestOperation, User}

  test "get_current/0" do
    expected =
      %RequestOperation{}
      |> Map.put(:method, :get)
      |> Map.put(:path, "/user/current")

    assert expected == User.get_current()
  end
end
