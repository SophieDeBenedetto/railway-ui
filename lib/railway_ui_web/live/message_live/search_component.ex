defmodule RailwayUiWeb.MessageLive.SearchComponent do
  use Phoenix.LiveComponent

  alias RailwayUiWeb.MessageLive.Index.Search

  def update(assigns, socket) do
    socket =
      socket
      |> assign(:search, %Search{})
      |> assign(:view, assigns.view)
    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.MessageView, "search_component.html", assigns)
  end
  def handle_event("search", params, socket) do
    send self(), {:search, params}
    {:noreply, socket}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "value"], "search" => %{"value" => value}},
        %{assigns: %{search: search}} = socket
      ) do
    {:noreply, assign(socket, :search, %Search{query: search.query, value: value})}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"query" => query}},
        %{assigns: %{search: search}} = socket
      ) do
    {:noreply, assign(socket, :search, %Search{query: query, value: search.value})}
  end

  def handle_event(
        "search_form_change",
        %{"_target" => ["search", "query"], "search" => %{"value" => _value}},
        socket
      ) do
    {:noreply, socket}
  end
end
