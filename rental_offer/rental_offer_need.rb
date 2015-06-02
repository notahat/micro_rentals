#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'connection'
require 'securerandom'
require 'json'

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
      member_id = [ nil, nil, SecureRandom.uuid ].sample

      packet = {
        'json_class' => 'RentalOfferNeedPacket',
        'need' => 'car_rental_offer',
        'correlation_id' => SecureRandom.uuid,
      }

      packet.merge!({ member_id: member_id }) unless member_id.nil?

      exchange.publish packet.to_json
      puts " [x] Published a rental offer need on the #{@bus_name} bus"
      sleep 3
    end
  end

end

RentalOfferNeed.new(ARGV.shift, ARGV.shift).start
