defmodule MemoWeb.GuardianSerializer do
  @behaviour Guardian.Serializer

  @user_storage Application.get_env(:memo_web, MemoWeb)[:user_storage]

  def for_token(user = %MemoWeb.User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, @user_storage.find(id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
