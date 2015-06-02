#!/usr/bin/env ruby
# encoding: utf-8

# Docker run command:
#   docker run --name='monitor' -it -v /c/Users/fred/src/microservice_workshop/ruby:/workshop -w /workshop/rental_offer fredgeorge/ruby_microservice bash
# To run monitor at prompt:
#   ruby rental_offer_monitor.rb 192.168.0.52 homer

require_relative 'listener'

# Streams rental-offer-related requests to the console
class RentalOfferSolutionCollector < Listener
  def handle_packet(_, packet)
    return unless packet.has_key?('solution')

    current_best_solution = db[packet['correlation_id']]

    if current_best_solution.nil? || packet['solution']['value'] > current_best_solution[:value]
      db[packet['correlation_id']] = { description: packet['solution']['description'], value: packet['solution']['value'] }
    end

    p [ packet['correlation_id'], db[packet['correlation_id']] ]
  end

  def db
    @db ||= Hash.new()
  end
end

RentalOfferSolutionCollector.new(ARGV.shift, ARGV.shift).start
