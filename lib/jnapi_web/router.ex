defmodule JNApiWeb.Router do
  use JNApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug JNApiWeb.Plug.Auth, otp_app: :jnapi
    plug Accent.Plug.Response,
      default_case: Accent.Case.Camel,
      header: "name-case",
      json_codec: Jason
  end

  scope "/api", JNApiWeb do
    pipe_through :api
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: JNApiWeb.ErrorHandler.Auth
  end

  scope "/api/v1", JNApiWeb.Api.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    post "/token/create", TokenController, :create
    post "/token/refresh", TokenController, :refresh
    delete "/auth/delete", TokenController, :logout
  end

  scope "/api/v1", JNApiWeb.Api.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    resources "/tasks", TaskController, except: [:index, :edit, :new]
    resources "/task_lists", TaskListController, except: [:index, :edit, :new]
  end

  scope "/api/v1/accounts", JNApiWeb.Api.V1, as: :api_v1_accounts do
    pipe_through [:api, :api_protected]

    get "/owned", AccountController, :owned
  end
end
