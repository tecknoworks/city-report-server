module ActiveAdmin
  module Filters
    module FormtasticAddons
      def klass
        @object.class
      end

      def polymorphic_foreign_type?(method)
        false
      end
    end
  end
end
