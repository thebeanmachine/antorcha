module Jobs
  class ConfirmReceptionJob < Struct.new(:reception_id)
    include ResourceMixIn
    
    def perform
      @reception = Reception.find(reception_id)
      confirm
    end

    def confirm
      resource(@reception).post '', :content_type => :xml, :accept => :xml
    end
  end
end
