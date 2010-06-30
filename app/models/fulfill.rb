class Fulfill < ActiveRecord::Base
  belongs_to :organization
  belongs_to :transaction_role
end
