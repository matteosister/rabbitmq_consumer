defmodule RabbitmqConsumer.Executer do
  def execute(cmd) do
    spawn(fn ->
      do_execute(cmd)
    end)
  end

  defp do_execute(cmd) do
    :timer.sleep(2)
    IO.puts "eseguito #{cmd}"
  end
end
