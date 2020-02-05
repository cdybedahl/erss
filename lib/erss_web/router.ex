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

    get "/fic", FicController, :index
    get "/fic/:page", FicController, :index

    get "/additional/:id/:page", AdditionalController, :list
    get "/additional", AdditionalController, :index
    post "/additional/:id/uprate/:amount", AdditionalController, :uprate
    post "/additional/:id/downrate/:amount", AdditionalController, :downrate

    get "/author/:id/:page", AuthorController, :list
    get "/author", AuthorController, :index
    post "/author/:id/uprate/:amount", AuthorController, :uprate
    post "/author/:id/downrate/:amount", AuthorController, :downrate

    get "/category/:id/:page", CategoryController, :list
    get "/category", CategoryController, :index
    post "/category/:id/uprate/:amount", CategoryController, :uprate
    post "/category/:id/downrate/:amount", CategoryController, :downrate

    get "/character/:id/:page", CharacterController, :list
    get "/character", CharacterController, :index
    post "/character/:id/uprate/:amount", CharacterController, :uprate
    post "/character/:id/downrate/:amount", CharacterController, :downrate

    get "/fandom/:id/:page", FandomController, :list
    get "/fandom", FandomController, :index
    post "/fandom/:id/uprate/:amount", FandomController, :uprate
    post "/fandom/:id/downrate/:amount", FandomController, :downrate

    get "/rating/:id/:page", RatingController, :list
    get "/rating", RatingController, :index
    post "/rating/:id/uprate/:amount", RatingController, :uprate
    post "/rating/:id/downrate/:amount", RatingController, :downrate

    get "/relationship/:id/:page", RelationshipController, :list
    get "/relationship", RelationshipController, :index
    post "/relationship/:id/uprate/:amount", RelationshipController, :uprate
    post "/relationship/:id/downrate/:amount", RelationshipController, :downrate

    get "/warning/:id/:page", WarningController, :list
    get "/warning", WarningController, :index
    post "/warning/:id/uprate/:amount", WarningController, :uprate
    post "/warning/:id/downrate/:amount", WarningController, :downrate
  end

  # /api/rating/4/downrate/1
  scope "/api", ErssWeb do
    pipe_through :api

    post "/:type/:id/:direction/:amount", ApiController, :tagrating
  end
end
