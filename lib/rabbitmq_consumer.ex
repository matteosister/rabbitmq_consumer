defmodule RabbitmqConsumer do
  @moduledoc """
  This script consumes messages from rabbitmq and call an external command to do the actual processing
  """

  @doc """
  main entry point for the script
  """
  def main(args) do
    RabbitmqConsumer.Consumer.start_link
    {parsed, _, _} = parse_args(args)
    if parsed[:help] do
      IO.puts @moduledoc
      IO.puts "usage: rabbitmq_consumer [options]"
      IO.puts ""
      IO.puts "Options:"
      IO.puts command_options_help
      System.halt(0)
    end
    IO.inspect parsed
  end

  defp parse_args(args) do
    OptionParser.parse(args, switches: switches, aliases: aliases)
  end

  defp switches do
    [
      cmd: :string,
      exchange: :string,
      help: :boolean,
      queue: :string,
      verbose: :boolean
    ]
  end

  defp aliases do
    [
      c: :cmd,
      e: :exchange,
      h: :help,
      q: :queue,
      v: :verbose
    ]
  end

  defp command_options_help do
    switches
    |> Enum.map(&map_switch/1)
    |> Enum.map(&justify_mapped_switch/1)
    |> Enum.map(fn (switch) -> Enum.join(switch, "   ") end)
    |> Enum.join("\n")
  end

  defp help_string(:cmd), do: "the command to be executed"
  defp help_string(:exchange), do: "the exchange name"
  defp help_string(:help), do: "display this help message"
  defp help_string(:queue), do: "the queue name"
  defp help_string(:verbose), do: "verbosity level"
  defp help_string(unknown_switch), do: raise "unable to find help string for switch #{unknown_switch}"

  defp alias_for_switch(nil), do: ""
  defp alias_for_switch({alias_name, alias_ref}), do: "-" <> to_string(alias_name)

  defp find_alias_by_switch_name(name, ifnone \\ nil) do
    Enum.find(
      aliases,
      ifnone,
      fn ({alias_name, alias_ref}) -> alias_ref == name end
    )
  end

  defp map_switch(switch = {name, _}) do
    found_alias = find_alias_by_switch_name(name)
    [to_string(name), alias_for_switch(found_alias), help_string(name)]
  end

  defp justify_mapped_switch([cmd, cmd_alias, description]) do
    ["  --" <> String.ljust(cmd, 10), String.rjust(cmd_alias, 3), description]
  end
end
