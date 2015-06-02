#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class SegmentTypeProvider < Listener

  def handle_packet(exchange, packet)
    return if !packet.has_key?('member_id') ||
      packet.has_key?('segment_type') ||
      packet.has_key?('solution')

    packet['segment_type'] = [ 'road_warrior', 'resort_hound' ].sample

    exchange.publish(packet.to_json)
  end

end

SegmentTypeProvider.new(ARGV.shift, ARGV.shift).start
