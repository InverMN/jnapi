defmodule JNApi.Repo do
  use Ecto.Repo,
    otp_app: :jnapi,
    adapter: Ecto.Adapters.Postgres
end
