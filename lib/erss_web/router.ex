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
    get "/page/:page", PageController, :index

    get "/tag/:type/:page", TagController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ErssWeb do
    pipe_through :api

    post "/up/:id", ApiController, :up
    post "/down/:id", ApiController, :down
  end
end
