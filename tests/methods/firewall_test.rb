require_relative '../test_helper'

describe Deltacloud::Client::Methods::Firewall do

  before do
    VCR.insert_cassette(__name__)
    @client = new_client
  end

  after do
    VCR.eject_cassette
  end

  # FIXME: TBD, not supported by mock driver yet.
end
