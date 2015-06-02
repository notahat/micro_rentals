#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

class BusMonitor < Listener
  def handle_packet(_, packet)
    puts " [x] Received #{JSON.pretty_generate(packet)}"
  end
end

BusMonitor.new(ARGV.shift, ARGV.shift).start
