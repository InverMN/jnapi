defmodule JNApi.TasksTest do
  use JNApi.DataCase, async: true

  alias JNApi.Tasks

  describe "tasks" do
    alias JNApi.Tasks.Task

    @valid_attrs %{is_completed: true, title: "some title"}
    @update_attrs %{is_completed: false, title: "some updated title"}
    @invalid_attrs %{is_completed: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Tasks.create_task(@valid_attrs)
      assert task.is_completed == true
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.is_completed == false
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end

  end

  describe "task_lists" do
    alias JNApi.Tasks.TaskList

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def task_list_fixture(attrs \\ %{}) do
      {:ok, task_list} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tasks.create_task_list()

      task_list
    end

    test "list_task_lists/0 returns all task_lists" do
      task_list = task_list_fixture()
      assert Tasks.list_task_lists() == [task_list]
    end

    test "get_task_list!/1 returns the task_list with given id" do
      task_list = task_list_fixture()
      assert Tasks.get_task_list!(task_list.id) == task_list
    end

    test "create_task_list/1 with valid data creates a task_list" do
      assert {:ok, %TaskList{} = task_list} = Tasks.create_task_list(@valid_attrs)
      assert task_list.title == "some title"
    end

    test "create_task_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task_list(@invalid_attrs)
    end

    test "update_task_list/2 with valid data updates the task_list" do
      task_list = task_list_fixture()
      assert {:ok, %TaskList{} = task_list} = Tasks.update_task_list(task_list, @update_attrs)
      assert task_list.title == "some updated title"
    end

    test "update_task_list/2 with invalid data returns error changeset" do
      task_list = task_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task_list(task_list, @invalid_attrs)
      assert task_list == Tasks.get_task_list!(task_list.id)
    end

    test "delete_task_list/1 deletes the task_list" do
      task_list = task_list_fixture()
      assert {:ok, %TaskList{}} = Tasks.delete_task_list(task_list)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task_list!(task_list.id) end
    end

    test "change_task_list/1 returns a task_list changeset" do
      task_list = task_list_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task_list(task_list)
    end
  end
end
