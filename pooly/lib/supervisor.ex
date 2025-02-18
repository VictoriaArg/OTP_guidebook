defmodule Pooly.Supervisor do
  use Supervisor

  def start_link(pools_config) do
    IO.inspect("Start Main Supervisor for configured pools")
    Supervisor.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  def init(pools_config) do
    children = [
      supervisor(Pooly.PoolsSupervisor, []),
      worker(Pooly.Server, [pools_config])
    ]

    IO.inspect("Main Supervisor defined its children: PoolsSupervisor and Main Server")

    opts = [strategy: :one_for_all]
    supervise(children, opts)
  end
end
