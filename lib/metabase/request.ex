defmodule Metabase.Request do
  @moduledoc """
  HTTP request sent to an endpoint.
  """

  alias Metabase.{RequestOperation}

  @type t ::
          %__MODULE__{
            body: String.t(),
            headers: HTTP.headers_t(),
            method: HTTP.method_t(),
            private: map,
            url: String.t()
          }

  defstruct body: nil, headers: [], method: nil, private: %{}, url: nil

  @doc """
  Builds a `Metabase.HTTP.Request` struct.
  """
  @spec new(RequestOperation.t(), any) :: t
  def new(operation, opts) do
    body = opts.json_codec.encode!(Enum.into(operation.body, %{}))
    headers = opts.headers
    method = operation.method
    url = RequestOperation.to_url(operation, opts)

    %__MODULE__{}
    |> Map.put(:body, body)
    |> Map.put(:headers, headers)
    |> Map.put(:method, method)
    |> Map.put(:url, url)
  end
end
