#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class UpgradeSolutionProvider < Listener

  def handle_packet(exchange, packet)
    return if packet.has_key?('solution')

    if packet['segment_type'] == 'road_warrior'
      value = rand(100) * 10
      description = 'Road Warriors get an Interceptor'
    else
      value = rand(100)
      description = 'Get a car upgrade'
    end

    packet['solution'] = {
      'description' => description,
      'type' => 'upgrade',
      'value' => value,
    }

    exchange.publish(packet.to_json)
  end

end

UpgradeSolutionProvider.new(ARGV.shift, ARGV.shift).start

