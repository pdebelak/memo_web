defmodule MemoWeb.User do
  use MemoWeb.Web, :model

  @required_fields [:email, :password, :password_confirmation]
  @optional_fields []

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def authenticate(params) do
    case check_password(MemoWeb.UserStorage.by_email(params["email"]), params) do
      {:ok, user} -> {:ok, user}
      {:error} ->
        changeset = changeset(%__MODULE__{}, params)
        {:error, %{changeset | action: :authenticate}}
    end
  end

  def name(user) do
    String.replace(user.email, ~r/@.*/, "")
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> hash_password()
    |> unique_constraint(:email)
  end

  defp hash_password(%{valid?: false} = changeset), do: changeset
  defp hash_password(%{valid?: true} = changeset) do
    hashedpw = Comeonin.Bcrypt.hashpwsalt(Ecto.Changeset.get_field(changeset, :password))
    Ecto.Changeset.put_change(changeset, :password_hash, hashedpw)
  end

  defp check_password(nil, _params), do: {:error}
  defp check_password(user, params) do
    if Comeonin.Bcrypt.checkpw(params["password"], user.password_hash) do
      {:ok, user}
    else
      {:error}
    end
  end
end
