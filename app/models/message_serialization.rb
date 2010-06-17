
module MessageSerialization
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.message do
      xml.tag!(:title, title)
      xml.tag!(:body, body)
      xml.tag!(:step, step.name)
    end
  end

  def from_hash(hash)
    attributes = hash.dup

    step_name = attributes.delete(:step)
    attributes[:step] = Step.find_by_name(step_name)
  
    self.attributes = attributes

    self
  end
end
