defmodule JNApi.UsersTest do
  use JNApi.DataCase

  alias JNApi.Users

  describe "refresh_tokens" do
    alias JNApi.Users.RefreshToken

    @valid_attrs %{jti: "some jti"}
    @update_attrs %{jti: "some updated jti"}
    @invalid_attrs %{jti: nil}

    def refresh_token_fixture(attrs \\ %{}) do
      {:ok, refresh_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_refresh_token()

      refresh_token
    end

    test "list_refresh_tokens/0 returns all refresh_tokens" do
      refresh_token = refresh_token_fixture()
      assert Users.list_refresh_tokens() == [refresh_token]
    end

    test "get_refresh_token!/1 returns the refresh_token with given id" do
      refresh_token = refresh_token_fixture()
      assert Users.get_refresh_token!(refresh_token.id) == refresh_token
    end

    test "create_refresh_token/1 with valid data creates a refresh_token" do
      assert {:ok, %RefreshToken{} = refresh_token} = Users.create_refresh_token(@valid_attrs)
      assert refresh_token.jti == "some jti"
    end

    test "create_refresh_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_refresh_token(@invalid_attrs)
    end

    test "update_refresh_token/2 with valid data updates the refresh_token" do
      refresh_token = refresh_token_fixture()
      assert {:ok, %RefreshToken{} = refresh_token} = Users.update_refresh_token(refresh_token, @update_attrs)
      assert refresh_token.jti == "some updated jti"
    end

    test "update_refresh_token/2 with invalid data returns error changeset" do
      refresh_token = refresh_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_refresh_token(refresh_token, @invalid_attrs)
      assert refresh_token == Users.get_refresh_token!(refresh_token.id)
    end

    test "delete_refresh_token/1 deletes the refresh_token" do
      refresh_token = refresh_token_fixture()
      assert {:ok, %RefreshToken{}} = Users.delete_refresh_token(refresh_token)
      assert_raise Ecto.NoResultsError, fn -> Users.get_refresh_token!(refresh_token.id) end
    end

    test "change_refresh_token/1 returns a refresh_token changeset" do
      refresh_token = refresh_token_fixture()
      assert %Ecto.Changeset{} = Users.change_refresh_token(refresh_token)
    end
  end
end
