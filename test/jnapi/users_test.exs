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
        |> Users.put_refresh_token()

      refresh_token
    end

    test "put_refresh_token/1 with valid data creates a refresh_token" do
      assert {:ok, %RefreshToken{} = refresh_token} = Users.put_refresh_token(@valid_attrs)
      assert refresh_token.jti == "321"
    end

    test "create_refresh_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.put_refresh_token(@invalid_attrs)
    end

    test "refresh_token_used?/1 when token used returns true" do
      {:ok, %RefreshToken{} = refresh_token} = Users.put_refresh_token(@valid_attrs)
      assert true = Users.refresh_token_used?(refresh_token.jti)
    end

    test "refresh_token_used?/1 when token not used returns false" do
      assert not Users.refresh_token_used?("adwojwadj2e2dj")
    end
  end
end
