# Metabase

## Installation

`metabase` is published on [Hex](https://hex.pm/packages/metabase). Add it to
your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:metabase, "~> 0.1"}
  ]
end
```

## Usage

Requests can be made using the `send/2` function. This function accepts a
`Metabase.RequestOperation` struct as the first argument and a keyword list of
configuration options as the second argument.

### Example

      iex> %Metabase.RequestOperation{}
      ...> |> Map.put(:body, username: "person@mymetabase.com", password: "fakepassword")
      ...> |> Map.put(:method, :post)
      ...> |> Map.put(:path, "/session")
      ...> |> Metabase.send(host: "mymetabase.com/")
      {:ok, %Metabase.Response{}}

## Configuration

The `send/2` function takes a keyword list of configuration options as the
second argument. These provide the client with additional details needed to
make a request and various other options for how the client should process the
request and how it should behave.

### Options

- `:client` - HTTP client adapter used to make the request. Defaults to
  `Metabase.HTTP.Hackney`.
- `:client_opts` - Configuration options passed to the client adapter
- `:headers` - HTTP headers used when making a request
- `:host` - Hostname used when making a request. This field is required.
- `:json_codec` - Module used to encode and decode JSON. Defaults to `Jason`.
- `:path` - Base path used when building the URL to send a request to. Defaults
  to `/api`.
- `:port` - HTTP port used when making a request
- `:protocol` - HTTP protocol used when making a request
- `:retry` - Module implementing a request retry strategy. Disabled when set
  to `false`. Defaults to `false`.
- `:retry_opts` - Options used to control the behavior of the retry module
