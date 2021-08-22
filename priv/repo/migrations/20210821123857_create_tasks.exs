defmodule JNApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :is_completed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
