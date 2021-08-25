defmodule JNApi.Users do
  import Ecto.Query, warn: false
  alias JNApi.Repo

  alias JNApi.Users.RefreshToken
 
  def put_refresh_token(attrs \\ %{}) do
    %RefreshToken{}
    |> RefreshToken.changeset(attrs)
    |> Repo.insert()
  end

  def delete_expired_refresh_tokens() do
    current_time = :os.system_time(:second)
    from(t in RefreshToken, where: ^current_time > t.exp)
    |> Repo.delete_all
  end

  def refresh_token_used?(jti) do
    from(t in RefreshToken, where: t.jti == ^jti)
    |> Repo.exists?
  end
end
