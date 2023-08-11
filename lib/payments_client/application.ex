defmodule PaymentsClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias PaymentsClient.RateLimiter

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: PaymentsClient.Worker.start_link(arg)
      # {PaymentsClient.Worker, arg}
      {Task.Supervisor, name: RateLimiter.TaskSupervisor},
      {RateLimiter.get_rate_limiter(),
       %{
         timeframe_max_requests: RateLimiter.get_requests_per_timeframe(),
         timeframe_units: RateLimiter.get_timeframe_unit(),
         timeframe: RateLimiter.get_timeframe()
       }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PaymentsClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
