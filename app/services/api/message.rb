
module Api
  class Message < ConvertableStruct
    member :id, :integer
    member :title, :string
    member :body, :string
    member :transaction_id, :integer
    member :step_id, :integer
  end
end
