defmodule Blitzy do
  @moduledoc """
  Documentation for `Blitzy`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Blitzy.hello()
      :world

  """
  def hello do
    :world
  end

  def run(n_workers, url) when n_workers > 0 do
    worker_fun = fn -> Blitzy.Worker.start(url) end

    1..n_workers
    |> Enum.map(fn _ -> Task.async(worker_fun) end)
    |> Enum.map(&Task.await(&1, :infinity))
  end

  defp parse_results(results) do
    {successes, _failures} =
      results
      |> Enum.partition(fn x ->
        case x do
          {:ok, _} -> true
          _ -> false
        end
      end)

    total_workers = Enum.count(results)
    total_success = Enum.count(successes)
    total_failure = total_workers - total_success

    data = successes |> Enum.map(fn {:ok, time} -> time end)
    average_time = average(data)
    longest_time = Enum.max(data)
    shortest_time = Enum.min(data)

    IO.puts("""
    Total workers     : #{total_workers}
    Successful reqs   : #{total_success}
    Failed res        : #{total_failure}
    Average (msecs)   : #{average_time}
    Longest (msecs)   : #{longest_time}
    Shortest (msecs)  : #{shortest_time}
    """)
  end

  defp average(list) do
    sum = Enum.sum(list)

    if sum > 0 do
      sum / Enum.count(list)
    else
      0
    end
  end
end
