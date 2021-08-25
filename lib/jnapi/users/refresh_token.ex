defmodule JNApi.Users.RefreshToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "refresh_tokens" do
    field :jti, :string
    field :exp, :integer
  end

  @doc false
  def changeset(refresh_token, attrs) do
    refresh_token
    |> cast(attrs, [:jti, :exp])
    |> validate_required([:jti, :exp])
  end
end
