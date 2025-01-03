defmodule Metext.PingPong do
  def start(turns) when turns > 0 do
    ping_pid = spawn(Metext.PingPong, :ping, [])
    pong_pid = spawn(Metext.PingPong, :pong, [])

    send(ping_pid, {:start, pong_pid, turns})
  end

  def ping do
    receive do
      {:start, pong_pid, turns} ->
        IO.puts("Ping: starting...")
        send(pong_pid, {:ping, self(), turns - 1})
        ping()

      {:pong, _pong_pid, 0} ->
        IO.puts("Ping received 'pong', pong won the game.")

      {:pong, pong_pid, turns} ->
        IO.puts("Ping received 'pong'")
        :timer.sleep(500)
        send(pong_pid, {:ping, self(), turns - 1})
        ping()
    end
  end

  def pong do
    receive do
      {:ping, _pong_pid, 0} ->
        IO.puts("Pong received 'ping', ping won the game.")
      {:ping, ping_pid, turns} ->
        IO.puts("Pong received 'ping'")
        :timer.sleep(500)
        send(ping_pid, {:pong, self(), turns - 1})
        pong()
    end
  end
end
