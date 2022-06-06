defmodule Metabase.HTTP do
  alias Metabase.{HTTP, Request}

  @type headers_t ::
          [{String.t(), String.t()}]

  @type method_t ::
          :delete | :get | :head | :patch | :post | :put

  @type response_t ::
          {:ok, HTTP.Response.t()} | {:error, any}

  @type status_code_t ::
          pos_integer

  @callback send(Request.t(), any) ::
              response_t
end
