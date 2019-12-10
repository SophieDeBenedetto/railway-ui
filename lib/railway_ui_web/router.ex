defmodule RailwayUiWeb.Router do
  use RailwayUiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    if Mix.env() == :dev do
      plug(RailwayUiWeb.CurrentUser)
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RailwayUiWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/published_messages", PublishedMessageLive.Index, session: [:current_user_uuid]
    live "/consumed_messages", ConsumedMessageLive.Index, session: [:current_user_uuid]
  end

  def route_info(router, method, path, host) do
    split_segments =
      for segment <- String.split(path, "/"), segment != "", do: segment
    route = split_segments |> List.last()
    case router.__match_route__(method, [route], host) do
      {%{} = metadata, _prepare, _pipeline, {_plug, _opts}} -> Map.delete(metadata, :conn)
      :error -> :error
    end
  end
end
