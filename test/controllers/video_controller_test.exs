defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: "max")
      conn = assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "max"
  test "List all user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "stupid cats")
    other_video = insert_video(user, title: "another video")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    assert String.contains?(conn.resp_body, other_video.title)
  end

  test "requires auth on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      get(conn, video_path(conn, :create, %{})),
      get(conn, video_path(conn, :update, "123", %{})),
      get(conn, video_path(conn, :delete, "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
