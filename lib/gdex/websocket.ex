defmodule Gdex.Websocket do
  defdelegate start_link(handler, state, opts \\ []), to: Gdex.Websocket.Client

  defmacro __using__(_) do
    quote do
      import Gdex.Websocket.Subscribe
      import Gdex.Websocket.Unsubscribe

      def handle_connect(_gdax, state), do: {:ok, state}
      def handle_message(_message, _gdax, state), do: {:ok, state}
      def handle_disconnect(_reason_, _gdax, state), do: {:ok, state}
      def handle_info(_message, _gdax, state), do: {:ok, state}

      defoverridable [handle_connect: 2, handle_message: 3, handle_disconnect: 3, handle_info: 3]
    end
  end

  defmacro is_channel(channel) do
    quote do
      is_atom(unquote(channel)) or is_binary(unquote(channel))
    end
  end
end
