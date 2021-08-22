defmodule JNApiWeb.Api.V1.TaskControllerTest do
  use JNApiWeb.ConnCase, async: true

  alias JNApi.Tasks
  alias JNApi.Tasks.Task
  require Logger

  @create_attrs %{
    is_completed: true,
    title: "some title"
  }
  @update_attrs %{
    is_completed: false,
    title: "some updated title"
  }
  @invalid_attrs %{is_completed: nil, title: "loooooooooooooooooooooooooooooooooooooong"}

  def fixture(:task) do
    {:ok, task} = Tasks.create_task(@create_attrs)
    task
  end

  setup %{conn: conn} do
    conn = 
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("name-case", "snake")

    authed_conn = assign_user(conn)
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "create task" do
    test "renders task when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.api_v1_task_path(authed_conn, :create), task: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(authed_conn, Routes.api_v1_task_path(authed_conn, :show, id))
      assert %{
               "id" => id,
               "is_completed" => true,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: conn} do
      conn = post(conn, Routes.api_v1_task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup [:create_task]

    test "renders task when data is valid", %{authed_conn: authed_conn, task: %Task{id: id} = task} do
      conn = put(authed_conn, Routes.api_v1_task_path(authed_conn, :update, task), task: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(authed_conn, Routes.api_v1_task_path(authed_conn, :show, id))

      assert %{
               "id" => id,
               "is_completed" => false,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: conn, task: task} do
      conn = put(conn, Routes.api_v1_task_path(conn, :update, task), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{authed_conn: authed_conn, task: task} do
      conn = delete(authed_conn, Routes.api_v1_task_path(authed_conn, :delete, task))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        assert get(authed_conn, Routes.api_v1_task_path(authed_conn, :show, task))
      end
    end
  end

  defp create_task(_) do
    task = fixture(:task)
    %{task: task}
  end

  defp assign_user(conn) do
    user = %{id: 1}
    Pow.Plug.assign_current_user(conn, user, [])
  end
end
