# frozen_string_literal: true

module Application
  ## -------------------------------------------------------------------------------------
  ## Entities are for defining (or re definining) the shape of the data when its sent to
  ## the API response
  ## -------------------------------------------------------------------------------------
  module Entities
    ## -----------------------------------------------------------------------------------
    ## Entity classes ending in "Base" means that it will be used as the root entity,
    ## which other entities can then reference.
    ## entities with "Embeds" in the name are used inside endpoints, those with "Base"
    ## are referenced by other entities.
    ## -----------------------------------------------------------------------------------
    class BookBase < Application::Entities::Mongoid
      expose :name
    end
    ## -----------------------------------------------------------------------------------
    ## Entity classes ending in "Embeds" add a response object called "_embedded"
    ## the embedded field requires the "zoom" parameter, and if matching comma deliminated
    ## zoom fields are provided related data will be embedded within the _embedded field
    ## -----------------------------------------------------------------------------------
    class BookEmbeds < Application::Entities::BookBase
      expose :_embedded do |record, options|
        embeds = {}
        unless options[:zoom].blank?
          embed_requests = options[:zoom].split(',')
          embed_requests.each do |embed|
            case embed.to_sym
            when :author
              embeds[:author] = Application::Entities::AuthorBase.represent record.author
            end
          end
        end
        embeds
      end
    end
  end
end
