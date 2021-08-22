defmodule JNApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, except: [:__meta__]}
  schema "tasks" do
    field :is_completed, :boolean, default: false
    field :title, :string, default: "Unnamed"
 
    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :is_completed])
    |> validate_required([:title, :is_completed])
    |> validate_length(:title, min: 2, max: 32)
  end
end
