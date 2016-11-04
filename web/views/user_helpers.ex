defmodule MemoWeb.UserHelpers do
  def logged_in?(conn) do
    !!current_user(conn)
  end

  def current_user(conn) do
    MemoWeb.Users.Authentication.current_user(conn)
  end
end
