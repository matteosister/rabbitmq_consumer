defmodule RabbitmqConsumer.CLIHelper do
  defmacro __using__(_options) do
    quote do
      def parse_args(args) do
        all_switches = Enum.concat(switches, help_switch) |> Enum.uniq
        all_aliases = Enum.concat(aliases, help_alias) |> Enum.uniq
        res = {parsed, _, _} = OptionParser.parse(args, switches: all_switches, aliases: all_aliases)
        if parsed[:help] do
          IO.puts @moduledoc
          #IO.puts "usage: rabbitmq_consumer [options]"
          IO.puts "Options:"
          IO.puts RabbitmqConsumer.CLIHelper.command_options_help(all_switches, switch_mapper(all_aliases))
          System.halt(0)
        end
        RabbitmqConsumer.CLIHelper.validate_parsed_args(parsed, required_switches)
        res
      end

      defp switch_mapper(aliases) do
        fn ({name, _}) ->
          found_alias = alias_for_switch_name(name, aliases)
          [to_string(name), alias_for_switch(found_alias), help_string(name)]
        end
      end

      defp alias_for_switch_name(name, aliases, ifnone \\ nil) do
        Enum.find(
          aliases,
          ifnone,
          fn ({_, alias_ref}) -> alias_ref == name end
        )
      end

      defp alias_for_switch(nil), do: ""
      defp alias_for_switch({alias_name, _}), do: "-" <> to_string(alias_name)

      defp switches, do: []
      defp aliases, do: []
      defp required_switches, do: []
      defp help_switch, do: [help: :boolean]
      defp help_alias, do: [h: :help]

      defp help_string(:help), do: "displays this help message"

      defoverridable [switches: 0, aliases: 0, required_switches: 0, help_string: 1]
    end
  end

  def validate_parsed_args(parsed, required_switches) do
    Enum.each required_switches, fn (required_switch) ->
      unless Keyword.has_key?(parsed, required_switch) do
        IO.puts "You have to pass the #{required_switch} option."
        System.halt(1)
      end
    end
  end

  def command_options_help(switches, switch_mapper) do
    switches
    |> Enum.map(switch_mapper)
    |> Enum.map(&justify_mapped_switch/1)
    |> Enum.map(fn (switch) -> Enum.join(switch, "   ") end)
    |> Enum.join("\n")
  end

  defp justify_mapped_switch([cmd, cmd_alias, description]) do
    ["  --" <> String.ljust(cmd, 10), String.rjust(cmd_alias, 3), description]
  end
end
