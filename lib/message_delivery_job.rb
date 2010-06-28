class MessageDeliveryJob < Struct.new(:message_id)
  def perform
    message = Message.find(message_id)
    unless message.delivered?
      RestClient.post(message.destination_url, message.to_xml, :content_type => :xml, :accept => :xml)
      message.delivered!
    end
  end
end
