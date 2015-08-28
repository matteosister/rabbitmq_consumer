defmodule RabbitmqConsumer do


  @doc """
  main entry point for the script
  """
  def main(args) do
    res = {parsed, _, _} = RabbitmqConsumer.CLI.parse_args(args)
    IO.puts "pipo"
    IO.inspect parsed
    RabbitmqConsumer.Consumer.start_link(parsed[:url], parsed[:exchange], parsed[:queue])
    loop
  end

  defp loop, do: loop


end
