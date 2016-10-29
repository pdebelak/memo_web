defmodule MemoWeb.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias MemoWeb.UserStorage

  def for_token(user = %MemoWeb.User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, UserStorage.find(id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
