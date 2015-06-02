#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class RentalOfferMonitor < Listener
  def handle_packet(_, packet)
    puts " [x] Received #{JSON.pretty_generate(packet)}"
  end
end

RentalOfferMonitor.new(ARGV.shift, ARGV.shift).start
