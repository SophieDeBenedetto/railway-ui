defmodule RailwayUiWeb.PublishedMessageLive.Index do
  alias RailwayUiWeb.PublishedMessageLive.Index.Data
  @railway_ipc Application.get_env(:railway_ui, :railway_ipc, RailwayIpc)

  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(RailwayUiWeb.PublishedMessageView, "index.html", assigns)
  end

  def mount(%{current_user_uuid: current_user_uuid}, socket) do
    socket =
      socket
      |> assign(:messages, Data.load_messages())
      |> assign(:data, Data.new(current_user_uuid))

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def handle_params(
        %{"page" => page_num},
        _uri,
        %{assigns: %{data: data}} = socket
      ) do
    socket =
      socket
      |> assign(:messages, Data.messages_page(page_num))
      |> assign(:data, Data.set_page(data, page_num))
    {:noreply, socket}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "republish",
        %{"message_uuid" => message_uuid},
        %{assigns: %{data: data}} = socket
      ) do
    case @railway_ipc.republish_message(message_uuid, Data.request_data(data)) do
      :ok ->
        {:noreply, assign(socket, :data, Data.flash_success(data, message_uuid))}

      {:error, error} ->
        {:noreply, assign(socket, :data, Data.flash_error(data, message_uuid, error))}
    end
  end
end