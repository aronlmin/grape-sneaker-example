# frozen_string_literal: true

##
module Application
  require './settings.rb'

  ## Configuration
  Dir.glob('./config/*.rb') { |file| load file }

  ## Library
  Dir.glob('./lib/*.rb') { |file| load file }

  ## Models
  Dir.glob('./models/*.rb') { |file| load file }

  ## Entities
  Dir.glob('./entities/*.rb') { |file| load file }

  ##
  module ErrorFormatter
    def self.call(message, _backtrace, _options, _env, _original_exception)
      if message.is_a? String
        { status: 'error', error: message }.to_json
      elsif message.is_a? Hash
        status = { status: 'error' }
        status.merge(message).to_json
      end
    end
  end

  ##
  class API < Grape::API
    use Rack::JSONP

    content_type :json, 'application/json'
    default_format :json
    error_formatter :json, ErrorFormatter
    rescue_from :all if ENV['RACK_ENV'] == 'production'

    helpers do
      ## add pagination metadata to the root of the JSON object response
      def present_pagination(data, **params)
        total_pages = data.total_pages
        pagination = {
          page: params[:page] ||= 1,
          per_page: params[:per] ||= 10,
          page_count: total_pages
        }
        present pagination, root: 'pagination', with: Grape::Presenters::Presenter
      end

      ## add a node called data to the root JSON object and add the main content to that
      ## node
      def present_data(key, data, options = {})
        response = {}
        d = data.class.respond_to?(:count) ? [data] : data
        d = [] if d.nil?
        response[key] = options[:with].represent(d, options.except(:with))
        present response, options, root: 'data', with: Grape::Presenters::Presenter
      end

      ## add metadata to the root of the JSON response
      def present_meta(data, attrs = {})
        d = data.class.respond_to?(:count) ? [data] : data
        meta = {
          status: 'OK',
          method: @method,
          record_count: d.nil? ? 0 : d.size,
          response_time: Time.now - @start_time
        }.merge(attrs)
        present meta, with: Grape::Presenters::Presenter
      end

      def logger
        API.logger
      end
    end

    ##
    before do
      ## add variables to be used in the present_meta helper method
      @start_time = Time.new
      @method = request.request_method
    end

    get '/' do
      present :root, { api_name: 'grape-sneaker-example' }, with: Grape::Presenters::Presenter
    end

    ## after loading all the appication code, lastly we can load our endpoints
    Dir.glob('./endpoints/*.rb') { |file| load file }

    mount Application::Endpoints::Authors
  end
end
