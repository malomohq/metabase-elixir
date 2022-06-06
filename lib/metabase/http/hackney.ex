defmodule Metabase.HTTP.Hackney do
  @moduledoc """
  HTTP client adapter for Hackney.

  Hackney is a simple HTTP client for Erlang. For more details about Hackney
  [check out their documentation on HexDocs][1].

  [1]: https://hexdocs.pm/hackney/
  """

  alias Metabase.{HTTP}

  @behaviour HTTP

  @impl true
  def send(request, opts) do
    case do_send(request, opts) do
      {:ok, status_code, headers} ->
        response =
          %HTTP.Response{}
          |> Map.put(:body, "")
          |> Map.put(:headers, headers)
          |> Map.put(:status_code, status_code)

        {:ok, response}

      {:ok, status_code, headers, body} ->
        response =
          %HTTP.Response{}
          |> Map.put(:body, body)
          |> Map.put(:headers, headers)
          |> Map.put(:status_code, status_code)

        {:ok, response}

      otherwise ->
        otherwise
    end
  end

  defp do_send(request, opts) do
    opts = opts.client_opts ++ [:with_body]

    :hackney.request(
      request.method,
      request.url,
      request.headers,
      request.body,
      opts
    )
  end
end
