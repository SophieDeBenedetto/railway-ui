defmodule RailwayUiWeb.PublishedMessageLive.IndexTest do
  use Phoenix.ConnTest
  import Mox
  import Phoenix.LiveViewTest
  import RailwayUi.Factory
  import Plug.Test, only: [init_test_session: 2]
  use RailwayUiWeb.ConnCase
  @endpoint RailwayUiWeb.Endpoint

  setup :set_mox_global

  setup do
    current_user_uuid = Ecto.UUID.generate()

    published_messages =
      Enum.map(0..10, fn _num ->
        build(:published_message)
      end)

    RailwayUi.PersistenceMock
    |> stub(:get_published_messages, fn _params ->
      published_messages
    end)

    RailwayUi.PersistenceMock
    |> stub(:published_messages_count, fn ->
      10
    end)

    conn =
      build_conn()
      |> init_test_session(%{current_user_uuid: current_user_uuid})

    {:ok, view, html} = live(conn, "/published_messages")

    [
      view: view,
      html: html,
      published_messages: published_messages,
      current_user_uuid: current_user_uuid
    ]
  end

  test "connected mount", %{html: html} do
    assert html =~ "Published Messages"
  end

  test "republish message", %{
    view: view,
    published_messages: published_messages,
    current_user_uuid: current_user_uuid
  } do
    published_message_uuid = List.first(published_messages).uuid

    RailwayIpcMock
    |> expect(:republish_message, fn ^published_message_uuid,
                                     %{
                                       correlation_id: _correlation_id,
                                       current_user: %{learn_uuid: ^current_user_uuid}
                                     } ->
      :ok
    end)

    html = render_click(view, :republish, %{"message_uuid" => published_message_uuid})
    assert html =~ "Successfully republished message"
  end

  test "it paginates", %{html: html, view: view, published_messages: published_messages} do
    assert html != Enum.at(published_messages, 2).uuid
    assert html != Enum.at(published_messages, 3).uuid
    html = render_live_link(view, "/published_messages?page=2")
    assert html =~ Enum.at(published_messages, 2).uuid
    assert html =~ Enum.at(published_messages, 3).uuid
  end

  #
  # test "it searches by UUID", %{
  #   view: view,
  #   core_cohort: core_cohort,
  #   second_core_cohort: second_core_cohort
  # } do
  #   html = render_submit(view, :uuid_search, %{uuid: core_cohort.uuid})
  #   assert html =~ core_cohort.uuid
  #   refute html =~ second_core_cohort.uuid
  # end
end
