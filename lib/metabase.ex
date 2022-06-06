defmodule Metabase do
  @moduledoc """
  Client used to make HTTP requests.

  ## Making Requests

  Requests can be made using the `send/2` function. This function accepts a
  `Metabase.RequestOperation` struct as the first argument and a keyword list of
  configuration options as the second argument.

  ### Example

      iex> %Metabase.RequestOperation{}
      ...> |> Map.put(:body, username: "person@mymetabase.com", password: "fakepassword")
      ...> |> Map.put(:method, :post)
      ...> |> Map.put(:path, "/session")
      ...> |> Metabase.send(host: "mymetabase.com/api")
      {:ok, %Metabase.Response{}}

  ## Configuration

  The `send/2` function takes a keyword list of configuration options as the
  second argument. These provide the client with additional details needed to
  make a request and various other options for how the client should process the
  request and how it should behave.

  ### Options

  * `:client` - HTTP client adapter used to make the request. Defaults to
    `Metabase.HTTP.Hackney`.
  * `:client_opts` - Configuration options passed to the client adapter
  * `:headers` - HTTP headers used when making a request
  * `:host` - Hostname used when making a request. This field is required.
  * `:json_codec` - Module used to encode and decode JSON. Defaults to `Jason`.
  * `:port` - HTTP port used when making a request
  * `:protocol` - HTTP protocol used when making a request
  * `:retry` - Module implementing a request retry strategy. Disabled when set
    to `false`. Defaults to `false`.
  * `:retry_opts` - Options used to control the behavior of the retry module

  """

  alias Metabase.{HTTP, Opts, Request, Response}

  @type headers_t ::
          [{String.t(), String.t()}]

  @type method_t ::
          :delete | :get | :head | :patch | :post | :put

  @type response_t ::
          {:ok, Response.t()} | {:error, Response.t() | any}

  @type status_code_t ::
          pos_integer

  @doc """
  Send an HTTP request.
  """
  @spec send(
          RequestOperation.t(),
          keyword
        ) :: Response.t()
  def send(operation, old_opts) do
    opts = Opts.new(old_opts)

    request = Request.new(operation, opts)

    case opts.client.send(request, opts) do
      {:ok, %HTTP.Response{status_code: status_code} = response}
      when status_code >= 400 ->
        {:error, Response.new(response, opts)}

      {:ok, %HTTP.Response{status_code: status_code} = response}
      when status_code >= 200 ->
        {:ok, Response.new(response, opts)}

      otherwise ->
        otherwise
    end
  end
end
