
module MessageSerialization
    
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.message do
      xml.tag!(:title, title)
      xml.tag!(:body, body)      
      xml.transaction do
        xml.tag!(:uri, transaction.uri)
        xml.tag!(:initialized_at, transaction.initialized_at)
      end
      xml.tag!(:step_id, step.id)
      xml.tag!(:organization_id, Identity.first!.organization.id)
    end
  end

  def from_hash(hash)
    attributes = hash.dup

    transaction_uri = attributes.delete(:transaction)
    self.attributes = attributes
    self.transaction = find_or_create_transaction(self.step, transaction_uri)

    self.incoming = true

    self
  end
  
  def find_or_create_transaction step, transaction_uri
    transaction = Transaction.find_by_uri(transaction_uri)
    return transaction if transaction
    make_transaction(step, transaction_uri)
  end
  
  def make_transaction step, transaction_uri
    Transaction.create :definition => step.definition, :uri => transaction_uri
  end
end
