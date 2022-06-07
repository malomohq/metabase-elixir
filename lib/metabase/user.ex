defmodule Metabase.User do
  alias Metabase.{RequestOperation}

  @doc """
  Fetches the user associated with the current session.
  """
  @spec get_current :: RequestOperation.t()
  def get_current do
    %RequestOperation{}
    |> Map.put(:method, :get)
    |> Map.put(:path, "/user/current")
  end
end
