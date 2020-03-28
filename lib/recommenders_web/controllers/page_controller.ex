defmodule RecommendersWeb.PageController do
  use RecommendersWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
