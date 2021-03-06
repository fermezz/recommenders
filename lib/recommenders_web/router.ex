defmodule RecommendersWeb.Router do
  use RecommendersWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Recommenders.Context
  end

  scope "/", RecommendersWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: RecommendersWeb.Schema
    forward "/graphql", Absinthe.Plug, schema: RecommendersWeb.Schema
  end
end
