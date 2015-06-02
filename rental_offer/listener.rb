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
      packet = JSON.parse(body)
      packet['hops'] ||= 0
      packet['hops'] += 1
      handle_packet(exchange, packet) unless packet['hops'] > 9
    end
  end

end
