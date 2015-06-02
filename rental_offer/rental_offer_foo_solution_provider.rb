#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class RentalOfferFooSolutionProvider < Listener

  def handle_packet(exchange, packet)
    return unless packet['json_class'] == 'RentalOfferNeedPacket'

    response = {
      'json_class' => 'RentalOfferSolutionPacket',
      'need' => 'car_rental_offer',
      'correlation_id' => packet['correlation_id'],
      'description' => 'foo',
      'value' => rand(100)
    }
    exchange.publish(response.to_json)
  end

end

RentalOfferFooSolutionProvider.new(ARGV.shift, ARGV.shift).start

