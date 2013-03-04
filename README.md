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

client.use(:ec2, 'API_KEY', 'API_SECRET').instances # List EC2 instances
client.use(:openstack, 'admin@tenant', 'password', KEYSTONE_URL).instances # List Openstack instances

```

Full documentation available [here](http://rdoc.info/github/mifo/deltacloud-client/master/frames)

# Methods currently supported:
```ruby
# $ rake console

[1] pry(main)> ls client

Deltacloud::Client::Helpers::Model#methods: error  from_collection  from_resource  model

Deltacloud::Client::Methods::Api#methods:
  api_driver  api_version     current_provider  entrypoints  features       path      supported_collections
  api_uri     current_driver  driver_name       feature?     must_support!  support?  version

Deltacloud::Client::Methods::BackwardCompatibility#methods: api_host  api_port  connect  discovered?  use_config!  use_driver  with_config

Deltacloud::Client::Methods::Driver#methods: driver  drivers  providers

Deltacloud::Client::Methods::Realm#methods: realm  realms

Deltacloud::Client::Methods::HardwareProfile#methods: hardware_profile  hardware_profiles

Deltacloud::Client::Methods::Image#methods: create_image  image  images

Deltacloud::Client::Methods::Instance#methods:
  create_instance  destroy_instance  instance  instances  reboot_instance  start_instance  stop_instance

Deltacloud::Client::Methods::InstanceState#methods: instance_state  instance_states

Deltacloud::Client::Methods::StorageVolume#methods:
  attach_storage_volume  create_storage_volume  destroy_storage_volume  detach_storage_volume  storage_volume  storage_volumes

Deltacloud::Client::Connection#methods:
  cache_entrypoint!  connection  entrypoint  request_driver  request_provider  use  use_provider  valid_credentials?
```


# TODO

- Added tests (right, I like to write the code first, because is more fun ;-))
- Add missing Deltacloud API models
- Test AeolusProject for compatibility

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
