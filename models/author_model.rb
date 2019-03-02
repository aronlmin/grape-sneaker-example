# frozen_string_literal: true

module Application
  ##
  class Author
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: :authors

    has_many :books, class_name: 'Application::Book', dependent: :destroy

    field :name, type: String
  end
end
