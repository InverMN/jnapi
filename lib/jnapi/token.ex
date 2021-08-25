defmodule JNApi.Token do
  use Joken.Config

  require Logger

  @impl true
  def token_config() do
    default_claims(skip: [:exp, :iss, :aud], iss: "JustNow API", aud: "JustNow API")
  end
end
