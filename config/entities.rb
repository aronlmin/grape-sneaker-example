# frozen_string_literal: true

module Application
  module Entities
    ##
    class Mongoid < Grape::Entity
      format_with(:mongo_id, &:to_s)
      with_options(format_with: :mongo_id) do
        expose :_id, as: :id
      end
      expose :created_at
      expose :updated_at
    end
  end
end
