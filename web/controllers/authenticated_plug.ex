defmodule MemoWeb.AuthenticatedPlug do
  use Plug.Builder

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def unauthenticated(conn, params) do
    unauthenticated(conn, params, "Not authorized")
  end

  def unauthenticated(conn, _params, message) do
    conn
    |> put_status(401)
    |> Phoenix.Controller.put_flash(:error, message)
    |> Phoenix.Controller.redirect(to: "/")
  end
end
