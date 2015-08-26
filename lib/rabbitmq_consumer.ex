defmodule RabbitmqConsumer do
  @moduledoc """
  Provides math-related functions.
  """

  def main(args) do
    RabbitmqConsumer.Consumer.start_link
    {parsed, _, _} = parse_args(args)
    if parsed[:help] do
      IO.puts @moduledoc
      System.halt(0)
    end
  end

  defp help do
    IO.puts """
This script consumes messages from rabbitmq and call an external command to do the actual processing
usage: rabbitmq_consumer [options]

Options:

"""
  end

  defp parse_args(args) do
    OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  defp switches do
    [
      config: :string,
      verbose: :boolean,
      execute: :string,
      help: :boolean
    ]
  end

  defp aliases do
    [d: :debug, c: :config, v: :verbose, e: :execute, h: :help]
  end
end
