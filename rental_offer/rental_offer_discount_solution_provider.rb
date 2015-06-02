#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class RentalOfferDiscountSolutionProvider < Listener

  def handle_packet(exchange, packet)
    return if packet.has_key?('solution')

    packet['solution'] = {
      'description' => 'discount',
      'value' => rand(100)
    }

    exchange.publish(packet.to_json)
  end

end

RentalOfferDiscountSolutionProvider.new(ARGV.shift, ARGV.shift).start


