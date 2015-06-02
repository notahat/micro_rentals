#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class RentalOfferDiscountSolutionProvider < Listener

  def handle_packet(exchange, packet)
    return if packet.has_key?('solution')

    if packet['membership'] == 'platinum'
      value = rand(100) * 10
      description = 'Platinum members get a massive discount'
    else
      value = rand(100)
      description = 'Discounted car rental'
    end

    packet['solution'] = {
      'description' => description,
      'type' => 'discount',
      'value' => value,
    }

    exchange.publish(packet.to_json)
  end

end

RentalOfferDiscountSolutionProvider.new(ARGV.shift, ARGV.shift).start


