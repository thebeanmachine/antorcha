class MessageDeliveryJob < Struct.new(:message_id)
  def perform
    message = Message.find(message_id)
    unless message.delivered?
      message.destination_organizations.each do |organization|
        RestClient.post(organization.url, message.to_xml, :content_type => :xml, :accept => :xml)
      end
      
      message.delivered!
    end
  end
end
