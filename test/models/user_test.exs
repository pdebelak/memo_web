defmodule MemoWeb.UserTest do
  use MemoWeb.ModelCase

  alias MemoWeb.User

  @valid_attrs %{email: "sample@example.com", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "mis-matched password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{email: "sample@example.com",
      password: "1lh2bj1rjbk2",
      password_confirmation: "b1bk23jkn12"})
    refute changeset.valid?
  end

  test "missing password_confirmation is invalid" do
    changeset = User.changeset(%User{}, %{email: "sample@example.com",
      password: "1lh2bj1rjbk2"})
    refute changeset.valid?
  end

  test "short password is invalid" do
    changeset = User.changeset(%User{}, %{email: "sample@example.com",
      password: "1lh2d",
      password_confirmation: "1lh2d"})
    refute changeset.valid?
  end

  test "duplicate email is invalid" do
    firstChangeset = User.changeset(%User{}, @valid_attrs)
    Repo.insert!(firstChangeset)
    changeset = User.changeset(%User{}, %{email: "sample@example.com",
      password: "password2",
      password_confirmation: "password2"})
    {:error, changeset} = Repo.insert(changeset)
    assert length(changeset.errors) > 0
  end
end
