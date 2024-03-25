defmodule GitSmart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GitSmartWeb.Telemetry,
      GitSmart.Repo,
      {DNSCluster, query: Application.get_env(:git_smart, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: GitSmart.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GitSmart.Finch},
      # Start a worker by calling: GitSmart.Worker.start_link(arg)
      # {GitSmart.Worker, arg},
      # Start to serve requests, typically the last entry
      GitSmartWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GitSmart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GitSmartWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
