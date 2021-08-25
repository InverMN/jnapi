defmodule JNApi.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias JNApi.Repo

  alias JNApi.Users.RefreshToken

  @doc """
  Returns the list of refresh_tokens.

  ## Examples

      iex> list_refresh_tokens()
      [%RefreshToken{}, ...]

  """
  def list_refresh_tokens do
    Repo.all(RefreshToken)
  end

  @doc """
  Gets a single refresh_token.

  Raises `Ecto.NoResultsError` if the Refresh token does not exist.

  ## Examples

      iex> get_refresh_token!(123)
      %RefreshToken{}

      iex> get_refresh_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_refresh_token!(id), do: Repo.get!(RefreshToken, id)

  @doc """
  Creates a refresh_token.

  ## Examples

      iex> create_refresh_token(%{field: value})
      {:ok, %RefreshToken{}}

      iex> create_refresh_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_refresh_token(attrs \\ %{}) do
    %RefreshToken{}
    |> RefreshToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a refresh_token.

  ## Examples

      iex> update_refresh_token(refresh_token, %{field: new_value})
      {:ok, %RefreshToken{}}

      iex> update_refresh_token(refresh_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_refresh_token(%RefreshToken{} = refresh_token, attrs) do
    refresh_token
    |> RefreshToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a refresh_token.

  ## Examples

      iex> delete_refresh_token(refresh_token)
      {:ok, %RefreshToken{}}

      iex> delete_refresh_token(refresh_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_refresh_token(%RefreshToken{} = refresh_token) do
    Repo.delete(refresh_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking refresh_token changes.

  ## Examples

      iex> change_refresh_token(refresh_token)
      %Ecto.Changeset{data: %RefreshToken{}}

  """
  def change_refresh_token(%RefreshToken{} = refresh_token, attrs \\ %{}) do
    RefreshToken.changeset(refresh_token, attrs)
  end
end
