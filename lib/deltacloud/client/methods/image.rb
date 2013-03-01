module Deltacloud::Client
  module Methods
    module Image

      # Retrieve list of all images
      #
      # Filter options:
      #
      # - :id -> Filter images using their 'id'
      # - :state -> Filter images  by their 'state'
      # - :architecture -> Filter images  by their 'architecture'
      #
      def images(filter_opts={})
        from_collection :images,
          connection.get(api_uri('images'), filter_opts)
      end

      # Retrieve the given image
      #
      # - image_id -> Image to retrieve
      #
      def image(image_id)
        from_resource :images,
          connection.get(api_uri("images/#{image_id}"))
      end

      # Create a new image from instance
      #
      # - instance_id -> The stopped instance used for creation
      # - create_opts
      #   - :name     -> Name of the new image
      #   - :description -> Description of the new image
      #
      def create_image(instance_id, create_opts={})
        must_support! :images
        r = connection.post(api_uri('images')) do |request|
          request.params = create_opts.merge(
            :instance_id => instance_id
          )
        end
        model(:image).convert(self, r.body)
      end

    end
  end
end
