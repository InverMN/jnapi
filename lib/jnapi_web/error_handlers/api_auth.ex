defmodule JNApiWeb.ErrorHandler.Auth do
  use JNApiWeb, :controller
  alias Plug.Conn

  def call(conn, :not_authenticated),
    do: response(conn, "Not authenticated")

  def call(conn, :token_expired),
    do: response(conn, "Token expired")

  def call(conn, :invalid_token_use),
    do: response(conn, "Invalid token use")

  defp response(conn, reason) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: reason}})
  end
end
