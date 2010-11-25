
module MessageSerialization
    
  def to_xml options = {}
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.message do

      add_local_rest_interface_xml(xml, options) if options[:local]

      xml.tag!(:title, title)
      xml.tag!(:body, body) unless options[:scrub]
      xml.transaction do
        xml.tag!(:uri, transaction.uri)
        xml.tag!(:initialized_at, transaction.initialized_at)
      end
      xml.tag!(:username, username)
      xml.tag!(:step_id, step_id)
    end
  end
  
  def add_local_rest_interface_xml xml, options = {}
    xml.tag! :id, id

    xml.tag! :cancelled, cancelled
    xml.tag! :expired, expired
    xml.tag! :unread, unread
    xml.tag! :transaction_id, transaction_id
    xml.tag! :shown_at, shown_at
    xml.tag! :organization_id, organization_id
  end

  def from_hash(hash)
    attributes = hash.dup

    transaction_hash = attributes.delete(:transaction)
    self.attributes = attributes
    self.transaction = find_or_create_transaction(self.step, transaction_hash)

    self.incoming = true

    self
  end
  
  def find_or_create_transaction step, transaction_hash
    transaction = Transaction.find_by_uri(transaction_hash[:uri])
    return transaction if transaction
    make_transaction(step, transaction_hash)
  end
  
  def make_transaction step, transaction_hash
    Transaction.create \
      :definition => step.definition,
      :uri => transaction_hash[:uri],
      :initialized_at => transaction_hash[:initialized_at]
  end
end
