defmodule ErssWeb.Router do
  use ErssWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowPersistentSession]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fix_initial_session
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

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_assent_routes()
    pow_extension_routes()
  end

  scope "/", ErssWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
    get "/page/:page", PageController, :index
    get "/by_tag/:id/:page", PageController, :by_tag
    post "/page/sort_by", PageController, :sort_by
    get "/search", PageController, :search
    get "/to_read/:page", PageController, :to_read

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

  def fix_initial_session(conn, _opts) do
    conn =
      case get_session(conn, :sort_by) do
        nil ->
          put_session(conn, :sort_by, "rating")

        _ ->
          conn
      end

    case get_session(conn, :show_minimum) do
      nil ->
        put_session(conn, :show_minimum, 0)

      _ ->
        conn
    end
  end
end
