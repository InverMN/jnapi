defmodule JNApiWeb.Api.V1.AccountController do
  use JNApiWeb, :controller

  def owned(conn, _) do
    user = Pow.Plug.current_user(conn)
    json(conn, user)
  end
end
