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
        send_delivery
        @delivery.delivered!
      end
    end

    def send_delivery
      resource(@delivery).post @delivery.to_xml, :content_type => :xml, :accept => :xml
    end
  
  end
end
