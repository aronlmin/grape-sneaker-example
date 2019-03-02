# frozen_string_literal: true

module Application
  module Endpoints
    ##
    class Authors < Grape::API
      format :json
      resource :authors do
        params do
          optional :page, type: Integer, default: 1
          optional :per, type: Integer, default: 10
          optional :order_by, type: String, default: 'name'
          optional :dir, type: String, default: 'asc'
          optional :zoom, type: String
        end
        get '/' do
          authors = Application::Author.all
          authors = authors.where(name: /^#{params[:name]}/i) unless params[:name].blank?
          authors = authors.order_by(params[:order_by].to_sym => params[:dir].to_sym) if params[:order_by_many].blank?
          authors = authors.page(params[:page]).per(params[:per]) unless params[:per].zero?

          ## we have a custom method we defined in our ./lib/bunny.rb file for passing
          ## messages to RabbitMQ
          BUNNY.do(
            :grape_sneaker_example,     ## our worker is subscribed to this channel
            cmd: :hello,                ## our worker has a case statement that can handle commands to route our request
            payload: authors.first      ## the main payload we want to send our worker, its best to keep this light
          )

          ## return the JSON response to the user
          present_meta authors
          present_pagination authors, page: params[:page], per: params[:per] unless params[:per].zero?
          present_data :authors, authors, with: Application::Entities::AuthorEmbeds, zoom: params[:zoom]
        end
      end
    end
  end
end
