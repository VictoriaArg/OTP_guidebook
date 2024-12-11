defmodule Metex.Worker do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  ## Client API
  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  ## Server API
  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}ºC", new_stats}

      _ ->
        {:reply, :error, stats}
    end
  end

  ## Helper Functions
  defp temperature_of(location) do
    url_for(location) |> HTTPoison.get() |> parse_response()
  end

  defp url_for(location) do
    location = URI.encode(location)
    "https://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{api_key()}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> Jason.decode!() |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp api_key do
    "1c005f0c6661a67c8b3ef2737a108e8e"
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true -> Map.update!(old_stats, location, &(&1 + 1))
      false -> Map.put_new(old_stats, location, 1)
    end
  end
end
