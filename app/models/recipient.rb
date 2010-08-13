class Recipient < ActiveRecord::Base
  belongs_to :step
  belongs_to :organization
end
