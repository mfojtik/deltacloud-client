module Deltacloud::Client

  class Base

    extend Helpers::XmlHelper
    include Deltacloud::Client::Methods::Api

    # These attributes are common for all models
    #
    # - obj_id -> The :id of Deltacloud API model (eg. instance ID)
    #
    attr_reader :obj_id
    attr_reader :name
    attr_reader :description

    # The Base class that other models should inherit from
    # To initialize, you need to suply these mandatory params:
    #
    # - :_client -> Reference to Client instance
    # - :_id     -> The 'id' of resource. The '_' is there to avoid conflicts
    #
    def initialize(opts={})
      @options = opts
      @obj_id = @options.delete(:_id)
      # Do not allow to modify the object#base_id
      @obj_id.freeze
      @client = @options.delete(:_client)
      update_instance_variables!(@options)
    end

    alias_method :_id, :obj_id

    # Reference to the current client connection and entirypoint.
    # This is needed to execute Deltacloud methods on model instances.
    #
    def connection
      @client.connection
    end

    def entrypoint
      @client.entrypoint
    end

    # Populate instance variables in model
    # This method could be also used to update the variables for already
    # initialized models. Look at +Instance#reload!+ method.
    #
    def update_instance_variables!(opts={})
      @options.merge!(opts)
      @options.each { |key, val| self.instance_variable_set("@#{key}", val) unless val.nil? }
      self
    end

    # Eye-candy representation of model, without ugly @client representation
    #
    def to_s
      "#<#{self.class.name}> #{@options.merge(:_id => @obj_id).inspect}"
    end

    class << self

      # Parse the XML response body from Deltacloud API
      # to +Hash+. Result is then used to create an instance of Deltacloud model
      #
      # NOTE: Children classes **must** implement this class method
      #
      def parse(client_ref, inst)
        warn "The self#parse method **must** be defined in #{self.class.name}"
        {}
      end

      # Convert the parsed +Hash+ from +parse+ method to instance of Deltacloud model
      #
      # - client_ref -> Reference to the Client instance
      # - obj -> Might be a Nokogiri::Element or Response
      #
      def convert(client_ref, obj)
        body = extract_xml_body(obj).to_xml.root
        attrs = parse(body)
        attrs.merge!(:_id => body['id'])
        raise Deltacloud::Client::Error.new('The :_id must not be nil.') if attrs[:_id].nil?
        attrs.merge!(:_client => client_ref)
        raise Deltacloud::Client::Error.new('The :_client reference is missing.') if attrs[:_client].nil?
        # The :name and :description are common attributes
        attrs.merge!(:name => text_at(body, 'name'))
        attrs.merge!(:description => text_at(body, 'description'))
        new(attrs)
      end

      # Convert response for the collection responses.
      #
      def from_collection(client_ref, response)
        response.body.to_xml.xpath('/*/*').map do |entity|
          convert(client_ref, entity)
        end
      end

    end

  end
end
