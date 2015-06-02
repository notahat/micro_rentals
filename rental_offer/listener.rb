require 'json'
require_relative 'connection'

class Listener

  def initialize(host, bus_name)
    @host = host
    @bus_name = bus_name
  end

  def start
    Connection.with_open(@host, @bus_name) {|ch, ex| monitor(ch, ex) }
  end

  def monitor(channel, exchange)
    queue = channel.queue("", :exclusive => true)
    queue.bind exchange
    queue.subscribe(block: true) do |delivery_info, properties, body|
      handle_packet(exchange, JSON.parse(body))
    end
  end

end
