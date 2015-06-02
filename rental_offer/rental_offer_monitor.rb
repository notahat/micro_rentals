#!/usr/bin/env ruby
# encoding: utf-8

# Docker run command:
#   docker run --name='monitor' -it -v /c/Users/fred/src/microservice_workshop/ruby:/workshop -w /workshop/rental_offer fredgeorge/ruby_microservice bash
# To run monitor at prompt:
#   ruby rental_car_monitor.rb 192.168.59.103 bugs

require_relative 'listener'

# Streams rental-offer-related requests to the console
class RentalOfferMonitor < Listener
  def handle_packet(_, packet)
    puts " [x] Received #{JSON.pretty_generate(packet)}"
  end
end

RentalOfferMonitor.new(ARGV.shift, ARGV.shift).start
