module Jobs
  class ReceiveMessageJob < Struct.new(:reception_id)
    def perform
      @reception = Reception.find(reception_id)
      receive unless @reception.message
    end

    def receive
      @reception.verify_organization_certificate if Rails.env.production?
      Message.receive! @reception
    end
  end
end
