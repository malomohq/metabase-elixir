defmodule Metabase.Opts do
  @moduledoc """
  Configuration needed by the HTTP client.
  """

  alias Metabase.{HTTP}

  @type t ::
          %__MODULE__{
            client: module,
            client_opts: keyword,
            headers: HTTP.headers_t(),
            host: String.t(),
            json_codec: module,
            path: String.t(),
            port: pos_integer,
            protocol: String.t(),
            retry: boolean | module,
            retry_opts: keyword,
            session: String.t()
          }

  defstruct client: HTTP.Hackney,
            client_opts: [],
            headers: [],
            host: "metabase.com",
            json_codec: Jason,
            path: "/api",
            port: nil,
            protocol: "https",
            retry: false,
            retry_opts: [],
            session: nil

  @doc """
  Builds a `Metabase.Opts` struct.

  Any options passed into this function will override struct defaults.
  """
  @spec new(keyword) :: t
  def new(opts) do
    struct!(__MODULE__, Enum.into(opts, %{}))
  end
end
