defmodule Metabase.HTTP.Response do
  @moduledoc """
  HTTP response returned by an adapter.

  This response module differs from `Metabase.HTTP.Response` in that it
  does not decode the body. The purpose of this struct is to provide a simple
  data structure that doesn't require any additional processing of the response.
  This simplifies adapter creation since the adapter is only concerned with
  mapping the raw data it receives to this struct.
  """

  alias Metabase.{HTTP}

  defstruct [:body, :headers, :status_code]

  @type t ::
          %__MODULE__{
            body: String.t(),
            headers: HTTP.headers_t(),
            status_code: HTTP.status_code_t()
          }

  @doc """
  Returns the value for the requested header.

  If the header does not exist `nil` is returned.
  """
  @spec get_header(t, String.t()) :: String.t()
  def get_header(response, header) do
    Enum.find_value(response.headers, fn
      {^header, value} ->
        value

      _otherwise ->
        nil
    end)
  end
end
