class MessageDeliveryJob < Struct.new(:delivery_id)
  def perform
    delivery = Delivery.find(delivery_id)
    message = delivery.message
    unless delivery.delivered?
      RestClient.post(delivery.url, message.to_xml, :content_type => :xml, :accept => :xml)
      delivery.delivered!
    end
  end
end
