module MetaToApi
  extend ActiveSupport::Concern

  module ClassMethods
    def to_api
      self.all.collect{ |meta| meta.name }
    end
  end
end
