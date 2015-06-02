#!/usr/bin/env ruby
# encoding: utf-8

# Docker run command:
#   docker run --name='monitor' -it -v /c/Users/fred/src/microservice_workshop/ruby:/workshop -w /workshop/rental_offer fredgeorge/ruby_microservice bash
# To run monitor at prompt:
#   ruby rental_offer_monitor.rb 192.168.0.52 homer

require_relative 'connection'
require 'json'
require 'pp'
# Streams rental-offer-related requests to the console
class RentalOfferSolutionCollector

  def initialize(host, bus_name)
    @host = host
    @bus_name = bus_name
  end

  def start
    Connection.with_open(@host, @bus_name) {|ch, ex| monitor_solutions(ch, ex) }
  end

private

  def monitor_solutions(channel, exchange)
    queue = channel.queue("", :exclusive => true)
    queue.bind exchange
    puts " [*] Waiting for solutions on the '#{@bus_name}' bus... To exit press CTRL+C"
    queue.subscribe(block: true) do |delivery_info, properties, body|
      packet = JSON.parse(body)
      if packet['json_class'] == 'RentalOfferSolutionPacket'
        collect_solution(packet)
        p [ packet['correlation_id'], db[packet['correlation_id']] ]
      end
    end
  end

  def collect_solution(packet)
    current_best_solution = db[packet['correlation_id']]

    if current_best_solution.nil? || packet['value'] > current_best_solution[:value]
      db[packet['correlation_id']] = { description: packet['description'], value: packet['value'] }
    end
  end

  def db
    @db ||= Hash.new()
  end
end

RentalOfferSolutionCollector.new(ARGV.shift, ARGV.shift).start
