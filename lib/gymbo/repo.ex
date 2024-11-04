defmodule Gymbo.Repo do
  use Ecto.Repo,
    otp_app: :gymbo,
    adapter: Ecto.Adapters.Postgres
end
