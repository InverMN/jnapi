defmodule JNApiWeb.Api.V1.TokenController do
  use JNApiWeb, :controller

  alias JNApiWeb.Plug.Auth
  alias Plug.Conn

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        json(conn, %{data: %{access_token: conn.private.api_access_token, refresh_token: conn.private.api_refresh_token}})

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  @spec refresh(Conn.t(), map()) :: Conn.t()
  def refresh(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> Auth.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{data: %{access_token: conn.private.api_access_token, refresh_token: conn.private.api_refresh_token}})
    end
  end

  @spec logout(Conn.t(), map()) :: Conn.t()
  def logout(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{}})
  end
end
