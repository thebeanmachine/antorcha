# Raised by ActiveRecord::Base.save! and ActiveRecord::Base.create! methods when record cannot be
# saved because record is invalid.
class AbstractRecordError < StandardError; end

# for HyperactiveResource method deprecations
module Deprecation 
  self.extend ActiveSupport::Deprecation
end

module ActiveResource
  module Formats
    module PdfFormat
      extend self

      def extension
        "pdf"
      end

      def mime_type
        "application/pdf"
      end

      def encode(hash, options={})
        hash.to_pdf(options)
      end

      def decode(pdf)
        pdf
      end


      private
        # Manipulate from_xml Hash, because xml_simple is not exactly what we
        # want for Active Resource.
        def from_pdf_data(data)
          if data.is_a?(Hash) && data.keys.size == 1
            data.values.first
          else
            data
          end
        end
    end
  end
end
class Array
  def acts_like_array?
    true
  end
end

class Hash
  def acts_like_hash?
    true
  end
end

class Object
  # Makes sure the object you're arrayifying is definitely an array
  # {:x => 1, :y => 1}.arrayify
  # => [{:x => 1, :y => 1}]
  #
  # Note to_a does not do this - it catss the existing object into an array,
  # which is probably not what you want!
  # {:x => 1, :y => 1}.to_a
  # => [[:x, 1], [:y, 1]]
  def arrayify
    self.acts_like?(:array) ? self : [self]
  end
end

# Overload the Connection to allow us to pass back raw data (ie without
# decoding it) if we want
module ActiveResource
  class Connection

    alias :old_get :get
    # Execute a GET request.
    # Used to get (find) resources.
    def get(path, headers = {}, decode = true)
      return old_get(path, headers) if decode
      # otherwise just return the raw body of the request
      request(:get, path, build_request_headers(headers, :get)).body
    end
  end
end



#--
# Below adds the README file into the rdoc for this class
#++
#:include:README
class HyperactiveResource < ActiveResource::Base

  # Raised by ActiveRecord::Base.save! and ActiveRecord::Base.create! methods when record cannot be
  # saved because record is invalid.
  class ResourceNotSaved < AbstractRecordError; end
  class ResourceNotFound < AbstractRecordError; end

  # Quick overloading of the ActiveRecord-style naming function for the
  # model in error messages.  This will be updated when associations are
  # complete
  def self.human_name(options = {})
    self.name.humanize
  end
  # Quick overloading of the ActvieRecord-style naming functions for
  # attributes in error messages.
  # This will be updated when associations are complete
  def self.human_attribute_name(attribute_key_name, options = {})
    attribute_key_name.humanize
  end

  # load the files here so we can test the code independantly of a rails
  # setup.
  require "active_record"
  # need to use load because require will kill active_record's own require
  # of the validatios module
  load "active_record/validations.rb"


  # Active\Resource's errors object is only a random selection of
  # ActiveRecord's error methods - and most of them are just copies of older
  # versions (eg before they added il8n)
  # So why not just inherit the attributes and add in the *only*
  # ActiveResource method that actually differs?
  class Errors < ActiveRecord::Errors
    
    def initialize(base) # :nodoc:
      @base, @errors = base, {}
    end

  # Edited from ActiveRecord as we don't yet fully support 
  # associations
    def generate_message(attribute, message = :invalid, options = {})

      message, options[:default] = options[:default], message if options[:default].is_a?(Symbol)

      defaults = [@base.class].map do |klass|
        [ "models.#{klass.name.underscore}.attributes.#{attribute}.#{message}".to_sym, 
          "models.#{klass.name.underscore}.#{message}".to_sym ]
      end
      
      defaults << options.delete(:default)
      defaults = defaults.compact.flatten << "messages.#{message}".to_sym

      key = defaults.shift
      value = @base.respond_to?(attribute) ? @base.send(attribute) : nil

      options = { :default => defaults,
        :model => @base.class.human_name,
        :attribute => @base.class.human_attribute_name(attribute.to_s),
        :value => value,
        :scope => [:activerecord, :errors]
      }.merge(options)

      I18n.translate(key, options)
    end

    
    # Grabs errors from the XML response.
    def from_xml(xml)
      clear
      humanized_attributes = @base.attributes.keys.inject({}) { |h, attr_name| h.update(attr_name.humanize => attr_name) }
      messages = Array.wrap(Hash.from_xml(xml)['errors']['error']) rescue []
      messages.each do |message|
        attr_message = humanized_attributes.keys.detect do |attr_name|
          if message[0, attr_name.size + 1] == "#{attr_name} "
            add humanized_attributes[attr_name], message[(attr_name.size + 1)..-1]
          end
        end
        
        add_to_base message if attr_message.nil?
      end
    end
  end


  # make validations work just like ActiveRecord by pulling them in directly
  extend ActiveRecord::Validations::ClassMethods
  # create callbacks for validate/validate_on_create/validate_on_update
  # Note: pull them from ActiveRecord's list in case they decide to update
  # the list...
  include ActiveSupport::Callbacks
  self.define_callbacks *ActiveRecord::Validations::VALIDATIONS
  # Add the standard list of ActiveRecord callbacks (for good measure).
  # Calling this here means we can override these with our own versions
  # below.
  self.define_callbacks *ActiveRecord::Base::CALLBACKS
  
  # make sure attributes of ARES has indifferent_access
  def initialize(attributes = {})
    @attributes     = {}.with_indifferent_access
    @prefix_options = {}
    load(attributes)
  end                             

  # I always thought it was stupid that AR couldn't initialize from an
  # instance of itself :P
  def self.new(stuff = {})
    return stuff.dup if stuff.is_a? self
    super(stuff)
  end

  # Creates an object just like HyRes.create but calls save! instead of save
  # so an exception is raised if the record is invalid.
  def self.create!(attributes = {})
    self.new(attributes).tap { |resource| resource.save! }
  end



  
  #This is required to make it behave like ActiveRecord
  def attributes=(new_attributes)    
    attributes.update(new_attributes)
  end


   
  def to_xml(options = {})
    # fix for rails bug 2521 (auto dasherizing when no field passed in)
    # Remove this when Rails has been fixed.
    [:dasherize, :camelize].each do |f|
      options[f] = (options.has_key?(f) && options[f] == true)
    end
    super(options)
  end

  # from_xml just returns a hash. We want it to actually instantiate the
  # record - or a set of records from XML.
  # Useful if we want to pull out a set of nested resources.
  # Works either on a single object or a set of nested ones.
  # Will return nil if it can't find a valid object or object-array of the
  # type of the current class.
  # 
  # eg:
  # Widget.from_xml('<widget><name>Thing</name></widget>')
  # => #<Widget:0xb6e8f420 ... @attributes={"name"=>"Thing"}>
  # Widget.from_xml('<widgets type="array"><widget><name>Thing</name></widget><widget><name>Thing2</name></widget></widgets>')
  # => [#<Widget:0xb6e7b6c8 ... @attributes={"name"=>"Thing"}>, 
  #     #<Widget:0xb6e7b740 ... @attributes={"name"=>"Thing2"}>
  def self.from_xml(the_xml)
    return nil if the_xml.blank?
    # not xml - already one of us
    return the_xml if the_xml.is_a?(self) || the_xml.acts_like?(:array) && the_xml[0].is_a?(self)

    attr_name = self.name.underscore
    the_hash = Hash.from_xml(the_xml)
    # returning a single item
    if the_hash.has_key?(attr_name) 
      return self.new(the_hash[attr_name])
    # returning a collection
    elsif the_hash.has_key?(attr_name.pluralize) 
      return the_hash[attr_name.pluralize].map {|item| self.new(item) }
    end
    # otherwise there's nothing there (or something we didn't expect)
    nil
  end


  # validates_uniqeuness_of has to pull data out of the remote webserver
  # to test, so it has to be rewritten for ARes-style stuff.
  # Currently assumes that you know what you're doing - ie no check for
  # whether the given model actually *has* the given attribute.
  # Just checks if a record already exists with the given value for the
  # given column.
  def self.validates_uniqueness_of(*attr_names)
    configuration = {}
    configuration.update(attr_names.extract_options!)

    validates_each(attr_names,configuration) do |this_resource, attr_name, value|    
      # skip if we allow nil and value is nil
      if (!configuration.has_key?(:allow_nil) || (configuration[:allow_nil] && !value.blank?))
        # TODO: make the below work
        #record.errors.add(attr_name, :taken, :default => configuration[:message], :value => value) if self.count(:conditions => {attr_name.to_s => value}) > 0
        # Currently find just fetches *every* record and we then have to
        # hand-filter it... :P

        match_set = self.find(:all, :conditions => { attr_name => value}).arrayify.compact!

        # trivial case - we didn't find any => this value's ok
        return true if match_set.blank?

        # there are two cases where there's no error.
        # Firstly, if we found none matching at all
        # Secondly, if we found one - but it's really the current record...
        #   which will only occur if the ids match
        # So we need to count the number of records returned that have the
        # attribute we've passed in... but don't have our id.
        this_resource.errors.add the_attr, "has already been taken. Please choose another" unless 0 == match_set.count {|rec| (value == rec.send(attr_name)) && (this_resource.to_param && rec.to_param != this_resource.to_param) }
      end
    end
  end


  # currently, ActiveResource doesn't handle a 404 on a destroy_all very
  # nicely... 
  # Returns true if it destroyed them all successfully.
  # Returns nil if it didn't find any.
  #
  # Note: make sure the remote API does not just redirect on delete (as per
  # somne standard Rails pre-generated code)... make sure it handles the xml
  # format nicely sending either a 200 or a 404 where appropriate
  def self.destroy_all(conditions = nil)
    matches = find(:all, :conditions => conditions)
    return true if matches.blank? # short circuit
    matches.arrayify.each { |object| object.destroy  }
    true
  end
  # unlike ActiveRecord... there's no easy way to just delete without
  # instantiating, so this is just an alias to +destroy_all+
  def self.delete_all(conds = nil)
    self.destroy_all(conds)
  end

  # Saves the model
  #
  # This will save remotely after making sure there are no local errors
  # returns false if saving fails
  def save(perform_validations = true)
    before_save    
    successful = (perform_validations ? super() : save_without_validation)
    after_save if successful          
    successful
  end    
    
  # Saves the model
  #
  # This will save remotely after making sure there are no local errors
  # Throws RecordNotSaved if saving fails
  def save!(perform_validations = true)
    save(perform_validations) || raise(ResourceNotSaved)
  end 
 
  # runs +validate+ and returns true if no errors were added otherwise false.
  def valid? 
    errors.clear

    run_callbacks(:validate)
    validate

    if new_record?
      run_callbacks(:validate_on_create)
      validate_on_create
    else
      run_callbacks(:validate_on_update)
      validate_on_update
    end

    # we're valid if we found no errors
    errors.empty?
  end
  
  # Returns the Errors object that holds all information about attribute error messages.
  def errors
    @errors ||= Errors.new(self)
  end

  alias :new_record? :new?

  def respond_to?(method, include_private = false)
    attribute_getter?(method) || attribute_setter?(method) || super
  end

  # reload should force the object to be completely new
  # Currently there aren't any options - but the param is there to match
  # with ActiveRecord.
  def reload(options = nil)
    the_id = self.to_param # remember the id (or it gets lost in the next step)
    @attributes = {}  # clear out everything
    # go find myself and reload based on the set of attributes found
    conds = @prefix_options.blank? ? nil : {:params => @prefix_options}
    self.load(self.class.find(the_id, conds).instance_variable_get('@attributes'))
  end

  # instance-method for count - used by the generic HyRes.count method
  # when it returns a single, instantiated object that contains the count
  # of the args given to it. This just pulls the count out of the
  # attributes hash (if present).
  def count
    @attributes[:count]
  end
  
  # copy/pasted from http://dev.rubyonrails.org/attachment/ticket/7308/reworked_activeresource_update_attributes_patch.diff
  #
  # Updates a single attribute and requests that the resource be saved. 
  # 
  # Note: Unlike ActiveRecord::Base.update_attribute, this method <b>is</b> subject to normal validation 
  # routines as an update sends the whole body of the resource in the request.  (See Validations). 
  # As such, this method is equivalent to calling update_attributes with a single attribute/value pair. 
  # 
  # If the saving fails because of a connection or remote service error, an exception will be raised.  If saving 
  # fails because the resource is invalid then <tt>false</tt> will be returned. 
  #     
  def update_attribute(name, value) 
    self.send("#{name}=".to_sym, value)
    self.save
  end 

  # does an +update_attribute+, but raises +ResourceNotSaved+ if it fails
  def update_attribute!(name, value)
    update_attribute(name, value) || raise(ResourceNotSaved)
  end
 
  # Updates this resource withe all the attributes from the passed-in Hash and requests that 
  # the record be saved. 
  # 
  # If the saving fails because of a connection or remote service error, an exception will be raised.  If saving 
  # fails because the resource is invalid then <tt>false</tt> will be returned. 
  # 
  # Note: Though this request can be made with a partial set of the resource's attributes, the full body 
  # of the request will still be sent in the save request to the remote service.  Also note that 
  # ActiveResource currently uses string versions of attribute 
  # names, so use <tt>update_attributes("name" => "ryan")</tt> <em>instead of</em> <tt>update_attribute(:name => "ryan")</tt>. 
  #     
  def update_attributes(attributes) 
    load(attributes) && save 
  end

  #  Works the same as +update_attributes+ but uses +save!+ rather than
  #  +save+
  #  Thus it will throw an exception if the save fails.
  def update_attributes!(attributes)
    load(attributes) || raise(ResourceNotSaved)
    save! 
  end
  
  
  # returns the raw data that the remote server returns for this object.
  # This is much more useful for non-html formats (eg getting the resource
  # in pdf-format so you can stream it to the user).
  # To ask for different ofrmats, pass it as an option eg:
  # raw_data(:conditions => {:site_id => 42}, :format => :pdf}
  def raw_data(conds = {})

    # if they've asked for a specific format - use that format, but
    # without losing the general format.
    old_format = nil
    if conds.has_key?(:format)
      old_format = self.class.format
      self.class.format = conds.delete(:format)
    end

    begin
      # go find myself with a get - but pass a "false" to tell it not to decode
      result = self.class.connection.get(element_path(@prefix_params), self.class.headers, false)
    ensure
      # no matter what happens, make sure we reset the format to the original
      self.class.format = old_format if old_format.present?
    end

    result
  end




  protected   ##########################################################

    # provided for compatibility with the new AR generate_message function
    def self.self_and_descendants_from_active_record
      [self]
    end

    # used when somebody overloads the "attribute=" method and then wants to
    # save the value into attributes
    def write_attribute(key, value)
      attributes[key.to_s] = value
    end


    # overwrite the encoding function to massage our attributes
    # into a form that can be encoded nicely.
    # Note - we now don't pass through any attributes except ones that are
    # known to exist ont he backend... ie remove everything that is not a
    # column or a known belongs_to association id
    #
    # If you want something to not be encoded - there is a parameter named
    # 'skip_to_xml_for' which you can use by passing in any models you want
    # to not appear int he encoding eg:
    # Widget.skip_to_xml_for :wodget_id
    #
    # This seems to have been a rrequirement when we didn't auto-clean the
    # attributes. probably an :include would be more appropriate now.
    def encode(opts = {})

      # first start with only the attributes that are actual columns
      massaged_attributes = attributes.dup.delete_if {|key,val| !self.class.columns.include?(key.to_sym) }

      # add in the belong_to association ids - but only if we have any
      unless self.belong_tos.blank?
        # Massage patient.to_param into patient_id (for every belongs_to we have
        # as an attribute)
        self.belong_tos.each do |thing|
          attr_name = thing.to_s.pluralize
          if attributes.has_key?(attr_name)
            the_things = attributes[attr_name]
            massaged_attributes["#{key}_id"] = the_thing.to_param unless the_thing.blank?
          elsif attributes.has_key?(attr_name+'_id')
            the_thing_id = attributes[attr_name+'_id']
            massaged_attributes["#{key}_id"] = the_thing_id unless the_thing_id.blank?
          end
        end
      end

      # Skip the things in the skip list
      massaged_attributes.delete_if {|key,value| skip_to_xml_for.include? key.to_sym }

      # the following is a copy of ARes's encode - but with our new attributes
      # It may need to be updated if we want to stay in line with ARes. :P
      case self.class.format
      when ActiveResource::Formats[:xml]
        self.class.format.encode(massaged_attributes, {:root => self.class.element_name}.merge(opts))
      else
        self.class.format.encode(massaged_attributes, opts)
      end
    end
    
    def save_nested
      return if nested_resources.blank?
      @saved_nested_resources = {}
      nested_resources.each do |nested_resource_name|
        resources = attributes[nested_resource_name.to_s.pluralize] 
        resources ||= send(nested_resource_name.to_s.pluralize)
        unless resources.nil?
          resources.each do |resource|
            @saved_nested_resources[nested_resource_name] = []
            #We need to set a reference from this nested resource back to the parent  

            fk = self.respond_to?("#{nested_resource_name}_options") ? self.send("#{nested_resource_name}_options")[:foreign_key]  : "#{self.class.name.underscore}_id"
            resource.send("#{fk}=", self.to_param)
            @saved_nested_resources[nested_resource_name] << resource if resource.save
          end
        end
      end
    end
    
    # Update the resource on the remote service.
    def update
      return false unless self.valid?
      connection.put(element_path(prefix_options), encode, self.class.headers).tap do |response|
        save_nested
        load_attributes_from_response(response)
        merge_saved_nested_resources_into_attributes
      end
      self
    end

    # Create (i.e. save to the remote service) the new resource.
    def create
      return false unless self.valid?
      run_callbacks(:before_create)
      connection.post(collection_path, encode, self.class.headers).tap do |response|
        save_nested
        load_attributes_from_response(response)
        merge_saved_nested_resources_into_attributes
      end
      run_callbacks(:after_create)
      self
    end  
    
    def merge_saved_nested_resources_into_attributes
      return if nested_resources.blank?
      @saved_nested_resources.each_key do |nested_resource_name|
        attr_name = nested_resource_name.to_s.pluralize
        resource_list_before_merge = attributes[attr_name] || []
        attributes[attr_name] = resource_list_before_merge - @saved_nested_resources[nested_resource_name]
        attributes[attr_name] +=  @saved_nested_resources[nested_resource_name]
      end
      @saved_nested_resources = []
    end
    
    def id_from_response(response)
      # response['Location'][/\/([^\/]*?)(\.\w+)?$/, 1] if response['Location'] 
      Hash.from_xml(response.body).values[0][self.class.primary_key.to_s]
    end

    def after_save
    end
    
    def before_save
      before_save_or_validate
    end
    
    def before_validate
      before_save_or_validate
    end
    
    #TODO I don't like the way this works. If you override validate you have to remember to call before_validate or super..
    def validate
      before_validate
    end

    # empty functions to be overloaded in the class if necessary.
    def validate_on_update
    end
    def validate_on_create
    end
     
    def before_save_or_validate
      #Do nothing
    end     


    # The list of columns that this HyRes object will recognise is stored on
    # this class accessor.
    # Any attributes not on this list will not be sent to the remote API on
    # create/update.
    class_inheritable_accessor :columns
    self.columns = [] #:nodoc:
    
    def self.column( names )
      raise ArgumentError if names.blank?
      self.columns << names
    end 


    ####################################################################
    # Associations
    # Public functions
    ####################################################################

    class_inheritable_accessor :has_manys #:nodoc:
    class_inheritable_accessor :nested_has_manys #:nodoc:
    class_inheritable_accessor :has_ones #:nodoc:
    class_inheritable_accessor :nested_has_ones #:nodoc:
    class_inheritable_accessor :belong_tos #:nodoc:
    class_inheritable_accessor :nested_resources #:nodoc:
    class_inheritable_accessor :skip_to_xml_for
    
    self.nested_resources = [] #:nodoc:
    self.has_manys = [] #:nodoc:
    self.nested_has_manys = [] #:nodoc:
    self.has_ones = [] #:nodoc:
    self.nested_has_ones = [] #:nodoc:
    self.belong_tos = [] #:nodoc:

    self.skip_to_xml_for = [] #:nodoc:


    # As per ActiveRecord - belongs_to allows you to associate one kind of
    # class with another through an id that is stored on the class that
    # declares the belongs_to relationship.
    # No AR-standard options work atm, but HyRes has it's own special option
    # for belongs_to associations, namely ':nested'
    # If nested is set to true - it assumes that this belongs_to
    # relationship also implies a nested-resource route on the remote API.
    # At present, we can only deal with a single prefix_path option (later
    # this may expand) - so we'll bail out if more than one belongs_to has
    # this option passed-in.
    # See README doc for more information about this.
    def self.belongs_to( names, opts = {} )
      raise ArgumentError if names.blank?
      if !opts.blank?
        # setup a nested resource route for this belongs_to association.
        if opts.has_key?(:nested) && opts[:nested] 
          raise ArgumentError, "the nested option can only deal with a single association at present, you passed #{names.length}" if names.blank? || (names.acts_like?(:array) && names.length != 1)
          # dearrayify if necessary
          the_name = names.acts_like?(:array) ? names[0] : names
          self.nested = the_name
        end
      end
      self.belong_tos << names
    end
      
    def self.has_many( names )
      raise ArgumentError if names.blank?
      self.has_manys << names
    end
    def self.has_one( name )
      raise ArgumentError if name.blank?
      raise ArgumentError if name.is_a?(Array) && name.length > 1
      self.has_ones = name.arrayify
    end
     
  #  When you call any of these dynamically inferred methods 
  #  the first call sets it so it's no longer dynamic for subsequent calls
  #  Ie. If there is residencies but no residency_ids
  #  then when you first call residency_ids it'll pull the residency ids into the attribute: residency_ids..
  #  But any changes aren't kept in sync (like ActiveRecord.. mostly)
    #  so you must do a @resource.reload to clear the cache and continue on
    def method_missing(name, *args)
      return super if attributes.keys.include? name.to_s

      # if the name is in one of the associations sets
      # Call the appropriate getter to fetch the values
      # before we return it to the user
      # This will store them on the object so a second call will not hit
      # method_missing
      case name.to_sym
      when *self.belong_tos
        return belong_to_getter_method_missing(name)
      when *self.belong_to_ids
        return belong_to_id_getter_method_missing(name)
      when *self.has_manys
        return has_many_getter_method_missing(name)
      when *self.has_many_ids
        return has_many_ids_getter_method_missing(name)
      when *self.has_ones
        return has_one_getter_method_missing(name)      
      when *self.columns
        return column_getter_method_missing(name)
      end                                     

      # when we call an attribute= on an attribute that is part of the
      # nested option - store the new value in the @prefix_options
      if self.nested
        case name.to_s
        when "#{self.nested}_id=" 
          # if we've passed in a bare id
          @prefix_options[name.to_s.first(-1)] = args.first
        when "#{self.nested}=" 
          # if we've passed an instance - just use the id
          @prefix_options[name.to_s.first(-1)] = args.first.to_param
        end
      end

      super(name, *args)
    end
    
    # Used by method_missing & load to infer setter & getter names from association names
    def has_many_ids    
      @has_many_ids ||= self.has_manys.map { |hm| "#{hm.to_s.singularize}_ids".to_sym }
    end
    
    # Used by method_missing & load to infer setter & getter names from association names
    def belong_to_ids
      @belong_to_ids ||= self.belong_tos.map { |bt| "#{bt}_id".to_sym }
    end
    
    # Calls to column getter when there is no attribute for it, nor a previous set called it will return nil rather than freak out
    def column_getter_method_missing( name )
      self.call_setter(name, nil)
    end
    
    #Getter for a belong_to relationship checks if the _id exists and dynamically finds the object
    def belong_to_getter_method_missing( name )
      # fetch the id (will fetch the object too)
      association_id = self.send("#{name.to_s.underscore}_id")
      return nil if association_id.blank? 

      #If there is a blah_id but not blah get it via a find
      call_setter(name, name.to_s.camelize.constantize.find(association_id))
    end
    
    #Getter for a belong_to's id will return the object.to_param if it exists
    def belong_to_id_getter_method_missing( name )
      #The assumption is that this will always be called with a name that ends in _id   
      association_name = self.class.remove_id name
      # If there is the obj itself rather than the blah_id Use the blah.to_param for blah_id
      return call_setter( name, attributes[association_name].to_param ) unless attributes[association_name].nil?

      # if we're a nested resource - the id may have been snatched away
      # and stashed in the prefix_options
      if self.nested && self.nested.to_sym == association_name.to_sym
        assn_id = (association_name+'_id').to_sym
        if !@prefix_options.blank? && @prefix_options.has_key?(assn_id)
          return call_setter( name, @prefix_options[assn_id])
        end
      end

      # call_setter( name, nil ) - Just like a column
      column_getter_method_missing( name ) 
    end
    
    #If there is _ids, but not objects array the method missing for has_many will get each object via id. Otherwise it will return
    #an empty array (like active
    def has_many_getter_method_missing( name )
      method_id_name = "#{name.to_s.singularize.underscore}_ids"
      # see if we already have ids - and find them if we don't
      association_ids = self.send(method_id_name) 
      if association_ids.blank?
        # if we get to here - then we already tried calling the
        # collection_fetch and failed - so just say we have none.
        call_setter( name, [] )
      else
        # first -double-check that the id-fetch didn't auto-load the
        # associated objects while finding the ids, otherwise we'll be
        # doubling up on finds.
        return attributes[name] if attributes.has_key?(name)

        # didn't find any, get them all via individual finds
        the_klass = self.class.foreign_key_to_class(name)
        my_klass_name = self.class.name.underscore

        my_klass_id = (my_klass_name + '_id').to_sym
        opts = the_klass.nested && the_klass.nested == my_klass_name.to_sym ? {my_klass_id => self.to_param}  : nil

        associated_models = association_ids.collect do |associated_id| 
          if opts
            the_klass.find(:all, :conditions => opts.merge(:id => associated_id))
          else
            the_klass.find(associated_id)
          end
        end

        call_setter(name, associated_models)
      end
    end
    
    def has_many_ids_getter_method_missing( name )
      association_name = self.class.remove_id(name).pluralize #(residency_ids => residencies)
      unless attributes[association_name].nil?
        collection_ids = attributes[association_name].collect(&:id)
      else
        the_collection = collection_fetch(name)
        if the_collection.blank?
          call_setter( name, [] )
        else
          # save these while we're at it
          call_setter( association_name, the_collection )
          collection_ids = the_collection.map &:id
        end
      end
      call_setter( name, collection_ids )
      collection_ids
    end

    # a collection-finder for a has-many associated collection.
    # Can take a name of: "widgets" OR "widget" or "widget_ids" and returns
    # the set of Widget objects associated with the current object (passing
    # self.to_param to the widget finder)
    def collection_fetch(name)
      the_klass = self.class.foreign_key_to_class(name)
      my_klass_name = self.class.name.underscore

      # if we are a nested resource (ie the remote API uses a nested route
      # for this resource eg /users/:user_id/widgets)
      # add ourself into the options
      if the_klass.nested && the_klass.nested.to_sym == my_klass_name.to_sym
        opts = {(my_klass_name+'_id').to_sym => self.to_param}
        the_klass.find_every(opts)
      else
        # otherwise use a standard collection finder - but pass in the
        # parent's id as a condition
        collection_finder_method = "find_all_by_#{my_klass_name}_id"
        the_klass.send(collection_finder_method, self.to_param)
      end
    end



    # quickie helper to turn a given name into a class constant
    # eg :user_id => <User>
    # Useful when you have a foreign-key and want the association.
    def self.foreign_key_to_class(name)
      remove_id(name.to_s).classify.constantize
    end

    class_inheritable_accessor :nested
    # If an association uses a nested route - you can just pass in the
    # association-name to "nested" and the nesting will be automatically
    # handled by HyRes. This automatically adds the appropraite "prefix="
    # for you - and will be called appropriately in the collection_fetch for
    # association-fetching
    def self.nested=(name)
      # generate a quick-trick prefix path on the nested resource and pass
      # in the required prefix option which is our own id
      the_class_name = name.to_s.underscore
      # add the nested resource as a prefix-path
      self.prefix = "/#{the_class_name.pluralize}/:#{the_class_name}_id/"
      @nested = name
    end
    # just returns the current value for "nested"
    def self.nested
      @nested 
    end

    
    def has_one_getter_method_missing( name )
      self.new? ? nil : 
        call_setter( name, name.to_s.camelize.constantize.send("find_by_#{self.class.name.underscore}_id", self.to_param) )
    end

    #Convenience method used by the method_missing methods
    def call_setter( name, value )
      # puts "****************** call_setter( #{name}, #{value} )"
      self.send( "#{name}=", value )
    end
    
    #Chops the _id off the end of a method name to be used in method_missing
    def self.remove_id( name_with_id )
      name_with_id.to_s.gsub(/_ids?$/,'')
    end

    #There are lots of differences between active_resource's initializer and active_record's
    #ARec lets you pass a block 
    #Arec doesn't clone
    #Arec calls blah= on everything that's passed in.
    #Arec will turn a "1" into a 1 if it's in an ID column (or any integer for that matter)
    #This is a copy of the method out of ActiveResource::Base modified
    def load(attributes)
      raise ArgumentError, "expected an attributes Hash, got #{attributes.inspect}" unless attributes.is_a?(Hash)
      # null-values are meaningful here, so merge in the keep-if-null option
      @prefix_options, attributes = split_options(attributes.merge(:keep_if_null => true))
      attributes.each do |key, value|      
        @attributes[key.to_s] =
          case value
            when Array
              #BEGIN ADDITION TO AR::BASE
              load_array(key, value)
              #END ADDITION              
            when Hash
              resource = find_or_create_resource_for(key)
              resource.new(value)
            else
              #BEGIN ADDITION TO AR::BASE
              convert_to_i_if_id_field(key, value)
              #WAS: value #.dup rescue value #REMOVED FROM AR:BASE
              #END ADDITION                                                  
            end
        #BEGIN ADDITION TO AR::BASE
        call_attribute_setter(key, value)
        #END ADDITION
        if key.to_sym == self.class.primary_key.to_sym
          @primary_key_value = value 
        end
      end
      # overwrite the primary_key if it's different from the default
      # regardless of primary key - the 'id' attribute needs to be the same
      # as the primary key
      @attributes['id'] = self.id = @primary_key_value if @primary_key_value

      #BEGIN ADDITION TO AR::BASE
      result = yield self if block_given?
      #END ADDITION
      result || self
    end
    
    #Called by overriden load
    def load_array( key, value )
      if self.has_many_ids.include? key
        #This means someone has set blah_ids = [1,2,3]
        #Instead of being retarded like ActiveResource normally is,
        #Let's turn this into "1,2,3"
        value.join(',')
      else
        resource = find_or_create_resource_for_collection(key)
        value.map { |attrs| resource.new(attrs) }
      end
    end
      
    #Called by overriden load
    def convert_to_i_if_id_field( key, value )
      #This might be an id of an association, and if they are passing in a string it should be to_ied                        
      # if not - just pass it back straight away
      return value unless self.belong_to_ids.include? key && (!value.nil? || (value.respond_to?(:empty?) && value.empty?))
      # otherwise cast it to an int
      value.to_i
    end
    
    #TODO Consolidate this with call_setter
    #Called by overriden load
    def call_attribute_setter( key, value )
      #TODO If there is a setter, we shouldn't directly set the attribute hash - we should rely on the setter method
      # => Now, we are doing both
      setter_method_name = "#{key}="
      self.send( setter_method_name, @attributes[key.to_s] ) if self.respond_to? setter_method_name
    end    
    
    def attribute_getter?(method)
      columns.include?(method.to_sym)
    end

    def attribute_setter?(method)
      columns.include?(method.to_s.gsub(/=$/, '').to_sym)
    end

  
    # add dynamic finders straight out of active record
    # This file just contains the matchers - which is really just a set of
    # RegExes that will apply to HyRes as easily as AR
    load "active_record/dynamic_finder_match.rb"

    # constructs an attributes hash from a set of attribute names and
    # arguments.
    # Copied directly from ActiveRecord.
    def self.construct_attributes_from_arguments(attribute_names, arguments)
      attributes = {}
      attribute_names.each_with_index { |name, idx| attributes[name.to_sym] = arguments[idx] }
      attributes
    end


    # Set up method_missing to match a method-name based on the allowed
    # dynamic finders.
    #
    # This allows:
    #  User.find_all_by_email('joe@bloggs.com')
    #   => returns all users with the matching parameter
    #  User.find_by(:email, 'joe@bloggs.com')
    #   => both return the first matching user
    #  User.find_last_by(:email, 'joe@bloggs.com')
    #   => same as above, but returns the last one. (note - because we don't
    #   "sort" yet - this will fetch all of them and then return the last in
    #   the array.
    #  User.find_all_by_email!('joe@bloggs.com')
    #   => adding a bang to the end will cause it to raise a
    #      ResourceNotFound if none were found!
    #  User.find_all_by_name_and_email('Joe', 'joe@bloggs.com')
    #   => returns users that match both given criteria (can pass any number
    #      of arguments)
    #  User.find_or_create_by_name('Joe')
    #   => will try to find it - and if it doesn't exist... will create it
    #      instead.
    #  User.find_or_create_by_name!('Joe')
    #   => same as above, but will user create! and therefore raise an
    #      exception if creation fails
    def self.method_missing(method_name, *args )
      if match = ActiveRecord::DynamicFinderMatch.match(method_name)
        attribute_names = match.attribute_names
        # TODO - this is a Good Idea - but needs implementing
        # super unless all_attributes_exist?(attribute_names)

        # If we asked for a finder (eg find_all_by_X)
        if match.finder?
          finder_scope = match.finder
          opts = args.extract_options! # pop the hash off the end
          # construct conditions from given attributes
          attr_conds = construct_attributes_from_arguments attribute_names, args
          # merge them in with any existing conditions
          opts[:conditions] = (opts.delete(:conditions) || {}).merge(attr_conds)

          # and send them to the finder in the chosen scope
          results = self.find(finder_scope, opts)

          # the user asked for find! and we found nothing - so raise a
          # descriptive exception
          raise ResourceNotFound, "Couldn't find #{self.name} with #{attr_conds.to_a.collect {|pair| "#{pair.first} = #{pair.second}"}.join(', ')}" if match.bang? && results.blank?

          # otherwise return whatever we found
          return results

        # if we asked for an instantiator (eg find_or_create_by_X)
        elsif match.instantiator?
          # We need to save the values from the match object as it'll
          # all be lost as soon as we try the finder!
          # first figure out which instantiator method we're using
          instantiator = match.instantiator # either :new or :create
          do_bang = match.bang?

          # the finder method name is the same as the one they've used on
          # the way in - but without the find/instantiate codeword swapped
          # for the "first" codeword (so we only find one)
          finder_method_name = method_name.to_s.gsub(/or_(create|initialize)_/,'')

          # first try finding the object
          begin
            # try finding it first
            # and send them to the finder in the chosen scope
            result = self.send(finder_method_name, *args)
            # if we found one - we're done.
            return result unless result.blank?
          rescue ResourceNotFound => msg
            # swallow a resource-not-found - we need to try and create one
          end
          # we get here if we didn't find one... so now create it

          # massage the opts into something creatable
          opts = args.extract_options! # pop the hash off the end
          # make a hash of the given attributes :)
          attr_conds = construct_attributes_from_arguments attribute_names, args
          # figure out my own model name and pass as options.
          # merge them in with any existing conditions
          attr_conds = (opts.delete(:conditions) || {}).merge(attr_conds)

          resource = self.new(attr_conds)
          # save (with bang if requested) it if we're not a "new"
          do_bang ? resource.save! : resource.save unless :new == instantiator
          return resource
        end # we asked for an instantiator
      else
        super( method_name, args )
      end
    end

    # hack on find_every - if we have passed some options, but not bothered
    # with the :params key, automatically add it... this is so we can use
    # standard AR syntax without having to pass in :params => :conditions =>
    # etc every time
    def self.find_every(options)
      begin
        from_value = options.respond_to?(:has_key?) && options.has_key?(:from) ? options.delete(:from) : nil
        case from_value
        when Symbol
          instantiate_collection(get(from_value, options[:params]))
        when String
          path = "#{from_value}#{query_string(options[:params])}"
          instantiate_collection(connection.get(path, headers).arrayify)
        else
          prefix_options, query_options = split_options(options)
          suffix_options = query_options.delete(:suffix_options)
          path = collection_path(prefix_options, query_options, suffix_options)
          instantiate_collection( (connection.get(path, headers).arrayify), prefix_options )
        end
      rescue ActiveResource::ResourceNotFound
        # We should be swallowing RecordNotFound exceptions and returning
        # nil - as per ActiveRecord.
        nil
      end
    end

    # hack on find_single to params-ify the options automatically
    # This allows us to pass in AR-style options (eg :conditions => etc)
    # without having to add a :params in front of it
    def self.find_single(id, opts)
      super(id, paramsify_options(opts))
    end

    def self.paramsify_options(opts)
      return opts if opts.blank? || !opts.respond_to?(:has_key?) || opts.has_key?(:params)

      from_value = opts.delete(:from)
      options = {:params => opts}
      options[:from] = from_value if from_value
      options
    end
 
    # convenience methods as per ActiveRecord
    def self.first(args = {})
      self.find(:first, args)
    end

    def self.last(args = {})
      self.find(:last, args)
    end

    def self.all(args = {})
      self.find(:all, args)
    end

    # Merges conditions so the result is a valid condition block
    # Unlike ActiveRecord's merge_conditions, this merges in the hash-form
    # before passing back a combined conditions hash
    #
    # Does a "merge left" so anything later in the array will overwrite
    # anything earlier in the array.
    #
    # Note... can't currently deal with "OR" options - and it also expects
    # unique keys (eg if you pass in two "email = " keys it'll just
    # overwrite the first with the second.
    def self.merge_conditions(*conditions)
      return nil if conditions.blank?
      merged_conditions = {}

      conditions.each do |condition|
        # de-hashify one level if we got {:conditions => {:what_we => :really_want}}
        condition = condition[:conditions] if condition.respond_to?(:has_key?) && condition.has_key?(:conditions)
        next if condition.blank?
        raise "Merge conditions expects arguments that are hashes, not #{conditions.class.name}" unless condition.is_a? Hash
        merged_conditions.merge!(condition)
      end
      merged_conditions
    end


    # Counts the number of items in your API that match the given
    # conditions. 
    #
    # If you pass in nothing, it will try the +default_counter_path+
    # 
    # If your API does not use the +default counter_path+, you can override it in one of two ways:
    #
    # If the path is the same for every model, you can pass the string-path to
    # self.counter_path= in your model class. This can be done for each individual
    # model.
    # Alternatively, you can pass in the counter_path for any specific instance of
    # count by passing it as an arg thus:
    # Widget.count(:counter_path => '/my_app/my_widgets_count.xml')
    # 
    # Both of these will still allow you to pass finder-args to the count method eg:.
    # Widget.count(:counter_path => '/my_app/my_widgets_count.xml', :name => 'wodget')
    # 
    # ...if all else fails (ie it tires and gets a ResourceNotFound error) -
    # the code will do a full fetch and count on a local array. If you know
    # there's no counter-action in your remote API, you're probably better
    # off doing that in your own code.
    #
    # Note: the finder here works because ActiveResource doesn't actually
    # know about how to instantiate resources properly - it will just create
    # a model that has a field called "count" on it.
    # Because we never try to save this fake resource - it should not fall
    # foul of validation...
    def self.count(args = {})
      begin
        raise "Must pass a nested-resource's id to count" if self.nested && !args.has_key?("#{nested.to_s.singularize}_id".to_sym)
        # try the neato way assuming a "count_widgets" collection path
        # has been passed in
        try_path = self.counter_path
        # passed-in path always overrides the default
        if (args.has_key?(:counter_path) && !args[:counter_path].blank?)
          try_path = args[:counter_path] 
          args.delete(:counter_path)
        end
        # update the args to add our counter path.
        # Note - don't disturb the original argments as we need them in the
        # fallback option.
        unless try_path.blank?
          new_args = args.merge(:from => try_path)
        else
          # try the default counter path.
          new_args = {:from => self.default_counter_path(args)}
        end
        them = self.find(:one, new_args)
        # find_every now swallows not-found errors, so we may need to
        # manually raise it to get into the failure block (below)
        # We also need to catch the horrible 'id not recognised error' that
        # is returned when /<wigets>/count.xml turns into
        #      :params =>  {:id => 'count'}
        # Thus we check if the returned object recognises the 'count' method
        raise HyperactiveResource::ResourceNotFound if them.blank? || !them.respond_to?(:count)

        # success!
        them.count.to_i

      rescue HyperactiveResource::ResourceNotFound, ActiveResource::ResourceNotFound, 
        ActiveResource::ServerError
        # if we failed to find any, or the remote server exploded (eg on a bad
        # route), we want to have one more go before falling over.
        # Fetch them all out and check the length of the array
        self.all(args).arrayify.length
      end
    end

    # an accessor that stores the model-specific path to use for counting
    # an object - in case it differs from the default (see
    # +default_counter_path)
    def self.counter_path(args = nil)
      @counter_path
    end
    def self.counter_path=(path)
      # clean up if somebody forgets to prepend a slash
      path = '/' + path unless path.blank? || path[0] == '/'
      @counter_path = path
    end
    # default counter-path to be used if counter_path is not set.
    # so: default_counter_path(args)
    # is expected to generate something equivalent to:
    #   /#{collection_path}/count.xml#{query_string(args)}
    # It uses the extended +collection_path+ with suffix_options of ['count']
    def self.default_counter_path(args)
      self.collection_path(args, nil, ['count'])
    end

    # extend collection_path to allow suffix options - which allow us to
    # actually construct standard rails named routes
    # Pass in suffix options as an array and they will be added just after
    # the collection-path name joined with '/',  and the format will be
    # applied to the last one. Params should work as previously
    # eg:
    # User.collection_path(nil, nil, ['count'])
    # => '/users/count.xml'
    # User.collection_path(nil, {:name => 'joe'}, ['count'])
    # => '/users/count.xml?name=joe'
    # User.collection_path({:group_id => 42}, {:name => 'joe'}, ['count', 'all'])
    # => '/groups/42/users/count/all.xml?name=joe'
    def self.collection_path(prefix_options = {}, query_options = nil, suffix_options = [])
      # allow suffix options to be passed in via the "query string" options.
      suffix_options ||= query_options.delete!(:suffix_options) if query_options && query_options.respond_to?(:has_key?) && query_options.has_key?(:suffix_options)

      # only override it if we pass in something different
      return super(prefix_options, query_options) if suffix_options.blank?

      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}#{collection_name}/#{suffix_options.arrayify.join('/')}.#{format.extension}#{query_string(query_options)}"
    end


    # a collection path for an existing instance may be different to that
    # for an uninitialized object - mainly becasue nested resources will
    # possibly refer to a nested id - and we'll need to pass that in as a
    # specific prefix_option so the scope isn't lost.
    # for some reason - this doesn't work correctly in ARes - probably
    # because it uses options || prefix_options - when we really need to
    # merge them in.
    def collection_path(prefix_options = {}, query_options = nil, suffix_options = [])
      prefix_options = @prefix_options.merge(prefix_options)
      self.class.collection_path(prefix_options, query_options, suffix_options)
    end
                    

    private #####################################################################

      # override ARes's normal split_options.
      # split an option hash into two hashes, one containing the prefix options,
      # and the other containing the leftovers.
      def self.split_options(options = {})
        return [{},{}] if options.blank? # trivial case

        # check we've got valid options...
        raise ArgumentError, "expected a Hash got: #{options.inspect}" unless options.acts_like? :hash

        prefix_options, query_options = {}, {}

        # When building URLs, we want to delete null-valued keys
        # (eg :conditions => nil), but we want to be able to tell this 
        # method not to do this if we're, say, building a set of attributes,
        # and null-values are meaningful (eg :name => nil)
        keep_if_null = options.delete(:keep_if_null)

        options.each do |key, value|
          next if key.blank?
          # delete this key if the value is null, unless null-values are
          # meaningful
          next if value.blank? unless keep_if_null

          (prefix_parameters.include?(key.to_sym) ? prefix_options : query_options)[key.to_sym] = value
        end

        # It's possible that some of the prefix_options come through inside
        # the :conditions - in which case - we still want them in the
        # prefix_options (though leave them otherwise).
        if query_options.has_key?(:conditions) && !query_options[:conditions].blank?
          conds_to_keep = {}
          # only do this if we have a simple hash-based conditions.
          # otherwise, it's too complicated to parse out the prefix-options.
          # We'll just pass it through anyway
          if query_options[:conditions].acts_like? :hash
            query_options.delete(:conditions).each do |key, value|
              if !key.blank?
                the_key = key.to_sym
                # pull prefix params out of the conditions
                prefix_options[the_key] = value if prefix_parameters.include?(the_key)
                conds_to_keep[the_key] = value unless prefix_options.has_key?(the_key)
              end
            end
            query_options[:conditions] = conds_to_keep unless conds_to_keep.blank?
          end
        end

        [ prefix_options, query_options ]
      end
end
