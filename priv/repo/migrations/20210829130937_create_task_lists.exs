defmodule JNApi.Repo.Migrations.CreateTaskLists do
  use Ecto.Migration

  def change do
    create table(:task_lists) do
      add :title, :string

      timestamps()
    end

  end
end
