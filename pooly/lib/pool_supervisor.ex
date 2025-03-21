defmodule Pooly.PoolSupervisor do
  use Supervisor

  def start_link(pool_config) do
    Supervisor.start_link(__MODULE__, pool_config, name: :"#{pool_config[:name]}Supervisor")
  end

  def init(pool_config) do
    opts = [
      strategy: :one_for_all
    ]

    children = [
      worker(Pooly.PoolServer, [self(), pool_config])
    ]

    IO.inspect("Pool Supervisor #{pool_config[:name]} started a Server")
    supervise(children, opts)
  end
end
