defmodule Metabase.RequestOperation do
  @moduledoc """
  Intermediate HTTP request data structure.

  Stores request details as their original data structures. This differs from
  `Metabase.Request` which stores request details in formats
  expected by an endpoint.
  """

  @type t ::
          %__MODULE__{
            body: keyword,
            encoding: :json,
            method: HTTP.method_t(),
            query: keyword,
            path: String.t()
          }

  defstruct body: [], encoding: :json, method: nil, query: [], path: nil

  @doc """
  Builds a URL string.
  """
  @spec to_url(any, any) :: String.t()
  def to_url(operation, opts) do
    %URI{}
    |> Map.put(:scheme, opts.protocol)
    |> Map.put(:host, opts.host)
    |> Map.put(:port, opts.port)
    |> Map.put(:path, operation.path)
    |> Map.put(:query, URI.encode_query(operation.query))
    |> URI.to_string()
  end
end
