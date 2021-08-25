defmodule JNApi.UsersTest do
  use JNApi.DataCase

  alias JNApi.Users

  describe "refresh_tokens" do
    alias JNApi.Users.RefreshToken

    @valid_attrs %{jti: "321", exp: 123}
    @invalid_attrs %{jti: nil, exp: nil}

    def refresh_token_fixture(attrs \\ %{}) do
      {:ok, refresh_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_refresh_token()

      refresh_token
    end

    test "create_refresh_token/1 with valid data creates a refresh_token" do
      assert {:ok, %RefreshToken{} = refresh_token} = Users.create_refresh_token(@valid_attrs)
      assert refresh_token.jti == "321"
    end

    test "create_refresh_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_refresh_token(@invalid_attrs)
    end
  end
end
