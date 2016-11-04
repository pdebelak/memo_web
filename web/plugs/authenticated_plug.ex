defmodule MemoWeb.AuthenticatedPlug do
  use Plug.Builder
  import Phoenix.Controller, only: [render: 4, put_flash: 3]

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def unauthenticated(conn, params) do
    unauthenticated(conn, params, "You must be logged in")
  end

  def unauthenticated(conn, _params, message) do
    conn
    |> put_status(401)
    |> put_flash(:error, message)
    |> render(MemoWeb.ErrorView, "401.html", [])
  end
end
