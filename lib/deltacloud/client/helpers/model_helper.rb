module Deltacloud::Client
  module Helpers
    module Model

      # Helper to retrieve the class straight from
      # Deltacloud::Client model.
      #
      # -name -> A class name in underscore form (:storage_volume)
      #
      def model(name)
        Deltacloud::Client.const_get(name.to_s.camelize)
      end

      # Checks if current @connection support +model_name+
      # and then convert HTTP response to a Ruby model
      #
      # - model_name -> A class name in underscore form
      # - collection_body -> HTTP body of collection
      #
      def from_collection(model_name, collection_body)
        must_support!(model_name)
        model(model_name.to_s.singularize).from_collection(
          self,
          collection_body
        )
      end

      # Check if the collection for given model is supported
      # in current @connection and then parse/convert
      # resource XML to a Ruby class
      #
      #
      def from_resource(model_name, resource_body)
        must_support!(model_name.to_s.pluralize)
        model(model_name).convert(self, resource_body)
      end

    end
  end
end
