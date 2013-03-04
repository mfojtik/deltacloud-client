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
    module Address

      # Retrieve list of all address entities
      #
      # Filter options:
      #
      # - :id -> Filter entities using 'id' attribute
      #
      def addresses(filter_opts={})
        from_collection :addresses,
        connection.get(api_uri('addresses'), filter_opts)
      end

      # Retrieve the single address entity
      #
      # - address_id -> Address entity to retrieve
      #
      def address(address_id)
        from_resource :address,
          connection.get(api_uri("addresses/#{address_id}"))
      end

      # Create a new address
      #
      # - create_opts
      #
      def create_address(create_opts={})
        must_support! :addresses
         response = connection.post(api_uri('addresses')) do |request|
          request.params = create_opts
        end
        model(:address).convert(self, response.body)
      end

    end
  end
end
