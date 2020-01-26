defmodule Erss.Repo do
  use Ecto.Repo,
    otp_app: :erss,
    adapter: Ecto.Adapters.Postgres
end
