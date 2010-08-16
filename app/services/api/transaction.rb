
module Api
  class Transaction < ActionWebService::Struct
    member :id, :integer
    member :title, :string
    member :uri, :string
  end
end