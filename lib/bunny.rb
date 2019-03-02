# frozen_string_literal: true

##
module BUNNY
  def self.do(channel, object = {})
    ## define and establish a connection to our rabbitMQ server
    conn = Bunny.new("amqp://#{ENV['RABBIT_MQ_USER']}:#{ENV['RABBIT_MQ_PASS']}@#{ENV['RABBIT_MQ_HOST']}")
    conn.start

    ## open up a channel
    ch = conn.create_channel

    ## create a que on the channel
    q = ch.queue(channel.to_s, durable: true, auto_delete: false)

    ## publish a message
    q.publish(object.to_json, routing_key: q.name)

    ## close the connection
    conn.close
  end
end
