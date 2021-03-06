defmodule RabbitmqConsumer.Consumer do
  use GenServer
  use AMQP
  alias RabbitmqConsumer.Executer

  def start_link(url, exchange, queue) do
    GenServer.start_link(
      __MODULE__,
      [url: url, exchange: exchange, queue: queue],
      name: :consumer
    )
  end

  def init([url: url, exchange: exchange, queue: queue]) do
    {:ok, conn} = Connection.open(url)
    {:ok, chan} = Channel.open(conn)
    # Limit unacknowledged messages to 10
    #Basic.qos(chan, prefetch_count: 10)
    #Queue.declare(chan, @queue_error, durable: false)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    Queue.declare(chan, queue, durable: false)
    #                            arguments: [{"x-dead-letter-exchange", :longstr, ""},
    #                                        {"x-dead-letter-routing-key", :longstr, @queue_error}])
    Exchange.fanout(chan, exchange, durable: false)
    Queue.bind(chan, queue, exchange)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, queue)
    {:ok, chan}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, routing_key: routing_key}}, chan) do
    #spawn fn -> consume(chan, tag, redelivered, payload) end
    executer = Executer.new("ls -la", chan, tag, routing_key, payload)
    Executer.execute(executer)
    {:noreply, chan}
  end
end
