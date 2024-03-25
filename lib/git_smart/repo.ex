defmodule GitSmart.Repo do
  use Ecto.Repo,
    otp_app: :git_smart,
    adapter: Ecto.Adapters.Postgres
end
