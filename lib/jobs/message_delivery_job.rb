module Jobs
  class MessageDeliveryJob < Struct.new(:delivery_id)
    include ResourceMixIn
    
    def perform
      @delivery = Delivery.find(delivery_id)
      @message = @delivery.message

      deliver
    end

    def deliver
      unless @delivery.delivered?
        send_message
        @delivery.delivered!
      end
    end

    def send_message
      resource(@delivery).post @message.to_xml, :content_type => :xml, :accept => :xml
    end
  
  end
end
