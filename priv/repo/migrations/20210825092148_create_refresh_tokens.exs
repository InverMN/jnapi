defmodule JNApi.Repo.Migrations.CreateRefreshTokens do
  use Ecto.Migration

  def change do
    create table(:refresh_tokens) do
      add :jti, :string
    end
 
      create index("refresh_tokens", [:jti], unique: true, currently: true)
  end
end
