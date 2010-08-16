
module Api
  class Token < ConvertableStruct
    member :username, :string
    member :password, :string
  end
end
