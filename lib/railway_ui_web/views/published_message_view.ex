defmodule RailwayUiWeb.PublishedMessageView do
  use RailwayUiWeb, :view
  import RailwayUiWeb.MessageViewHelper

  def pagination_params(%{value: nil}, page_num) do
    %{page: page_num}
  end

  def pagination_params(search_params, page_num) do
    Map.merge(%{search: Map.from_struct(search_params)}, %{page: page_num})
  end
end
