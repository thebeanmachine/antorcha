
module Api
  class Message < ConvertableStruct
    member :id, :integer
    member :title, :string
    member :body, :string
    member :transaction, Api::Transaction
    member :step_id, :integer
  end
end
