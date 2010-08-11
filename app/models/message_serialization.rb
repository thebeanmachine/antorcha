
module MessageSerialization
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.message do
      xml.tag!(:title, title)
      xml.tag!(:body, body)
      xml.tag!(:transaction, transaction.uri)
      xml.tag!(:step_id, step.id)
    end
  end

  def from_hash(hash)
    attributes = hash.dup

    transaction_uri = attributes.delete(:transaction)
    attributes[:transaction] = find_or_create_transaction(step, transaction_uri)
  
    self.attributes = attributes

    self
  end
  
  def find_or_create_transaction step, transaction_uri
    transaction = Transaction.find_by_uri(transaction_uri)
    return transaction if transaction
    smrf_transaction(step, transaction_uri)
  end
  
  def smrf_transaction step, transaction_uri
    Transaction.create :definition => step.definition, :uri => transaction_uri
  end
end
