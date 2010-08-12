
module Api
  class Message < ConvertableStruct
    member :title, :string
    member :body, :string
    member :transaction_id, :integer
  end
end
