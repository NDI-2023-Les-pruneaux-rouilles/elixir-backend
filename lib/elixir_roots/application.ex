defmodule ElixirRoots.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirRootsWeb.Telemetry,
      ElixirRoots.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:elixir_roots, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:elixir_roots, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirRoots.PubSub},
      # Start a worker by calling: ElixirRoots.Worker.start_link(arg)
      # {ElixirRoots.Worker, arg},
      Supervisor.child_spec({Cachex, name: :cdn_cache}, id: :cdn_cache),
      Supervisor.child_spec({Cachex, name: :cdn_index}, id: :cdn_index),
      # Start to serve requests, typically the last entry
      ElixirRootsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirRoots.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirRootsWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
