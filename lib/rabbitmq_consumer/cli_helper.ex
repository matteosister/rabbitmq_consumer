defmodule RabbitmqConsumer.CLIHelper do
  defmacro __using__(_options) do
    quote do
      def parse_args(args) do
        all_switches = Enum.concat(switches, help_switch) |> Enum.uniq
        all_aliases = Enum.concat(aliases, help_alias) |> Enum.uniq
        {parsed, _, _} = OptionParser.parse(args, switches: all_switches, aliases: all_aliases)
        IO.inspect(parsed)
      end

      def switches, do: []
      def aliases, do: []
      def required_switches, do: []
      def help_switch, do: [help: :boolean]
      def help_alias, do: [h: :help]

      def help_string(:help), do: "displays this help message"

      defoverridable [switches: 0, aliases: 0, required_switches: 0,
                      help_string: 1]
    end
  end
end
