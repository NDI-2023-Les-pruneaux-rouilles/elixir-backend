defmodule ElixirRoots.Repo do
  use Ecto.Repo,
    otp_app: :elixir_roots,
    adapter: Ecto.Adapters.SQLite3
end
