class Message < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :step

  belongs_to :step
  
  named_scope :incoming, :conditions => {:incoming => true}
  named_scope :outgoing, :conditions => {:incoming => false}

  def delivered!
    update_attribute(:delivered_at, Time.now) unless delivered?
  end

  def delivered?
    not delivered_at.nil?
  end


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
