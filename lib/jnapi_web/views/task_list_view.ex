defmodule JNApiWeb.TaskListView do
  use JNApiWeb, :view
  alias JNApiWeb.TaskListView

  def render("index.json", %{task_lists: task_lists}) do
    %{data: render_many(task_lists, TaskListView, "task_list.json")}
  end

  def render("show.json", %{task_list: task_list}) do
    %{data: render_one(task_list, TaskListView, "task_list.json")}
  end

  def render("task_list.json", %{task_list: task_list}) do
    %{id: task_list.id,
      title: task_list.title}
  end
end
