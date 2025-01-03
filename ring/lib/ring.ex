defmodule Ring do
  @moduledoc """
  Documentation for `Ring`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ring.hello()
      :world

  """
  def hello do
    :world
  end

  def create_processes(n) do
    1..n |> Enum.map(fn _ -> spawn(fn -> loop() end) end)
  end

  def loop do
    receive do
      {:link, link_to} when is_pid(link_to) ->
        Process.link(link_to)
        loop()

      :trap_exit ->
        Process.flag(:trap_exit, true)
        loop()

      :crash ->
        1 / 0

      {:EXIT, pid, reason} ->
        IO.puts("#{inspect(self())} received {:EXIR, #{inspect(pid)}, #{reason}}")
        loop()
    end
  end

  def link_processes(procs) do
    link_processes(procs, [])
  end

  def link_processes([proc1, proc2 | rest], linked_processes) do
    send(proc1, {:link, proc2})
    link_processes([proc2 | rest], [proc1 | linked_processes])
  end

  def link_processes([proc | []], linked_processes) do
    first_process = linked_processes |> List.last()
    send(proc, {:link, first_process})
    :ok
  end
end
