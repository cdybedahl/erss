defmodule ErssWeb.Router do
  use ErssWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ErssWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/additional", AdditionalController, :index
    get "/author", AuthorController, :index
    get "/category", CategoryController, :index
    get "/character", CharacterController, :index
    get "/fandom", FandomController, :index
    get "/rating", RatingController, :index
    get "/relationship", RelationshipController, :index
    get "/warning", WarningController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ErssWeb do
  #   pipe_through :api
  # end
end
