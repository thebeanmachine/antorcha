module Jobs
  class ReceiveMessageJob < Struct.new(:reception_id)
    def perform
      @reception = Reception.find(reception_id)
      receive if @reception.just_arrived?
    end

    def receive
      unless @reception.process
        raise "Message could not be received."
      end
    end
  end
end
