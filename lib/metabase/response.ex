defmodule Metabase.Response do
  @moduledoc """
  HTTP response returned by a request.
  """

  alias Metabase.{HTTP, Opts}

  @type t ::
          %__MODULE__{
            body: map,
            headers: HTTP.headers_t(),
            status_code: HTTP.status_code_t()
          }

  defstruct [:body, :headers, :status_code]

  @doc """
  Builds a `Metabase.Response` struct.

  Only decodes the body of a response if the value of the "content-type" header
  is supported. Otherwise, the body will be returned as is.

  ## Supported Encodings

  * `application/json`
  """
  @spec new(HTTP.Response.t(), Opts.t()) :: t
  def new(response, opts) do
    body = do_decode(response, opts)
    headers = response.headers
    status_code = response.status_code

    %__MODULE__{}
    |> Map.put(:body, body)
    |> Map.put(:headers, headers)
    |> Map.put(:status_code, status_code)
  end

  defp do_decode(response, opts) do
    content_type = HTTP.Response.get_header(response, "content-type")

    if content_type && content_type =~ "application/json" do
      opts.json_codec.decode!(response.body)
    else
      response.body
    end
  end
end
