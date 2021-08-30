defmodule JNApiWeb.Api.V1.TaskListController do
  use JNApiWeb, :controller

  alias JNApi.Tasks
  alias JNApi.Tasks.TaskList

  action_fallback JNApiWeb.FallbackController

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"task_list" => task_list_params}) do
    with {:ok, %TaskList{} = task_list} <- Tasks.create_task_list(task_list_params) do
      conn
      |> put_status(:created)
      |> json(%{data: task_list})
    end
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    task_list = Tasks.get_task_list!(id)
    json(conn, %{data: task_list})
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "task_list" => task_list_params}) do
    task_list = Tasks.get_task_list!(id)

    with {:ok, %TaskList{} = task_list} <- Tasks.update_task_list(task_list, task_list_params) do
      json(conn, %{data: task_list})
    end
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    task_list = Tasks.get_task_list!(id)

    with {:ok, %TaskList{}} <- Tasks.delete_task_list(task_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
