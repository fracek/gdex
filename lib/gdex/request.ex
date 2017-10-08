defmodule Gdex.Request do

  defstruct [
    method: nil,
    path: "/",
    body: "",
    params: [],
    headers: [],
    paginated: false,
  ]

  @type t :: %__MODULE__{}

  @spec new(atom, binary, Keyword.t) :: Gdex.Request.t
  def new(method, path, data \\ []) do
    %Gdex.Request{
      method: Atom.to_string(method),
      path: path,
      body: data[:body] || "",
      params: data[:params] || [],
      headers: data[:headers] || [],
      paginated: data[:paginated] || false,
    }
  end

  @spec request(Gdex.Request.t, Gdex.Config.t) :: {:ok, term} | {:error, term}
  def request(%__MODULE__{method: method, body: body, paginated: false} = request, config) do
    url = make_url(request, config)
    headers = make_headers(request, config)
    case do_request(method, url, body, headers) do
      {:ok, {body, _}} -> {:ok, body}
      {:error, reason} -> {:error, reason}
    end
  end
  def request(%__MODULE__{paginated: true} = request, config) do
    try do
      response = stream!(request, config) |> Enum.to_list
      {:ok, response}
    rescue
      e -> {:error, e}
    end
  end

  def stream!(request, config) do
    Stream.resource(
      fn -> perform_paginated_request(request, config) end,
      &process_page/1,
      fn _ -> nil end
    )
  end

  @doc false
  def make_headers(%__MODULE__{method: method, body: body, headers: headers} = request, config) do
    path = make_path(request)
    {:ok, auth_headers} = Gdex.Auth.auth_headers(config, method, path, body)

    ["Content-Type": "application/json"]
    |> Keyword.merge(headers)
    |> Keyword.merge(auth_headers)
  end

  @doc false
  def make_url(request, config) do
    url = if String.ends_with?(config[:rest_url], "/") do
      String.slice(config[:rest_url], 0..-2)
    else
      config[:rest_url]
    end
    url <> make_path(request)
  end

  @doc false
  def make_path(%__MODULE__{path: path, params: params}) do
    if not Enum.empty?(params) do
      path <> "?" <> URI.encode_query(params)
    else
      path
    end
  end

  defp do_request(method, url, body, headers) do
    case HTTPoison.request(method, url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: headers}} ->
	body = Poison.decode!(body)
	{:ok, {body, headers}}
      {:ok, %HTTPoison.Response{body: body}} ->
	body = Poison.decode!(body)
	{:error, {:gdax, body["message"]}}
      {:error, %HTTPoison.Error{reason: reason}} ->
	{:error, {:httpoison, reason}}
    end
  end

  defp perform_paginated_request(%__MODULE__{method: method, body: body} = request, config) do
    url = make_url(request, config)
    headers = make_headers(request, config)
    do_perform_paginated_request(request, config, method, url, body, headers)
  end

  defp perform_paginated_request(%__MODULE__{method: method, body: body, params: params} = request, config, cb_after) do
    new_params = Keyword.put_new(params, :after, cb_after)
    new_request = Map.put(request, :params, new_params)
    url = make_url(new_request, config)
    headers = make_headers(new_request, config)
    do_perform_paginated_request(request, config, method, url, body, headers)
  end

  defp do_perform_paginated_request(original_request, config, method, url, body, headers) do
    case do_request(method, url, body, headers) do
      {:ok, {body, headers}} ->
	cb_after = Map.new(headers) |> Map.get("cb-after")
	{body, {original_request, config, cb_after}}
      {:error, {:gdax, message}} ->
	raise Gdex.Error, message
      {:error, {:httpoison, reason}} ->
	raise Gdex.Error, "#{inspect reason}"
    end
  end

  defp process_page({nil, {_, _, nil}}) do
    {:halt, nil}
  end

  defp process_page({nil, {request, config, cb_after}}) do
    perform_paginated_request(request, config, cb_after)
    |> process_page
  end

  defp process_page({items, {request, config, cb_after}}) do
    {items, {nil, {request, config, cb_after}}}
  end
end
