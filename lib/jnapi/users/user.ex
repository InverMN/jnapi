defmodule JNApi.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  @derive {Jason.Encoder, except: [:__meta__, :current_password, :password, :password_hash]}
  schema "users" do
    pow_user_fields()

    field :name, :string

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:name])
    |> Ecto.Changeset.validate_required([:name])
  end
end
