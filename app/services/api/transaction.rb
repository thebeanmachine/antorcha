
module Api
  class Transaction < ConvertableStruct
    member :id, :integer
    member :title, :string
    member :uri, :string
    member :expired_at, :string
    member :initialized_at, :string    
    member :expired, :boolean
    member :stopped, :boolean
    member :cancelled, :boolean
  end
end