defmodule ErssWeb.Router do
  use ErssWeb, :router
  use Pow.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowPersistentSession]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session

    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  scope "/", ErssWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
    get "/page/:page", PageController, :index
    get "/by_tag/:id/:page", PageController, :by_tag
    post "/page/sort_by", PageController, :sort_by
    get "/search", PageController, :search

    get "/tag/:type/:page", TagController, :index

    get "/toplist", ToplistController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ErssWeb do
    pipe_through :api

    post "/up/:id", ApiController, :up
    post "/down/:id", ApiController, :down

    post "/find_tag", ApiController, :find_tag
    post "/set_read", ApiController, :set_read
  end
end
