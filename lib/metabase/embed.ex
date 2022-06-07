defmodule Metabase.Embed do
  @moduledoc """
  Embeds allow you to fetch dashboards and cards from Metabase that can be
  embedded in other applications.

  ## JWT

  This module is responsible for building the URL path used to fetch the embeds.
  A token will automatically be generated for each endpoint that will
  authenticate the request with Metabase.

  ### Options

  Each function that builds an embed path can defined the following options:

  * `:expire_in` (required) - number of minutes the embed is valid for
  * `:secret_key` (required) - embedding secret key provided by Metabase

  Metabase also allows you to provide additional options that can be used
  to modify the look and feel of an embed.

  * `:bordered` - adds a visible border to the embed. Can be `true` or `false`.
  * `:theme` - shows the embed in dark mode. Can be `null` or `"night"`.
  * `:titled` - adds a title to the embed. Can be `true` or `false`.

  ### Example

      iex> Metabase.Embed.dashboard(999, %{account: "999"}, expire_in: 10, secret_key: "fakesecret", bordered: false)
      "/embed/dashboard/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NTQ2MjE4OTQsInBhcmFtcyI6eyJhY2NvdW50IjoiOTk5In0sInJlc291cmNlIjp7ImRhc2hib2FyZCI6OTk5fX0.gb4XlMdP6dFLAlVh3BLxjGL3ig96HlmtZ-EhyPbtSGU#bordered=false"
  """

  @type embed_opts_t ::
          [expire_in: pos_integer(), secret_key: String.t()]

  @type url_opts_t ::
          [bordered: boolean, theme: String.t(), titled: boolean]

  @doc """
  Path to pull a dashboard.
  """
  @spec dashboard(non_neg_integer, map, embed_opts_t | url_opts_t) :: String.t()
  def dashboard(dashboard_id, params, opts) do
    token =
      Map.new()
      |> Map.put(:resource, %{dashboard: dashboard_id})
      |> Map.put(:params, params)
      |> token(opts)

    "/embed/dashboard/" <> token <> url_query(opts)
  end

  defp url_query(opts) do
    url_opts = Keyword.take(opts, [:bordered, :theme, :titled])

    if Enum.empty?(url_opts) do
      ""
    else
      "#" <> URI.encode_query(url_opts)
    end
  end

  @doc """
  Creates a token used to authenticate an embed URL.
  """
  @spec token(Joken.claims(), Keyword.t()) :: String.t()
  def token(claims, opts) do
    verify_opts!(opts)

    claims = Map.put(claims, :exp, exp(opts))

    Joken.generate_and_sign!(%{}, claims, signer(opts))
  end

  defp exp(opts) do
    Joken.current_time() + 60 * opts[:expire_in]
  end

  defp signer(opts) do
    Joken.Signer.create("HS256", opts[:secret_key])
  end

  defp verify_opts!(opts) do
    opts
    |> verify_expire_in_opt!()
    |> verify_secret_key_opt!()
  end

  defp verify_expire_in_opt!(opts) do
    if Keyword.get(opts, :expire_in) do
      opts
    else
      raise ArgumentError, ":expire_in embed option is required"
    end
  end

  defp verify_secret_key_opt!(opts) do
    if Keyword.get(opts, :secret_key) do
      opts
    else
      raise ArgumentError, ":secret_key embed option is required"
    end
  end
end
