defmodule JNApiWeb.Plug.AuthTest do
  use JNApiWeb.ConnCase, async: true
  doctest JNApiWeb.Plug.Auth

  alias JNApiWeb.{Plug.Auth, Endpoint}
  alias JNApi.{Repo, Users.User}

  @pow_config [otp_app: :jnapi]

  setup %{conn: conn} do
    conn = %{conn | secret_key_base: Endpoint.config(:secret_key_base)}
    user = Repo.insert!(%User{id: 1, email: "test@example.com", name: "John Doe"})

    {:ok, conn: conn, user: user}
  end

  test "can create, fetch, renew, and delete session", %{conn: conn, user: user} do
    assert {_no_auth_conn, nil} = Auth.fetch(conn, @pow_config)

    assert {%{private: %{api_access_token: access_token, api_refresh_token: refresh_token}}, ^user} =
        Auth.create(conn, user, @pow_config)

    :timer.sleep(100)

    assert {_conn, ^user} = Auth.fetch(with_auth_header(conn, access_token), @pow_config)
    assert {%{private: %{api_access_token: new_access_token, api_refresh_token: new_refresh_token}}, ^user} =
      Auth.renew(with_auth_header(conn, refresh_token), @pow_config)

    :timer.sleep(100)

    assert {_conn, _user} = Auth.fetch(with_auth_header(conn, access_token), @pow_config)
    assert {_conn, nil} = Auth.renew(with_auth_header(conn, refresh_token), @pow_config)
    assert {_conn, ^user} = Auth.fetch(with_auth_header(conn, new_access_token), @pow_config)

    Auth.delete(with_auth_header(conn, new_refresh_token), @pow_config)
    :timer.sleep(100)

    assert {_conn, _user} = Auth.fetch(with_auth_header(conn, new_access_token), @pow_config)
    assert {_conn, nil} = Auth.renew(with_auth_header(conn, new_refresh_token), @pow_config)
  end

  defp with_auth_header(conn, token), do: Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
end
