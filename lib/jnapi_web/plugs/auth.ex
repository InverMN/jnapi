defmodule JNApiWeb.Plug.Auth do
  @moduledoc false

  alias Plug.Conn
  alias Pow.Config
  alias JNApi.Users
  alias JNApi.Users.User
  alias JNApi.Repo
  import Ecto.Query

  @doc """
  Fetches the user from access token.
  """
  @spec fetch(Conn.t(), Config.t()) :: {Conn.t(), map() | nil}
  def fetch(conn, _config) do
    with {:ok, token} <- fetch_token(conn),
         {:ok, %{"user_id" => user_id} = claims} <- verify_token(token),
         :ok <- has_use(claims, "access"),
         :ok <- has_not_expired(claims),
         user <- Repo.one!(from u in User, where: u.id == ^user_id) do
      {conn, user}
    else
      _any -> {conn, nil}
    end
  end

  @doc """
  Creates an access and refresh token for the user.

  The tokens are added to the `conn.private` as `:api_access_token` and
  `:api_refresh_token`. The refresh token is stored in the access token
  metadata and vice versa.
  """
  @spec create(Conn.t(), map(), Config.t()) :: {Conn.t(), map()}
  def create(conn, user, _config) do
    token_claims = %{user_id: user.id}
    conn =
      conn
      |> Conn.put_private(:api_access_token, sign_token!(:access_token, token_claims))
      |> Conn.put_private(:api_refresh_token, sign_token!(:refresh_token, token_claims))

    {conn, user}
  end

  @doc """
  The refresh token is deleted.
  """
  @spec delete(Conn.t(), Config.t()) :: Conn.t()
  def delete(conn, _config) do
    with {:ok, token} <- fetch_token(conn),
         {:ok, %{"jti" => jti, "exp" => exp}} <- verify_token(token),
         false <- Users.refresh_token_used?(jti) do
      Users.put_refresh_token(%{ jti: jti, exp: exp })
    else
      _any -> :ok
    end

    conn
  end

  @doc """
  Creates new tokens using the renewal token.

  The access token, if any, will be deleted by fetching it from the renewal
  token metadata. The renewal token will be deleted from the store after the
  it has been fetched.
  """
  @spec renew(Conn.t(), Config.t()) :: {Conn.t(), map() | nil}
  def renew(conn, config) do
    with {:ok, token} <- fetch_token(conn),
         {:ok, %{"jti" => jti, "exp" => exp, "user_id" => user_id} = claims} <- verify_token(token),
         :ok <- has_use(claims, "refresh"),
         :ok <- has_not_expired(claims),
         false <- Users.refresh_token_used?(jti),
         user <- Repo.one!(from u in User, where: u.id == ^user_id) do
      Users.put_refresh_token(%{ jti: jti, exp: exp })
      create(conn, user, config)
    else
      _any -> {conn, nil}
    end
  end

  defp sign_token!(token_type, extra_claims) do
    extra_claims = Map.put(extra_claims, :use, token_usage(token_type))
    extra_claims = Map.put(extra_claims, :exp, expiration_time(token_type))
    JNApi.Token.generate_and_sign!(extra_claims)
  end

  defp expiration_time(token_type) do
    case token_type do
      # 10 minutes
      :access_token -> :os.system_time(:second) + 60 * 10
      # 30 days
      :refresh_token -> :os.system_time(:second) + 60 * 60 * 24 * 30
    end
  end

  defp token_usage(token_type) do
    case token_type do
      :access_token -> "access"
      :refresh_token -> "refresh"
      _ -> "unknown"
    end
  end

  defp fetch_token(conn) do
    case Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token | _rest] -> {:ok, token}
      _any -> :error
    end
  end

  defp verify_token(token),
    do: JNApi.Token.verify_and_validate(token)

  defp has_use(%{"use" => given_use}, desired_use) do
    if given_use == desired_use do
      :ok
    else
      :invalid_token_use
    end
  end

  defp has_not_expired(%{"exp" => expire_time}) do
    if expire_time > :os.system_time(:second) do
      :ok
    else
      :token_expired
    end
  end
end
