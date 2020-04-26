defmodule RailwayUiWeb.MessageLive.Index do
  alias RailwayUiWeb.MessageLive.Index.State
  alias RailwayUiWeb.Router.Helpers, as: Routes
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.MessageView, "index.html", assigns)
  end

  def mount(_params, %{current_user_uuid: current_user_uuid} = _session, socket) do
    IO.puts "CURRENT USER"
    IO.puts current_user_uuid
    socket =
      socket
      |> assign(:state, State.new(current_user_uuid))
      |> assign(:messages, [])
    {:ok, socket}
  end

  def mount(_params, session, socket) do
    IO.puts "SESSION"
    IO.inspect session
    socket =
      socket
      |> assign(:state, State.new("12345"))
      |> assign(:messages, [])
    {:ok, socket}
  end

  # def handle_params(%{}, uri, %{assigns: %{state: state}} = socket) do
  #   %{path: "/" <> message_type} = URI.parse(uri)
  #     state = State.new(state, message_type)
  #   socket =
  #     socket
  #     |> assign(:state, state)
  #     |> assign(:messages, State.load_messages(state))
  #
  #   {:noreply, socket}
  # end
  #
  # def handle_params(
  #       %{"page" => page_num, "search" => %{"query" => query, "value" => value}},
  #       uri,
  #       %{assigns: %{state: state}} = socket
  #     ) do
  #   %{path: "/" <> message_type} = URI.parse(uri)
  #   state = State.new(state, message_type, page_num)
  #   socket =
  #     socket
  #     |> assign(:state, State.for_search(state, query, value, page_num))
  #     |> assign(:messages, State.messages_search(state, query, value, page_num))
  #
  #   {:noreply, socket}
  # end
  #
  # def handle_params(
  #       %{"page" => page_num},
  #       uri,
  #       %{assigns: %{state: state}} = socket
  #     ) do
  #   %{path: "/" <> message_type} = URI.parse(uri)
  #   state = State.new(state, message_type, page_num)
  #   socket =
  #     socket
  #     |> assign(:state, state)
  #     |> assign(:messages, State.messages_page(state, page_num))
  #
  #   {:noreply, socket}
  # end
  #
  # def handle_params(
  #       %{"search" => %{"query" => query, "value" => value}},
  #       uri,
  #       %{assigns: %{state: state}} = socket
  #     ) do
  #   %{path: "/" <> message_type} = URI.parse(uri)
  #   state = State.new(state, message_type)
  #   socket =
  #     socket
  #     |> assign(:state, State.for_search(state, query, value))
  #     |> assign(:messages, State.messages_search(state, query, value))
  #
  #   {:noreply, socket}
  # end
  # def handle_params(
  #       _params,
  #       uri,
  #       %{assigns: %{state: state}} = socket
  #     ) do
  #   %{path: "/" <> message_type} = URI.parse(uri)
  #   state = State.new(state, message_type)
  #   socket =
  #     socket
  #     |> assign(:state, state)
  #     |> assign(:messages, State.load_messages(state))
  #
  #   {:noreply, socket}
  # end

  def handle_event("search", params, socket) do
    {:noreply,
     live_redirect(socket,
       to: Routes.live_path(socket, __MODULE__, params)
     )}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "value"], "search" => %{"value" => value}},
        %{assigns: %{state: state}} = socket
      ) do
    {:noreply, assign(socket, :state, State.set_search_value(state, value))}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"query" => query}},
        %{assigns: %{state: state}} = socket
      ) do
    IO.puts "HERE"
    IO.inspect(socket.assigns.messages)
    {:noreply, assign(socket, :state, State.set_search_query(state, query))}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"value" => _value}},
        socket
      ) do
    {:noreply, socket}
  end
end
