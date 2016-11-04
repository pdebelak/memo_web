defmodule MemoWeb.Users.Authentication do
  @behaviour Guardian.Serializer

  alias MemoWeb.User
  alias MemoWeb.Users.Storage

  def changeset(params \\ %{}) do
    Ecto.Changeset.cast(%User{}, params, [:email, :password])
  end

  def authenticate(%{ "email" => email, "password" => password } = params) do
    case check_password(Storage.by_email(email), password) do
      {:ok, user} -> {:ok, user}
      {:error} ->
        {:error, %{changeset(params) | action: :authenticate}}
    end
  end

  defp check_password(nil, _password), do: {:error}
  defp check_password(user, password) do
    if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error}
    end
  end

  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def sign_in(conn, user), do: Guardian.Plug.sign_in(conn, user)
  def sign_out(conn), do: Guardian.Plug.sign_out(conn)

  # GuardianSerializer behaviour
  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }
  def from_token("User:" <> id), do: { :ok, Storage.find(id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
