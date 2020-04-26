defmodule RailwayUiWeb.RouterForwarding do
  use RailwayUiWeb, :router
  defmacro live_messages(path, opts \\ []) do
    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        import Phoenix.LiveView.Router, only: [live: 4]
        live "/published_messages", RailwayUiWeb.MessageLive.Index
      end
    end
  end
end
