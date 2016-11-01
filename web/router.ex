defmodule MemoWeb.Router do
  use MemoWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MemoWeb do
    pipe_through :browser # Use the default browser stack

    resources "/memos", MemoController, except: [:index]
    get "/register", UserController, :new
    post "/register", UserController, :create
    get "/settings", UserController, :edit
    put "/settings", UserController, :update
    resources "/users", UserController, only: [] do
      resources "/memos", MemoController, only: [:index]
    end
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/", MemoController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MemoWeb do
  #   pipe_through :api
  # end
end
