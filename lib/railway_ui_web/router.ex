defmodule RailwayUiWeb.Router do
  use RailwayUiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
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
    live "/published_messages", MessageLive.Index, session: [:current_user_uuid], name: "Sophie"
    live "/consumed_messages", MessageLive.Index, session: [:current_user_uuid]
    # live "/published_messages", PublishedMessageLive.Index, session: [:current_user_uuid]
    # live "/consumed_messages", ConsumedMessageLive.Index, session: [:current_user_uuid]
  end
end
