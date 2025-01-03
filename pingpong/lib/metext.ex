defmodule Metext do
  @moduledoc """
  Documentation for `Metext`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metext.hello()
      :world

  """
  def hello do
    :world
  end

  def temperatures_of(cities) do
    coordinator_pid =
      spawn(Metext.Coordinator, :loop, [[], Enum.count(cities)])

    cities
    |> Enum.each(fn city ->
      worker_pid = spawn(Metext.Worker, :loop, [])
      send(worker_pid, {coordinator_pid, city})
    end)
  end
end
