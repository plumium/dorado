defmodule Dorado.Repo do
  use Ecto.Repo,
    otp_app: :dorado,
    adapter: Ecto.Adapters.Postgres
end
