defmodule RecommendersWeb.PageControllerTest do
  use RecommendersWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Recommenders!"
  end
end
