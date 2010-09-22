
module Api
  class Message < ConvertableStruct
    member :id, :integer
    member :title, :string
    member :body, :string
    member :cancelled, :boolean
    member :expired, :boolean
    member :unread, :boolean
    member :transaction_id, :integer
    member :step_id, :integer
    member :shown_at, :datetime

    def initialize model_or_hash = {}
      if model_or_hash.kind_of? ::Message
        message = model_or_hash
        self.cancelled = message.cancelled
        self.expired = message.expired
        self.unread = message.unread
      end
      super model_or_hash
    end
    
  end
end
