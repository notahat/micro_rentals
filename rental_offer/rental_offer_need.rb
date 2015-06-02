#!/usr/bin/env ruby
# encoding: utf-8

# Docker run command:
#   docker run --name='need' -it -v /c/Users/fred/src/microservice_workshop/ruby:/workshop -w /workshop/rental_offer fredgeorge/ruby_microservice bash
# To run monitor at prompt:
#   ruby rental_offer_need.rb 192.168.0.52 homer

require_relative 'rental_offer_need_packet'
require_relative 'connection'
require 'securerandom'
require 'json'

# Expresses a need for rental car offers
class RentalOfferNeed

  def initialize(host, bus_name)
    @host = host
    @bus_name = bus_name
  end

  def start
    Connection.with_open(@host, @bus_name) {|ch, ex| publish_need(ch, ex)}
  end

  private

  def publish_need(channel, exchange)
    loop do
      packet = {
        'json_class' => 'RentalOfferNeedPacket',
        'need' => 'car_rental_offer',
        'correlation_id' => SecureRandom.uuid,
      }

      exchange.publish packet.to_json
      puts " [x] Published a rental offer need on the #{@bus_name} bus"
      sleep 5
    end
  end

end

RentalOfferNeed.new(ARGV.shift, ARGV.shift).start
