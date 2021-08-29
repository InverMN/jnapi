defmodule JNApiWeb.Api.V1.RegistrationControllerTest do
  use JNApiWeb.ConnCase, async: true

  @password "secret1234"

  setup %{conn: conn} do
    conn = put_req_header(conn, "name-case", "snake")
    {:ok, conn: conn}
  end

  describe "create/2" do
    @valid_params %{"user" => %{"name" => "John Doe", "email" => "john.doe@example.com", "password" => @password, "password_confirmation" => @password}}
    @invalid_params %{"user" => %{"email" => "invalid", "password" => @password, "password_confirmation" => ""}}

    test "with valid params", %{conn: conn} do
      conn = post(conn, Routes.api_v1_registration_path(conn, :create, @valid_params))

      assert json = json_response(conn, 200)
      assert json["data"]["access_token"]
      assert json["data"]["refresh_token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, Routes.api_v1_registration_path(conn, :create, @invalid_params))

      assert json = json_response(conn, 500)
      assert json["error"]["message"] == "Couldn't create user"
      assert json["error"]["status"] == 500
      assert json["error"]["errors"]["password_confirmation"] == ["does not match confirmation"]
      assert json["error"]["errors"]["email"] == ["has invalid format"]
    end
  end
end
