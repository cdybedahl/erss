defmodule Erss.ReadingList do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Erss.Repo

  schema "reading_list" do
    field(:read, :boolean, default: false)
    belongs_to :user, Erss.Users.User
    belongs_to :fic, Erss.Fic

    timestamps()
  end

  def is_read(fic, user) do
    from(r in Erss.ReadingList,
      where: r.fic_id == ^fic.id and r.user_id == ^user.id,
      select: r.read
    )
    |> Repo.one()
  end

  def set_read(fic, user, state) do
    from(r in Erss.ReadingList,
      where: r.fic_id == ^fic.id and r.user_id == ^user.id
    )
    |> Repo.one()
    |> case do
      nil ->
        %__MODULE__{read: state, fic_id: fic.id, user_id: user.id} |> Repo.insert!()

      r ->
        change(r, read: state) |> Repo.update!()
    end
  end
end
