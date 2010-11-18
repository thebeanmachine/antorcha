require 'rubygems' 
require 'builder' unless defined?(Builder)

class String
  def to_xml(options = {})
    raise "Not all elements respond to to_xml" unless all? { |e| e.respond_to? :to_xml }


    options = options.dup
    options[:indent]   ||= 2
    options[:builder]  ||= Builder::XmlMarkup.new(:indent => options[:indent])
     
    root     = options.delete(:root).to_s
    children = options.delete(:children)

    options[:builder].instruct! unless options.delete(:skip_instruct)

    opts = options.merge({ :root => self })

    xml = options[:builder]
    xml.tag!("string", self) unless self.blank?
    # if empty?
    #       xml.tag!(root, options[:skip_types] ? {} : {:type => "array"})
    #     else
    #       xml.tag!(root, options[:skip_types] ? {} : {:type => "array"}) {
    #         yield xml if block_given?
    #         each { |e| e.to_xml(opts.merge({ :skip_instruct => true })) }
    #       }
    #     end
  end
end
