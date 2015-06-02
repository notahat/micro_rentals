#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'listener'

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
    @db ||= Hash.new
  end
end

RentalOfferSolutionCollector.new(ARGV.shift, ARGV.shift).start
