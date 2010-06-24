
module MessageSerialization
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.message do
      xml.tag!(:title, title)
      xml.tag!(:body, body)
      xml.tag!(:task, task.name)
      xml.tag!(:instruction, instruction.name)
    end
  end

  def from_hash(hash)
    attributes = hash.dup

    instruction_name = attributes.delete(:instruction)
    attributes[:instruction] = Instruction.find_by_name(instruction_name)

    task_name = attributes.delete(:task)
    attributes[:task] = Task.find_by_name(task_name)
  
    self.attributes = attributes

    self
  end
end
