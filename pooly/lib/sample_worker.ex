defmodule SampleWorker do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def handle_call(:stop, _from, state) do
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:work_for, duration}, state) do
    IO.inspect("work for #{duration}")
    :timer.sleep(duration)
    {:stop, :normal, state}
  end

  def handle_cast({:greet_team, nil}, state) do
    Logger.info("Have a nice weekend")
    {:noreply, state}
  end

  def handle_cast({:greet_team, team_member}, state) do
    Logger.info("Hello #{team_member}")
    {:noreply, state}
  end

  def work_for(pid, duration) do
    GenServer.cast(pid, {:work_for, duration})
  end

  def greet_team(pid, []), do: GenServer.cast(pid, {:greet_team, nil})

  def greet_team(pid, [team_member | rest]) do
    GenServer.cast(pid, {:greet_team, team_member})
    greet_team(pid, rest)
  end
end

# w1 = Pooly.checkout "Pool1"
# Pooly.status "Pool1"
# w2 = Pooly.checkout "Pool1"
# w3 = Pooly.checkout "Pool1"
# SampleWorker.work_for w1, 10_000
# Pooly.checkout "Pool1", true, :infinity
# SampleWorker.greet_team w1, ["Vicky", "Male", "Ale S.", "Ale M.", "Ale R.", "Dani", "Carlota"]
