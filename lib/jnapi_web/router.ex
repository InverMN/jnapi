defmodule JNApiWeb.Router do
  use JNApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug JNApiWeb.ApiAuthPlug, otp_app: :jnapi
  end

  scope "/api", JNApiWeb do
    pipe_through :api
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: JNApiWeb.APIAuthErrorHandler
  end

  scope "/api/v1", JNApiWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", JNApiWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]
  end
end
