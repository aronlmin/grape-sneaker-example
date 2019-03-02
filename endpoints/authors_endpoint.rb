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
          companies = JOBDATA::Company.all
          companies = companies.where(ts_id: params[:ts_id]) unless params[:ts_id].blank?
          companies = companies.order_by(params[:order_by].to_sym => params[:dir].to_sym) if params[:order_by_many].blank?
          companies = companies.order_by(order_by_many(params[:order_by_many])) unless params[:order_by_many].blank?
          companies = companies.page(params[:page]).per(params[:per]) unless params[:per].zero?
          present_meta companies
          present_pagination companies, page: params[:page], per: params[:per] unless params[:per].zero?
          present_data :companies, companies, with: JOBDATA::Entities::CompanyEmbeds, zoom: params[:zoom]
        end
      end
    end
  end
end
