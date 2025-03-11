defmodule Blitzy.Worker do
  use Timex
  require Logger

  def start(url) do
    {timestamp, response} = Duration.measure(fn -> HTTPoison.get(url) end)
    handle_response({Duration.to_milliseconds(timestamp), response})
  end

  def start(url, caller, func \\ &HTTPoison.get/1) do
    {timestamp, response} = Duration.measure(fn -> func.(url) end)

    caller
    |> send({self(), handle_response({Duration.to_milliseconds(timestamp), response})})
  end

  def handle_response({msecs, {:ok, %HTTPoison.Response{status_code: code}}})
      when code >= 200 and code <= 304 do
    Logger.info("worker [-#{inspect(self())}] completed in #{msecs}")

    {:ok, msecs}
  end

  def handle_response({_msecs, {:error, reason}}) do
    Logger.info("worker [-#{inspect(self())}] error due to #{inspect(reason)}")

    {:error, reason}
  end

  def handle_response({_msecs, _}) do
    Logger.info("worker [-#{inspect(self())}] errored out")
    {:error, :unknown}
  end
end
