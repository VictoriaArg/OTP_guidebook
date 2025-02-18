defmodule Pooly.PoolsSupervisor do
  use Supervisor

  def start_link() do
    IO.inspect("Starting a PoolsSupervisor")
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    opts = [
      strategy: :one_for_one
    ]

    supervise([], opts)
  end
end
