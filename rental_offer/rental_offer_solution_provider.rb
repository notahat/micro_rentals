#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'connection'
require 'json'

class RentalOfferSolutionProvider

  def initialize(host, bus_name)
    @host = host
    @bus_name = bus_name
  end

  def start
    Connection.with_open(@host, @bus_name) {|ch, ex| monitor_solutions(ch, ex) }
  end

private

  def monitor_solutions(channel, exchange)
    queue = channel.queue("", :exclusive => true)
    queue.bind exchange
    queue.subscribe(block: true) do |delivery_info, properties, body|
      packet = JSON.parse(body)
      if packet['json_class'] == 'RentalOfferNeedPacket'
        respond_to_need(exchange, packet)
      end
    end
  end

  def respond_to_need(exchange, packet)
    response = {
      'json_class' => 'RentalOfferSolutionsPacket',
      'need' => 'car_rental_offer',
      'correlation_id' => packet['correlation_id'],
      'solutions' => [
        { 'name' => 'foo', 'value' => 42 }
      ]
    }
    exchange.publish(response.to_json)
  end

end


RentalOfferSolutionProvider.new(ARGV.shift, ARGV.shift).start

