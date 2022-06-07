defmodule Metabase.Session do
  alias Metabase.{RequestOperation}

  @doc """
  Creates a session.

  This is equivalent to performing a login.
  """
  @spec create(keyword) :: RequestOperation.t()
  def create(params) do
    %RequestOperation{}
    |> Map.put(:body, params)
    |> Map.put(:method, :post)
    |> Map.put(:path, "/session")
  end
end
