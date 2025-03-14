defmodule SampleWorker do
  use GenServer

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
    IO.inspect("STOP")
    {:stop, :normal, :ok, state}
  end

  def handle_cast({:work_for, duration}, state) do
    IO.inspect("work for #{duration}")
    :timer.sleep(duration)
    {:stop, :normal, state}
  end

  def work_for(pid, duration) do
    GenServer.cast(pid, {:work_for, duration})
  end
end

# w1 = Pooly.checkout "Pool1"
# w2 = Pooly.checkout "Pool1"
# w3 = Pooly.checkout "Pool1"
# SampleWorker.work_for w1, 10_000
# Pooly.checkout "Pool1", true, :infinity
