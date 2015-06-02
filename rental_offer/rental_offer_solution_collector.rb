#!/usr/bin/env ruby
# encoding: utf-8

require 'json'
require_relative 'listener'

class RentalOfferSolutionCollector < Listener
  def handle_packet(_, packet)
    return unless packet.has_key?('solution')
    db_key = packet['correlation_id']

    db[db_key] ||= []
    db[db_key] << { type: packet['solution']['type'], description: packet['solution']['description'], value: packet['solution']['value'] }

    best_offer = db[db_key].sort_by { |offer| offer[:value] }.last

    puts JSON.generate([ db_key, best_offer ])
  end

  def db
    @db ||= Hash.new
  end
end

RentalOfferSolutionCollector.new(ARGV.shift, ARGV.shift).start
