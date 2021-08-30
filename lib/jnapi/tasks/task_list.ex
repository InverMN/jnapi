defmodule JNApi.Tasks.TaskList do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "task_lists" do
    field :title, :string, default: "Unnamed"

    timestamps()
  end

  @doc false
  def changeset(task_list, attrs) do
    task_list
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
