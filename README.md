# deltacloud-client

[![Code Climate](https://codeclimate.com/github/mifo/deltacloud-client.png)](https://codeclimate.com/github/mifo/deltacloud-client)

This is a Ruby client library for the [Deltacloud API](http://deltacloud.apache.org).

## Usage

```ruby
API_URL = "http://localhost:3001/api" # Deltacloud API endpoint

# Simple use-cases
client = Deltacloud::Client(API_URL, 'mockuser', 'mockpassword')

pp client.instances           # List all instances
pp client.instance('i-12345') # Get one instance

inst = client.create_instance 'ami-1234', :hwp_id => 'm1.small' # Create instance

inst.reboot!  # Reboot instance

# Advanced usage

# Deltacloud API supports changing driver per-request:

client.driver(:ec2, 'API_KEY', 'API_SECRET').instances # List EC2 instances
client.driver(:openstack, 'admin@tenant', 'password', KEYSTONE_URL).instances # List Openstack instances

```

Full documentation available [here](http://rdoc.info/github/mifo/deltacloud-client/master/frames)

# Adding support for collection

* Write `lib/deltacloud/client/models/ENTITY.rb`

This class should include list of entity attributes in `attr_reader` block.
Also it should implement the `self#parse` method that defines how an entity will
be deserialized from XML. (Look [here](https://github.com/mifo/deltacloud-client/blob/master/lib/deltacloud/client/models/realm.rb) for example.
The `r` variable here is an instance of the Nokogiri::Element node.

* Write `lib/deltacloud/client/methods/ENTITY.rb`

All entity CRUD methods should go here. ([example](https://github.com/mifo/deltacloud-client/blob/master/lib/deltacloud/client/methods/realm.rb))

* Require model/methods in `client.rb` and add the `include` statement in the `connection.rb` file

# License

Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/
