
module Api
  class Transaction < ActionWebService::Struct
    member :id, :integer
    member :title, :string
    member :uri, :string
    member :expired_at, :string
    member :initialized_at, :string
  end
end