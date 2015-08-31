defmodule RabbitmqConsumer.CLI do
  @moduledoc """
  This script consumes messages from rabbitmq and call an external command to do the actual processing
  """

  use RabbitmqConsumer.CLIHelper

  defp switches do
    [
      cmd: :string,
      exchange: :string,
      help: :boolean,
      queue: :string,
      url: :string,
      verbose: :boolean
    ]
  end

  defp aliases do
    [
      c: :cmd,
      e: :exchange,
      h: :help,
      q: :queue,
      u: :url,
      v: :verbose
    ]
  end

  defp required_switches do
    [:url, :exchange, :queue, :cmd]
  end

  defp help_string(:cmd), do: "the command to be executed"
  defp help_string(:exchange), do: "the exchange name"
  defp help_string(:help), do: "display this help message"
  defp help_string(:queue), do: "the queue name"
  defp help_string(:url), do: "rabbit amqp uri specification (https://www.rabbitmq.com/uri-spec.html)"
  defp help_string(:verbose), do: "verbosity"
  defp help_string(:ansi), do: "ansi output"
  defp help_string(_), do: ""
end
