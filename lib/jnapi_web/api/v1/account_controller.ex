defmodule JNApiWeb.Api.V1.AccountController do
  use JNApiWeb, :controller
  
  import Ecto.Query, only: [from: 2]
  alias JNApi.Users.User

  def owned(conn, _) do
    user = Pow.Plug.current_user(conn)
    json(conn, %{id: user.id, email: user.email, name: user.name})
  end
end
