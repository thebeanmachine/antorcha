class Fulfill < ActiveRecord::Base
  belongs_to :organization
  belongs_to :role
end
