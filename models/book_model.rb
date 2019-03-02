# frozen_string_literal: true

module Application
  ##
  class Book
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: :books

    belongs_to :author, class_name: 'Application::Author'

    field :name, type: String
  end
end
