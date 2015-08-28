defmodule RabbitmqConsumer.Executer do
  use AMQP
  defstruct cmd: nil, channel: nil, tag: nil, routing_key: "", payload: nil

  def new(cmd, channel, tag, routing_key, payload) do
    %RabbitmqConsumer.Executer{cmd: cmd, channel: channel, tag: tag, routing_key: routing_key, payload: payload}
  end

  def execute(executer) do
    spawn(fn -> do_execute(executer) end)
  end

  defp do_execute(executer = %RabbitmqConsumer.Executer{channel: channel, tag: tag, cmd: cmd}) do
    Basic.ack channel, tag
    IO.puts "eseguito #{executer}"
  end
end

defimpl String.Chars, for: RabbitmqConsumer.Executer do
  def to_string(%RabbitmqConsumer.Executer{cmd: cmd, tag: tag, routing_key: routing_key, payload: payload}) do
    "%RabbitmqConsumer.Executer{cmd: \"#{cmd}\", tag: #{tag}, routing_key: \"#{routing_key}\", payload: \"#{payload}\"}"
  end
end
