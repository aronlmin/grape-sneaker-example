# frozen_string_literal: true

##
module Workers
  ##
  class MyWorker
    ## RabbitMQ / Sneakers Configurations for this Model
    include Sneakers::Worker
    from_queue(
      :grape_sneaker_example,    # namespace for RabbitMQ to use
      timeout_job_after: 5,      # Maximal seconds to wait for job
      prefetch: 10,              # Grab 10 jobs together. Better speed.
      threads: 10,               # Threadpool size (good to match prefetch)
      env: ENV['RACK_ENV'],      # Environment
      durable: true,             # Is queue durable?
      ack: true,                 # Must we acknowledge?
      heartbeat: 8,              # Keep a good connection with broker
      exchange: 'sneakers',      # AMQP exchange
      hooks: {},                 # prefork/postfork hooks
      start_worker_delay: 10     # Delay between thread startup
    )

    def work(msg)
      obj = JSON.parse(msg)
      case obj['cmd']
      when 'hello'
        puts
        puts "world - #{Time.now}"
        puts
      end
    end
  end
end
