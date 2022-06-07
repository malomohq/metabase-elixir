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
    |> put_header("content-type", "application/json")
    |> put_session(opts.session)
  end

  @doc """
  Adds a new request header if not present. Otherwise, replaces the previous
  value.
  """
  @spec put_header(t, String.t(), String.t()) :: t
  def put_header(request, key, value) do
    headers =
      request.headers
      |> Enum.into(%{})
      |> Map.put(key, value)
      |> Enum.into([])

    %{request | headers: headers}
  end

  @doc """
  Adds the Metabase session header if provided.
  """
  @spec put_session(t, String.t()) :: t
  def put_session(request, nil) do
    request
  end

  def put_session(request, session_id) do
    put_header(request, "x-metabase-session", session_id)
  end
end
