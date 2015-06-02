#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class RentalOfferFooSolutionProvider < Listener

  def handle_packet(exchange, packet)
    return if packet.has_key?('solution')

    packet['solution'] = {
      'description' => 'foo',
      'value' => rand(100)
    }

    exchange.publish(packet.to_json)
  end

end

RentalOfferFooSolutionProvider.new(ARGV.shift, ARGV.shift).start

