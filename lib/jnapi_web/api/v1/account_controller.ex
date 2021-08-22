defmodule JNApiWeb.Api.V1.AccountController do
  use JNApiWeb, :controller
  
  import Ecto.Query, only: [from: 2]
  alias JNApi.Users.User
  import Ecto.Query
  alias JNApi.Repo
  require Logger

  def owned(conn, _) do
    user = Pow.Plug.current_user(conn)
    Logger.debug(inspect user)
    json(conn, user)
  end
end
