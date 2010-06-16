class MessageDeliveryJob < Struct.new(:message_id)
  def perform
    message = Message.find(message_id)
    RestClient.post('http://localhost:3000/messages', message.to_json, :content_type => :json, :accept => :json)
  end
end
