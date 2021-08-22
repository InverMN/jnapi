defmodule JNApiWeb.Api.V1.TaskController do
  use JNApiWeb, :controller

  alias JNApi.Tasks
  alias JNApi.Tasks.Task

  action_fallback JNApiWeb.FallbackController

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> json(%{data: task})
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    json(conn, %{data: task})
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      json(conn, %{data: task})
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)

    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      Plug.Conn.send_resp(conn, 204, "")
    end
  end
end
