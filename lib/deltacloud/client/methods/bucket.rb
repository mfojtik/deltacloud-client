# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.  The
# ASF licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

module Deltacloud::Client
  module Methods
    module Bucket

      # Retrieve list of all bucket entities
      #
      # Filter options:
      #
      # - :id -> Filter entities using 'id' attribute
      #
      def buckets(filter_opts={})
        from_collection :buckets,
        connection.get(api_uri('buckets'), filter_opts)
      end

      # Retrieve the single bucket entity
      #
      # - bucket_id -> Bucket entity to retrieve
      #
      def bucket(bucket_id)
        from_resource :bucket,
          connection.get(api_uri("buckets/#{bucket_id}"))
      end

      # Create a new bucket
      #
      # - create_opts
      #
      def create_bucket(name)
        must_support! :buckets
         response = connection.post(api_uri('buckets')) do |request|
          request.params = { :name => name }
        end
        model(:bucket).convert(self, response.body)
      end

      # Destroy given bucket
      #
      def destroy_bucket(bucket_id)
        must_support! :buckets
        r = connection.delete(api_uri("buckets/#{bucket_id}"))
        r.status == 204
      end

    end
  end
end
