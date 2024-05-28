defmodule Dorado.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DoradoWeb.Telemetry,
      Dorado.Repo,
      {DNSCluster, query: Application.get_env(:dorado, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dorado.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dorado.Finch},
      # Start a worker by calling: Dorado.Worker.start_link(arg)
      # {Dorado.Worker, arg},
      # Start to serve requests, typically the last entry
      DoradoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dorado.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DoradoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
