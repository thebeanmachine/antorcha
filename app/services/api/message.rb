
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
  end
end
