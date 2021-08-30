defmodule JNApiWeb.Api.V1.TaskListControllerTest do
  use JNApiWeb.ConnCase, async: true

  alias JNApi.Tasks
  alias JNApi.Tasks.TaskList

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  def fixture(:task_list) do
    {:ok, task_list} = Tasks.create_task_list(@create_attrs)
    task_list
  end

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    conn = put_req_header(conn, "name-case", "snake")
    authed_conn = Pow.Plug.assign_current_user(conn, %{id: 1}, [])
    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "create task_list" do
    test "renders task_list when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.api_v1_task_list_path(authed_conn, :create), task_list: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(authed_conn, Routes.api_v1_task_list_path(authed_conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.api_v1_task_list_path(authed_conn, :create), task_list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task_list" do
    setup [:create_task_list]

    test "renders task_list when data is valid", %{authed_conn: authed_conn, task_list: %TaskList{id: id} = task_list} do
      conn = put(authed_conn, Routes.api_v1_task_list_path(authed_conn, :update, task_list), task_list: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(authed_conn, Routes.api_v1_task_list_path(authed_conn, :show, id))

      assert %{
               "id" => id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, task_list: task_list} do
      conn = put(authed_conn, Routes.api_v1_task_list_path(authed_conn, :update, task_list), task_list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete task_list" do
    setup [:create_task_list]

    test "deletes chosen task_list", %{authed_conn: authed_conn, task_list: task_list} do
      conn = delete(authed_conn, Routes.api_v1_task_list_path(authed_conn, :delete, task_list))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.api_v1_task_list_path(authed_conn, :show, task_list))
      end
    end
  end

  defp create_task_list(_) do
    task_list = fixture(:task_list)
    %{task_list: task_list}
  end
end
