# deltacloud-client

[![Code Climate](https://codeclimate.com/github/mifo/deltacloud-client.png)](https://codeclimate.com/github/mifo/deltacloud-client)
[![Build Status](https://travis-ci.org/mifo/deltacloud-client.png)](https://travis-ci.org/mifo/deltacloud-client)

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


# TODO

- Test AeolusProject for compatibility

# Want help?

## Adding new Deltacloud collection to client

```
$ rake generate[YOUR_COLLECTION] # eg. 'storage_snapshot'
# Hit Enter 2x
```

- Edit `lib/deltacloud/client/methods/YOUR_COLLECTION.rb` and add all
  methods for manipulating your collection. The list/show methods
  should already be generated for you, but double-check them.

- Edit `lib/deltacloud/client/model/YOUR_COLLECTION.rb` and add model
  methods. Model methods should really be just a syntax sugar and exercise
  the *Deltacloud::Client::Methods* methods.
  The purpose of *model* class life is to deserialize XML body received
  from Deltacloud API to a Ruby class.

## Debugging a nasty bug?

- You can easily debug deltacloud-client using powerful **pry**.

  - `gem install deltacloud-core`
  - optional: `rbenv rehash` ;-)
  - `deltacloudd -i mock -p 3002`
  - `rake console`

Console require **pry** gem installed. If you are not using this awesome
gem, you can fix it by `gem install pry`.

# License

Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/
