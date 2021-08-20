defmodule JNApi.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

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
